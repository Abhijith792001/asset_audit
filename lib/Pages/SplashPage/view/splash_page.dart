import 'package:asset_audit/Pages/HomePage/view/responsive_layout.dart';
import 'package:asset_audit/Pages/SplashPage/view/desktop_splash_page.dart';
import 'package:asset_audit/Pages/SplashPage/view/mobile_splash_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileSplashPage(),
      desktopBody: DesktopSplashPage(),
    );
  }
}
