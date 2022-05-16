import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sticky_notes/view/home_screen.dart';

import '../constant.dart';

class AddNoteScreen extends StatelessWidget {
  AddNoteScreen({Key? key}) : super(key: key);

  final title = TextEditingController();
  final notes = TextEditingController();

  final formKey = GlobalKey<FormState>();

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await collectionReference
                      .doc(kFirebaseAuth.currentUser!.uid)
                      .collection("data")
                      .add({
                    "title": title.text,
                    "notes": notes.text,
                    "time": DateTime.now().toString()
                  }).then(
                    (value) => Get.off(
                      () => HomeScreen(),
                    ),
                  );
                }
              },
              child: Text(
                "Done",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required";
                  }
                },
                controller: title,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(fontSize: 21),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: notes,
                maxLength: 1000,
                maxLines: 20,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Add Notes",
                  border: InputBorder.none,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
