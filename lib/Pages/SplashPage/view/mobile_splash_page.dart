import 'package:asset_audit/Pages/SplashPage/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MobileSplashPage extends StatelessWidget {
  MobileSplashPage({super.key});
  final SplashController controller = Get.find<SplashController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/amrita_logo.png', width: 200.w),
            SizedBox(height: 10.h),
            Text(
              'Powered by My Amrita',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
