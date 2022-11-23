import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcelwalaa_driver/controller/auth.dart';
import 'package:parcelwalaa_driver/utils/colors.dart';
import 'package:parcelwalaa_driver/utils/sCurve_screens.dart';
import 'package:parcelwalaa_driver/view/auth/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
      body: Stack(
        children: [
          sCurveTop(),
          Column(
            children: [
              SizedBox(
                height: Get.size.height * 0.25,
                width: Get.size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Signup",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Create account",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.size.height * 0.75,
                width: Get.size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Row(children: const [Text("Name")]),
                        const SizedBox(height: 5),
                        Container(
                          height: 55,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: TextFormField(
                              controller: authController.name,
                              cursorColor: kTextColour,
                              decoration: const InputDecoration(
                                hintText: "  Jhon",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(children: const [Text("Mobile Number")]),
                        const SizedBox(height: 5),
                        Container(
                          height: 55,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: TextFormField(
                              controller: authController.number,
                              cursorColor: kTextColour,
                              decoration: const InputDecoration(
                                hintText: " 9865333566",
                                prefixText: "+91 ",
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(children: const [Text("Aadhar")]),
                        const SizedBox(height: 5),
                        Container(
                          height: 55,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: TextFormField(
                              controller: authController.aadhar,
                              cursorColor: kTextColour,
                              decoration: const InputDecoration(
                                hintText: " 4565 5434 4564 4566",
                                prefixIcon: Icon(
                                  Icons.contact_mail_sharp,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(children: const [Text("Pan")]),
                        const SizedBox(height: 5),
                        Container(
                          height: 55,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: TextFormField(
                              controller: authController.pan,
                              cursorColor: kTextColour,
                              decoration: const InputDecoration(
                                hintText: "AFDHY6654N",
                                prefixIcon: Icon(
                                  Icons.contact_page,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(children: const [Text("UPI")]),
                        const SizedBox(height: 5),
                        Container(
                          height: 55,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: TextFormField(
                              controller: authController.upi,
                              cursorColor: kTextColour,
                              decoration: const InputDecoration(
                                hintText: " 9876543211@upi",
                                prefixIcon: Icon(
                                  Icons.payment,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(children: const [Text("Bike Number")]),
                        const SizedBox(height: 5),
                        Container(
                          height: 55,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: TextFormField(
                              controller: authController.bikeNumber,
                              cursorColor: kTextColour,
                              decoration: const InputDecoration(
                                hintText: " MP04MJ7654",
                                prefixIcon: Icon(
                                  Icons.pedal_bike_outlined,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                authController.pickProfile();
                              },
                              child: Container(
                                height: 55,
                                width: 150,
                                decoration: const BoxDecoration(
                                  color: kPrimaryColour,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Upload Photo",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                authController.pickDl();
                              },
                              child: Container(
                                height: 55,
                                width: 150,
                                decoration: const BoxDecoration(
                                  color: kPrimaryColour,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Upload DL",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            authController.sendOtp(isNew: true);
                          },
                          child: Container(
                              height: 55,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: kPrimaryColour,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Obx(
                                () => Center(
                                  child: authController.isLoading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 2,
                                        )
                                      : const Text(
                                          "Send OTP",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              )),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?  ",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  Get.offAll(() => const LoginScreen()),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
