import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ModernLoginPage extends StatelessWidget {
  const ModernLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Logo & Title
              Column(
                children: [
                  SizedBox(height: 30.h),
                  SvgPicture.asset('assets/images/amrita_logo.svg', width: 120.w),
                  SizedBox(height: 20.h),
                  Text("Welcome Back 👋",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      )),
                  SizedBox(height: 4.h),
                  Text("Enter your MPIN to continue",
                      style: TextStyle(fontSize: 13.sp, color: Colors.black45)),
                  SizedBox(height: 30.h),

                  // MPIN Circles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      6,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Keypad
              Column(
                children: [
                  buildKeypadRow(['1', '2', '3']),
                  buildKeypadRow(['4', '5', '6']),
                  buildKeypadRow(['7', '8', '9']),
                  buildKeypadRow(['', '0', '⌫']),
                  SizedBox(height: 20.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildKeypadRow(List<String> values) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: values.map((value) {
          return value.isEmpty
              ? SizedBox(width: 80.w) // empty placeholder
              : MPINKey(title: value);
        }).toList(),
      ),
    );
  }
}

class MPINKey extends StatelessWidget {
  final String title;
  const MPINKey({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: () {
        // handle MPIN input here
      },
      child: Container(
        width: 80.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: title == '⌫'
            ? Icon(Icons.backspace_outlined, color: Colors.black54, size: 22.sp)
            : Text(
                title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
      ),
    );
  }
}
