import 'package:asset_audit/Pages/AuditingPage/view/desktop_auditing_page.dart';
import 'package:asset_audit/Pages/AuditingPage/view/mobile_auditing_page.dart';
import 'package:asset_audit/Pages/HomePage/view/responsive_layout.dart';
import 'package:flutter/material.dart';

class AuditingPage extends StatelessWidget {
  const AuditingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileAuditingPage(),
      desktopBody: DesktopAuditingPage(),
    );
  }
}