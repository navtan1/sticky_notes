import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sticky_notes/view/home_screen.dart';
import 'package:sticky_notes/view/sign_up_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GetStorage storage = GetStorage();

  String? userData;

  @override
  void initState() {
    getData().whenComplete(() => Timer(Duration(seconds: 3), () {
          Get.off(() => userData == null ? SignUpScreen() : HomeScreen());
        }));
    super.initState();
  }

  Future getData() async {
    String user = await storage.read("email");

    setState(() {
      userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade200,
              Colors.cyan.shade200,
              Colors.tealAccent.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
            child: Image.asset(
          "assets/notes.png",
          scale: 4,
        )),
      ),
    );
  }
}
