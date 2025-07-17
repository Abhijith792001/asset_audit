import 'package:asset_audit/Pages/BarCodePage/binding/barcode_binding.dart';
import 'package:get/get.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/Pages/HomePage/view/home_page.dart';
import 'package:asset_audit/Pages/AuditingPage/view/auditing_page.dart';
import 'package:asset_audit/Pages/BarCodePage/view/asset_view_page.dart';
import 'package:asset_audit/Pages/BarCodePage/view/barcode_page.dart';
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
      binding: BarcodeBinding(),
    ),
    GetPage(
      name: AppRoutes.barcodePage,
      page: () => BarcodePage(), 
      binding: BarcodeBinding()
    ),
  ];
}
