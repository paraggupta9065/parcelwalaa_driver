import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcelwalaa_driver/controller/auth.dart';
import 'package:parcelwalaa_driver/utils/colors.dart';
import 'package:parcelwalaa_driver/utils/sCurve_screens.dart';
import 'package:parcelwalaa_driver/view/auth/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                      "Login",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Access account",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: Get.size.height * 0.75,
                  width: Get.size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        // Row(children: const [Text("Name")]),
                        // const SizedBox(height: 5),
                        // Container(
                        //   height: 55,
                        //   decoration: const BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(15))),
                        // ),

                        const SizedBox(height: 100),
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
                                hintText: "9865333566",
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
                        InkWell(
                          onTap: () {
                            authController.sendOtp(isNew: false);
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
                              "Don’t have an account?  ",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            InkWell(
                              onTap: () => Get.offAll(
                                () => const SignUpScreen(),
                              ),
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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
