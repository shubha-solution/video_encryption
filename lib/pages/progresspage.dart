import 'dart:async';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_encryption/components/colorpage.dart';
import 'package:video_encryption/components/fontfamily.dart';
import 'package:video_encryption/constants/myfonts.dart';
import 'package:video_encryption/controllers/ffmpeg/video_compressor.dart';
import 'package:video_encryption/controllers/filepath_controller.dart';
import 'package:video_encryption/controllers/files/files.dart';
import 'package:video_encryption/pages/titlebar/title_bar.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  SettingsStorage storage = SettingsStorage();

  List<String> animatedText = [
    'Protect your videos ensure complete security.',
    'Keep your videos safe maintain privacy and security.',
    'Secure your content safeguard your data.'
  ];

  RxBool isEnpChecked = false.obs;
  RxBool isCompressedChecked = false.obs;

  RxBool isinProgress = true.obs;
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;
  RxBool isCompressing = false.obs;

  // controllers
  FilePath c = Get.put(FilePath());
  RunCommand p = Get.put(RunCommand());

  TextStyle headingstyle = FontFamily.font6.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: ColorPage.darkblue.withOpacity(0.7));
  TextStyle buttonTextStyle = TextStyle(
    fontFamily: MyFonts.heading,
    fontSize: MyFonts.headingsize,
    color: ColorPage.darkblue,
  );
  TextStyle headingNumber = TextStyle(
    fontFamily: MyFonts.heading,
    fontSize: MyFonts.headingsize,
    color: ColorPage.darkblue.withOpacity(0.3),
  );
  TextStyle rowTextStyle = FontFamily.font3
      .copyWith(color: const Color.fromARGB(255, 130, 130, 130));

  final RxMap<String, bool> compressedState = <String, bool>{}.obs;

  @override
  void initState() {
    storage.readHistoryVideos(c.infoFilePath);

    Timer.periodic(const Duration(seconds: 10), (timer) {
      storage.readHistoryVideos(c.infoFilePath);
    });

    super.initState();
  }

  String? _selectedVideoPath;

  bool isChecked(String path) {
    return _selectedVideoPath == path;
  }

  void setChecked(String path, bool value) {
    setState(() {
      _selectedVideoPath = value ? path : null;
      compressedState[path] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    final Map<String, List<Map<String, dynamic>>> groupedVideos = {};
    for (var video in c.videos) {
      final date = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(video['CompressDate']));
      if (!groupedVideos.containsKey(date)) {
        groupedVideos[date] = [];
      }
      groupedVideos[date]!.add(video);
    }

    final List<String> dates = groupedVideos.keys.toList();

    List<String> filteredDates = dates.where((date) {
      if (_selectedIndex == 0) {
        // Show videos where status is true
        return groupedVideos[date]!.any((video) => video['Status'] == 'true');
      } else if (_selectedIndex == 1) {
        // Show videos where status is false
        return groupedVideos[date]!.any((video) => video['Status'] == 'false');
      } else {
        // Show nothing for selectedIndex 2
        return false;
      }
    }).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Column(
        children: [
          const Row(
            children: [
              Expanded(child: TitleBar()),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            height: height - 35,
            width: width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(Icons.arrow_back_rounded)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('Progress', style: buttonTextStyle),
                          const SizedBox(
                            width: 5,
                          ),
                          isinProgress.value
                              ? Text(
                                  '${c.allcompressedvideospath.length.toString()}/${c.tobecompressedvideospath.length.toString()}',
                                  style: headingNumber,
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    Obx(
                      () => isinProgress.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: MaterialButton(
                                    color: Colors.blue[700],
                                    onPressed: () async {
                                      c.tobecompressedvideospath.clear();
                                      c.allcompressedvideospath.clear();
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          'Clear All',
                                          style: FontFamily.font3
                                              .copyWith(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  color: Colors.blue[700],
                                  onPressed: () async {
                                    const typeGroup = XTypeGroup(
                                      label: 'Videos',
                                      extensions: ['mp4', 'mkv', 'flv'],
                                    );
                                    final List<XFile> files = await openFiles(
                                        initialDirectory: 'Upload videos',
                                        acceptedTypeGroups: [typeGroup]);

                                    if (files.isNotEmpty) {
                                      for (var file in files) {
                                        p.addNewVideo(file.path);
                                        c.checkoriginalvideos.value = true;
                                      }
                                    } else {
                                      print("File selection canceled");
                                    }
                                  },
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      'Browse',
                                      style: FontFamily.font3
                                          .copyWith(fontSize: 14),
                                    ),
                                  )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Obx(
                                  () => Opacity(
                                    opacity:
                                        c.tobecompressedvideospath.isNotEmpty
                                            ? 1
                                            : 0.4,
                                    child: MaterialButton(
                                      shape: ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                            color: Colors.black54, width: 2),
                                      ),
                                      onPressed:
                                          c.tobecompressedvideospath.isNotEmpty
                                              ? () {
                                                  c.isCanceled.value
                                                      ? p.restartCompressing()
                                                      : p.cancelCompression();
                                                  c.isCanceled.value =
                                                      !c.isCanceled.value;
                                                }
                                              : null,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.cancel_outlined,
                                              size: 20,
                                              color: Colors.black54,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              !c.isCanceled.value
                                                  ? 'Cancel All'
                                                  : 'Restart',
                                              style: FontFamily.font3.copyWith(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Row(
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      MaterialButton(
                        onPressed: () {
                          isinProgress.value = true;
                        },
                        color: isinProgress.value ? ColorPage.darkblue : null,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
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
                      ),
                      const SizedBox(width: 20),
                      MaterialButton(
                        onPressed: () {
                          isinProgress.value = false;
                        },
                        color: !isinProgress.value ? ColorPage.darkblue : null,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Obx(
                  () => isinProgress.value
                      ? Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    spreadRadius: 4,
                                    offset: Offset(8, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Video Type',
                                      style: headingstyle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Video Name',
                                      style: headingstyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Location',
                                      style: headingstyle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Video Size (in MB)',
                                      style: headingstyle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Duration',
                                      style: headingstyle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Encrypt',
                                      style: headingstyle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Compress',
                                      style: headingstyle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const SizedBox(width: 40),
                                ],
                              ),
                            ),
                            Expanded(
                                child: true
                                    ? ListView.builder(
                                        itemCount:
                                            c.tobecompressedvideospath.length,
                                        itemBuilder: (context, index) {
                                          print(index);
                                          final videoPath = c
                                              .tobecompressedvideospath[index]
                                                  ["path"]
                                              .replaceAll(r'\', r'/');
                                          return InkWell(
                                            onTap: () {},
                                            child: Obx(() {
                                              return Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  c.currentCompressingVide ==
                                                          videoPath
                                                      ? LinearProgressIndicator(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          minHeight: 50,
                                                          color:
                                                              Colors.blue[300],
                                                          value:
                                                              p.progress.value,
                                                        )
                                                      : const SizedBox(),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: c.allcompressedvideospath
                                                              .contains(
                                                                  videoPath)
                                                          ? Colors.green[100]
                                                          : c.currentCompressingVide ==
                                                                  videoPath
                                                              ? Colors
                                                                  .transparent
                                                              : Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(8),
                                                      ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            '${c.tobecompressedvideospath[index]["type"]}',
                                                            style: rowTextStyle,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: Tooltip(
                                                            message:
                                                                c.tobecompressedvideospath[
                                                                        index]
                                                                    ["name"],
                                                            child: Text(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              '${c.tobecompressedvideospath[index]["name"]}',
                                                              style: FontFamily
                                                                  .font4
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: Tooltip(
                                                            message:
                                                                '${c.tobecompressedvideospath[index]["path"].replaceAll(r'\', r'/')}',
                                                            child: Text(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              '${c.tobecompressedvideospath[index]["path"].replaceAll(r'\', r'/')}',
                                                              style: FontFamily
                                                                  .font4
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            '${c.tobecompressedvideospath[index]["sizeMB"]} Mb',
                                                            style: rowTextStyle,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            '${c.tobecompressedvideospath[index]["duration"]}',
                                                            style: rowTextStyle,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        SizedBox(
                                                          width: 60,
                                                          child: Center(
                                                            child: c.tobecompressedvideospath
                                                                            .length ==
                                                                        index ||
                                                                    c.currentCompressingVide !=
                                                                        videoPath
                                                                ? Checkbox(
                                                                    checkColor:
                                                                        ColorPage
                                                                            .darkblue,
                                                                    fillColor:
                                                                        const MaterialStatePropertyAll(
                                                                            Colors.transparent),
                                                                    value: isChecked(
                                                                        videoPath),
                                                                    onChanged: c
                                                                            .allcompressedvideospath
                                                                            .contains(
                                                                                videoPath)
                                                                        ? null
                                                                        : (bool?
                                                                            value) {
                                                                            setChecked(videoPath,
                                                                                value!);
                                                                          },
                                                                  )
                                                                : null,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        SizedBox(
                                                          width: 100,
                                                          child: Center(
                                                              child: c.currentCompressingVide ==
                                                                      videoPath
                                                                  ? null
                                                                  : Checkbox(
                                                                      checkColor:
                                                                          ColorPage
                                                                              .darkblue,
                                                                      fillColor:
                                                                          const MaterialStatePropertyAll(
                                                                              Colors.transparent),
                                                                      value: compressedState[
                                                                              videoPath] ??
                                                                          false,
                                                                      onChanged:
                                                                          (bool?
                                                                              value) {
                                                                        if (value !=
                                                                            null) {
                                                                          setState(
                                                                              () {
                                                                            compressedState[videoPath] =
                                                                                value;
                                                                          });
                                                                        }
                                                                      },
                                                                    )),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        SizedBox(
                                                          width: 40,
                                                          child: Center(
                                                            child: c.currentCompressingVide !=
                                                                    c.tobecompressedvideospath[
                                                                            index]
                                                                            [
                                                                            "path"]
                                                                        .replaceAll(
                                                                            r'\',
                                                                            r'/')
                                                                ? IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      print(c
                                                                          .tobecompressedvideospath);
                                                                      c.tobecompressedvideospath.remove(c
                                                                          .tobecompressedvideospath[
                                                                              index]
                                                                              [
                                                                              'path']
                                                                          .replaceAll(
                                                                              r'\',
                                                                              r'/'));
                                                                      print(
                                                                          "Removed ${c.tobecompressedvideospath[index]['path']}");
                                                                    },
                                                                    color: Colors
                                                                        .red,
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .delete_outlined),
                                                                  )
                                                                : null,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: c.checkoriginalvideos.value
                                            ? const CircularProgressIndicator(
                                                semanticsLabel: 'Please Wait',
                                              )
                                            : const Text(
                                                'No video available',
                                                textScaler:
                                                    TextScaler.linear(2),
                                              ))),
                          ],
                        )
                      : Row(
                          children: [
                            const SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        spreadRadius: 4,
                                        offset: Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  height: 140,
                                  child: NavigationRail(
                                    backgroundColor: Colors.transparent,
                                    selectedIndex: _selectedIndex,
                                    groupAlignment: groupAlignment,
                                    onDestinationSelected: (int index) {
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    },
                                    labelType: labelType,
                                    destinations: const <NavigationRailDestination>[
                                      NavigationRailDestination(
                                        icon: Icon(Icons.check),
                                        selectedIcon: Icon(Icons.check_circle),
                                        label: Text('Completed'),
                                      ),
                                      NavigationRailDestination(
                                        icon: Icon(Icons.warning_amber_rounded),
                                        selectedIcon:
                                            Icon(Icons.warning_rounded),
                                        label: Text('Failed'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 50),
                            Expanded(
                              child: Container(
                                height: height * 0.9,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: ListView.builder(
                                    itemCount: filteredDates.length,
                                    itemBuilder: (context, index) {
                                      final date = filteredDates[index];
                                      final count =
                                          groupedVideos[date]!.where((video) {
                                        if (_selectedIndex == 0) {
                                          return video['Status'] == 'true';
                                        } else if (_selectedIndex == 1) {
                                          return video['Status'] == 'false';
                                        } else {
                                          return false;
                                        }
                                      }).length;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Material(
                                          color: Colors.transparent,
                                          elevation: 10,
                                          shadowColor: Colors.black26,
                                          child: ListTile(
                                            shape: ContinuousRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            minVerticalPadding: 10,
                                            tileColor: Colors.white,
                                            onTap: () {
                                              _showMyDialog(
                                                  context,
                                                  date,
                                                  groupedVideos[date]!,
                                                  _selectedIndex);
                                            },
                                            subtitle: Text("$count videos"),
                                            trailing: const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 16,
                                            ),
                                            title: Text(
                                              date,
                                              style: FontFamily.font3.copyWith(
                                                  color: ColorPage.bluegrey800,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMyDialog(BuildContext context, String date,
      List<Map<String, dynamic>> videos, int selectedIndex) {
    List<Map<String, dynamic>> filteredVideos = videos.where((video) {
      if (selectedIndex == 0) {
        return video['Status'] == 'true';
      } else if (selectedIndex == 1) {
        return video['Status'] == 'false';
      } else {
        return false;
      }
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Videos on $date"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: filteredVideos.asMap().entries.map((entry) {
                int index = entry.key;
                var video = entry.value;
                return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(7),
                    margin: const EdgeInsets.all(5),
                    child: Row(children: [
                      const SizedBox(width: 10),
                      Text(
                        "${(index + 1).toString()}.",
                        style: FontFamily.font3
                            .copyWith(color: ColorPage.darkblue),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          video['Name'],
                          style: FontFamily.font3
                              .copyWith(color: ColorPage.darkblue),
                        ),
                      ),
                    ]));
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Close",
                style: FontFamily.font3.copyWith(color: ColorPage.darkblue),
              ),
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
