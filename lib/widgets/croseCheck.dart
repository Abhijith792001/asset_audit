import 'package:asset_audit/theme/app_theme.dart';
import 'package:flutter/material.dart';

 check(String title, IconData icon) {
return  Row(
    children: [
      Icon(icon, color: AppTheme.successColor, size: 20),
      SizedBox(width: 8),
      Text(title, style: TextStyle(fontSize: 16)),
    ],
  );
}
