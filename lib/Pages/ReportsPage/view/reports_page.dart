import 'package:asset_audit/Pages/HomePage/view/responsive_layout.dart';
import 'package:asset_audit/Pages/ReportsPage/view/desktop_reports_page.dart';
import 'package:asset_audit/Pages/ReportsPage/view/mobile_reports_page.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileReportPage(),
      desktopBody: DesktopReportPage(),
    );
  }
}
