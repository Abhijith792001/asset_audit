import 'dart:convert';
import 'package:asset_audit/Pages/AuditingPage/controller/auditing_controller.dart';
import 'package:asset_audit/Pages/AuditingPage/model/scanned_model.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:asset_audit/utils/storage_manager.dart';
import 'package:asset_audit/widgets/asset_card.dart';
import 'package:asset_audit/widgets/custom_dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DesktopAuditingPage extends GetView<AuditingController> {
  DesktopAuditingPage({super.key});

  final buildingId = Get.arguments['buildingId'];
  final buildingName = Get.arguments['buildingName'];
  final appStorage = StorageManager();
  final _assetNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    );
    return PopScope(
      canPop: false,
      onPopInvoked:
          (didPop) => {
        if (!didPop) {Get.offNamed(AppRoutes.homePage)},
      },
      child: Scaffold(
        backgroundColor: AppTheme.grayLightColor,
        body: Row(
          children: [
            // Left Column
            Container(
              width: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.whiteColor,
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Get.offAllNamed(AppRoutes.homePage),
                        child: Icon(
                          LucideIcons.chevronLeft,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.selectedRoom.value == ''
                                ? 'Auditing'
                                : controller.selectedRoom.value,
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    buildingName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Floor Dropdown
                  Obx(
                    () => CustomDropdownSearch(
                      hint: 'Select Floor',
                      selectedValue:
                          controller.pendingFloors.value.length == 0
                              ? null
                              : controller
                                      .pendingFloors.value.first.message!
                                      .pendingRoomsByFloor!
                                      .map((f) => f.floorName)
                                      .contains(
                                        controller.selectedFloor.value,
                                      )
                                  ? controller.selectedFloor.value
                                  : null,
                      items:
                          controller.pendingFloors.value.length == 0
                              ? []
                              : controller
                                  .pendingFloors.value.first.message!
                                  .pendingRoomsByFloor!
                                  .map(
                                    (floor) => floor.floorName.toString(),
                                  )
                                  .toList(),
                      onChanged:
                          (value) =>
                          controller.setSelectedPendingFloor(value),
                    ),
                  ),
                  SizedBox(height: 12),
                  // Room Dropdown
                  Obx(
                    () => CustomDropdownSearch(
                      hint: 'Select Room',
                      selectedValue:
                          controller.selectedRoom.value == null
                              ? ''
                              : controller.selectedRoom.value.trim(),
                      items:
                          controller.pendingRooms.length == 0
                              ? []
                              : controller.pendingRooms
                                  .map(
                                    (room) =>
                                        room.roomName.toString().trim(),
                                  )
                                  .toList(),
                      onChanged:
                          (value) =>
                          controller.setSelectedPendingRoom(value),
                    ),
                  ),
                  SizedBox(height: 12),
                  // Validation Messages
                  Obx(() {
                    if (controller.selectedFloor.isEmpty) {
                      return Text('Please select a floor to continue', style: TextStyle(color: Colors.red));
                    }
                    if (controller.selectedRoom.isEmpty) {
                      return Text('Select your room to proceed', style: TextStyle(color: Colors.orange));
                    }
                    return const SizedBox();
                  }),
                  Spacer(),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (controller.selectedRoom.value.isEmpty ||
                                controller.selectedFloor.value.isEmpty) {
                              Get.snackbar(
                                'Not Selected',
                                'Please select a Floor and Room first.',
                              );
                            } else {
                              Get.dialog(
                                Dialog(
                                  child: Container(
                                    padding: EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Enter Asset Number', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 20),
                                        TextField(
                                          controller: _assetNumber,
                                          decoration: InputDecoration(
                                            hintText: 'Asset Number',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: Text('Cancel'),
                                            ),
                                            SizedBox(width: 12),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final assetNumber =
                                                    _assetNumber.text.trim();
                                                if (assetNumber.isEmpty) {
                                                  Get.snackbar(
                                                    'Input Required',
                                                    'Please enter an asset number',
                                                  );
                                                  return;
                                                }
                                                final success = await controller.getAsset(assetNumber.toUpperCase());
                                                if (success) {
                                                  Get.back();
                                                  _assetNumber.clear();
                                                  Get.toNamed(
                                                    AppRoutes.assetViewPage,
                                                  );
                                                }
                                              },
                                              child: Text('Search'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Icon(LucideIcons.search),
                          label: Text('Search Manual'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: Text('Finish Audit?'),
                                content: Text('Are you sure you want to complete this audit?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.getAllAssetsByRoom(
                                        buildingId,
                                        controller.selectedFloorId.value,
                                        controller.selectedRoomId.value,
                                      );
                                      Get.back();
                                    },
                                    child: Text('Confirm'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(LucideIcons.circleCheck),
                          label: Text('Finish Audit'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      onPressed: () => controller.scanAndFetch(context,),
                      icon: Icon(LucideIcons.qrCode),
                      label: Text('Scan Assets'),
                    ),
                  ),
                ],
              ),
            ),
            // Right Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scanned Assets',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: Obx(
                        () => Skeletonizer(
                          enabled: controller.isLoading.value,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              if (controller.selectedRoomId.value.isNotEmpty) {
                                controller.fetchAuditedAssets(
                                  buildingId,
                                  controller.selectedFloorId.value,
                                  controller.selectedRoomId.value,
                                );
                              }
                            },
                            child: Builder(
                              builder: (context) {
                                final hasValidData = controller.auditAssets.isNotEmpty &&
                                    controller.auditAssets.first.message != null &&
                                    controller.auditAssets.first.message!.isNotEmpty;

                                final itemCount = controller.isLoading.value
                                    ? 5
                                    : hasValidData
                                        ? controller.auditAssets.first.message!.length
                                        : 1;

                                return ListView.builder(
                                  itemCount: itemCount,
                                  itemBuilder: (BuildContext context, int index) {
                                    if (controller.isLoading.value) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: AssetCard(
                                          assetName: "Loading Asset Name",
                                          status: "Loading Status",
                                        ),
                                      );
                                    } else if (!hasValidData) {
                                      return Center(
                                        child: Text('No assets scanned yet'),
                                      );
                                    } else {
                                      final asset = controller.auditAssets.first.message![index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: AssetCard(
                                          assetName: asset.asset.toString(),
                                          status: asset.auditStatus.toString(),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
