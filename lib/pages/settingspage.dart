import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:get/get.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:video_encryption/components/colorpage.dart';
import 'package:video_encryption/components/fontfamily.dart';
import 'package:video_encryption/components/mytextfield.dart';
import 'package:video_encryption/components/settings_animatedtext.dart';
import 'package:video_encryption/constants/constants.dart';
import 'package:video_encryption/constants/myfonts.dart';
import 'package:video_encryption/controllers/filepath_controller.dart';
import 'package:video_encryption/ffmpeg/video_compressor.dart';
import 'package:video_encryption/files/files.dart';
import 'package:video_encryption/pages/titlebar/title_bar.dart';
import 'package:video_encryption/routes/routes.dart';
import 'package:video_encryption/utils/file_selector.dart';

class SettingsPage extends StatefulWidget {
  final SettingsStorage storage;
  const SettingsPage({super.key, required this.storage});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // read the saved json file
      widget.storage.readSettings().then((value) => setSettingsValue());

      setDeviceUniqueId();
    }

    fps.text = '30';
    bit.text = '1000';

    super.initState();
  }

  setSettingsValue() {
    if (_getfilePath.originalFolderPath.value != "" &&
        _getfilePath.compressedFolderPath.value != "" &&
        _getfilePath.fps.value != "" &&
        _getfilePath.bit.value != "") {
      setState(() {
        originalfile.text = _getfilePath.originalFolderPath.value;
        encryptedfile.text = _getfilePath.compressedFolderPath.value;
        fps.text = _getfilePath.fps.value;
        bit.text = _getfilePath.bit.value;
        uploadtocloude = _getfilePath.cloud.value;
        compress = _getfilePath.compress.value;
        autoshut = _getfilePath.shutdown.value;
      });
    }
  }

  Future<void> setDeviceUniqueId() async {
    String deviceUniqueId = await getDeviceUniqueId();
    setState(() {
      devicename.text = deviceUniqueId;
    });
  }

  Future<String> getDeviceUniqueId() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'device_unique_id';
    String? deviceUniqueId = prefs.getString(key);

    if (deviceUniqueId == null) {
      var uuid = const Uuid();
      deviceUniqueId = uuid.v4();
      await prefs.setString(key, deviceUniqueId);
    }

    return deviceUniqueId;
  }

  List<String> animatedText = [
    'Protect your videos ensure complete security.',
    'Keep your videos safe maintain privacy and security.',
    'Secure your content safeguard your data.'
  ];

  // Styles & Colors
  var fontstyle = FontFamily.font4;
  var rates = FontFamily.font4;
  var headingfontstyle =
      const TextStyle(fontFamily: 'Outfit-Medium', fontSize: 16);

  // Restore to default value
  restore() {
    setState(() {
      uploadtocloude = false;
      compress = false;
      autoshut = false;
      devicename.text = '';
      originalfile.text = '';
      encryptedfile.text = '';
      fps.text = '';
      bit.text = '';
    });
  }

  // Controllers
  TextEditingController devicename = TextEditingController();
  TextEditingController originalfile = TextEditingController();
  TextEditingController encryptedfile = TextEditingController();
  TextEditingController fps = TextEditingController();
  TextEditingController bit = TextEditingController();

  bool uploadtocloude = false;
  bool compress = false;
  bool autoshut = false;

  final GlobalKey<FormState> _formkey = GlobalKey();

  // Initialise getx controllers
  RunCommand c = Get.put(RunCommand());
  final FilePath _getfilePath = Get.put(FilePath());
  var _rangefps = 60.0;
  var _rangebit = 1000.0;

  bool _showfps = false;
  bool _showbit = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/settingsbg.png'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(child: TitleBar()),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: MyAnimatedText(
                        width: width,
                        text: animatedText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 80,
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 600),
                              decoration: BoxDecoration(
                                  color: ColorPage.white,
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              width: width * 0.5,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              child: Form(
                                key: _formkey,
                                child: Obx(
                                  () => Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'VIDEO SETTINGS',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          MyFonts.heading,
                                                      fontSize:
                                                          MyFonts.headingsize,
                                                      color:
                                                          ColorPage.darkblue),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      MyTextField(
                                        width: width,
                                        controller: devicename,
                                        errorText: 'Please enter device name',
                                        heading: 'Device name',
                                        hintText: "Enter device name",
                                        onTap: () {},
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      MyTextField(
                                        width: width,
                                        controller: originalfile,
                                        errorText:
                                            'Please select original video path',
                                        heading: 'Original video path',
                                        hintText: "Select File Location",
                                        onTap: () async {
                                          String? selectedDirectory =
                                              await FileSelector
                                                  .selectDirectory();
                                          if (selectedDirectory != null) {
                                            originalfile.text =
                                                selectedDirectory;
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      MyTextField(
                                        width: width,
                                        controller: encryptedfile,
                                        errorText:
                                            'Please select encrypted video path',
                                        heading: 'Encrypted video path',
                                        hintText: "Select File Location",
                                        onTap: () async {
                                          String? selectedDirectory =
                                              await FileSelector
                                                  .selectDirectory();
                                          if (selectedDirectory != null) {
                                            encryptedfile.text =
                                                selectedDirectory;
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text("Frame rate:",
                                              style: headingfontstyle),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              MouseRegion(
                                                // hitTestBehavior: HitTestBehavior.translucent ,
                                                onEnter: (event) {
                                                  setState(() {
                                                    _showfps = true;
                                                  });
                                                },
                                                onExit: (event) {
                                                  setState(() {
                                                    _showfps = false;
                                                  });
                                                },
                                                child: SizedBox(
                                                  height: 70,
                                                  child: Tooltip(
                                                    margin: const EdgeInsets.only(
                                                        top: 5),
                                                    message: "Frame Rate",
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 80,
                                                      child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                    controller: fps,
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    decoration: InputDecoration(
                                                      filled: _showfps,
                                                      fillColor: Colors.grey[100],
                                                      border: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: ColorPage.darkblue),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      focusedBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.transparent),
                                                      ),
                                                      enabledBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.transparent),
                                                      ),
                                                      errorStyle: const TextStyle(height: 0, color: Colors.transparent), // Adjust error text style
                                                      contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20), // Increase padding as needed
                                                    ),
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return '*';  // Consider using a more descriptive error message
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Expanded(child: SizedBox()),
                                              Slider(
                                                max: 60,
                                                min: 10,
                                                divisions: 5,
                                                label: _rangefps
                                                    .toStringAsFixed(0),
                                                value: _rangefps,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _rangefps = value;
                                                    fps.text = value
                                                        .toStringAsFixed(0);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text('Bit rate:',
                                              style: headingfontstyle),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MouseRegion(
                                            // hitTestBehavior: HitTestBehavior.translucent ,
                                            onEnter: (event) {
                                              setState(() {
                                                _showbit = true;
                                              });
                                            },
                                            onExit: (event) {
                                              setState(() {
                                                _showbit = false;
                                              });
                                            },
                                            child: SizedBox(
                                              height: 70,
                                              child: Tooltip(
                                                margin:
                                                    const EdgeInsets.only(top: 5),
                                                message: "Bit Rate",
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 80,
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                    controller: bit,
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    decoration: InputDecoration(
                                                      filled: _showbit,
                                                      fillColor: Colors.grey[100],
                                                      border: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: ColorPage.darkblue),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      focusedBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.transparent),
                                                      ),
                                                      enabledBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.transparent),
                                                      ),
                                                      errorStyle: const TextStyle(height: 0, color: Colors.transparent), // Adjust error text style
                                                      contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20), // Increase padding as needed
                                                    ),
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return '*';  // Consider using a more descriptive error message
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          Slider(
                                            value: _rangebit,
                                            min: 100,
                                            max: 1000,
                                            divisions: 9,
                                            label: _rangebit.round().toString(),
                                            onChanged: (double value) {
                                              setState(() {
                                                _rangebit = value;
                                                bit.text =
                                                    value.toStringAsFixed(0);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text('Upload on cloud',
                                              style: headingfontstyle),
                                          const Expanded(child: SizedBox()),
                                          Switch(
                                            value: uploadtocloude,
                                            onChanged: (newValue) {
                                              setState(() {
                                                uploadtocloude = newValue;
                                                _getfilePath.cloud.value =
                                                    newValue;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text('Allow to compress video',
                                              style: headingfontstyle),
                                          const Expanded(child: SizedBox()),
                                          Switch(
                                            value: compress,
                                            onChanged: (newValue) {
                                              setState(() {
                                                compress = newValue;
                                                _getfilePath.compress.value =
                                                    newValue;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text('Automatic shutdown',
                                              style: headingfontstyle),
                                          const Expanded(child: SizedBox()),
                                          Switch(
                                            value: _getfilePath.shutdown.value,
                                            onChanged: (newValue) async {
                                              _getfilePath.shutdown.value =
                                                  newValue;
                                              autoshut = newValue;

                                              if (autoshut) {
                                                await launchAtStartup.disable();
                                              } else {
                                                launchAtStartup.enable();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Expanded(
                                                    child: SizedBox()),
                                                FilledButton(
                                                    style: const ButtonStyle(
                                                        shape: MaterialStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20)))),
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                ColorPage
                                                                    .darkblue),
                                                        elevation:
                                                            MaterialStatePropertyAll(
                                                                10)),
                                                    onPressed: () async {
                                                      await FlutterPlatformAlert
                                                          .playAlertSound();

                                                      final result = await FlutterPlatformAlert.showAlert(
                                                          windowTitle:
                                                              'Confirm Restore to Default Settings',
                                                          text:
                                                              'Are you sure you want to restore all settings to their default values? This action cannot be undone.',
                                                          alertStyle:
                                                              AlertButtonStyle
                                                                  .yesNoCancel);
                                                      if (result ==
                                                          AlertButton
                                                              .yesButton) {
                                                        restore();
                                                      }
                                                    },
                                                    child:
                                                        const Text('Restore')),
                                                const Expanded(
                                                    child: SizedBox()),
                                                FilledButton(
                                                    style: const ButtonStyle(
                                                        shape: MaterialStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20)))),
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                ColorPage
                                                                    .darkblue),
                                                        elevation:
                                                            MaterialStatePropertyAll(
                                                                10)),
                                                    onPressed: () async {
                                                      await FlutterPlatformAlert
                                                          .playAlertSound();

                                                      final result = await FlutterPlatformAlert.showAlert(
                                                          windowTitle:
                                                              'Confirm Update',
                                                          text:
                                                              'Are you sure you want to Update? ',
                                                          alertStyle:
                                                              AlertButtonStyle
                                                                  .yesNoCancel);
                                                      if (result ==
                                                          AlertButton
                                                              .yesButton) {
                                                        if (_formkey
                                                            .currentState!
                                                            .validate()) {
                                                          _getfilePath.bit
                                                              .value = bit.text;
                                                          _getfilePath.fps
                                                              .value = fps.text;
                                                          _getfilePath
                                                                  .compressedFolderPath
                                                                  .value =
                                                              encryptedfile
                                                                  .text;
                                                          _getfilePath
                                                                  .originalFolderPath
                                                                  .value =
                                                              originalfile.text;
                                                          _getfilePath
                                                                  .cloud.value =
                                                              uploadtocloude;
                                                          _getfilePath.compress
                                                              .value = compress;

                                                          _getfilePath.shutdown
                                                              .value = autoshut;

                                                          MyNotification
                                                              .showNotification(
                                                                  'Started monitoring: ${originalfile.text}');
                                                          widget.storage
                                                              .writeSettings(
                                                                  originalfile
                                                                      .text,
                                                                  encryptedfile
                                                                      .text,
                                                                  fps.text,
                                                                  bit.text,
                                                                  uploadtocloude,
                                                                  compress,
                                                                  autoshut);
                                                        } else {
                                                          MyNotification
                                                              .showNotification(
                                                                  'Please fill all the required fields',
                                                                  isError:
                                                                      true);
                                                        }
                                                      }
                                                    },
                                                    child:
                                                        const Text('Update')),
                                                const Expanded(
                                                    child: SizedBox()),
                                                FilledButton(
                                                    style: const ButtonStyle(
                                                        shape: MaterialStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20)))),
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                ColorPage
                                                                    .darkblue),
                                                        elevation:
                                                            MaterialStatePropertyAll(
                                                                10)),
                                                    onPressed: () async {
                                                      await FlutterPlatformAlert
                                                          .playAlertSound();

                                                      final result = await FlutterPlatformAlert.showAlert(
                                                          windowTitle:
                                                              'Confirm Sign Out',
                                                          text:
                                                              'Are you sure you want to sign out? ',
                                                          alertStyle:
                                                              AlertButtonStyle
                                                                  .yesNoCancel);
                                                      if (result ==
                                                          AlertButton
                                                              .yesButton) {
                                                        Get.toNamed(RoutesClass
                                                            .getlogin());
                                                      }
                                                    },
                                                    child:
                                                        const Text('Signout')),
                                                const Expanded(
                                                    child: SizedBox()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
