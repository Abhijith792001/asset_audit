import 'package:asset_audit/Pages/AuditingPage/controller/auditing_controller.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:asset_audit/utils/storage_manager.dart';
import 'package:asset_audit/widgets/asset_card.dart';
import 'package:asset_audit/widgets/custom_dropdown%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuditingPage extends GetView<AuditingController> {
  AuditingPage({super.key});

  final buildingId = Get.arguments['buildingId'];
  final buildingName = Get.arguments['buildingName'];
  final appStorage = StorageManager();
  final _assetNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked:
          (didPop) => {
            if (!didPop) {Get.offNamed(AppRoutes.homePage)},
          },
      child: Scaffold(
        backgroundColor: AppTheme.whiteColor,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            controller.scanAndFetch(context);
          },
          icon: Icon(LucideIcons.qrCode, color: AppTheme.whiteColor),
          label: Text(
            'Scan Assets',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.whiteColor,
            ),
          ),
          backgroundColor: AppTheme.primaryColor,
        ),
        appBar: AppBar(
          toolbarHeight: 70,
          leading: InkWell(
            onTap: () => {Get.offAllNamed(AppRoutes.homePage)},
            child: Icon(LucideIcons.chevronLeft, color: AppTheme.whiteColor),
          ),
          title: Obx(
            () => Text(
              controller.selectedRoom.value == ''
                  ? 'Auditing'
                  : controller.selectedRoom.value,
              style: TextStyle(color: AppTheme.whiteColor, fontSize: 18),
            ),
          ),
          backgroundColor: AppTheme.primaryColor,
          actions: [
            InkWell(
              onTap: () {
                // controller.postMissingAsset(assetNumbers: []);
                Get.dialog(
                  AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text('Are You sure'),
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
                        onPressed: () {
                          controller.getAllAssetsByRoom(
                            buildingId,
                            controller.selectedFloorId.value,
                            controller.selectedRoomId.value,
                          );
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: BadgeBtn(title: 'Finish'),
            ),
            SizedBox(width: 10.w),
          ],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        buildingName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.h),
                    Obx(
                      () => Flexible(
                        child: CustomDropdown(
                          hint: 'Select Floor',
                          selectedValue:
                              controller.pendingFloors.value.length == 0
                                  ? null
                                  : controller
                                      .pendingFloors
                                      .value
                                      .first
                                      .message!
                                      .pendingRoomsByFloor!
                                      .map((f) => f.floorName)
                                      .contains(controller.selectedFloor.value)
                                  ? controller.selectedFloor.value
                                  : null,
                          items:
                              controller.pendingFloors.value.length == 0
                                  ? []
                                  : controller
                                      .pendingFloors
                                      .value
                                      .first
                                      .message!
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: CustomDropdown(
                    hint: 'Select Room',
                    selectedValue:
                        controller.selectedRoom.value == null
                            ? ''
                            : controller.selectedRoom.value.trim(),
                    items:
                        controller.pendingRooms.length == 0
                            ? []
                            : controller.pendingRooms
                                .map((room) => room.roomName.toString().trim())
                                .toList(),
                    onChanged:
                        (value) => controller.setSelectedPendingRoom(value),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Obx(() {
                  if (controller.selectedFloor.isEmpty) {
                    return Text(
                      'Please select a floor to continue',
                      style: TextStyle(color: AppTheme.dangerColor),
                    );
                  }
                  if (controller.selectedRoom.isEmpty) {
                    return Text(
                      'Select your room to proceed',
                      style: TextStyle(color: AppTheme.dangerColor),
                    );
                  }
                  return const SizedBox(); // All selections done
                }),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap:
                          () => {
                            Get.dialog(
                              AlertDialog(
                                backgroundColor: AppTheme.whiteColor,
                                actions: [
                                  Column(
                                    children: [
                                      SizedBox(height: 10.h),
                                      Text(
                                        'Enter Asset Number',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextField(controller: _assetNumber),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await controller.getAsset(
                                                _assetNumber.text.trim(),
                                              );
                                              Get.toNamed(
                                                AppRoutes.assetViewPage,
                                              );
                                            },
                                            child: Text(
                                              'Search Asset',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          },
                      child: BadgeBtn(title: 'Search Manual'),
                    ),
                    InkWell(
                      onTap: () => {controller.clearAudit()},
                      child: BadgeBtn(title: 'Clear History'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: AppTheme.blackColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Scanned Assets',
                      style: TextStyle(
                        fontSize: 16.87.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                () => Expanded(
                  child: Skeletonizer(
                    enabled: controller.isLoading.value,
                    enableSwitchAnimation: true,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // Add refresh functionality if needed
                        //  controller.fetchAuditedAssets(buildingId, floorId, roomId);
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount:
                            controller.isLoading.value
                                ? 5 // Show 5 skeleton items while loading
                                : controller.auditAssets.value.length == 0 ||
                                    controller
                                            .auditAssets
                                            .value
                                            .first
                                            .message!
                                            .length ==
                                        0
                                ? 1 // Show 1 item for "No assets" message
                                : controller.auditAssets.first.message!.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (controller.isLoading.value) {
                            // Return skeleton version of AssetCard
                            return Column(
                              children: [
                                SizedBox(height: 5.h),
                                AssetCard(
                                  assetName: "Loading Asset Name",
                                  status: "Loading Status",
                                ),
                              ],
                            );
                          }

                          if (controller.auditAssets.value.length == 0 ||
                              controller
                                      .auditAssets
                                      .value
                                      .first
                                      .message!
                                      .length ==
                                  0) {
                            // Show "No assets" message when not loading and no data
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 50.h),
                                child: Text(
                                  'No assets scanned yet',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppTheme.grayColor,
                                  ),
                                ),
                              ),
                            );
                          }

                          // Show actual asset data
                          final assets =
                              controller.auditAssets.first.message![index];
                          return Column(
                            children: [
                              SizedBox(height: 5.h),
                              AssetCard(
                                assetName: assets.asset.toString(),
                                status: assets.auditStatus.toString(),
                              ),
                            ],
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
    );
  }
}

class BadgeBtn extends StatelessWidget {
  const BadgeBtn({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
