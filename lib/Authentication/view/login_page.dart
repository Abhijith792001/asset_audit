import 'package:asset_audit/Authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:flutter_svg/svg.dart';

class MPinLoginPage extends StatelessWidget {
  MPinLoginPage({super.key});

  final TextEditingController mPinController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1, -1),
            end: Alignment(0.1, 0),
            colors: [const Color(0xFFFFBFD2), const Color(0xFFF1F2ED)],
          ),
        ),
        padding: EdgeInsets.all(16.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/amrita_logo.svg',
              width: 140.w,
            ),
            SizedBox(height: 30.h),
            Text(
              "Welcome Back",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
            ),
            Text('Enter your MPIN to login', style: TextStyle(fontSize: 12.sp)),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.only(left: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.sp)),
                border: Border.all(color: Colors.black45),
              ),
              child: TextField(
                controller: mPinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: 'Enter Your 6-digit MPIN',
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Obx(() => InkWell(
                  onTap: authController.isLoading.value
                      ? null
                      : () {
                          final mpin = mPinController.text.trim();
                          if (mpin.length != 6) {
                            Get.snackbar("Invalid MPIN", "MPIN must be 6 digits");
                          } else {
                            authController.loginWithMPin(mpin);
                          }
                        },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: authController.isLoading.value
                        ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
