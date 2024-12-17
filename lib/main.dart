import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subcript/ui/features/common/pushNotification.dart';
import 'package:subcript/ui/features/common/widgets/dashboardScreen.dart';
import 'package:subcript/ui/features/document/screens/document_page.dart';
import 'package:subcript/ui/features/document/screens/document_upload_page.dart';
import 'package:subcript/ui/features/login/screens/login_page.dart';
import 'package:subcript/ui/features/login/screens/login_recover_password_page.dart';
import 'package:subcript/ui/features/login/screens/recover_pin_hub.dart';
import 'package:subcript/ui/features/login/screens/subcriptio_hub_page.dart';
import 'package:subcript/ui/features/register/screens/register_company_page.dart';
import 'package:subcript/ui/features/splash/screens/splash_page.dart';




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
  initializeDateFormatting('es');
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
      initialRoute: userSession != null ? '/dashboard' : '/splash',
      getPages: [
        GetPage(name: '/', page: ()=> const LoginScreen()),
        GetPage(name: '/splash', page: ()=> const SplashScreen()),
        GetPage(name: '/dashboard', page: ()=> DashBoardScreen(indexBar: null,)),
        GetPage(name: '/dashboardDocument', page: ()=> DashBoardScreen(indexBar: 3,)),
        GetPage(name: '/recoverPass', page: ()=> const RecoverPassword()),
        GetPage(name: '/recoverPin', page: ()=> const RecoverPinHub()),
        GetPage(name: '/registerCompany', page: ()=> const RegisterCompanyScreen()),
        GetPage(name: '/payRoll', page: ()=> const PayRoll()),
        GetPage(name: '/subcriptioHub', page: ()=> const SubcriptioHubPage()),
        GetPage(name: '/documentUploadPage', page: ()=> const DocumentUploadPage()),
      ],
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
     // builder: DevicePreview.appBuilder,
      //locale: DevicePreview.locale(context),
    );
  }
}


