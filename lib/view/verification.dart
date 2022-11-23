import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcelwalaa_driver/controller/auth.dart';
import 'package:parcelwalaa_driver/model/response_model.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: authController.isVerifiedCheck(context),
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

          return Column(
            children: const [
              SizedBox(
                height: 150,
              ),
              CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Verification Pending",
                style: TextStyle(fontSize: 50),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Contact Parcelwalaa",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}
