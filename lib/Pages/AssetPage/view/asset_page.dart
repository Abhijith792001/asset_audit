import 'package:asset_audit/Pages/AssetPage/controller/asset_controller.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:asset_audit/widgets/asset_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AssetPage extends GetView<AssetController> {
  const AssetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Get.offNamed(AppRoutes.homePage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          toolbarHeight: 70,
          centerTitle: true,
          title: Text(
            "Asset Page",
            style: TextStyle(color: AppTheme.whiteColor),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(LucideIcons.chevronLeft, color: AppTheme.whiteColor),
          ),
        ),
        body: Obx(() {
          final assets = controller.assetList.value;
          return SingleChildScrollView(
            child: Column(
              children: [
                Text('Total Assets : ${controller.assetList.length}'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.assetList.length,
                  itemBuilder: (BuildContext context, int index) {
                return (
                     AssetCard(assetName: 'assetName', status: 'status')
                );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
