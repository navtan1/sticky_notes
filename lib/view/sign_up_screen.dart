import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sticky_notes/constant.dart';
import 'package:sticky_notes/controller/password_controller.dart';
import 'package:sticky_notes/controller/sign_up_button_controller.dart';
import 'package:sticky_notes/firebase_service/firebase_services.dart';
import 'package:sticky_notes/view/home_screen.dart';
import 'package:sticky_notes/view/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GetStorage _storage = GetStorage();

  final fName = TextEditingController();

  final lName = TextEditingController();

  final email = TextEditingController();

  final passWord = TextEditingController();

  final formKey = GlobalKey<FormState>();

  PasswordController passwordController = Get.put(PasswordController());

  SignUpButtonController buttonController = Get.put(SignUpButtonController());

  File? _image;

  final imagePic = ImagePicker();

  Future pickedImage() async {
    var imagePicked = await imagePic.pickImage(source: ImageSource.gallery);

    if (imagePicked != null) {
      setState(() {
        _image = File(imagePicked.path);
      });
    }
  }

  Future<String?> uploadFile(File file, String filename) async {
    print("File path:${file.path}");
    try {
      var response = await storage.ref("user_image/$filename").putFile(file);
      return response.storage.ref("user_image/$filename").getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }

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
                      "Register your account",
                      style: TextStyle(fontSize: 20),
                    ),
                    Stack(
                      children: [
                        Card(
                          margin: EdgeInsets.all(15),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: _image == null
                                  ? Icon(Icons.person)
                                  : Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: GestureDetector(
                                onTap: () {
                                  pickedImage();
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(Icons.camera_alt),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        }
                      },
                      controller: fName,
                      decoration: InputDecoration(hintText: "First Name"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        }
                      },
                      controller: lName,
                      decoration: InputDecoration(hintText: "Last Name"),
                    ),
                    SizedBox(
                      height: 10,
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
                                buttonController.onChange();
                                bool status = await FirebaseServices.signUp(
                                    email.text, passWord.text);
                                if (status == true) {
                                  String? imageUrl = await uploadFile(_image!,
                                      "${kFirebaseAuth.currentUser!.email}jpg");
                                  await _storage.write("email", email.text);
                                  collectionReference
                                      .doc(kFirebaseAuth.currentUser!.uid)
                                      .set(
                                    {
                                      "first name": fName.text,
                                      "last name": lName.text,
                                      "email": email.text,
                                      "password": passWord.text,
                                      "image": imageUrl,
                                    },
                                  ).then(
                                    (value) => Get.off(
                                      () => HomeScreen(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Invalid user id or Password"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      )
                                      .closed
                                      .then((value) =>
                                          buttonController.onChange());
                                }
                              }
                            },
                            child: Text("Sign Up"),
                          )
                        : CircularProgressIndicator()),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => buttonController.press.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("You have Already Account ?"),
                                TextButton(
                                  onPressed: () {
                                    Get.off(() => SignInScreen());
                                  },
                                  child: Text("Log in"),
                                )
                              ],
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
