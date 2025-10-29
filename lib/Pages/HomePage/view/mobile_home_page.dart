import 'package:asset_audit/Authentication/controller/auth_controller.dart';
import 'package:asset_audit/Pages/HomePage/controller/home_controller.dart';
import 'package:asset_audit/Pages/HomePage/model/audit_model.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:asset_audit/widgets/building_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MobileHomePage extends GetView<HomeController> {
  final AuthController _authControler = Get.find<AuthController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                _authControler.userName.value,
              ),
              accountEmail: Text(_authControler.userMail.value),
              currentAccountPicture: CircleAvatar(
                child: Icon(LucideIcons.user, size: 35.sp),
              ),
              decoration: BoxDecoration(color: AppTheme.primaryColor),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            // Divider(),
            Spacer(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _authControler.logout(); 
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: Container(
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
                                  InkWell(
                                    onTap: () {
                                      _scaffoldKey.currentState!.openDrawer();
                                    },
                                    child: Icon(
                                      LucideIcons.alignLeft,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  // CircleAvatar(child: Text('AJ')),
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
                                    _authControler.userName.value
                                        .toString(),
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
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  await controller.fetchAudit();
                                },
                                child: Obx(() {
                                  if (controller.isLoading.value) {
                                    // While loading – show skeletons
                                    return Skeletonizer(
                                      enabled: true,
                                      child: ListView.builder(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          return BuildingListCard(
                                            buildingName: "Loading...",
                                            auditType: "Loading...",
                                            auditId: "Loading...",
                                          );
                                        },
                                      ),
                                    );
                                  } else if (controller.auditList.isEmpty) {
                                    // No audits – show message with scrollable physics
                                    return ListView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(height: 100.h),
                                        Center(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'No audits assigned to you at the moment. \nPlease check back later.',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    // Show actual data
                                    return ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: controller.auditList.length,
                                      itemBuilder: (
                                        BuildContext context,
                                        int index,
                                      ) {
                                        final Message? audits =
                                            controller.auditList[index];
                                        return audits == null
                                            ? SizedBox.shrink()
                                            : InkWell(
                                              onTap:
                                                  () => {
                                                    Get.offNamed(
                                                      AppRoutes.auditingPage,
                                                      arguments: {
                                                        'auditNumber':
                                                            audits.auditNumber,
                                                        'buildingId':
                                                            audits.building,
                                                        'buildingName':
                                                            audits.buildingName,
                                                        'dueDate':
                                                            audits.dueDate,
                                                      },
                                                    ),
                                                  },
                                              child: BuildingListCard(
                                                buildingName:
                                                    '${audits.auditNumber}' ??
                                                    '',
                                                auditType:
                                                    audits.auditType ?? '',
                                                auditId:
                                                    'End Date : ${audits.dueDate}' ??
                                                    '',
                                              ),
                                            );
                                      },
                                    );
                                  }
                                }),
                              ),
                            ),
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
                onTap: () => {
                   Get.toNamed(AppRoutes.reportsPage)
                },
                borderRadius: BorderRadius.circular(10),
                child: _buildBottomNavItem(Icons.bar_chart, 'Reports'),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => {
                  Get.toNamed(AppRoutes.assetPage)
                },
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
      Icon(icon, color: Colors.white, size: 20.sp),
      Text(label, style: TextStyle(color: Colors.white, fontSize: 12.sp)),
    ],
  );
}
