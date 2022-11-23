import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:parcelwalaa_driver/controller/auth.dart';
import 'package:parcelwalaa_driver/controller/orders.dart';
import 'package:parcelwalaa_driver/model/response_model.dart';
import 'package:parcelwalaa_driver/utils/colors.dart';
import 'package:parcelwalaa_driver/view/auth/login_screen.dart';
import 'package:parcelwalaa_driver/view/homepage.dart';
import 'package:parcelwalaa_driver/view/verification.dart';
import 'package:vibration/vibration.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  dynamic data = message.data;

  for (int i = 0; i < 10; i++) {
    final player = AudioPlayer();
    final duration = await player.setAsset("asset/orders_received.mp3");
    await Vibration.vibrate(duration: 1000, amplitude: 255);
    await player.play();
    await Future.delayed(const Duration(seconds: 1));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("login");
  await Firebase.initializeApp();
  await firebaseMessengerImplimentation();
  runApp(MyApp());
}

Future<void> firebaseMessengerImplimentation() async {
  // try {
  final authController = Get.put(AuthController());

  if (authController.isLogin() == true) {
    AuthController authController = Get.put(AuthController());
    OrderController orderController = Get.put(OrderController());
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    String driverId = authController.getDriver()['user_id'];
    print("/" + driverId + "/");
    await messaging.subscribeToTopic(driverId.toString());

    await messaging.subscribeToTopic("driver");
    // await messaging.subscribeToTopic(driverId);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    dynamic token = await messaging.getToken();
    await authController.setToken(token: token);
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      dynamic data = message.data;
      ServerResponse response = await orderController.getOrder(id: data['id']);
      Map order = response.body["orders"];
      Map deliveryAddressId = order['delivery_address_id'];
      Map shop = order['shop_id'];
      if (data['id'] != null) {
        Get.defaultDialog(
          title: "New Order",
          content: SizedBox(
            height: 400,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(10),
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
                  const SizedBox(height: 5),
                  ListTile(
                    title: AutoSizeText(
                      shop["store_name"],
                      maxLines: 3,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    subtitle: AutoSizeText(
                      shop["line1"],
                      maxLines: 3,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Text(
                        "To",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ListTile(
                    title: AutoSizeText(
                      deliveryAddressId["name"],
                      maxLines: 3,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    subtitle: AutoSizeText(
                      deliveryAddressId["line1"],
                      maxLines: 3,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: const [
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
                  const SizedBox(height: 20),
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
          backgroundColor: Colors.white,
          titleStyle: const TextStyle(color: Colors.black),
          middleTextStyle: const TextStyle(color: Colors.black),
          radius: 10,
        );
        final player = AudioPlayer();
        final duration = await player.setAsset("asset/orders_received.mp3");
        await Vibration.vibrate(duration: 1000, amplitude: 255);
        await player.play();
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      dynamic data = message.data;
      ServerResponse response = await orderController.getOrder(id: data['id']);
      Map order = response.body["orders"];
      Map deliveryAddressId = order['delivery_address_id'];
      Map shop = order['shop_id'];

      if (data['id'] != null) {
        Get.defaultDialog(
          title: "New Order",
          content: SizedBox(
            height: 400,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(10),
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
                  ListTile(
                    title: AutoSizeText(
                      shop["store_name"],
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    subtitle: AutoSizeText(
                      shop["line1"],
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
          backgroundColor: Colors.white,
          titleStyle: const TextStyle(color: Colors.black),
          middleTextStyle: const TextStyle(color: Colors.black),
          radius: 10,
        );
        final player = AudioPlayer();
        final duration = await player.setAsset("asset/orders_received.mp3");
        await Vibration.vibrate(duration: 1000, amplitude: 255);
        await player.play();
      }
    });
  }
  // } catch (e) {
  //   print(e);
  // }
}

class MyApp extends StatelessWidget {
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        cursorColor: kTextColour,
      ),
      home:
          authController.isLogin() ? const Verification() : const LoginScreen(),
    );
  }
}
