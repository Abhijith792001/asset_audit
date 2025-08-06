import 'package:asset_audit/Authentication/binding/auth_binding.dart';
import 'package:asset_audit/Authentication/view/login_page.dart';
import 'package:asset_audit/Authentication/view/modern_login_page.dart';
import 'package:asset_audit/Authentication/view/registration_page.dart';
import 'package:asset_audit/Pages/ErrorPages/binding/error_binding.dart';
import 'package:asset_audit/Pages/errorPages/view/error_page.dart';
import 'package:get/get.dart';
import 'package:asset_audit/Pages/SplashPage/binding/splash_binding.dart';
import 'package:asset_audit/Pages/SplashPage/view/splash_page.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/Pages/HomePage/view/home_page.dart';
import 'package:asset_audit/Pages/AuditingPage/view/auditing_page.dart';
import 'package:asset_audit/Pages/AuditingPage/view/asset_view_page.dart';
import 'package:asset_audit/Pages/HomePage/binding/home_binding.dart';
import 'package:asset_audit/Pages/AuditingPage/binding/auditing_binding.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.homePage,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.auditingPage,
      page: () => AuditingPage(),
      binding: AuditingBinding(),
    ),
    GetPage(
      name: AppRoutes.assetViewPage,
      page: () => AssetViewPage(),
      binding: AuditingBinding(),
    ),
   
    GetPage(
      name: AppRoutes.splashPage,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
   
    GetPage(
      name: AppRoutes.registrationPage,
      page: () => RegistrationPage(),
      binding: AuthBinding()
    ),
   
    GetPage(
      name: AppRoutes.loginPage,
      page: () => MPinLoginPage(),
      binding: AuthBinding()
    ),
    GetPage(
      name: AppRoutes.modernLoginPage,
      page: () => ModernLoginPage(),
      binding: AuthBinding()
    ),
    GetPage(
      name: AppRoutes.errorPage,
      page: () => Errorpage(),
      binding: ErrorBinding()

    ),
   
  ];
}
