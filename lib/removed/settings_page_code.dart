  // Future<void> _selectFile() async {
  //   if (defaultTargetPlatform == TargetPlatform.windows ||
  //       defaultTargetPlatform == TargetPlatform.linux ||
  //       defaultTargetPlatform == TargetPlatform.macOS) {
  //     const typeGroup = XTypeGroup(
  //       label: 'videos',
  //       extensions: [
  //         'mp4',
  //         'mov',
  //         'avi',
  //         'mkv',
  //         'flv',
  //         'wmv',
  //         'webm',
  //         'mpeg',
  //         'mpg'
  //       ],
  //     );
  //     final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
  //     if (file != null) {
  //       setState(() {
  //         originalfile.text = file.path;
  //       });
  //     }
  //   } else {
  //     developer.log("File selection is not supported on this platform.");
  //   }
  // }