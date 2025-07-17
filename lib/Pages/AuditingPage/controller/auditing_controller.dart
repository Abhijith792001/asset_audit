import 'package:asset_audit/Pages/AuditingPage/model/floor_model.dart';
import 'package:asset_audit/Pages/AuditingPage/model/room_model.dart';
import 'package:asset_audit/service/api_service.dart';
import 'package:get/get.dart';

class AuditingController extends GetxController {
  final ApiService apiService = ApiService();

  RxList<CustomFloor> floors = <CustomFloor>[].obs;
  RxList<CustomRoom> rooms = <CustomRoom>[].obs;

  RxString selectedFloor = ''.obs;
  RxString selectedRoom = ''.obs;

  RxBool isLoading = false.obs;
  late final String buildingId;
  late final String buildingName;


  @override
  void onInit() {
    super.onInit();
    buildingId = Get.arguments?['buildingId'] ?? '';
    buildingName = Get.arguments?['buildingName'] ?? '';
    if (buildingId.isNotEmpty) {
      getFloor(buildingId);
    } else {
      print('No building ID provided');
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

  // Handle floor selection and fetch corresponding rooms
  // void setSelectedFloor(String value) {
  //   selectedFloor.value = value;

  //   final selected = floors.firstWhere(
  //     (floor) => floor.customFloor == selectedFloor.value,
  //     orElse: () => CustomFloor(name: '', customFloor: ''),
  //   );

  //   if (selected.name!.isNotEmpty) {
  //     final floorId = selected.name;
  //     getRoom(floorId!); // Fetch rooms for selected floor
  //   } else {
  //     rooms.clear(); // Clear rooms if invalid floor is selected
  //   }
  // }
  void setSelectedFloor(String value) {
  // Update floor and reset room every time
  selectedFloor.value = value;
  selectedRoom.value = '';
  rooms.clear(); // Clear room list before fetching new data

  final selected = floors.firstWhere(
    (floor) => floor.customFloor == value,
    orElse: () => CustomFloor(name: '', customFloor: ''),
  );

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
  }
}
