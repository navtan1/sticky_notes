import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sticky_notes/constant.dart';

import '../controller/updates_notes.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {Key? key, this.fname, this.lname, this.emails, this.image})
      : super(key: key);

  final fname;
  final lname;
  final emails;
  final image;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final fName = TextEditingController();

  final lName = TextEditingController();

  final email = TextEditingController();

  UpdatesNotes updatesNotes = Get.put(UpdatesNotes());

  Future updateData() async {
    String? imageUrl =
        await uploadFile(_image!, "${kFirebaseAuth.currentUser!.email}jpg");

    collectionReference.doc(kFirebaseAuth.currentUser!.uid).update({
      "first name": fName.text,
      "last name": lName.text,
      "image": imageUrl ?? widget.image,
    }).catchError((e) {
      print("$e");
    });
  }

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
  void initState() {
    fName.text = widget.fname;
    lName.text = widget.lname;
    email.text = widget.emails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Obx(
          () => updatesNotes.change.value
              ? IconButton(
                  onPressed: () {
                    Get.off(() => HomeScreen());
                  },
                  icon: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.black,
                  ))
              : TextButton(
                  onPressed: () async {
                    await updatesNotes.updateNotes();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                ),
        ),
        title: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  await updatesNotes.updateNotes();
                  if (updatesNotes.change.value == true) {
                    await updateData();
                  }
                },
                child: Text(
                  updatesNotes.change.value ? "Edit" : "Done",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                                ? Image.network(
                                    "${widget.image}",
                                    fit: BoxFit.cover,
                                  )
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
                                if (updatesNotes.change.value == false) {
                                  pickedImage();
                                }
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
                ],
              ),
              Text("First Name"),
              Obx(
                () => TextField(
                  controller: fName,
                  readOnly: updatesNotes.change.value,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(fontSize: 21),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Last Name"),
              Obx(
                () => TextField(
                  controller: lName,
                  readOnly: updatesNotes.change.value,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(fontSize: 21),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Email"),
              TextField(
                controller: email,
                readOnly: true,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(fontSize: 21),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
