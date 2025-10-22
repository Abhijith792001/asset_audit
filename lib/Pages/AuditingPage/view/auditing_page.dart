import 'dart:convert';
import 'package:asset_audit/Pages/AuditingPage/controller/auditing_controller.dart';
import 'package:asset_audit/Pages/AuditingPage/model/scanned_model.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:asset_audit/utils/storage_manager.dart';
import 'package:asset_audit/widgets/asset_card.dart';
import 'package:asset_audit/widgets/custom_dropdown%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    );
    return PopScope(
      canPop: false,
      onPopInvoked:
          (didPop) => {
        if (!didPop) {Get.offNamed(AppRoutes.homePage)},
      },
      child: Scaffold(
        backgroundColor: AppTheme.grayLightColor,
        // --- 1. WRAPPED THE COLUMN WITH SingleChildScrollView ---
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Modern Header Section
              Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.w),
                    bottomRight: Radius.circular(30.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row with Back Button
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Get.offAllNamed(AppRoutes.homePage),
                              child: Icon(
                                LucideIcons.chevronLeft,
                                color: AppTheme.whiteColor,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Obx(
                                () => Text(
                                  controller.selectedRoom.value == ''
                                      ? 'Auditing'
                                      : controller.selectedRoom.value,
                                  style: TextStyle(
                                    color: AppTheme.whiteColor,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        // Building Name
                        Text(
                          buildingName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // Floor Dropdown
                        Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.w),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: CustomDropdown(
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
                        ),
                        SizedBox(height: 12.h),
                        // Room Dropdown
                        Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.w),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
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
                        ),
                        SizedBox(height: 12.h),
                        // Validation Messages
                        Obx(() {
                          if (controller.selectedFloor.isEmpty) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      'Please select a floor to continue',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (controller.selectedRoom.isEmpty) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      'Select your room to proceed',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox();
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Search Manual Button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (controller.selectedRoom.value.isEmpty ||
                              controller.selectedFloor.value.isEmpty) {
                            Get.snackbar(
                              'Not Selected',
                              'Please select a Floor and Room first.',
                            );
                          } else {
                            Get.dialog(
                              Dialog(
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  padding: EdgeInsets.all(24.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.whiteColor,
                                    borderRadius: BorderRadius.circular(24.w),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        LucideIcons.search,
                                        size: 48.sp,
                                        color: AppTheme.primaryColor,
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'Enter Asset Number',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      TextField(
                                        controller: _assetNumber,
                                        decoration: InputDecoration(
                                          hintText: 'Asset Number',
                                          filled: true,
                                          fillColor: AppTheme.grayLightColor,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12.w,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          prefixIcon: Icon(LucideIcons.hash),
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () => Get.back(),
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12.h,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12.w),
                                                ),
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: ElevatedButton(
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

                                                // The duplicate check is now handled inside getAsset
                                                final success = await controller.getAsset(assetNumber);
                                                if (success) {
                                                  Get.back(); // Close the dialog
                                                  _assetNumber.clear(); // Clear text field for next time
                                                  Get.toNamed(
                                                    AppRoutes.assetViewPage,
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppTheme.primaryColor,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12.h,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12.w),
                                                ),
                                              ),
                                              child: Text(
                                                'Search',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp,
                                                  color: AppTheme.whiteColor,
                                                ),
                                              ),
                                            ),
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
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 12.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor,
                            borderRadius: BorderRadius.circular(16.w),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.secondaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.search,
                                size: 18.sp,
                                color: AppTheme.primaryColor,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'Search Manual',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Finish Audit Button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                           Get.dialog(
                             Dialog(
                              backgroundColor: Colors.transparent,
                              child: Container(
                                padding: EdgeInsets.all(24.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.whiteColor,
                                  borderRadius: BorderRadius.circular(24.w),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(
                                          0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        LucideIcons.circleCheck,
                                        size: 48.sp,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'Finish Audit?',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Are you sure you want to complete this audit?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () => Get.back(),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.w),
                                              ),
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              controller.getAllAssetsByRoom(
                                                buildingId,
                                                controller.selectedFloorId.value,
                                                controller.selectedRoomId.value,
                                              );
                                              Get.back();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppTheme.primaryColor,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.w),
                                              ),
                                            ),
                                            child: Text(
                                              'Confirm',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                                color: AppTheme.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 12.w,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryColor,
                                AppTheme.primaryColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16.w),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.circleCheck,
                                size: 18.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'Finish Audit',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scanned Assets Section Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Icon(
                        Icons.history,
                        color: AppTheme.primaryColor,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Scanned Assets',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.blackColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Assets List
              Obx(
                // --- 2. REMOVED Expanded WIDGET ---
                () => Skeletonizer(
                  enabled: controller.isLoading.value,
                  enableSwitchAnimation: true,
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
                          // --- 3. ADDED shrinkWrap AND physics PROPERTIES ---
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: itemCount,
                          itemBuilder: (BuildContext context, int index) {
                            if (controller.isLoading.value) {
                              return Column(
                                key: ValueKey('skeleton_$index'),
                                children: [
                                  SizedBox(height: 8.h),
                                  const AssetCard(
                                    assetName: "Loading Asset Name",
                                    status: "Loading Status",
                                  ),
                                ],
                              );
                            } else if (!hasValidData) {
                              return Center(
                                key: const ValueKey('empty_state'),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(20.w),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          LucideIcons.scanLine,
                                          size: 30.sp,
                                          color: AppTheme.primaryColor.withOpacity(0.6),
                                        ),
                                      ),
                                      SizedBox(height: 24.h),
                                      Text(
                                        'No assets scanned yet',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'Select a floor and room to see assets',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              if (index >= controller.auditAssets.first.message!.length) {
                                return const SizedBox.shrink();
                              }
                              final asset = controller.auditAssets.first.message![index];
                              return Padding(
                                key: ValueKey(asset.asset),
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: AssetCard(
                                  key: ValueKey('${asset.asset}_card'),
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
              )
            ],
          ),
        ),
        // Modern Floating Action Button
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(30.w),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => controller.scanAndFetch(context,),
            icon: Icon(
              LucideIcons.qrCode,
              color: AppTheme.whiteColor,
              size: 24.sp,
            ),
            label: Text(
              'Scan Assets',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.whiteColor,
                letterSpacing: 0.5,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
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