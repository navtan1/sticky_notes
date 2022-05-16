import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sticky_notes/view/sign_up_screen.dart';

import '../controller/password_controller.dart';
import '../controller/sign_up_button_controller.dart';
import '../firebase_service/firebase_services.dart';
import 'home_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  GetStorage storage = GetStorage();

  final email = TextEditingController();
  final passWord = TextEditingController();
  final formKey = GlobalKey<FormState>();

  PasswordController passwordController = Get.put(PasswordController());
  SignUpButtonController buttonController = Get.put(SignUpButtonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.shade100,
              Colors.cyan.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "LogIn your Account",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: email,
                    validator: (value) {
                      RegExp regex = RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                      if (!regex.hasMatch(value!)) {
                        return "Enter valid Email";
                      }
                    },
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => TextFormField(
                      obscureText: passwordController.pass.value,
                      validator: (value) {
                        if (value!.length < 6) {
                          return "Attlist 6 character";
                        }
                      },
                      controller: passWord,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            passwordController.changeValue();
                          },
                          icon: Icon(passwordController.pass.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() => buttonController.press.value
                      ? ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await buttonController.onChange();
                              bool status = await FirebaseServices.logIn(
                                  email.text, passWord.text);
                              if (status == true) {
                                await storage.write("email", email.text);
                                Get.off(
                                  () => HomeScreen(),
                                )!
                                    .then(
                                        (value) => buttonController.onChange());
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("Invalid user id or Password"),
                                        duration: Duration(seconds: 3),
                                      ),
                                    )
                                    .closed
                                    .then(
                                        (value) => buttonController.onChange());
                              }
                            }
                          },
                          child: Text("Sign In"),
                        )
                      : CircularProgressIndicator()),
                  SizedBox(
                    height: 20,
                  ),
                  // ElevatedButton(
                  //     onPressed: () async {
                  //       await storage.remove("email");
                  //       ScaffoldMessenger.of(context)
                  //           .showSnackBar(SnackBar(content: Text("hii")))
                  //           .closed
                  //           .then((value) => buttonController.onChange());
                  //     },
                  //     child: Text("showSnackbar")),
                  Obx(
                    () => buttonController.press.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("You do not have any Account ?"),
                              TextButton(
                                onPressed: () {
                                  Get.off(() => SignUpScreen());
                                },
                                child: Text("Sign Up"),
                              )
                            ],
                          )
                        : SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
