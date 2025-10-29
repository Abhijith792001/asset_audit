import 'package:asset_audit/Pages/AssetPage/controller/asset_controller.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DesktopAssetPage extends StatelessWidget {
  final AssetController controller = Get.put(AssetController());

  DesktopAssetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: AppTheme.grayLightColor,
      body: Row(
        children: [
          Container(
            width: 350,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Assets",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Obx(
                        () => Text(
                          "${controller.assets.length} items",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: controller.searchAssets,
                        decoration: InputDecoration(
                          hintText: "Search assets...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value && controller.assets.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (controller.assets.isEmpty) {
                      return Center(child: Text("No assets found"));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.assets.length,
                      itemBuilder: (context, index) {
                        final asset = controller.assets[index];
                        return ListTile(
                          title: Text(asset.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(asset.productCategory),
                          onTap: () {
                            // Handle tap, maybe show details on the right
                          },
                        );
                      },
                    );
                  }),
                ),
                Obx(
                  () => BottomAppBar(
                    color: AppTheme.grayLightColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.chevron_left_rounded),
                          onPressed: controller.page.value > 1 ? controller.previousPage : null,
                        ),
                        Text('Page ${controller.page.value}', style: TextStyle(color: AppTheme.primaryColor)),
                        IconButton(
                          icon: const Icon(Icons.chevron_right_rounded),
                          onPressed: (controller.page.value * controller.limit) < controller.allAssets.length
                              ? controller.nextPage
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text("Select an asset to view details"),
            ),
          ),
        ],
      ),
    );
  }
}
