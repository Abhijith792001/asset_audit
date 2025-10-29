import 'package:asset_audit/Pages/AuditingPage/view/desktop_asset_view_page.dart';
import 'package:asset_audit/Pages/AuditingPage/view/mobile_asset_view_page.dart';
import 'package:asset_audit/Pages/HomePage/view/responsive_layout.dart';
import 'package:flutter/material.dart';

class AssetViewPage extends StatelessWidget {
  const AssetViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileAssetViewPage(),
      desktopBody: DesktopAssetViewPage(),
    );
  }
}