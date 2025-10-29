import 'package:asset_audit/Authentication/view/desktop_login_page.dart';
import 'package:asset_audit/Authentication/view/mobile_login_page.dart';
import 'package:asset_audit/Pages/HomePage/view/responsive_layout.dart';
import 'package:flutter/material.dart';

class MPinLoginPage extends StatelessWidget {
  const MPinLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileLoginPage(),
      desktopBody: DesktopLoginPage(),
    );
  }
}



