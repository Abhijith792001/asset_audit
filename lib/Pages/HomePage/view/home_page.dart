import 'package:asset_audit/Pages/HomePage/controller/home_controller.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:asset_audit/widgets/building_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
              child: SafeArea(
                maintainBottomViewPadding: true,
                minimum: EdgeInsets.all(0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.alignLeft,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10.w),
                                  CircleAvatar(child: Text('AJ')),
                                ],
                              ),
                              Image.asset(
                                'assets/images/amrita_logo_white.png',
                                width: 100.w,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome !',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Abhijith 👋🏼',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            textAlign: TextAlign.right,
                            'Quickly access asset info \nby scanning a QR code.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        width: Get.width,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.grayColor,
                              blurRadius: 4,
                              offset: Offset(0, -1),
                              spreadRadius: 0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32.sp),
                            topRight: Radius.circular(32.sp),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Audit List',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Obx(() {
                              if (controller.auditList.value.isEmpty) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: controller.auditList.length,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    final audits = controller.auditList[index];
                                    return audits.building == null
                                        ? Container()
                                        : InkWell(
                                          onTap: () => {},
                                          child: InkWell(
                                            onTap:
                                                () => {
                                                  Get.offNamed(
                                                    arguments: {
                                                      'auditNumber': audits.auditNumber,
                                                      'buildingId':
                                                          audits.building,
                                                      'buildingName':
                                                          audits.building_name,
                                                          'dueDate' : audits.dueDate,
                                                    },
                                                    AppRoutes.auditingPage,
                                                  ),
                                                },
                                            child: BuildingListCard(
                                              buildingName: audits.auditNumber,
                                              auditType: audits.auditType,
                                              auditId:
                                                  audits.building_name
                                                      .toString(),
                                            ),
                                          ),
                                        );
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(163, 18, 63, 1),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => {},
                borderRadius: BorderRadius.circular(10),
                child: _buildBottomNavItem(LucideIcons.house, 'Home'),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => {},
                borderRadius: BorderRadius.circular(10),
                child: _buildBottomNavItem(Icons.bar_chart, 'Reports'),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => {},
                borderRadius: BorderRadius.circular(10),
                child: _buildBottomNavItem(LucideIcons.box, 'Assets'),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => {},
                borderRadius: BorderRadius.circular(10),
                child: _buildBottomNavItem(LucideIcons.user, 'Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBottomNavItem(IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: Colors.white, size: 20.sp), // Scaled icon size
      Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ), // Scaled font size
    ],
  );
}
