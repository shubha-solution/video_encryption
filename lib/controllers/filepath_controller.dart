import 'package:get/get.dart';

class FilePath extends GetxController {
  RxString originalFolderPath = ''.obs;
  RxString compressedFolderPath = ''.obs;
  RxString completedFolderPath = ''.obs;

  RxString bit = "".obs;
  RxString fps = "".obs;
  RxBool cloud = false.obs;
  RxBool compress = false.obs;
  RxBool shutdown = false.obs;

  // Progress Page
  // RxList<VideoDetails> tobecompressedvideospath = <VideoDetails>[].obs  ;

  RxList tobecompressedvideospath = [].obs ;
  RxList allcompressedvideospath = [].obs ;

  RxString currentCompressingVide = "".obs;

}
