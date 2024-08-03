import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class FilePath extends GetxController {
  RxString originalFolderPath = ''.obs;
  RxList originalFiles = [].obs;
  RxString compressedFolderPath = ''.obs;
  RxString completedFolderPath = ''.obs;
  RxBool checkoriginalvideos = true.obs;
  RxString bit = "".obs;
  RxString fps = "".obs;
  RxBool cloud = false.obs;
  RxBool compress = false.obs;
  RxBool shutdown = false.obs;
  RxBool isCanceled = false.obs;

  // Progress Page
  // RxList<VideoDetails> tobecompressedvideospath = <VideoDetails>[].obs  ;

  RxList tobecompressedvideospath = [].obs;
  RxList allcompressedvideospath = [].obs;
  RxList<dynamic> videos = [].obs;

  RxString currentCompressingVide = "".obs;

  final infoFilePath = 'path/to/info_file.json';
}
