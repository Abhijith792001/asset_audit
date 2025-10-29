import 'package:asset_audit/Authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';


class MobileLoginPage extends StatelessWidget {
  MobileLoginPage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final RxString mPin = ''.obs;
  final FocusNode _focusNode = FocusNode();

  void onKeyPressed(String value) {
    if (value == '⌫') {
      if (mPin.value.isNotEmpty) {
        mPin.value = mPin.value.substring(0, mPin.value.length - 1);
      }
    } else if (mPin.value.length < 6) {
      mPin.value += value;
      if (mPin.value.length == 6) {
        authController.loginWithMPin(mPin.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      focusNode: _focusNode,
      autofocus: true,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.digit0): const KeypadIntent('0'),
        LogicalKeySet(LogicalKeyboardKey.digit1): const KeypadIntent('1'),
        LogicalKeySet(LogicalKeyboardKey.digit2): const KeypadIntent('2'),
        LogicalKeySet(LogicalKeyboardKey.digit3): const KeypadIntent('3'),
        LogicalKeySet(LogicalKeyboardKey.digit4): const KeypadIntent('4'),
        LogicalKeySet(LogicalKeyboardKey.digit5): const KeypadIntent('5'),
        LogicalKeySet(LogicalKeyboardKey.digit6): const KeypadIntent('6'),
        LogicalKeySet(LogicalKeyboardKey.digit7): const KeypadIntent('7'),
        LogicalKeySet(LogicalKeyboardKey.digit8): const KeypadIntent('8'),
        LogicalKeySet(LogicalKeyboardKey.digit9): const KeypadIntent('9'),
        LogicalKeySet(LogicalKeyboardKey.backspace): const KeypadIntent('⌫'),
      },
      actions: {
        KeypadIntent: KeypadAction(onKeyPressed),
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFDFD),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Section
                    Column(
                      children: [
                        SizedBox(height: 40.h),
                        SvgPicture.asset('assets/images/amrita_logo.svg', width: 110.w),
                        SizedBox(height: 20.h),
                        Text("Welcome Back ",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            )),
                        Text("Enter your MPIN",
                            style: TextStyle(fontSize: 13.sp, color: Colors.black54)),
                        SizedBox(height: 40.h),
              
                        // MPIN Indicator
                        Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(6, (index) {
                                final filled = index < mPin.value.length;
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                                  width: 14.w,
                                  height: 14.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: filled ? Colors.black : Colors.black26,
                                  ),
                                );
                              }),
                            )),
                      ],
                    ),
              
                    // Keypad Section
                    Column(
                      children: [
                        buildKeypadRow(['1', '2', '3']),
                        buildKeypadRow(['4', '5', '6']),
                        buildKeypadRow(['7', '8', '9']),
                        buildKeypadRow(['', '0', '⌫']),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ],
                ),
              ),
              Obx(() {
                return authController.isLoading.value
                    ? Container(
                        color: Colors.black.withOpacity(0.3), // dim background
                        child: Center(child: Lottie.asset('assets/loading/Loading.json')),
                      )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildKeypadRow(List<String> values) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: values.map((value) {
          return value.isEmpty
              ? SizedBox(width: 70.w)
              : MinimalKey(title: value, onTap: () => onKeyPressed(value));
        }).toList(),
      ),
    );
  }
}

class KeypadIntent extends Intent {
  const KeypadIntent(this.value);
  final String value;
}

class KeypadAction extends Action<KeypadIntent> {
  KeypadAction(this.onKeyPressed);
  final Function(String) onKeyPressed;

  @override
  Object? invoke(covariant KeypadIntent intent) {
    onKeyPressed(intent.value);
    return null;
  }
}

class MinimalKey extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const MinimalKey({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: const Color(0xFFFDFDFD),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        alignment: Alignment.center,
        child: title == '⌫'
            ? Icon(Icons.backspace_outlined, size: 22.sp, color: Colors.black54)
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
