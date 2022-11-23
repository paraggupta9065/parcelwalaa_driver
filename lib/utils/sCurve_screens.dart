import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/utils/colors.dart';
import '/view/auth/login_screen.dart';

Widget sCurveBottom() {
  return Stack(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: Get.size.height * .25,
                    width: Get.size.width,
                    child: Image.asset(
                      "asset/doodle.jpeg",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: kPrimaryColour.withOpacity(0.8),
                    height: Get.size.height * .25,
                  ),
                ],
              ),
            ],
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: Get.size.height * .25,
                      width: Get.size.width,
                      child: Image.asset(
                        "asset/doodle.jpeg",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      color: kPrimaryColour.withOpacity(0.8),
                      height: Get.size.height * .25,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      Stack(
        children: [
          Container(
            height: Get.size.height * 0.75,
            decoration: const BoxDecoration(
              color: kBackgroundColour,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget sCurveTop() {
  return Stack(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(50),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: Get.size.height * .25,
                      width: Get.size.width,
                      child: Image.asset(
                        "asset/doodle.jpeg",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      color: kPrimaryColour.withOpacity(0.8),
                      height: Get.size.height * .25,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: Get.size.height * .25,
                    width: Get.size.width,
                    child: Image.asset(
                      "asset/doodle.jpeg",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: kPrimaryColour.withOpacity(0.8),
                    height: Get.size.height * .25,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: Get.size.height * 0.75,
            decoration: const BoxDecoration(
              color: kBackgroundColour,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
