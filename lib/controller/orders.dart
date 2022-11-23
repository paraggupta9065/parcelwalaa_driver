import 'package:get/get.dart';
import 'package:parcelwalaa_driver/controller/auth.dart';
import 'package:parcelwalaa_driver/model/response_model.dart';
import 'package:parcelwalaa_driver/utils/responseHandler.dart';
import 'package:parcelwalaa_driver/utils/url.dart';
import 'package:dio/dio.dart' as d;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:parcelwalaa_driver/utils/colors.dart';

class OrderController extends GetxController {
  final authController = Get.put(AuthController());

  RxMap order = {}.obs;

  Future<ServerResponse> updateStatus({
    required String status,
    required String id,
  }) async {
    String url = '${kMainUrl}${updateStatusUrl}/${id}';

    d.Dio dio = d.Dio(d.BaseOptions(
      responseType: d.ResponseType.json,
      validateStatus: (_) => true,
    ));
    d.Response rawResponse = await dio.post(
      url,
      data: {
        "status": status,
      },
      options: d.Options(
        headers: {"token": authController.getToken()},
      ),
    );
    return ServerResponse(
        statusCode: rawResponse.statusCode!, body: rawResponse.data);
  }

  getOrder({required String id}) async {
    String url = kMainUrl + getOrderUrl + id;

    ServerResponse response = await responseHandler(
      body: {},
      url: url,
      sendToken: true,
      requestType: RequestType.geet,
    );

    return response;
  }

  Future<ServerResponse> getAsssignedOrder() async {
    String url = kMainUrl + getAsssignedOrderUrl;

    ServerResponse response = await responseHandler(
      body: {},
      url: url,
      sendToken: true,
      requestType: RequestType.geet,
    );
    if (response.body['order'] == null) {
      return response;
    }
    order.value = response.body['order'];

    Map deliveryAddressId = order.value['delivery_address_id'];
    List order_inventory = order.value['order_inventory'];
    if (order.value['status'] != "prepared") {
      return response;
    }
    Get.defaultDialog(
      title: "New Order",
      content: SizedBox(
        height: 400,
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      "From",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                ListView.builder(
                  itemCount: order_inventory.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: AutoSizeText(
                        order_inventory[index]['shop_id']["store_name"],
                        maxLines: 3,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: AutoSizeText(
                        order_inventory[index]['shop_id']["address_line1"],
                        maxLines: 3,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "To",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                ListTile(
                  title: AutoSizeText(
                    deliveryAddressId["name"],
                    maxLines: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: AutoSizeText(
                    deliveryAddressId["line1"],
                    maxLines: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "Distance -",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " 3.7 km",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final ordersController = Get.put(OrderController());
                        await ordersController.updateStatus(
                            status: "assignedAccepted", id: order['_id']);
                        Get.back();
                        MapsLauncher.launchCoordinates(
                            37.4220041, -122.0862462);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          // If the button is pressed, return green, otherwise blue
                          if (states.contains(MaterialState.pressed)) {
                            return kPrimaryColour;
                          }
                          return kPrimaryColour;
                        }),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        // final ordersController = Get.put(OrdersController());
                        // await ordersController.updateStatus(
                        //     status: "cancelled", id: order['_id']);
                        // Get.back();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          // If the button is pressed, return green, otherwise blue
                          if (states.contains(MaterialState.pressed)) {
                            return kPrimaryColour;
                          }
                          return kPrimaryColour;
                        }),
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    // final ordersController = Get.put(OrdersController());
                    // await ordersController.updateStatus(
                    //     status: "cancelled", id: order['_id']);
                    // Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      // If the button is pressed, return green, otherwise blue
                      if (states.contains(MaterialState.pressed)) {
                        return kPrimaryColour;
                      }
                      return kPrimaryColour;
                    }),
                  ),
                  child: const Text(
                    'View Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: Colors.black),
      middleTextStyle: const TextStyle(color: Colors.black),
      radius: 10,
    );
    return response;
  }
}
