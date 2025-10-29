import 'package:asset_audit/Authentication/controller/auth_controller.dart';
import 'package:asset_audit/Pages/HomePage/controller/home_controller.dart';
import 'package:asset_audit/Pages/HomePage/model/audit_model.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:asset_audit/widgets/building_list_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DesktopHomePage extends GetView<HomeController> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: Row(
        children: [
          // Left side: Navigation and branding
          Container(
            width: 250,
            // color: Theme.of(context).cardColor,
            decoration: BoxDecoration(
            color: Colors.white,
              border: Border(right: BorderSide(
                color: AppTheme.grayLightColor
              ))
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/images/amrita_logo.png',
                    width: 150,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.bar_chart),
                  title: Text('Reports'),
                  onTap: () => Get.toNamed(AppRoutes.reportsPage),
                ),
                ListTile(
                  leading: Icon(Icons.add_box),
                  title: Text('Assets'),
                  onTap: () => Get.toNamed(AppRoutes.assetPage),
                ),
                Spacer(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () => _authController.logout(),
                ),
              ],
            ),
          ),

          // Right side: Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${_authController.userName.value}!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Here are your assigned audits. You can select one to view the details.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.fetchAudit();
                      },
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return Skeletonizer(
                            enabled: true,
                            child: ListView.builder(
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
                          return Center(
                            child: Text(
                              'No audits assigned to you at the moment.',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: controller.auditList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Message? audit = controller.auditList[index];
                              return audit == null
                                  ? SizedBox.shrink()
                                  : InkWell(
                                      onTap: () => {
                                        Get.toNamed(
                                          AppRoutes.auditingPage,
                                          arguments: {
                                            'auditNumber': audit.auditNumber,
                                            'buildingId': audit.building,
                                            'buildingName': audit.buildingName,
                                            'dueDate': audit.dueDate,
                                          },
                                        ),
                                      },
                                      child: BuildingListCard(
                                        buildingName: '${audit.auditNumber}' ?? '',
                                        auditType: audit.auditType ?? '',
                                        auditId: 'End Date : ${audit.dueDate}' ?? '',
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
    );
  }
}
