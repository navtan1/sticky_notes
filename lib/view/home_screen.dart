import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sticky_notes/constant.dart';
import 'package:sticky_notes/controller/sign_up_button_controller.dart';
import 'package:sticky_notes/firebase_service/firebase_services.dart';
import 'package:sticky_notes/view/add_note.dart';
import 'package:sticky_notes/view/current_location.dart';
import 'package:sticky_notes/view/open_notes.dart';
import 'package:sticky_notes/view/profile.dart';
import 'package:sticky_notes/view/sign_in_screen.dart';

import 'about.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GetStorage storage = GetStorage();

  SignUpButtonController buttonController = Get.put(SignUpButtonController());

  final title = TextEditingController();

  final notes = TextEditingController();

  String? fName;
  String? lName;
  String? email;
  String? getImage;

  Future getData() async {
    final user =
        await collectionReference.doc(kFirebaseAuth.currentUser!.uid).get();

    Map<String, dynamic>? getUserData = user.data() as Map<String, dynamic>?;

    setState(() {
      fName = getUserData!["first name"];
      lName = getUserData["last name"];
      email = getUserData["email"];
      getImage = getUserData["image"];
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "$fName $lName",
                style: TextStyle(fontSize: 25),
              ),
              accountEmail: Text(
                "$email",
                style: TextStyle(fontSize: 13),
              ),
              currentAccountPicture: Container(
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage("$getImage"), fit: BoxFit.cover),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => ProfileScreen(
                      fname: fName,
                      lname: lName!,
                      emails: email!,
                      image: getImage,
                    ));
              },
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
              ),
            ),
            Divider(color: Colors.black45),
            GestureDetector(
              onTap: () {
                Get.off(() => HomeScreen());
              },
              child: ListTile(
                leading: Icon(Icons.note_add_sharp),
                title: Text("Notes"),
              ),
            ),
            Divider(color: Colors.black45),
            GestureDetector(
              onTap: () {
                Get.to(() => AboutScreen());
              },
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text("About"),
              ),
            ),
            Divider(color: Colors.black45),
            GestureDetector(
              onTap: () {
                Get.to(() => CurrentLocat());
              },
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text("Map"),
              ),
            ),
            Spacer(),
            Divider(color: Colors.black45),
            GestureDetector(
              onTap: () async {
                await FirebaseServices.logOut()
                    .then((value) => storage.remove("email"))
                    .then((value) => Get.off(() => SignInScreen()));
              },
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text("Log Out"),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddNoteScreen());
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionReference
            .doc(kFirebaseAuth.currentUser!.uid)
            .collection("data")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> info = snapshot.data!.docs;
            return ListView.builder(
              itemCount: info.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => OpenNotes(
                          getTitle: info[index].get("title"),
                          getNotes: info[index].get("notes"),
                          getindex: info[index].id,
                        ));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${info[index].get("title")}",
                          style: TextStyle(fontSize: 21),
                        ),
                        Row(
                          children: [
                            Text(info[index]
                                .get("time")
                                .toString()
                                .split(" ")[0]),
                            Text(
                                ", ${info[index].get("time").toString().split(" ")[1].split(".")[0]}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
