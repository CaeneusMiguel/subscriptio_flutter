import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';



Future<void>handleBackgroundMessage(RemoteMessage message)async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi{
  final _firebaseMessagins = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage?message){
    if(message==null)return;

  }

  Future initPushNotifications()async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications()async {

    await _firebaseMessagins.requestPermission().then((value) async {
      String? fCMToken =await _firebaseMessagins.getToken();
      log("token: $fCMToken");
      initPushNotifications();
      GetStorage().write('tokenFireBase',fCMToken);
    });



  }
}