import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sticky_notes/view/home_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.off(() => HomeScreen());
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text("About"),
      ),
      body: Column(
        children: const [
          SizedBox(
            height: 20,
          ),
          Text(
            "  This Application is develop by Navtan Bhanderi\n\n  To store your important note in this App",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
