import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_encryption/components/colorpage.dart';
import 'package:video_encryption/components/completed_list.dart';
import 'package:video_encryption/components/failed_list.dart';
import 'package:video_encryption/components/fontfamily.dart';
import 'package:video_encryption/components/others_list.dart';
import 'package:video_encryption/constants/myfonts.dart';
import 'package:video_encryption/controllers/ffmpeg/video_compressor.dart';
import 'package:video_encryption/controllers/filepath_controller.dart';
import 'package:video_encryption/pages/titlebar/title_bar.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {


  // animated text Content
  List<String> animatedText = [
    'Protect your videos ensure complete security.',
    'Keep your videos safe maintain privacy and security.',
    'Secure your content safeguard your data.'
  ];

  // Pages content
  List<Widget> pages = [
    const Completed(),
    const Failed(),
    const Others(),
  ];

  // which Row is Selected
  Set<int> selectedRows = {}; // Set to keep track of selected row indices

  // Navigation button true = progress and false = history
  RxBool isinProgress = true.obs;

  // history page navigation rail selected index
  int _selectedIndex = 0;

   // history page navigation rail type
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  // navigation rail style
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;

  // Controllers
  FilePath c = Get.put(FilePath());
  RunCommand p = Get.put(RunCommand());

  // style
  TextStyle headingstyle = FontFamily.font6.copyWith(fontSize: 16,fontWeight: FontWeight.w600,color: ColorPage.darkblue.withOpacity(0.7));
      TextStyle buttonTextStyle =         TextStyle(
                            fontFamily: MyFonts.heading,
                            fontSize: MyFonts.headingsize,
                            color: ColorPage.darkblue,
                          );
                    TextStyle headingNumber =           TextStyle(
                                  fontFamily: MyFonts.heading,
                                  fontSize: MyFonts.headingsize,
                                  color: ColorPage.darkblue.withOpacity(0.3),
                                );

                                TextStyle rowTextStyle =     FontFamily.font3.copyWith(color: const Color.fromARGB(255, 130, 130, 130));

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

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
                    Row(
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
                        Text(
                          'Progress',
                          style: buttonTextStyle
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Obx(() => isinProgress.value
                            ? Text(
                                '13',
                                style: headingNumber,
                              )
                            : const SizedBox())
                      ],
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
                                MaterialButton(
                                  color: Colors.blue[700],
                                  onPressed: () {},
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
                                MaterialButton(
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        color: Colors.black54, width: 2),
                                  ),
                                  onPressed: () {},
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
                                          'Cancel All',
                                          style: FontFamily.font3.copyWith(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  )),
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
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      spreadRadius: 4,
                                      offset: Offset(8, 8),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'Thumbnail',
                                        style: headingstyle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
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
                                      width: 100,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'Video Size',
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
                                child: ListView.builder(
                                  itemCount: c.tobecompressedvideospath.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {},
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          index == 0
                                              ? Obx(
                                                  () => LinearProgressIndicator(
                                                    backgroundColor: Colors.white,
                                                    borderRadius: BorderRadius.circular(8),
                                                    minHeight: 50,
                                                    color: Colors.blue[300],
                                                    value: p.progress.value,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          Container(
                                            margin: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: index == 0
                                                  ? Colors.transparent
                                                  : Colors.green[100],
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Obx(
                                              () => Row(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 100,
                                                    child: SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(30),
                                                        child: Image.asset(
                                                          'assets/profile-picture.jpeg',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                   SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      textAlign: TextAlign.center,
                                                      'mp4',
                                                      style: rowTextStyle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                   Expanded(
                                                    child: Tooltip(
                                                      message: "Samplevideo1.mp4",
                                                      child: Text(
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.center,
                                                        'Samplevideo1.mp4',
                                                      style: FontFamily.font4.copyWith(color:  Colors.black54,fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Tooltip(
                                                      message: c.tobecompressedvideospath[index],
                                                      child: Text(
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.center,
                                                        c.tobecompressedvideospath[index].toString(),
                                                      style: FontFamily.font4.copyWith(color:  Colors.black,fontSize: 14),

                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                   SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      textAlign: TextAlign.center,
                                                      '45 MB',
                                                      style: rowTextStyle,

                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                   SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      textAlign: TextAlign.center,
                                                      '12:20',
                                                      style: rowTextStyle,

                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const SizedBox(
                                                    width: 60,
                                                    child: Center(
                                                      child: Image(
                                                        image: AssetImage('assets/close.png'),
                                                        width: 10,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const SizedBox(
                                                    width: 100,
                                                    child: Center(
                                                      child: Icon(Icons.check_rounded, size: 20),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  SizedBox(
                                                    width: 40,
                                                    child: Center(
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        color: Colors.red,
                                                        icon: const Icon(Icons.delete_outlined),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
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
                                    height: 200,
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
                                          icon: Icon(Icons.favorite_border),
                                          selectedIcon: Icon(Icons.favorite),
                                          label: Text('Completed'),
                                        ),
                                        NavigationRailDestination(
                                          icon: Icon(Icons.bookmark_border),
                                          selectedIcon: Icon(Icons.book),
                                          label: Text('Failed'),
                                        ),
                                        NavigationRailDestination(
                                          icon: Icon(Icons.star_border),
                                          selectedIcon: Icon(Icons.star),
                                          label: Text('Others'),
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
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: pages[_selectedIndex],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
