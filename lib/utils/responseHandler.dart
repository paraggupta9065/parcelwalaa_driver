import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:parcelwalaa_driver/controller/auth.dart';
import '/model/response_model.dart';

enum RequestType { post, geet, delete }

Future<ServerResponse> responseHandler({
  required String url,
  required Map body,
  required bool sendToken,
  RequestType requestType = RequestType.geet,
}) async {
  final authController = Get.put(AuthController());

  Dio dio = Dio(BaseOptions(
      responseType: ResponseType.json,
      validateStatus: (_) => true,
      headers: {
        "token": sendToken ? authController.getToken() : "",
      }));
  Response rawResponse;
  if (requestType == RequestType.geet) {
    rawResponse = await dio.get(
      url,
    );
  } else if (requestType == RequestType.delete) {
    rawResponse = await dio.delete(
      url,
    );
  } else {
    rawResponse = await dio.post(
      url,
      data: body,
    );
  }
  return ServerResponse(
      statusCode: rawResponse.statusCode!, body: rawResponse.data);
}
