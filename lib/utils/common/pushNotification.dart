import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



Future<void>backgroundHandler(RemoteMessage message)async{
  print("backgroundHandler:");
  print(message.data.toString());
  print(message.notification?.title ?? "");
}

class PushNotification {
  static String fcmToken = "";
  static Future<void> initialized() async{
    await Firebase.initializeApp();

    if(Platform.isAndroid){
      //FirebaseMessaging.instance.requestPermission();
      NotificationHelper.initialized();
    }else if(Platform.isIOS){
      FirebaseMessaging.instance.requestPermission();
    }
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    getDeviceTokenToSendNotification();

    //si la app esta finalizada y se pulsa en la notificación, realiza este codigo
    FirebaseMessaging.instance.getInitialMessage().then((message) {


      if(message != null){
        print("new Notification");
        print("$message.data");
        print(message.notification?.title ?? "");

      }

    });

    FirebaseMessaging.onMessage.listen((message) {

      if(message.notification != null){
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);

        NotificationHelper.displayNotification(message);

        //notificacion local
      }
    });

    //app en background pero no finalizada

    FirebaseMessaging.onMessageOpenedApp.listen((message) {

      if(message.notification != null){
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);
      }
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

 static Future<String>getDeviceTokenToSendNotification()async{

   try {
     fcmToken = (await FirebaseMessaging.instance.getToken())?.toString() ?? "";
     print("FCM Token: $fcmToken");
     return fcmToken;
   } catch (e) {
     print("Error obteniendo el token: $e");
     return "";
   }
  }
}

class NotificationHelper{

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialized() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(android: initializationSettingsAndroid),
        onDidReceiveNotificationResponse: (details) {

        }, /*onDidReceiveBackgroundNotificationResponse: localBackgroundHandler*/);
  }

  static void displayNotification(RemoteMessage message)async{
    try{
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(android: AndroidNotificationDetails("subcript",
          "subcript_channel",importance: Importance.max,priority: Priority.high));
      await flutterLocalNotificationsPlugin.show(id, message.notification!.title, message.notification!.body,
          notificationDetails, payload: message.data['_id'] ?? "");
    }on Exception catch(e){
      print(e);
    }
  }
}

Future<void> localBackgroundHandler(NotificationResponse data) async{

  print(data.toString());
  print("localBackgroundHandler :");
  print(data.notificationResponseType ==
      NotificationResponseType.selectedNotification
      ? "selectedNotification"
      : "selectedNotificationAction");
  print(data.payload);

}