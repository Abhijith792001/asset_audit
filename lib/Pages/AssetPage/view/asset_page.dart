import 'package:asset_audit/Pages/AssetPage/view/desktop_asset_page.dart';
import 'package:asset_audit/Pages/AssetPage/view/mobile_asset_page.dart';
import 'package:asset_audit/Pages/HomePage/view/responsive_layout.dart';
import 'package:flutter/material.dart';

class AssetPage extends StatelessWidget {
  const AssetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileAssetPage(),
      desktopBody: DesktopAssetPage(),
    );
  }
}
