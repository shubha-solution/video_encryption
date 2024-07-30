import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_encryption/components/colorpage.dart'; // Assuming this defines ColorPage.darkblue
import 'package:video_encryption/components/fontfamily.dart'; // Assuming this defines FontFamily.font3
import 'package:video_encryption/constants/myfonts.dart'; // Assuming this defines MyFonts
import 'package:video_encryption/pages/titlebar/title_bar.dart'; // Assuming this defines TitleBar

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final Map<String, dynamic> dummyData = {
    "inprogressvideos": [
      {
        "videoName": "Introduction to Flutter",
        "location": "/videos/intro_to_flutter.mp4",
        "sizeMB": 150.5
      },
      {
        "videoName": "Advanced Dart Programming",
        "location": "/videos/advanced_dart.mp4",
        "sizeMB": 200.0
      },
      {
        "videoName": "Building a REST API with Node.js",
        "location": "/videos/rest_api_nodejs.mp4",
        "sizeMB": 300.75
      },
      {
        "videoName": "Getting Started with React",
        "location": "/videos/react_getting_started.mp4",
        "sizeMB": 250.25
      },
      {
        "videoName": "Mastering Python",
        "location": "/videos/mastering_python.mp4",
        "sizeMB": 320.0
      }
    ],
    "events": [
      {"name": "Meeting with client", "date": "2024-08-01T10:00:00Z"},
      {"name": "Project deadline", "date": "2024-08-15T23:59:59Z"},
      {"name": "Conference", "date": "2024-09-10T09:00:00Z"}
    ]
  };

  RxBool isinProgress = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/settingsbg2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(child: TitleBar()),
              ],
            ),
            Flexible(
              child: Center(
                child: Card(
                  elevation: 50,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 500,
                    width: 900,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: LinearProgressIndicator(
                            value: 0.75,
                            borderRadius: BorderRadiusDirectional.all(
                                Radius.circular(10)),
                            minHeight: 10,
                          ),
                        ),
                        const Text(
                          '75%',
                          style: TextStyle(
                            fontSize: 15,
                            color: ColorPage.darkblue,
                          ),
                        ),
                        Text(
                          'PROGRESS',
                          style: TextStyle(
                            fontFamily: MyFonts.heading,
                            fontSize: MyFonts.headingsize,
                            color: ColorPage.darkblue,
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 2,
                          indent: 200,
                          endIndent: 200,
                          color: Colors.black12,
                        ),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  isinProgress.value = true;
                                },
                                color: isinProgress.value
                                    ? ColorPage.darkblue
                                    : null,
                                child: Text(
                                  'In Progress',
                                  style: FontFamily.font3.copyWith(
                                    color: !isinProgress.value
                                        ? ColorPage.darkblue
                                        : null,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              MaterialButton(
                                onPressed: () {
                                  isinProgress.value = false;
                                },
                                color: !isinProgress.value
                                    ? ColorPage.darkblue
                                    : null,
                                child: Text(
                                  'History',
                                  style: FontFamily.font3.copyWith(
                                    color: isinProgress.value
                                        ? ColorPage.darkblue
                                        : null,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 2,
                          indent: 200,
                          endIndent: 200,
                          color: Colors.black12,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => isinProgress.value
                                      ? SingleChildScrollView(
                                          child: DataTable(
                                            columns: const [
                                              DataColumn(
                                                  label: Text('Video Name')),
                                              DataColumn(label: Text('Location')),
                                              DataColumn(
                                                  label: Text('Size (in MB)')),
                                              DataColumn(label: Text('')),
                                            ],
                                            rows: dummyData["inprogressvideos"]
                                                .map<DataRow>((video) {
                                              return DataRow(cells: [
                                                DataCell(
                                                    Text(video['videoName'])),
                                                DataCell(Text(video['location'])),
                                                DataCell(Text(
                                                    video['sizeMB'].toString())),
                                                DataCell(IconButton(
                                                  onPressed: () {
                                                    // Handle delete action
                                                  },
                                                  icon: const Icon(
                                                      Icons.cancel_outlined),
                                                )),
                                              ]);
                                            }).toList(),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: dummyData["events"].length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              onTap: () {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const Text(
                                                        'AlertDialog Title'),
                                                    content: const Text(
                                                        'AlertDialog description'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'Cancel'),
                                                        child:
                                                            const Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              title: Text(dummyData["events"]
                                                  [index]["date"]),
                                            );
                                          },
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20), 
                              Obx(
                                () => isinProgress.value
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 200),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MaterialButton(
                                              color: Colors.blue,
                                              onPressed: () {},
                                              child: const Text('Browse'),
                                            ),
                                            MaterialButton(
                                              color: Colors.blueGrey,
                                              onPressed: () {},
                                              child: const Text('Cancel all'),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}