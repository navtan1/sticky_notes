import 'package:get/get.dart';

class PasswordController extends GetxController {
  RxBool pass = true.obs;

  changeValue() {
    pass.value = !pass.value;
  }
}
