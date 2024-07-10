import 'package:video_encryption/components/clsfontsize.dart';
import 'package:video_encryption/components/colorpage.dart';
import 'package:video_encryption/components/fontfamily.dart';
import 'package:video_encryption/components/getxcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_encryption/components/myloginbutton.dart';
import 'package:video_encryption/constants/constants.dart';
import 'package:video_encryption/constants/myfonts.dart';
import 'package:video_encryption/pages/titlebar/title_bar.dart';

class DthLmsLogin extends StatefulWidget {
  // List info;
  const DthLmsLogin({super.key});

  @override
  State<DthLmsLogin> createState() => _DthLmsLoginState();
}

class _DthLmsLoginState extends State<DthLmsLogin> {

  // Controllers
  TextEditingController signupuser = TextEditingController();
  TextEditingController signupname = TextEditingController();
  TextEditingController signupemail = TextEditingController();
  TextEditingController signupphno = TextEditingController();
  TextEditingController signupyt = TextEditingController();
  TextEditingController signupwb = TextEditingController();
  TextEditingController signuppassword = TextEditingController();
  TextEditingController loginemail = TextEditingController();
  TextEditingController loginpassword = TextEditingController();
  TextEditingController loginotp = TextEditingController();

  Getx getxController = Get.put(Getx());
  Getx getx = Get.put(Getx());


  // Form keys
  final GlobalKey<FormState> desktopKey1 = GlobalKey();
  final GlobalKey<FormState> desktopKey2 = GlobalKey();

  late double fontsize = ClsFontsize.DoubleExtraLarge + 2;
  InputBorder border = const UnderlineInputBorder(
      borderSide: BorderSide(color: ColorPage.colorgrey));
  double boxwidth = 500;

  var key = '0';

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/background.jpg'), fit: BoxFit.fill),
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
                  child: Column(
                    children: [
                      const Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                                child: Image.asset(
                              'assets/1.png',
                              fit: BoxFit.cover,
                             
                            )),
                          ],
                        ),
                      ),
                    ],
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
                            width: boxwidth,
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            decoration: BoxDecoration(
                                color: ColorPage.white,
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            child: Obx(
                              () => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Form(
                                    key: desktopKey2,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Login',
                                              style: TextStyle(
                                                  fontFamily: MyFonts.heading,
                                                  fontSize: MyFonts.headingsize,
                                                  color: ColorPage.darkblue),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text('Login ID',
                                                style: FontFamily.font)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                  child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Cannot blank';
                                                  }
                                                  return null;
                                                },
                                                controller: loginemail,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                // controller: ,
                                                decoration: InputDecoration(
                                                    enabledBorder: border,
                                                    focusedBorder: border,
                                                    hintText: '000000'),
                                              )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Password',
                                              style: FontFamily.font,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                obscureText: getx
                                                    .loginpasswordshow.value,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Cannot blank';
                                                  }
                                                  return null;
                                                },
                                                controller: loginpassword,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          getx.loginpasswordshow
                                                                  .value =
                                                              !getx
                                                                  .loginpasswordshow
                                                                  .value;
                                                        },
                                                        icon: getx
                                                                .loginpasswordshow
                                                                .value
                                                            ? const Icon(Icons
                                                                .visibility_off)
                                                            : const Icon(Icons
                                                                .visibility)),
                                                    enabledBorder: border,
                                                    focusedBorder: border,
                                                    hintText: '****'),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: MyLoginButton(
                                                mychild: 'LOGIN',
                                              ))
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('New User?',
                                                style: FontFamily.font4),
                                            MaterialButton(
                                              shape: ContinuousRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              onPressed: () {},
                                              child: Center(
                                                child: Text('Create an account',
                                                    style: FontFamily.font4
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        FutureBuilder(
                                          future: getUDID(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Column(
                                                children: [
                                                  Text(
                                                    'Device ID',
                                                    style: FontFamily.font
                                                        .copyWith(fontSize: 15),
                                                  ),
                                                  Text(
                                                    snapshot.data.toString(),
                                                    style: FontFamily.font4,
                                                  ),
                                              
                                                ],

                                              );
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Flexible(
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(top: 25),
                        //     child: Row(
                        //       mainAxisAlignment:
                        //           MainAxisAlignment.center,
                        //       children: [
                        //         Card(
                        //           elevation: 30,
                        //           child: SizedBox(
                        //               width: formfieldsize,
                        //               child: ElevatedButton.icon(
                        //                 style: ButtonStyle(
                        //                     backgroundColor:
                        //                         MaterialStatePropertyAll(
                        //                             Colors
                        //                                 .amber[400]),
                        //                     padding:
                        //                         const MaterialStatePropertyAll(
                        //                       EdgeInsets.symmetric(
                        //                           vertical: 20),
                        //                     ),
                        //                     shape:
                        //                         MaterialStatePropertyAll(
                        //                       ContinuousRectangleBorder(
                        //                           borderRadius:
                        //                               BorderRadius
                        //                                   .circular(
                        //                                       20)),
                        //                     )),

                        //                 // color: ColorPage.colorgrey,
                        //                 onPressed: () {
                        //                   // final obj = GoogleSignup();
                        //                   // obj.signin();
                        //                 },
                        //                 icon: Image.asset(
                        //                     'assets/google.png'),
                        //                 label: Text(
                        //                     'Connect with Google',
                        //                     style: FontFamily.font),
                        //               )),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.all(30),
                //       // height: 200,
                //       // color: Colors.red,
                //       child: Column(
                //         children: [
                //           Image.network(
                //             'https://videoencryptor.com/assets/images/logo.png',
                //           ),
                //           Text(
                //             'Windows Encryptor 1.0.0',
                //             style: FontFamily.font4,
                //           )
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
