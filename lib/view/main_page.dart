import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:parcelwalaa_driver/controller/location.dart';
import 'package:parcelwalaa_driver/controller/orders.dart';
import 'package:parcelwalaa_driver/controller/settings.dart';
import 'package:parcelwalaa_driver/model/response_model.dart';
import 'package:parcelwalaa_driver/utils/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(Duration(seconds: 2)).then(
    //   (value) => Get.defaultDialog(
    //     onWillPop: () async {
    //       return false;
    //     },
    //     title: "New Order",
    //     titlePadding: EdgeInsets.all(20),
    //     content: SizedBox(
    //       height: 300,
    //       width: 200,
    //       child: Column(
    //         children: [
    //           Row(
    //             children: const [
    //               Text(
    //                 "PICK UP",
    //                 style: TextStyle(fontWeight: FontWeight.bold),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 5),
    //           Row(
    //             children: const [
    //               SizedBox(
    //                 width: 170,
    //                 child: Text(
    //                   "Board Colony, Char Imli, Bhopal",
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.w300,
    //                     fontSize: 15,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 10),
    //           Row(
    //             children: const [
    //               Text(
    //                 "DROP UP",
    //                 style: TextStyle(fontWeight: FontWeight.bold),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 5),
    //           Row(
    //             children: const [
    //               SizedBox(
    //                 width: 170,
    //                 child: Text(
    //                   "Board Colony, Char Imli, Bhopal",
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.w300,
    //                     fontSize: 15,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 10),
    //           Row(
    //             children: const [
    //               Text(
    //                 "DISTANCE :",
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //               Text(
    //                 " 5.1KM",
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.w300,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Expanded(child: SizedBox()),
    //           MaterialButton(
    //             color: kPrimaryColour,
    //             onPressed: () {},
    //             child: const Center(
    //               child: Text(
    //                 "Accept",
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.w400,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(height: 5),
    //           MaterialButton(
    //             color: const Color.fromARGB(255, 225, 63, 52),
    //             onPressed: () {
    //               Get.back();
    //             },
    //             child: const Center(
    //               child: Text(
    //                 "Reject",
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.w400,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     backgroundColor: Colors.white,
    //     titleStyle: const TextStyle(color: Colors.black),
    //     middleTextStyle: const TextStyle(color: Colors.black),
    //     radius: 10,
    //   ),
    // );
  }

  SettingsController settingsController = SettingsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Online",
          style: TextStyle(color: kTextColour),
        ),
        backgroundColor: Colors.white,
        actions: [
          FutureBuilder(
            future: settingsController.onlineStatus(),
            builder:
                (BuildContext context, AsyncSnapshot<ServerResponse> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              }
              return Switch(
                  value: snapshot.data!.body["isOnline"],
                  onChanged: (v) async {
                    await settingsController.onlineStatusChange(value: v);
                    setState(() {});
                  });
            },
          ),
        ],
      ),
      body: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late GoogleMapController mapController;
  final locationController = Get.put(LocationController());
  final orderController = Get.put(OrderController());
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final LatLng _center =
        LatLng(locationController.lat.value, locationController.long.value);

    _markers.add(
      Marker(
        markerId: MarkerId('Home'),
        position: _center,
      ),
    );

    return Scaffold(
      bottomNavigationBar: FutureBuilder(
        future: orderController.getAsssignedOrder(),
        builder:
            (BuildContext context, AsyncSnapshot<ServerResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ),
            );
          }

          Map order = orderController.order.value;
          print(order);

          if (order.keys.isEmpty) {
            return const SizedBox();
          }
          Map deliveryAddressId = order['delivery_address_id'];
          List order_inventory = order['order_inventory'];
          if (order['status'] == 'assignedAccepted') {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    final ordersController = Get.put(OrderController());
                    await ordersController.updateStatus(
                        status: "arrivedShop", id: order['_id']);
                    setState(() {});
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
                    'Arrived At Vendor',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // final ordersController = Get.put(OrderController());
                    // await ordersController.updateStatus(
                    //     status: "arrivedShop", id: order['_id']);
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
                    'Call Vendor',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          } else if (order['status'] == 'arrivedShop') {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    final ordersController = Get.put(OrderController());
                    await ordersController.updateStatus(
                        status: "pickedUp", id: order['_id']);
                    setState(() {});
                    MapsLauncher.launchCoordinates(37.4220041, -122.0862462);
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
                    'Picked',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // final ordersController = Get.put(OrderController());
                    // await ordersController.updateStatus(
                    //     status: "arrivedShop", id: order['_id']);
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
                    'Call Vendor',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          } else if (order['status'] == 'pickedUp') {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    final ordersController = Get.put(OrderController());
                    await ordersController.updateStatus(
                        status: "arrivedCustumer", id: order['_id']);
                    setState(() {});
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
                    'Arrived at customer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // final ordersController = Get.put(OrderController());
                    // await ordersController.updateStatus(
                    //     status: "arrivedShop", id: order['_id']);
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
                    'Call Customer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          } else if (order['status'] == 'arrivedCustumer') {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    final ordersController = Get.put(OrderController());
                    await ordersController.updateStatus(
                        status: "delivered", id: order['_id']);
                    setState(() {});
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
                    'Delivered',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // final ordersController = Get.put(OrderController());
                    // await ordersController.updateStatus(
                    //     status: "arrivedShop", id: order['_id']);
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
                    'Call Customer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        liteModeEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 10.0,
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }
}
