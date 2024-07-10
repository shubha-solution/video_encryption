  // import 'package:intl_phone_field/intl_phone_field.dart';


//  // sliding ar at the top


//  Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // Text('Signup'),
//                             // Text('Login'),
//                             Expanded(
//                               child: SizedBox(
//                                 child: AnimatedButtonBar(
//                                   controller: AnimatedButtonController()
//                                     ..setIndex(1),
//                                   radius: 32.0,
//                                   padding: const EdgeInsets.all(16.0),
//                                   backgroundColor: ColorPage.bluegrey800,
//                                   foregroundColor: ColorPage.bluegrey300,
//                                   elevation: 24,
//                                   curve: Curves.linear,
//                                   borderColor: ColorPage.white,
//                                   borderWidth: 2,
//                                   innerVerticalPadding: 16,
//                                   children: [
//                                     ButtonBarEntry(
//                                         onTap: () {
//                                           getxController.show.value = true;
//                                         },
//                                         child: Text(
//                                           'Sign Up',
//                                           style: FontFamily.font,
//                                         )),
//                                     ButtonBarEntry(
//                                         onTap: () {
//                                           getxController.show.value = false;
//                                         },
//                                         child: Text(
//                                           'Log in',
//                                           style: FontFamily.font,
//                                         )),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
                        









  // Form(
  //                                   key: desktopKey1,
  //                                   child: Column(
  //                                     children: [
                                        
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.start,
  //                                         children: [
  //                                           Text(
  //                                             'Institute name',
  //                                             style: FontFamily.font,
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         children: [
  //                                           Expanded(
  //                                             child: TextFormField(
  //                                               autovalidateMode:
  //                                                   AutovalidateMode
  //                                                       .onUserInteraction,
  //                                               textInputAction:
  //                                                   TextInputAction.next,
  //                                               validator: (value) {
  //                                                 if (value!.isEmpty) {
  //                                                   return 'Cannot blank';
  //                                                 } else {
  //                                                   return null;
  //                                                 }
  //                                               },
  //                                               keyboardType:
  //                                                   TextInputType.name,
  //                                               controller: signupuser,
  //                                               decoration: InputDecoration(
  //                                                   prefixIcon: const Icon(
  //                                                       Icons.school_rounded),
  //                                                   enabledBorder: border,
  //                                                   focusedBorder: border,
  //                                                   hintText: 'Institute name'),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.start,
  //                                         children: [
  //                                           Expanded(
  //                                             child: Text(
  //                                               'Contact person',
  //                                               style: FontFamily.font,
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         children: [
  //                                           Expanded(
  //                                             child: TextFormField(
  //                                               autovalidateMode:
  //                                                   AutovalidateMode
  //                                                       .onUserInteraction,
  //                                               textInputAction:
  //                                                   TextInputAction.next,
  //                                               validator: (value) {
  //                                                 if (value!.isEmpty) {
  //                                                   return 'Cannot blank';
  //                                                 } else {
  //                                                   return null;
  //                                                 }
  //                                               },
  //                                               keyboardType:
  //                                                   TextInputType.name,
  //                                               controller: signupname,
  //                                               decoration: InputDecoration(
  //                                                   prefixIcon: const Icon(
  //                                                       Icons.person),
  //                                                   enabledBorder: border,
  //                                                   focusedBorder: border,
  //                                                   hintText: 'Contact person'),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.start,
  //                                         children: [
  //                                           Text(
  //                                             'Contact Email',
  //                                             style: FontFamily.font,
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         children: [
  //                                           Expanded(
  //                                             child: TextFormField(
  //                                               autovalidateMode:
  //                                                   AutovalidateMode
  //                                                       .onUserInteraction,
  //                                               textInputAction:
  //                                                   TextInputAction.next,
  //                                               validator: (value) {
  //                                                 if (value!.isEmpty) {
  //                                                   return 'Cannot blank';
  //                                                 } else {
  //                                                   return null;
  //                                                 }
  //                                               },
  //                                               keyboardType:
  //                                                   TextInputType.emailAddress,
  //                                               controller: signupemail,
  //                                               decoration: InputDecoration(
  //                                                   prefixIcon:
  //                                                       const Icon(Icons.email),
  //                                                   enabledBorder: border,
  //                                                   focusedBorder: border,
  //                                                   hintText:
  //                                                       'hello@email.com'),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.start,
  //                                         children: [
  //                                           Text(
  //                                             'Phone Number',
  //                                             style: FontFamily.font,
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           Expanded(
  //                                             child: IntlPhoneField(
  //                                               textInputAction:
  //                                                   TextInputAction.next,
  //                                               autovalidateMode:
  //                                                   AutovalidateMode
  //                                                       .onUserInteraction,
  //                                               controller: signupphno,
  //                                               decoration: InputDecoration(
  //                                                 disabledBorder: border,
  //                                                 enabledBorder: border,
  //                                                 hintText: '9000000000',
  //                                                 alignLabelWithHint: true,
  //                                               ),
  //                                               initialCountryCode: 'IN',
  //                                               onChanged: (phone) {
  //                                                 // print(phone.completeNumber);
  //                                               },
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.start,
  //                                         children: [
  //                                           Text(
  //                                             'YouTube channel',
  //                                             style: FontFamily.font,
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         children: [
  //                                           Expanded(
  //                                             child: TextFormField(
  //                                               autovalidateMode:
  //                                                   AutovalidateMode
  //                                                       .onUserInteraction,
  //                                               textInputAction:
  //                                                   TextInputAction.next,
  //                                               validator: (value) {
  //                                                 if (value!.isEmpty) {
  //                                                   return 'Cannot blank';
  //                                                 } else {
  //                                                   return null;
  //                                                 }
  //                                               },
  //                                               keyboardType:
  //                                                   TextInputType.phone,
  //                                               controller: signupyt,
  //                                               decoration: InputDecoration(
  //                                                   prefixIcon: const Icon(
  //                                                       Icons.search_rounded),
  //                                                   enabledBorder: border,
  //                                                   focusedBorder: border,
  //                                                   hintText:
  //                                                       'YouTube channel'),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.start,
  //                                         children: [
  //                                           Text(
  //                                             'Website link',
  //                                             style: FontFamily.font,
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         children: [
  //                                           Expanded(
  //                                             child: TextFormField(
  //                                               autovalidateMode:
  //                                                   AutovalidateMode
  //                                                       .onUserInteraction,
  //                                               textInputAction:
  //                                                   TextInputAction.next,
  //                                               validator: (value) {
  //                                                 if (value!.isEmpty) {
  //                                                   return 'Cannot blank';
  //                                                 } else {
  //                                                   return null;
  //                                                 }
  //                                               },
  //                                               keyboardType:
  //                                                   TextInputType.phone,
  //                                               controller: signupwb,
  //                                               decoration: InputDecoration(
  //                                                   prefixIcon:
  //                                                       const Icon(Icons.web),
  //                                                   enabledBorder: border,
  //                                                   focusedBorder: border,
  //                                                   hintText: 'Website Link'),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.start,
  //                                         children: [
  //                                           Text(
  //                                             'Password',
  //                                             style: FontFamily.font,
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         children: [
  //                                           Expanded(
  //                                             child: TextFormField(
  //                                               obscureText: getx
  //                                                   .signuppasswordshow.value,
  //                                               autovalidateMode:
  //                                                   AutovalidateMode
  //                                                       .onUserInteraction,
  //                                               textInputAction:
  //                                                   TextInputAction.next,
  //                                               validator: (value) {
  //                                                 if (value!.isEmpty) {
  //                                                   return 'Cannot blank';
  //                                                 } else {
  //                                                   return null;
  //                                                 }
  //                                               },
  //                                               keyboardType: TextInputType
  //                                                   .visiblePassword,
  //                                               controller: signuppassword,
  //                                               decoration: InputDecoration(
  //                                                   prefixIcon: const Icon(
  //                                                       Icons.password),
  //                                                   enabledBorder: border,
  //                                                   focusedBorder: border,
  //                                                   suffixIcon: IconButton(
  //                                                       onPressed: () {
  //                                                         getx.signuppasswordshow
  //                                                                 .value =
  //                                                             !getx
  //                                                                 .signuppasswordshow
  //                                                                 .value;
  //                                                       },
  //                                                       icon: getx
  //                                                               .signuppasswordshow
  //                                                               .value
  //                                                           ? const Icon(Icons
  //                                                               .visibility_off)
  //                                                           : const Icon(Icons
  //                                                               .visibility)),
  //                                                   hintText: 'Password'),
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       const SizedBox(
  //                                         height: 20,
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.end,
  //                                         children: [
  //                                           TextButton(
  //                                             onPressed: () {
  //                                               // Get.to(() =>
  //                                               //     const ForgotScreen());
  //                                             },
  //                                             child: Text(
  //                                               'Forget password',
  //                                               style: FontFamily.mobilefont,
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       Padding(
  //                                         padding: const EdgeInsets.symmetric(
  //                                             vertical: 20),
  //                                         child: Row(
  //                                           mainAxisAlignment:
  //                                               MainAxisAlignment.center,
  //                                           children: [
  //                                             Expanded(
  //                                               child: MaterialButton(
  //                                                 shape:
  //                                                     ContinuousRectangleBorder(
  //                                                         borderRadius:
  //                                                             BorderRadius
  //                                                                 .circular(
  //                                                                     20)),
  //                                                 padding:
  //                                                     const EdgeInsets.only(
  //                                                         top: 8, bottom: 15),
  //                                                 color: ColorPage.colorgrey,
  //                                                 onPressed: () {
  //                                                   Get.toNamed(RoutesClass
  //                                                       .settingspage);
                              
  //                                                   // if (desktop_key1
  //                                                   //         .currentState!
  //                                                   //         .validate() &
  //                                                   //     GetUtils.isEmail(
  //                                                   //         signupemail
  //                                                   //             .text)) {
  //                                                   //   desktop_key1
  //                                                   //       .currentState!
  //                                                   //       .save();
  //                                                   //   // Get.to(
  //                                                   //   //     () =>
  //                                                   //   //         OTPScreen(
  //                                                   //   //           signupuser.text,
  //                                                   //   //           signupname.text,
  //                                                   //   //           signupemail.text,
  //                                                   //   //           signuppassword.text,
  //                                                   //   //           signupphno.text,
  //                                                   //   //         ),
  //                                                   //   //     transition:
  //                                                   //   //         Transition.leftToRight);
  //                                                   // } else {
  //                                                   //   Get.snackbar(
  //                                                   //       "Error",
  //                                                   //       "Please enter valid details",
  //                                                   //       colorText:
  //                                                   //           ColorPage.white);
  //                                                   // }
  //                                                 },
  //                                                 child: Text(
  //                                                   'Sign Up',
  //                                                   style: TextStyle(
  //                                                       fontSize: fontsize,
  //                                                       color: ColorPage.white),
  //                                                 ),
  //                                               ),
  //                                             )
  //                                           ],
  //                                         ),
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         children: [
  //                                           Text(
  //                                             'Already a member ?',
  //                                             style: FontFamily.font4,
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         children: [
  //                                           Expanded(
  //                                             child: MaterialButton(
  //                                               padding:
  //                                                   const EdgeInsets.symmetric(
  //                                                       vertical: 10),
  //                                               shape:
  //                                                   ContinuousRectangleBorder(
  //                                                       borderRadius:
  //                                                           BorderRadius
  //                                                               .circular(20)),
                              
  //                                               // color: ColorPage.colorgrey,
  //                                               onPressed: () {},
  //                                               child: Center(
  //                                                 child: Text(
  //                                                   'Login',
  //                                                   style: TextStyle(
  //                                                     fontSize: ClsFontsize
  //                                                         .ExtraSmall,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                       const SizedBox(
  //                                         height: 15,
  //                                       ),
  //                                       const SizedBox(
  //                                         height: 10,
  //                                       ),
  //                                       FutureBuilder(
  //                                         future: getUDID(),
  //                                         builder: (context, snapshot) {
  //                                           if (snapshot.hasData) {
  //                                             return Column(
  //                                               children: [
  //                                                 Text(
  //                                                   'Device Name',
  //                                                   style: FontFamily.font,
  //                                                 ),
  //                                                 Text(
  //                                                   snapshot.data.toString(),
  //                                                   style: FontFamily.font4,
  //                                                 ),
  //                                                 // const Text("3597279"),
  //                                               ],
  //                                             );
  //                                           } else {
  //                                             return const CircularProgressIndicator();
  //                                           }
  //                                         },
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 )
  //                               :