
  // void checkForNewFiles() async {
  //   print("${c.tobecompressedvideospath} file List");
  //   // final originalDirectory = Directory(c.originalFolderPath.value);
  //   for( var video in c.tobecompressedvideospath){
  //     //  final originalDirectory = Directory(dirname(video));

  //   // final compressedDirectory = Directory(c.compressedFolderPath.value);

  //   // final originalFiles =
  //   //     originalDirectory.listSync().whereType<File>().toList();
  //    final file = File(video);
  //   // final compressedFilesList =
  //   //     compressedDirectory.listSync().whereType<File>().toList();

  //   // final compressedFileNames =
  //   //     compressedFilesList.map((file) => basename(file.path)).toSet();


  //     // if (!compressedFileNames.contains(basename(file.path))) {
  //       bool isWriting = await _isFileStillBeingWritten(file);
  //       if (!isWriting) {
  //         isCompressing =
  //             true; // Set flag to indicate compression is in progress
  //         compressVideo(file.path, c.compressedFolderPath.value, c.fps.value,
  //             c.bit.value);
  //             break;
  //        // Start compressing one file and exit the loop
  //       }
  //     // }
      
  //   }
   
    
  //   // _closeDialogIfOpen();
  // }







    // void getfileslist() 
  // {
  //   final originalDirectory = Directory(c.originalFolderPath.value);
  //   final completedDirectory = Directory(c.completedFolderPath.value);


  //   final videoExtensions = ['.mp4', '.mkv', '.flv'];

  //   if (!originalDirectory.existsSync() || !completedDirectory.existsSync()) {
  //     return;
  //   }

  //   final originalFiles = originalDirectory
  //       .listSync()
  //       .where((item) => item is File && videoExtensions.contains(extension(item.path).toLowerCase()))
  //       .toList();

  //   for (var file in originalFiles) {
  //     final specificPathFile = File(join(completedDirectory.path, basename(file.path)));
  //     if (!specificPathFile.existsSync() && !c.tobecompressedvideospath.contains(file.path)) {
  //       c.tobecompressedvideospath.add(file.path);
  //     }
      
  //   }

  //   // Start compressing if not already compressing and there are videos to compress
  //   if (!isCompressing && c.tobecompressedvideospath.isNotEmpty) {
  //     startCompressing();
  //   }
  // }