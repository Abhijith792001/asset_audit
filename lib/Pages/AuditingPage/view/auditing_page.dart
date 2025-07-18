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

class AuditingPage extends GetView<AuditingController> {
  AuditingPage({super.key});

  final buildingId = Get.arguments['buildingId'];
  final buildingName = Get.arguments['buildingName'];
  final dueDate = Get.arguments['dueDate'];
  final appStorage = StorageManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Get.toNamed(AppRoutes.barcodePage);
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
        title: Text(
          buildingName,
          style: TextStyle(color: AppTheme.whiteColor, fontSize: 19),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        // minimum: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Auditing',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'End: ${dueDate}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
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
                child: Row(
                  children: [
                    Flexible(
                      child: CustomDropdown(
                        hint: 'Select Floor',
                        selectedValue:
                            controller.floors
                                    .map((f) => f.customFloor)
                                    .contains(controller.selectedFloor.value)
                                ? controller.selectedFloor.value
                                : null,
                        items:
                            controller.floors
                                .map((floor) => floor.customFloor.toString())
                                .toList(),
                        onChanged:
                            (value) => controller.setSelectedFloor(value),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: CustomDropdown(
                        hint: 'Select Room',
                        selectedValue:
                            controller.rooms
                                    .map((f) => f.customRoom)
                                    .contains(controller.selectedRoom.value)
                                ? controller.selectedRoom.value
                                : null,
                        items:
                            controller.rooms
                                .map((room) => room.customRoom.toString())
                                .toList(),
                        onChanged: (value) => controller.setSelectedRoom(value),
                      ),
                    ),
                  ],
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
                    style: TextStyle(color: AppTheme.successColor),
                  );
                }
                if (controller.rooms.isEmpty) {
                  return Text(
                    'No rooms found for the selected floor',
                    style: TextStyle(color: AppTheme.dangerColor),
                  );
                }
                if (controller.selectedRoom.isEmpty) {
                  return Text(
                    'Select your room to proceed',
                    style: TextStyle(color: AppTheme.successColor),
                  );
                }
                return const SizedBox(); // All selections done
              }),
            ),

            SizedBox(height: 20.h),
            Padding(
                   padding:  EdgeInsets.only(left: 16.w,right: 16.w,),
              child: Row(
                children: [
                  Icon(Icons.history, color: AppTheme.blackColor, size: 20.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Recently Scanned Assets',
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
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: controller.RecentscannedAssets.length,
                  itemBuilder: (BuildContext context, int index) {
                    final assets = controller.RecentscannedAssets[index];
                    return Column(
                      children: [
                        SizedBox(height: 5.h,),
                        AssetCard(
                          assetName: assets.assetNo.toString(),
                          status: assets.assetStatus.toString(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
