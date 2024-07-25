import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:video_encryption/controllers/files/files.dart';
import 'package:video_encryption/pages/loginsignup.dart';
import 'package:video_encryption/pages/settingspage.dart';

class RoutesClass {
static String login ='/';
static String settingspage ='/settingspage';



static String getlogin()=> login;
static String getsettings()=> settingspage;
static List<GetPage> routes = [
  GetPage(name: login, page: ()=>  const DthLmsLogin(),
    transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 800)),
  GetPage(name: settingspage, page: ()=> SettingsPage(storage: SettingsStorage(),),transition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 800)),
];
}