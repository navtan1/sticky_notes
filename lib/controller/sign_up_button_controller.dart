import 'package:get/get.dart';

class SignUpButtonController extends GetxController {
  RxBool press = true.obs;

  onChange() {
    press.value = !press.value;
  }
}
