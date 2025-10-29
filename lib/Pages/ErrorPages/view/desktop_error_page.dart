import 'package:asset_audit/Pages/ErrorPages/controller/error_controller.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DesktopErrorpage extends GetView<ErrorController> {
  const DesktopErrorpage({super.key});

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
        actions: [Icon(LucideIcons.ellipsisVertical), SizedBox(width: 5)],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.red[700],
                radius: 35,
                child: Icon(LucideIcons.x, size: 55, color: AppTheme.whiteColor),
              ),
              SizedBox(height: 20),
              Text(
                'MPIN Setup Required',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              SizedBox(height: 10),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Go to the website, open the top-left profile menu, and tap "Manage MPIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ),
              SizedBox(height: 20),
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
                        horizontal: 16,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppTheme.btnPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.link, size: 20, color: Colors.white),
                          SizedBox(width: 4),
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
      ),
    );
  }
}
