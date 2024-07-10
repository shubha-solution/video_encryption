import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FilePath extends GetxController {
  RxString originalFolderPath = ''.obs;
  RxString compressedFolderPath = ''.obs;
  RxString bit = "".obs;
  RxString fps = "".obs;
  RxBool cloud = false.obs;
  RxBool compress = false.obs;
  RxBool shutdown = false.obs;
}
