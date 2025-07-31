import 'dart:convert';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:dio/dio.dart' as appDio;
import 'package:asset_audit/Pages/AuditingPage/model/floor_model.dart';
import 'package:asset_audit/Pages/AuditingPage/model/room_model.dart';
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

  RxList<CustomFloor> floors = <CustomFloor>[].obs;
  RxList<CustomRoom> rooms = <CustomRoom>[].obs;
  RxList<AssetModel> assets = <AssetModel>[].obs;
  RxList<ScannedModel> scannedAssets = <ScannedModel>[].obs;
  RxList<ScannedModel> RecentscannedAssets = <ScannedModel>[].obs;
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

  RxString selectedUser = ''.obs;

  late final String buildingId;
  late final String buildingName;
  late final String dueDate;
  late final String auditNumber;

  @override
  void onInit() {
    super.onInit();
    
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
      getFloor(buildingId);
    } else {
      print('No building ID provided');
    }
    print(buildingId);
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

  // Fetch Floors by Building ID
  void getFloor(String buildingId) async {
    try {
      isLoading.value = true;
      final response = await apiService.getApi(
        'get_lm_floor?custom_building=$buildingId',
      );

      if (response != null && response['message']?['custom_floor'] != null) {
        final floorModel = FloorModel.fromJson(response);
        final floorList = floorModel.message?.customFloor ?? [];
        floors.assignAll(floorList);
      }
    } catch (e) {
      print('Error fetching floor: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedFloor(String value) {
    // Update floor and reset room every time
    selectedFloor.value = value;
    selectedRoom.value = '';
    rooms.clear(); // Clear room list before fetching new data

    final selected = floors.firstWhere(
      (floor) => floor.customFloor == value,
      orElse: () => CustomFloor(name: '', customFloor: ''),
    );
    print("${selected.name} this is selected i need id");

    selectedFloorId.value = selected.name.toString();

    if (selected.name != null && selected.name!.isNotEmpty) {
      getRoom(selected.name!); // Fetch rooms for the new floor
    } else {
      rooms.clear();
    }

    print('User selected new floor: $value');
  }

  // Fetch rooms based on floor ID and building ID
  void getRoom(String floorId) async {
    try {
      isLoading.value = true;
      final response = await apiService.getApi(
        'get_lm_room?custom_building=$buildingId&custom_floor=$floorId',
      );

      if (response != null && response['message']?['custom_room'] != null) {
        final roomModel = RoomModel.fromJson(response);
        final roomList = roomModel.message?.customRoom ?? [];
        rooms.assignAll(roomList);
      } else {
        rooms.clear();
      }

      print(rooms);
    } catch (e) {
      print('Error fetching rooms: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Handle room selection
  void setSelectedRoom(String value) {
    selectedRoom.value = value;

    print(
      'Selected Floor: ${selectedFloor.value}, Selected Room: ${selectedRoom.value}',
    );
    final roomTake = rooms.firstWhere(
      (floor) => floor.customRoom == value,
      orElse: () => CustomRoom(name: '', customRoom: ''),
    );
    selectedRoomId.value = roomTake.name.toString();
    print(roomTake.name);
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

        // Check if scanned already
        var existingData = await appStorage.read("scannedAssets");
        if (existingData != null) {
          List<dynamic> decoded = jsonDecode(existingData);
          final existingScans =
              decoded
                  .map((e) => ScannedModel.fromJson(e as Map<String, dynamic>))
                  .toList();

          final alreadyScanned = existingScans.any(
            (item) => item.assetNo == result,
          );

          if (alreadyScanned) {
            Get.snackbar(
              'Duplicate Scan',
              'This asset was already scanned!',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
            return; // stop here
          }
        }

        // Not scanned yet → proceed
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

  addScannedAssets() async {
    if (assets.value.isEmpty) return;

    final value = assets.value.first;
    final scanned = ScannedModel(
      assetNo: value.assetNo.toString(),
      owner: value.owner.toString(),
      modifiedBy: value.owner.toString(),
      assetStatus: value.assetStatus.toString(),
      date: '17/07/2025',
    );

    scannedAssets.value = [scanned];

    Get.snackbar('Success', 'Added Successfully');
    // selectedUser.value = '';

    print(jsonEncode(scannedAssets.value.first));
    var existing = await appStorage.read("scannedAssets");
    print(jsonEncode(existing));

    if (existing == null) {
      print("josn ${jsonEncode([scanned])}");
      appStorage.write("scannedAssets", jsonEncode([scanned.toJson()]));
      final valueResultt = await appStorage.read('scannedAssets');
      print('read ${valueResultt}');
    } else {
      List<dynamic> decoded = jsonDecode(existing);
      decoded.add(scanned.toJson());
      appStorage.write("scannedAssets", jsonEncode(decoded));
      final valueResultt = await appStorage.read('scannedAssets');
      print('read ${valueResultt}');
    }
    getRecentAssets();
    Get.offNamed(
      AppRoutes.auditingPage,
      arguments: {
        'buildingId': buildingId,
        'buildingName': buildingName,
        'dueDate': dueDate,
      },
    );
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
    required String assetStatusOfCurrent
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
        'activity_by': currentUserMail.value,
        'current_status':statusAsset.value
      };

      appDio.Response response = await apiService.postApi(
        'create_audit_analysis',
        payLoad,
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Added Successful');
        selectedUser.value = '';
        print(response);
        print(currentAssetStatus.value);
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





}
