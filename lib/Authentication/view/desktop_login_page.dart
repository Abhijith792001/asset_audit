import 'package:asset_audit/Authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class DesktopLoginPage extends StatelessWidget {
  DesktopLoginPage({super.key});

  final AuthController authController = Get.find<AuthController>();
  final RxString mPin = ''.obs;

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
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Section
                      Column(
                        children: [
                          SizedBox(height: 40),
                          SvgPicture.asset('assets/images/amrita_logo.svg', width: 110),
                          SizedBox(height: 20),
                          Text("Welcome Back ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              )),
                          Text("Enter your MPIN",
                              style: TextStyle(fontSize: 13, color: Colors.black54)),
                          SizedBox(height: 40),
                
                          // MPIN Indicator
                          Obx(() => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(6, (index) {
                                  final filled = index < mPin.value.length;
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 6),
                                    width: 14,
                                    height: 14,
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
                          SizedBox(height: 30),
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
      ),
    );
  }

  Widget buildKeypadRow(List<String> values) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: values.map((value) {
          return value.isEmpty
              ? SizedBox(width: 70)
              : MinimalKey(title: value, onTap: () => onKeyPressed(value));
        }).toList(),
      ),
    );
  }
}

class MinimalKey extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const MinimalKey({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 70,
          height: 60,
          alignment: Alignment.center,
          child: title == '⌫'
              ? Icon(Icons.backspace_outlined, size: 22, color: Colors.black54)
              : Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
        ),
      ),
    );
  }
}
