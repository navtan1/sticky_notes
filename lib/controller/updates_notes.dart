import 'package:get/get.dart';

class UpdatesNotes extends GetxController {
  RxBool change = true.obs;
  RxBool circles = true.obs;
  RxBool upDate = true.obs;

  updateNotes() {
    change.value = !change.value;
  }

  changeCircle() {
    circles.value = !circles.value;
  }

  updateData() {
    upDate.value = !upDate.value;
  }
}
