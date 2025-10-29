import 'package:asset_audit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MobileReportPage extends StatelessWidget {
  const MobileReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    );
    return Scaffold(
      backgroundColor: AppTheme.grayLightColor,
      body: Column(
        children: [
          // Header Section
          Container(
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [
              //     AppTheme.primaryColor,
              //     AppTheme.primaryColor.withOpacity(0.8)
              //   ],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.w),
                bottomRight: Radius.circular(30.w),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          child: Icon(
                            LucideIcons.chevronLeft,
                            color: AppTheme.whiteColor,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Page Title
                    Text(
                      "Reports",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Audit reports and analytics",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
          // Empty State
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.fileText,
                        size: 40.sp,
                        color: AppTheme.primaryColor.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      "No Reports Available",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Start creating audit reports to see them here",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    // Create Report Button
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
