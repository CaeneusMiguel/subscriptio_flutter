import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/Screens/register/registerCompanyScreen.dart';
import 'package:subcript/utils/common/pushNotification.dart';
import 'package:subcript/utils/widgets/dashboardScreen.dart';
import 'package:subcript/Screens/login/loginScreen.dart';




String? userSession = GetStorage().read('token');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await PushNotification.initialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialise  localnotification
    //LocalNotificationService.initialize();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      initialRoute: userSession != null ? '/dashboard' : '/',
      getPages: [
        GetPage(name: '/', page: ()=> const LoginScreen()),
        GetPage(name: '/dashboard', page: ()=> DashBoardScreen()),
        GetPage(name: '/registerCompany', page: ()=> RegisterCompanyScreen()),
      ],
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
     // builder: DevicePreview.appBuilder,
      //locale: DevicePreview.locale(context),
    );
  }
}


