import 'package:get/get.dart';

void showSnackbar(String msg) {
  Get.showSnackbar(GetSnackBar(
    message: msg.toString(),
    duration: const Duration(seconds: 2),
  ));
}
