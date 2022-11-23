import 'package:flutter/material.dart';
import 'package:parcelwalaa_driver/utils/colors.dart';

class Earning extends StatefulWidget {
  const Earning({Key? key}) : super(key: key);

  @override
  State<Earning> createState() => _EarningState();
}

class _EarningState extends State<Earning> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Today So Far",
          style: TextStyle(color: kTextColour),
        ),
        backgroundColor: Colors.white,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                "₹ 100",
                style: TextStyle(
                  color: kTextColour,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ),
            );
          }
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                trailing: Text(
                  "₹100",
                ),
                title: Text(
                  DateTime.now().toString(),
                ),
                subtitle: Text(
                  DateTime.now().toString(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
