import 'dart:convert';
import 'dart:developer';
import 'package:asset_audit/Pages/AuditingPage/model/assets_by_model.dart';
import 'package:asset_audit/Pages/AuditingPage/model/audit_assets_model.dart';
import 'package:asset_audit/Pages/AuditingPage/model/pending_rooms_by_floor.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:dio/dio.dart' as appDio;
import 'package:asset_audit/Pages/AuditingPage/model/scanned_model.dart';
import 'package:asset_audit/Pages/AuditingPage/model/asset_model.dart';
import 'package:asset_audit/Pages/AuditingPage/model/user_model.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/service/api_service.dart';
import 'package:asset_audit/utils/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class AuditingController extends GetxController {
  final ApiService apiService = ApiService();
  StorageManager appStorage = StorageManager();

  // RxList<CustomFloor> floors = <CustomFloor>[].obs;
  // RxList<CustomRoom> rooms = <CustomRoom>[].obs;
  RxList<AssetModel> assets = <AssetModel>[].obs;
  RxList<ScannedModel> scannedAssets = <ScannedModel>[].obs;
  RxList<ScannedModel> RecentscannedAssets = <ScannedModel>[].obs;

  //comparing
  RxList<AuditedAssetsModel> auditAssets = <AuditedAssetsModel>[].obs;
  RxList<AssetsByRoomModel> roomAssets = <AssetsByRoomModel>[].obs;

  RxList<PendingRoomsByFloorModel> pendingFloors =
      <PendingRoomsByFloorModel>[].obs;
  RxList<Rooms> pendingRooms = <Rooms>[].obs;

  RxList<CustomUsers> users = <CustomUsers>[].obs;

  RxString selectedFloor = ''.obs;
  RxString selectedRoom = ''.obs;
  RxString barcode = ''.obs;
  RxString selectedRoomId = ''.obs;
  RxString selectedFloorId = ''.obs;
  RxString currentAssetStatus = ''.obs;
  RxBool isLoading = false.obs;
  RxString currentUserMail = ''.obs;
  RxString statusValueOfAsset = ''.obs;
  RxString statusAsset = ''.obs;
  RxString userName = ''.obs;
  RxString userMail = ''.obs;

  RxString selectedUser = ''.obs;

  late final String buildingId;
  late final String buildingName;
  late final String dueDate;
  late final String auditNumber;

  @override
  void onInit() async {
    super.onInit();
    userName.value = await appStorage.read('name');
    userMail.value = await appStorage.read('mail');
    print("${userMail.value}----->");
    buildingId = Get.arguments?['buildingId'] ?? '';
    buildingName = Get.arguments?['buildingName'] ?? '';
    dueDate = Get.arguments?['dueDate'] ?? '';
    auditNumber = Get.arguments?['auditNumber'] ?? '';

    getRecentAssets();
    getUser();
    getUserMail();
    setCurrentAssetStatus();
    // updateAssets();
    if (buildingId.isNotEmpty) {
    } else {
      print('No building ID provided');
    }
    print(buildingId);
    fetchRoom(buildingId);

    // getAllAssetsByRoom('', '', '');
  }

  void getRecentAssets() async {
    final recentScannedAssets = await appStorage.read("scannedAssets");

    if (recentScannedAssets != null) {
      // Decode string to List
      List<dynamic> decodedList = jsonDecode(recentScannedAssets);
      final finalData =
          decodedList
              .map((e) => ScannedModel.fromJson(e as Map<String, dynamic>))
              .toList();
      RecentscannedAssets.value = finalData;
    } else {
      RecentscannedAssets.clear(); // Optional: clear if nothing in storage
    }
  }

  Future<bool> showDuplicateDialog() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppTheme.whiteColor,
        title: Text('Duplicate Detected'),
        content: Text('This is a duplicate. Do you want to continue?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  //Barcode
  Future<void> scanAndFetch(BuildContext context) async {
    if (selectedRoom.value.isEmpty && selectedFloor.value.isEmpty) {
      Get.snackbar('Not Selected', 'Please select Room & Floor');
    } else if (selectedRoom.value.isEmpty) {
      Get.snackbar('Not Selected', 'Please select the Room');
    } else if (selectedFloor.value.isEmpty) {
      Get.snackbar('Not Selected', 'Please select the Floor');
    } else {
      final result = await SimpleBarcodeScanner.scanBarcode(
        context,
        barcodeAppBar: const BarcodeAppBar(
          appBarTitle: 'Scan Asset Barcode',
          centerTitle: true,
          enableBackButton: true,
          backButtonIcon: Icon(Icons.arrow_back_ios),
        ),
        isShowFlashIcon: true,
        delayMillis: 1,
      );

      if (result != null && result.isNotEmpty && result != '-1') {
        barcode.value = result;

        bool isDuplicate = false;

        // Check if the asset is already in the audited list from the server
        if (auditAssets.isNotEmpty && auditAssets.first.message != null) {
          final alreadyAudited = auditAssets.first.message!.any(
            (auditedAsset) => auditedAsset.asset == result,
          );
          if (alreadyAudited) {
            isDuplicate = true;
          }
        }

        // Check if scanned already (locally)
        if (!isDuplicate) {
          var existingData = await appStorage.read("scannedAssets");
          if (existingData != null) {
            List<dynamic> decoded = jsonDecode(existingData);
            final existingScans = decoded
                .map((e) => ScannedModel.fromJson(e as Map<String, dynamic>))
                .toList();

            final alreadyScanned = existingScans.any(
              (item) => item.assetNo == result,
            );

            if (alreadyScanned) {
              isDuplicate = true;
            }
          }
        }

        if (isDuplicate) {
          final proceed = await showDuplicateDialog();
          if (!proceed) {
            return; // Stop if user cancels
          }
        }

        // Not a duplicate, or user chose to proceed → continue
        await getAsset(result);
        Get.toNamed(AppRoutes.assetViewPage);
      }
    }
  }

  //Get asset
  getAsset(String code) async {
    try {
      isLoading.value = true;
      final response = await apiService.getApi('get_one?id=$code');

      if (response['message'] != null) {
        final assetList = response['message'];
        if (assetList.isNotEmpty) {
          assets.value = await [AssetModel.fromJson(assetList)];

          final assetOwnerEmail =
              assets.value.first.ownerUser?.toString() ?? '';

          final matchedUser = users.firstWhereOrNull(
            (user) =>
                user.email == assetOwnerEmail || user.name == assetOwnerEmail,
          );

          if (matchedUser != null) {
            selectedUser.value = matchedUser.name ?? '';
          } else {
            selectedUser.value = '';
            print("No matching user found for asset owner: $assetOwnerEmail");
          }

          print(selectedUser.value);
          print(assets.value.first);
        } else {
          Get.snackbar('Not Found', 'No asset found...');
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch asset: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  getUser() async {
    try {
      isLoading.value = true;
      final response = await apiService.getApi('get_users');
      if (response != null && response['message'] != null) {
        final UsersModel usersModel = UsersModel.fromJson(response);
        users.clear();
        users.addAll(usersModel.message ?? []);
        print(users.map((e) => e.toJson()).toList());
      } else {
        Get.snackbar('Error', 'Failed to fetch users: Invalid response');
      }
    } catch (e) {
      Get.snackbar('Error', 'API error while fetching users: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  setSelectedUsers(String value) {
    selectedUser.value = value;
  }

  Future updateAssetStatus({
    required String auditNumber,
    required String assetNumber,
    required String building,
    required String floor,
    required String room,
    required String auditType,
    required String assetStatus,
    required String assetOwner,
    String? storeName,
    required String activityBy,
    required String assetStatusOfCurrent,
  }) async {
    try {
      isLoading.value = true;

      final payLoad = {
        'audit_number': auditNumber,
        'asset': assetNumber,
        'building': building,
        'floor': floor,
        'room': room,
        'audit_type': auditType,
        'audit_status': assetStatus,
        'asset_owner': assetOwner,
        'store': storeName,
        'activity_by': userMail.value,
        'current_status': statusAsset.value,
      };

      appDio.Response response = await apiService.postApi(
        'create_audit_analysis',
        payLoad,
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Added Successful');
        fetchAuditedAssets(
          buildingId,
          selectedFloorId.value,
          selectedRoomId.value,
        );
        selectedUser.value = '';
        print(response);
        print(currentAssetStatus.value);
        Get.offNamed(
          AppRoutes.auditingPage,
          arguments: {
            'buildingId': buildingId,
            'buildingName': buildingName,
            'dueDate': dueDate,
          },
        );
      } else {
        Get.snackbar('Error', 'Check your code');
      }
    } catch (e) {
      Get.snackbar('Error', 'Unable to submit audit. Please try again.');
      print('cached error ${e.toString()}');
    }
  }

  void setCurrentAssetStatus() {
    if (assets.isEmpty) {
      currentAssetStatus.value = '';
      return;
    }

    final roomMatch = selectedRoomId.value == assets.first.customRoom;
    final ownerMatch = selectedUser.value == assets.first.ownerUser;

    if (selectedUser == assets.first.ownerUser && roomMatch) {
      currentAssetStatus.value = 'Properly Placed';
      statusAsset.value = "Completed";
    } else if (!roomMatch && !ownerMatch) {
      currentAssetStatus.value = 'Asset Reallocated';
      statusAsset.value = "Pending";
    } else if (!roomMatch) {
      currentAssetStatus.value = 'Location Updated';
      statusAsset.value = "Pending";
    } else if (!ownerMatch) {
      currentAssetStatus.value = 'Owner Updated';
      statusAsset.value = "Pending";
    } else {
      currentAssetStatus.value = 'Unknown Asset';
      statusAsset.value = "Pending";
    }

    print('Asset Status: ${currentAssetStatus.value}');
  }

  clearAudit() async {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.whiteColor,
        title: Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await appStorage.delete('scannedAssets');
              scannedAssets.clear();
              RecentscannedAssets.clear();
              Get.back();
              final deletedData = await appStorage.read('scannedAssets');
              print("scannedAssets after delete: $deletedData");
              // Get.back();
            },
            child: Text('Clear', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  deleteSelectedScanedAsset(String id) async {
    var data = await appStorage.read('scannedAssets');
    if (data != null) {
      List<dynamic> decoded = jsonDecode(data);
      decoded.removeWhere((item) => item['asset_no'] == id);
      await appStorage.write('scannedAssets', jsonEncode(decoded));
      getRecentAssets();
      Get.snackbar('Deleted', 'Asset removed successfully');
    }
  }

  getUserMail() async {
    final value = await appStorage.read('userMail');
    currentUserMail.value = value ?? '';
    print(currentUserMail.value);
  }

  fetchRoom(String buildingId) async {
    final data = {"building": buildingId};
    appDio.Response response = await apiService.postApi(
      'get_pending_rooms_by_building',
      data,
    );
    log('${response.data}');
    pendingFloors.value =
        await [PendingRoomsByFloorModel.fromJson(response.data)].toList();

    // log('${jsonEncode(pendingFloors.value)}');
  }

  setSelectedPendingFloor(String value) async {
    selectedFloor.value = value;
    selectedRoom.value = '';
    auditAssets.value = [];

    final filteredData =
        pendingFloors.first.message!.pendingRoomsByFloor!
            .where((e) => e.floorName == value)
            .map((e) => e.rooms)
            .first;
    print(jsonEncode(filteredData));
    if (filteredData != null && filteredData.length != 0) {
      pendingRooms.value =
          await filteredData
              .map((e) => Rooms(roomId: e.roomId, roomName: e.roomName))
              .toList();
    }

    final floorId =
        pendingFloors.first.message?.pendingRoomsByFloor?.first.floorId ?? '';
    if (floorId != '') {
      selectedFloorId.value = floorId.toString();
      log('----------------> floor id ${selectedFloorId}');
    } else {
      log('floor is fetching is error ');
    }
  }

  setSelectedPendingRoom(String room) {
    log(room);
    if (room != null) {
      selectedRoom.value = room.trim();
    }

    final roomId = pendingRooms.where((e) => e.roomName == room).first.roomId;
    if (roomId != null) {
      selectedRoomId.value = roomId.toString();
      fetchAuditedAssets(
        buildingId,
        selectedFloorId.value,
        selectedRoomId.value,
      );
      log('---------------------------> ${selectedRoomId}');
    } else {
      log('roomId fethcing is error');
    }
  }

  fetchAuditedAssets(String buildingId, String floorId, String roomId) async {
    isLoading.value = true;
    final payload = {"building": buildingId, "floor": floorId, "room": roomId};
    print('AuditedAssetsModel ${payload}');
    try {
      appDio.Response response = await apiService.postApi(
        'get_api_audit_analysis_filter',
        payload,
      );

      auditAssets.value =
          await [AuditedAssetsModel.fromJson(response.data)].toList();

      log('AuditedAssetsModel${jsonEncode(auditAssets.value)}');
      // if (response.statusCode != null) {
      // }
    } catch (e) {
      Get.snackbar('Error', 'Check your api$e');
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      log("tested");
      isLoading.value = false;
    }
  }

  getAllAssetsByRoom(String buildingId, String floorId, String roomId) async {
    final payLoad = {
      "custom_building": buildingId,
      "custom_floor": floorId,
      "custom_room": roomId,
    };
    try {
      isLoading.value = true;
      appDio.Response response = await apiService.postApi(
        'get_api_asset_list_filter',
        payLoad,
      );
      if (response != null) {
        log('room assets is fetched');
        roomAssets.value = await [AssetsByRoomModel.fromJson(response.data)];
        missAssetsFinder();

        log('${jsonEncode(roomAssets.value)}');
      }
    } catch (e) {
      log('${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  missAssetsFinder() async {
    List audit_assetno =
        auditAssets.first.message!.map((e) => e.asset).toList();
    List room_assetno = roomAssets.first.message!.map((e) => e.name).toList();

    List missingAsset =
        room_assetno.where((item) => !audit_assetno.contains((item))).toList();

    postMissingAsset(assetNumbers: missingAsset);

    //     }

    print('----------------audit-----------> $audit_assetno');
    print('----------room------------>$room_assetno');
    print('----------missing Asset------------>$missingAsset');

    log(
      'missing assets--------------------------------------------> ${missingAsset}',
    );

    log('Need room${jsonEncode(roomAssets.value)}');
    log('Need value${jsonEncode(auditAssets.value)}');
  }

  Future<void> postMissingAsset({required List assetNumbers}) async {
    try {
      if (assetNumbers.isEmpty) {
        Get.snackbar(
          'No Missing Assets',
          'Nothing to post',
          backgroundColor: AppTheme.dangerColor,
          colorText: AppTheme.whiteColor,
        );
        return;
      }

      var payload = {
        "message":
            assetNumbers
                .map(
                  (e) => {
                    'audit_number': auditNumber,
                    'asset': e.toString(),
                    'building': buildingId,
                    'floor': selectedFloorId.value,
                    'room': selectedRoomId.value,
                    'audit_type': 'Issued Audit',
                    'audit_status': 'Missing Asset',
                    'asset_owner': userMail.value,
                    // 'store': "ICTS Store",
                    'activity_by': userMail.value,
                    'current_status': 'Pending',
                  },
                )
                .toList(),
      };

      print("Payload ------------------------> $payload");

      final appDio.Response response = await apiService.postApi(
        'create_audit_analysis_multiple',
        payload,
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Missing Assets Posted');

        selectedUser.value = '';
        print("Response: ${response.data}");
      } else {
        Get.snackbar('Error', 'Failed to post. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print('Caught error: ${e.toString()}');
    } finally {
      roomStatusUpdate();
      clearDropDown();
    }
  }

  roomStatusUpdate() async {
    final payload = {
      "audit_number": auditNumber,
      "building": buildingId,
      "rooms_to_update": [selectedRoomId.value],
    };
    print('rooms status payload $payload');
    try {
      isLoading.value = true;
      appDio.Response response = await apiService.postApi(
        'update_audit_status',
        payload,
      );

      if (response != null) {
        print('Room status updated $response');
      } else {
        print('cheack you api');
      }
    } catch (e) {
      Get.snackbar('error', '${e.toString()}');
    }
  }

  clearDropDown() {
    selectedFloor.value = '';
    selectedRoom.value = '';
    pendingRooms.value = [];
    fetchRoom(buildingId);
  }
}
