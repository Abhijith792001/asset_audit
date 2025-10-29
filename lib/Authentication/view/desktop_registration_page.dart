import 'package:asset_audit/Authentication/controller/auth_controller.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DesktopRegistrationPage extends StatelessWidget {
  DesktopRegistrationPage({super.key});

  final AuthController controller = Get.find<AuthController>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFBFD2),
                  Color.fromRGBO(241, 242, 237, 1),
                ],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 450),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      SvgPicture.asset(
                        'assets/images/amrita_logo.svg',
                        width: 140,
                      ),
                      SizedBox(height: 30),
            
                      // Heading
                      Text(
                        "Sign in to Your Account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Enter your email to continue",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 30),
            
                      // Email Input
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            border: InputBorder.none,
                            icon: Icon(Icons.email_outlined, color: Colors.grey[600]),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
            
                      // Error Message
                      Obx(
                        () => controller.errorMessage.value.isEmpty
                            ? SizedBox.shrink()
                            : Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  controller.errorMessage.value,
                                  style: TextStyle(
                                    color: AppTheme.dangerColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 30),
            
                      // Sign In Button
                      InkWell(
                        onTap: () {
                          controller.accountChecking(
                            _emailController.text.trim(),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: AppTheme.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            'Sign In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
            
                      SizedBox(height: 20),
                      // Optional: Footer Text
                      Text(
                        "By continuing, you agree to our Terms & Conditions",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
           Obx(() {
              return controller.isLoading.value
                  ? Container(
                      color: Colors.black.withOpacity(0.3), // dim background
                      child: Center(child: Lottie.asset('assets/loading/Loading.json')),
                    )
                  : const SizedBox.shrink();
            }),
        ],
      ),
    );
  }
}
