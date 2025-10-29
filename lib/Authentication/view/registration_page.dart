import 'package:asset_audit/Authentication/view/desktop_registration_page.dart';
import 'package:asset_audit/Authentication/view/mobile_registration_page.dart';
import 'package:asset_audit/Pages/HomePage/view/responsive_layout.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileRegistrationPage(),
      desktopBody: DesktopRegistrationPage(),
    );
  }
}
