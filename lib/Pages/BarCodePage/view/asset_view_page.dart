import 'package:asset_audit/Pages/AuditingPage/controller/auditing_controller.dart';
import 'package:asset_audit/Pages/BarCodePage/controller/barcode_controller.dart';
import 'package:asset_audit/Pages/HomePage/controller/home_controller.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:asset_audit/widgets/croseCheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AssetViewPage extends StatelessWidget {
  AssetViewPage({super.key});

  // ✅ Use existing controller instance
  final controller = Get.find<BarcodeController>();
  final controller2 = Get.find<AuditingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          onPopInvoked: (didPopup) {
            if (!didPopup) {
              Get.toNamed(
                AppRoutes.auditingPage,
                arguments: {
                  'buildingId': controller2.buildingId,
                  'buildingName': controller2.buildingName,
                },
              );
            }
          },
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        gradient: AppTheme.btnPrimaryGradient,
                      ),
                      child: SafeArea(
                        minimum: EdgeInsets.symmetric(horizontal: 16.sp),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.assets.clear();
                                    controller.barcode.value = '';
                                    Get.toNamed(
                                      AppRoutes.auditingPage,
                                      arguments: {
                                        'buildingId': controller2.buildingId,
                                        'buildingName':
                                            controller2.buildingName,
                                      },
                                    );
                                  },
                                  child: Icon(
                                    LucideIcons.chevronLeft,
                                    color: AppTheme.whiteColor,
                                  ),
                                ),
                                SizedBox(width: 10.h),
                                Text(
                                  'Asset Details',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 45.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.sp,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.whiteColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 100.h),
                          Text(
                            'Cross-checking',
                            style: TextStyle(
                              fontSize: 16.87.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          check('Room', LucideIcons.circleCheck),
                          check('Building', LucideIcons.circleCheck),
                          SizedBox(height: 30.h),
                          Text(
                            'Remarks',
                            style: TextStyle(
                              fontSize: 16.67.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'For Class room above Amriteswari hall',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.grayColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Owner',
                            style: TextStyle(
                              fontSize: 16.67.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            assetList.owner.toString(),
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
                            assetList.modifiedBy.toString(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.grayColor,
                            ),
                          ),
                          SizedBox(height: 40.h),
                          InkWell(
                            onTap: () => Get.offAllNamed(AppRoutes.homePage),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 7.h,
                                    horizontal: 50.w,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    gradient: AppTheme.primaryGradient,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 140.h,
                right: 0,
                left: 0,
                child: Container(
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
                                      assetList.customBuilding ??
                                          assetList.store ??
                                          'Not Specified',
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
                              'Status : ${assetList.assetStatus}',
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
              ),
            ],
          ),
        );
      }),
    );
  }
}
