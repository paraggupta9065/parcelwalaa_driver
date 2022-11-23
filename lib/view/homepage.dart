import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcelwalaa_driver/controller/auth.dart';
import 'package:parcelwalaa_driver/controller/homepage.dart';
import 'package:parcelwalaa_driver/controller/location.dart';
import 'package:parcelwalaa_driver/view/earning.dart';
import 'package:parcelwalaa_driver/view/main_page.dart';
import 'package:parcelwalaa_driver/view/setting.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  HomepageController controller = Get.put(HomepageController());
  final authController = Get.put(AuthController());
  final locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    locationController.sendLocation();
    locationController.getLatLong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: controller.pageController,
          children: const [MainPage(), Earning(), Setting()],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavyBar(
            selectedIndex: controller.selectIndex.value,
            showElevation: true, // use this to remove appBar's elevation
            onItemSelected: (index) {
              controller.selectIndex.value = index;
              controller.pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            items: [
              BottomNavyBarItem(
                icon: const Icon(Icons.home),
                title: const Text('Home'),
                activeColor: Colors.red,
              ),
              BottomNavyBarItem(
                  icon: const Icon(Icons.stop_circle_sharp),
                  title: const Text('Earning'),
                  activeColor: Colors.pink),
              BottomNavyBarItem(
                  icon: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  activeColor: Colors.blue),
            ],
          ),
        ));
  }
}
