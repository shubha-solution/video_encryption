// class VideoDetails {
//   String name;
//   String path;
//   String size;
//   String duration;
//   String completedPath;
//   String compressedPath;
//   String status;



//   VideoDetails({
//     required this.name,
//     required this.path,
//     required this.size,
//     required this.duration,
//     required this.completedPath,
//     required this.compressedPath,
//     required this.status,
//   });

//   factory VideoDetails.fromJson(Map<String, dynamic> json) {
//     return VideoDetails(
//       name: json['name'],
//       path: json['path'],
//       size: json['size'],
//       duration: json['duration'],
//       completedPath: json['completedPath'],
//       compressedPath: json['compressedPath'],
//       status: json['status'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'path': path,
//       'size': size,
//       'duration': duration,
//       'completedPath': completedPath,
//       'compressedPath': compressedPath,
//       'status': status,

//     };
//   }
// }