import 'package:asset_audit/Pages/ErrorPages/controller/error_controller.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MobileErrorpage extends GetView<ErrorController> {
  const MobileErrorpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        backgroundColor: AppTheme.whiteColor,
        centerTitle: true,
        title: Text('Error'),
        leading: IconButton(onPressed: (){
          Get.offNamed(AppRoutes.registrationPage);
        }, icon: Icon(LucideIcons.x)),
        actions: [Icon(LucideIcons.ellipsisVertical), SizedBox(width: 5.w)],
      ),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.red[700],
              radius: 35.sp,
              child: Icon(LucideIcons.x, size: 55, color: AppTheme.whiteColor),
            ),
            SizedBox(height: 20.h),
            Text(
              'MPIN Setup Required',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Go to the website, open the top-left profile menu, and tap "Manage MPIN',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.redirectUrl();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.btnPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(8.w)),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.link, size: 20, color: Colors.white),
                        SizedBox(width: 4.h),
                        Text(
                          'Go to Portal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
