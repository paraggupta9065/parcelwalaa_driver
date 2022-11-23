import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:parcelwalaa_driver/controller/auth.dart';
import 'package:parcelwalaa_driver/model/response_model.dart';
import 'package:parcelwalaa_driver/utils/responseHandler.dart';
import 'package:parcelwalaa_driver/utils/snackbar.dart';
import 'package:parcelwalaa_driver/utils/url.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class LocationController extends GetxController {
  AuthController authController = Get.put(AuthController());

  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;
  getLatLong() async {
    bool status = await ph.Permission.locationAlways.isGranted;
    if (!status) {
      ph.PermissionStatus status = await ph.Permission.locationAlways.request();
      if (status.isDenied) {
        showSnackbar("Please Grant Permission");
      }
    }
    Position position = await _determinePosition();

    lat.value = position.latitude;
    long.value = position.longitude;
  }

  sendLocation() async {
    if (await authController.getStatus()) {
      bool status = await ph.Permission.locationAlways.isGranted;
      if (!status) {
        ph.PermissionStatus status =
            await ph.Permission.locationAlways.request();
        if (status.isDenied) {
          showSnackbar("Please Grant Permission");
        }
      }
      Position position = await _determinePosition();
      String url = kMainUrl + setLocationUrl;

      ServerResponse response = await responseHandler(
        body: {"lat": position.latitude, "long": position.longitude},
        url: url,
        sendToken: true,
        requestType: RequestType.post,
      );

      if (response.body['status'] == "sucess") {
        return response.body["isOnline"];
      } else if (response.body['status'] == "fail") {
        showSnackbar(response.body['msg'].toString());
      }
    }
    await Future.delayed(const Duration(minutes: 1));
    sendLocation();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
