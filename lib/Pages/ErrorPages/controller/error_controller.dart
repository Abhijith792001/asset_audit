import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorController extends GetxController {
  void redirectUrl() async {
    final Uri url = Uri.parse('https://icts.amrita.ac.in/helpdesk/dashboard');

    // Use try-catch to handle exceptions
    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        Get.snackbar("Error", "Could not open the link");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to launch URL: $e");
    }
  }
}
