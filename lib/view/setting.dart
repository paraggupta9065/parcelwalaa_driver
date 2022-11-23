import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcelwalaa_driver/controller/auth.dart';
import 'package:parcelwalaa_driver/controller/settings.dart';
import 'package:parcelwalaa_driver/model/response_model.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  SettingsController settingsController = Get.put(SettingsController());
  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: settingsController.onlineStatus(),
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

          return ListView(
            children: [
              ListTile(
                title: const Text("online"),
                trailing: Switch(
                  value: snapshot.data!.body["isOnline"],
                  onChanged: (value) async {
                    await settingsController.onlineStatusChange(value: value);
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70, right: 70),
                child: MaterialButton(
                  onPressed: () {
                    authController.logout();
                  },
                  child: const Text("Log Out"),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
