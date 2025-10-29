import 'package:asset_audit/Pages/ErrorPages/view/desktop_error_page.dart';
import 'package:asset_audit/Pages/ErrorPages/view/mobile_error_page.dart';
import 'package:asset_audit/Pages/HomePage/view/responsive_layout.dart';
import 'package:flutter/material.dart';

class Errorpage extends StatelessWidget {
  const Errorpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileErrorpage(),
      desktopBody: DesktopErrorpage(),
    );
  }
}
