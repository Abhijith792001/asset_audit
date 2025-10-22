import 'package:asset_audit/Pages/AuditingPage/controller/auditing_controller.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:asset_audit/widgets/custom_dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AssetViewPage extends StatelessWidget {
  AssetViewPage({super.key});

  // ✅ Use existing controller instance
  final controller = Get.find<AuditingController>();
  // final controller2 = Get.find<AuditingController>();

  // final floorName = Get.arguments['floorName'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            controller.assets.clear();
            controller.barcode.value = '';
            Get.toNamed(
              AppRoutes.auditingPage,
              arguments: {
                'buildingId': controller.buildingId,
                'buildingName': controller.buildingName,
              },
            );
          },
          child: Icon(LucideIcons.chevronLeft, color: AppTheme.whiteColor),
        ),
        title: Text(
          'Asset Details',
          style: TextStyle(color: AppTheme.whiteColor),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.assets.isEmpty) {
          return const Center(child: Text('This asset is not found'));
        }

        final assetList = controller.assets.first;

        return PopScope(
          // onPopInvokedWithResult:
          //     (didPop, result) => {
          //       Get.toNamed(
          //         AppRoutes.auditingPage,
          //         arguments: {
          //           'buildingId': controller2.buildingId,
          //           'buildingName': controller2.buildingName,
          //         },
          //       ),
          //     },
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              Get.toNamed(
                AppRoutes.auditingPage,
                arguments: {
                  'buildingId': controller.buildingId,
                  'buildingName': controller.buildingName,
                },
              );
            }
          },

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Audit Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppTheme.whiteColor,
                    borderRadius: BorderRadius.circular(16.sp),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        blurRadius: 4,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 12.w,
                          right: 12.w,
                          top: 12.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                    color: AppTheme.secondaryColor,
                                    borderRadius: BorderRadius.circular(8.sp),
                                  ),
                                  child: Icon(
                                    LucideIcons.box,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      assetList.assetNo.toString(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      assetList.productCategory.toString(),
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.grayColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              '12/05/2025',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppTheme.grayColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(thickness: 0.7, color: Colors.grey[300]),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 12.w,
                          right: 12.w,
                          bottom: 12.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Current Status : ${assetList.assetStatus}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      Text(
                        'Room Audited: ${controller.selectedRoom}',
                        style: TextStyle(
                          fontSize: 16.67,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.grayColor,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'Current Owner',
                        style: TextStyle(
                          fontSize: 16.67.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        controller.selectedUser.value == ""
                            ? 'Owner Not found'
                            : controller.selectedUser.value.toString(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              assetList.ownerName == null
                                  ? AppTheme.dangerColor
                                  : AppTheme.grayColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              // controller.updateAssets();
                              showModel(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32.sp),
                                color: AppTheme.secondaryColor,
                                border: Border.all(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              child: Text(
                                'Update Owner',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Product Model',
                        style: TextStyle(
                          fontSize: 16.67.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        assetList.productModel.toString(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.grayColor,
                        ),
                      ),

                      SizedBox(height: 10.h),
                      Text(
                        'Modified By',
                        style: TextStyle(
                          fontSize: 16.67.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        controller.userMail.value,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.grayColor,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      controller.isDuplicateAsset.value == false
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Audit Status',
                                style: TextStyle(
                                  fontSize: 16.87.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5.h),

                              // check(
                              //   controller.selectedRoomId == assetList.customRoom
                              //       ? "Room Matched"
                              //       : "Not Matched",
                              //   controller.selectedRoomId == assetList.customRoom
                              //       ? LucideIcons.circleCheck
                              //       : LucideIcons.circle,
                              // ),
                              Text(
                                controller.selectedRoomId ==
                                        assetList.customRoom
                                    ? 'Location Verified: Asset is placed in the correct location.'
                                    : 'Location Mismatch: Asset found in a different location than expected.',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      controller.selectedRoomId ==
                                              assetList.customRoom
                                          ? AppTheme.blackColor
                                          : AppTheme.dangerColor,
                                ),
                              ),
                            ],
                          )
                          : SizedBox.shrink(),
                      SizedBox(height: 10.h),
                      // Confirm Button
                      Obx(() {
                        return controller.isDuplicateAsset.value == false
                            ? InkWell(
                              onTap: () {
                                if (controller.selectedUser.value != "") {
                                  controller.setCurrentAssetStatus();
                                  // controller.addScannedAssets();
                                  controller.updateAssetStatus(
                                    auditNumber: controller.auditNumber,
                                    assetNumber: assetList.assetNo.toString(),
                                    building: controller.buildingId,
                                    floor: controller.selectedFloorId.value,
                                    auditType: 'Issued Audit',
                                    assetStatus:
                                        controller.currentAssetStatus.value,
                                    assetOwner: controller.selectedUser.value,
                                    storeName:
                                        assetList.store == null
                                            ? ''
                                            : assetList.store.toString(),
                                    activityBy: controller.userMail.value,
                                    room: controller.selectedRoomId.value,
                                    assetStatusOfCurrent: '',
                                  );
                                } else {
                                  Get.snackbar(
                                    'Select User',
                                    'The owen is not selected',
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(32),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.h,
                                  horizontal: 30.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  gradient: AppTheme.primaryGradient,
                                  border: Border.all(
                                    color: AppTheme.primaryColor,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                            : Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.dangerColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.dangerColor,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                '⚠️ This asset has already been scanned.',
                                style: TextStyle(
                                  color: AppTheme.dangerColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void showModel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.sp)),
      ),
      builder: (ctx) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(ctx).unfocus(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxHeight: Get.height * 0.8),
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.sp),
                    topRight: Radius.circular(32.sp),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2.sp),
                        ),
                      ),
                    ),
                    Text(
                      'Edit Owner',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(() {
                      return CustomDropdownSearch(
                        hint: 'Select user',
                        selectedValue: controller.selectedUser.value,
                        items:
                            controller.users.map((f) => f.email ?? '').toList(),
                        onChanged:
                            (value) => controller.setSelectedUsers(value),
                      );
                    }),
                    SizedBox(height: 24.h),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(ctx).pop(),
                            borderRadius: BorderRadius.circular(32.sp),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32.sp),
                                color: AppTheme.whiteColor,
                                border: Border.all(
                                  color: AppTheme.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(ctx).pop();
                              Get.snackbar(
                                'Success',
                                'Asset owner updated successfully',
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  9,
                                  143,
                                  58,
                                ),
                                colorText: Colors.white,
                              );
                            },
                            borderRadius: BorderRadius.circular(32.sp),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32.sp),
                                gradient: AppTheme.primaryGradient,
                                border: Border.all(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              child: Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
