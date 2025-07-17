import 'package:asset_audit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

 check(String title, IconData icon) {
return  Row(
    children: [
      Icon(icon, color: AppTheme.successColor, size: 20),
      SizedBox(width: 8.h),
      Text(title, style: TextStyle(fontSize: 16.sp)),
    ],
  );
}
