import 'package:get/get.dart';

class ProgressControllerTest extends GetxController {
  var progress = 0.0.obs;

  void updateProgress(double value) {
    progress.value = value;
  }
}
