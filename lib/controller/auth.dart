import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcelwalaa_driver/view/auth/login_screen.dart';
import 'package:parcelwalaa_driver/view/auth/otp_screen.dart';
import 'package:parcelwalaa_driver/view/homepage.dart';
import 'package:parcelwalaa_driver/view/verification.dart';
import '/model/response_model.dart';
import '/utils/responseHandler.dart';
import '/utils/snackbar.dart';
import '/utils/url.dart';

class AuthController extends GetxController {
  TextEditingController name = TextEditingController(text: "parag");
  TextEditingController number = TextEditingController(text: "8654345677");
  TextEditingController aadhar = TextEditingController(text: "456776543456");
  TextEditingController pan = TextEditingController(text: "dlspg8846n");
  TextEditingController upi = TextEditingController(text: "8319905007@upi");
  TextEditingController bikeNumber = TextEditingController(text: "mp39mj7711");
  TextEditingController otp = TextEditingController();

  //image
  final ImagePicker _picker = ImagePicker();
  XFile? profile;
  pickProfile() async {
    profile = await _picker.pickImage(source: ImageSource.camera);
  }

  XFile? dl;
  pickDl() async {
    dl = await _picker.pickImage(source: ImageSource.camera);
  }
//image

  RxBool isLoading = false.obs;
  sendOtp({required bool isNew}) async {
    isLoading.value = true;
    String url = kMainUrl + sendOtpUrl;

    ServerResponse response = await responseHandler(
      url: url,
      body: {"number": number.text.toString()},
      sendToken: false,
      requestType: RequestType.post,
    );
    if (response.body['status'] == "sucess") {
      otp.text = response.body['code'];
      Get.off(() => OtpScreen(
            number: number.text.toString(),
            isNew: isNew,
          ));
    } else if (response.body['status'] == "fail") {
      showSnackbar(response.body['msg'].toString());
    }

    isLoading.value = false;
  }

  verifyOtp({required String number}) async {
    isLoading.value = true;
    String url = kMainUrl + verifyOtpUrl;
    Map body = {
      "number": number,
      "otpCode": otp.text.toString(),
    };

    ServerResponse response = await responseHandler(
      url: url,
      body: body,
      sendToken: false,
      requestType: RequestType.post,
    );

    if (response.body['status'] == "sucess" &&
        response.body['role'] == "deliveryBoy") {
      addLoginLog(
        token: response.body['token'],
        driver: response.body['driver'],
      );
      Get.off(() => const Homepage());
    } else if (response.body['status'] == "sucess" &&
        response.body['role'] != "deliveryBoy") {
      showSnackbar("Use ${response.body['role']} app to acces account");
    } else if (response.body['status'] == "fail") {
      showSnackbar(response.body['msg'].toString());
    }
    isLoading.value = false;
  }

  createDriver({required String number}) async {
    isLoading.value = true;
    String url = kMainUrl + createDriverUrl;
    Map body = {
      "name": name.text,
      "number": number,
      "aadhar": aadhar.text,
      "pan": pan.text,
      "upi": upi.text,
      "bike_number": bikeNumber.text,
      "otpCode": otp.text.toString(),
    };

    ServerResponse response = await responseHandler(
        url: url, body: body, sendToken: false, requestType: RequestType.post);
    if (response.body['status'] == "sucess") {
      addLoginLog(
        token: response.body['token'],
        driver: response.body['driver'],
      );
      Get.off(() => const Verification());
    } else if (response.body['status'] == "fail") {
      showSnackbar(response.body['msg'].toString());
    }
    isLoading.value = false;
  }

  Future<bool> getStatus() async {
    isLoading.value = true;
    String url = kMainUrl + getDeliveryBoyStatusUrl;

    ServerResponse response = await responseHandler(
        body: {}, url: url, sendToken: true, requestType: RequestType.geet);
    if (response.body['status'] == "sucess") {
      return response.body["isOnline"];
    } else if (response.body['status'] == "fail") {
      showSnackbar(response.body['msg'].toString());
    }

    isLoading.value = false;
    return false;
  }

  var box = Hive.box('login');
  addLoginLog({
    required String token,
    required Map driver,
  }) async {
    await box.put("token", token);
    await box.put("driver", driver);
  }

  isLogin() {
    dynamic token = box.get("token");
    if (token != null) {
      return true;
    }
    return false;
  }

  String getToken() {
    dynamic token = box.get("token");

    return token;
  }

  Map getDriver() {
    dynamic shop = box.get("driver");
    return shop;
  }

  Future<void> setToken({required String token}) async {
    isLoading.value = true;
    String url = '${kMainUrl}${setTokenUrl}${token}';

    await responseHandler(
      url: url,
      body: {},
      sendToken: true,
      requestType: RequestType.post,
    );

    isLoading.value = false;
  }

  logout() {
    box.clear();
    Get.offAll(() => const LoginScreen());
  }

  Future<ServerResponse> isVerifiedCheck(context) async {
    String url = kMainUrl + isVerifiedUrl;

    ServerResponse response = await responseHandler(
        url: url, body: {}, sendToken: true, requestType: RequestType.geet);

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    dynamic token = await messaging.getToken();
    await setToken(token: token);
    if (response.body["status"] == "sucess" &&
        response.body["isVerified"] == true) {
      // await Get.offAll(() => const Homepage());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const Homepage()));
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (_) => const Earning()));
      });
    }

    return response;
  }
}
