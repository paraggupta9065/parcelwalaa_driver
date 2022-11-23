import 'package:get/get.dart';
import 'package:parcelwalaa_driver/controller/auth.dart';
import '/model/response_model.dart';
import '/utils/responseHandler.dart';
import '/utils/snackbar.dart';
import '/utils/url.dart';

class SettingsController extends GetxController {
  AuthController authController = Get.put(AuthController());

  onlineStatusChange({required bool value}) async {
    String url = kMainUrl + deliveryBoyStatusUpdateUrl;

    ServerResponse response = await responseHandler(
      body: {
        "isOnline": value,
        'number': authController.getDriver()['number'],
      },
      url: url,
      sendToken: true,
      requestType: RequestType.post,
    );
    if (response.body['status'] == "sucess") {
    } else if (response.body['status'] == "fail") {
      showSnackbar(response.body['msg'].toString());
    }
  }

  Future<ServerResponse> onlineStatus() async {
    String url = kMainUrl + getDeliveryBoyStatusUrl;

    ServerResponse response = await responseHandler(
      body: {},
      url: url,
      sendToken: true,
      requestType: RequestType.geet,
    );
    return response;
  }
}
