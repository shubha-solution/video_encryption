import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// void main() {
//   runApp(MyApp());
// }


      // home: VideoListScreen(),


class VideoListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> videos = [
    {
      "Name": "output.mp4",
      "Path": "C:/Users/HP/Downloads/videos/output.mp4",
      "Size": "5.0 MB",
      "Duration": "3.05",
      "CompletedPath": "C:/Users/HP/Documents/completedfolder",
      "CompressedPath": "C:/Users/HP/Documents/encrypted video",
      "Status": "failed",
      "CompressDate": "2024-08-02"
    },
    {
      "Name": "sample.mp4",
      "Path": "C:/Users/HP/Downloads/videos/sample.mp4",
      "Size": "4.1 MB",
      "Duration": "2.52",
      "CompletedPath": "C:/Users/HP/Documents/completedfolder",
      "CompressedPath": "C:/Users/HP/Documents/encrypted video",
      "Status": "failed",
      "CompressDate": "2024-08-02"
    },
    {
      "Name": "y2mate.com - SUNIYAN SUNIYAN Official Audio Juss x MixSingh x Teji Sandhu  Punjabi Songs 2024  ZAYN WORLDWIDE_v144P.mp4",
      "Path": "C:/Users/HP/Downloads/videos/y2mate.com - SUNIYAN SUNIYAN Official Audio Juss x MixSingh x Teji Sandhu  Punjabi Songs 2024  ZAYN WORLDWIDE_v144P.mp4",
      "Size": "4.7 MB",
      "Duration": "3.25",
      "CompletedPath": "C:/Users/HP/Documents/completedfolder",
      "CompressedPath": "C:/Users/HP/Documents/encrypted video",
      "Status": "failed",
      "CompressDate": "2024-08-02"
    }
  ];

  @override
  Widget build(BuildContext context) {
    // Group videos by date
    final Map<String, List<Map<String, dynamic>>> groupedVideos = {};
    for (var video in videos) {
      final date = DateFormat('dd-MM-yyyy').format(DateTime.parse(video['CompressDate']));
      if (!groupedVideos.containsKey(date)) {
        groupedVideos[date] = [];
      }
      groupedVideos[date]!.add(video);
    }

    final List<String> dates = groupedVideos.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: ListView.builder(
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final count = groupedVideos[date]!.length;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: Offset(4, 5),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                _showMyDialog(context, date, groupedVideos[date]!);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("$date - $count videos"),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMyDialog(BuildContext context, String date, List<Map<String, dynamic>> videos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Videos for $date'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: videos.map((video) {
              return ListTile(
                title: Text(video['Name']),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
