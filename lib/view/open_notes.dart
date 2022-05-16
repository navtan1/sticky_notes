import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sticky_notes/constant.dart';

import '../controller/updates_notes.dart';
import 'home_screen.dart';

class OpenNotes extends StatefulWidget {
  OpenNotes({
    Key? key,
    this.getTitle,
    this.getNotes,
    this.getindex,
  }) : super(key: key);

  final getTitle;

  final getindex;

  final getNotes;

  @override
  State<OpenNotes> createState() => _OpenNotesState();
}

class _OpenNotesState extends State<OpenNotes> {
  TextEditingController title = TextEditingController();

  TextEditingController notes = TextEditingController();

  UpdatesNotes updatesNotes = Get.put(UpdatesNotes());

  @override
  void initState() {
    title = TextEditingController(text: widget.getTitle);
    notes = TextEditingController(text: widget.getNotes);
    super.initState();
  }

  Future updateData() async {
    await collectionReference
        .doc(kFirebaseAuth.currentUser!.uid)
        .collection("data")
        .doc("${widget.getindex}")
        .update({
      "title": title.text,
      "notes": notes.text,
      "time": DateTime.now().toString()
    }).catchError((e) {
      print("$e");
    });
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
              updatesNotes.change.value
                  ? IconButton(
                      onPressed: () async {
                        await updatesNotes.updateNotes();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    )
                  : TextButton(
                      onPressed: () async {
                        await updatesNotes.updateNotes();
                        if (updatesNotes.change.value == true) {
                          await updateData();
                        }
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
              updatesNotes.change.value
                  ? IconButton(
                      onPressed: () {
                        Get.dialog(AlertDialog(
                          title: Text("Do you want to delete this Notes"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  collectionReference
                                      .doc(kFirebaseAuth.currentUser!.uid)
                                      .collection("data")
                                      .doc("${widget.getindex}")
                                      .delete()
                                      .then(
                                        (value) => Get.off(
                                          () => HomeScreen(),
                                        ),
                                      );
                                },
                                child: Text("Delete")),
                          ],
                        ));
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ))
                  : SizedBox(),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(children: [
            Obx(
              () => TextField(
                controller: title,
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
            Obx(
              () => TextField(
                controller: notes,
                readOnly: updatesNotes.change.value,
                maxLength: 1000,
                maxLines: 20,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Add Notes",
                  border: InputBorder.none,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
