import 'package:asset_audit/Pages/HomePage/view/desktop_home_page.dart';
import 'package:asset_audit/Pages/HomePage/view/mobile_home_page.dart';
import 'package:asset_audit/Pages/HomePage/view/responsive_layout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileHomePage(),
      desktopBody: DesktopHomePage(),
    );
  }
}
