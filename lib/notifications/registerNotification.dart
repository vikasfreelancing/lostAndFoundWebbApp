import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert' as decoder;
import 'dart:typed_data';

class Notifications {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  int id = 0;
  final String email;
  Notifications({this.email});
  final firebaseMessaging = FirebaseMessaging();
  Future<String> registerNotification() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return "";
    }
    configLocalNotification();
    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message)
          : showNotification(message);
      return;
    }, onResume: (Map<String, dynamic> message) {
      //print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      //print('onLaunch: $message');
      return;
    });
    String docId;
    var res = await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
    firebaseMessaging.getToken().then((token) async {
      print('push token: $token');

      if (res.documents.length > 0) {
        docId = res.documents.first.documentID;
        Firestore.instance
            .collection('users')
            .document(docId)
            .updateData({'pushToken': token});
      } else {
        var ref = await Firestore.instance.collection('users').add(
            {'email': email, 'pushToken': token, 'updatedAt': Timestamp.now()});
        docId = ref.documentID;
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
    print("DocumentId : $docId");
    return docId;
  }

  void showNotification(message) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    print(message['notification']['body']);
    print(message['notification']['title']);
    print(decoder.json.encode(message));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        Platform.isAndroid
            ? 'co.viku826693.lost_and_found'
            : 'co.viku826693.lost_and_found',
        'lost and found',
        'your channel description',
        playSound: true,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound('alert'),
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
        icon: 'app_icon',
        vibrationPattern: vibrationPattern,
        enableLights: true);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id++,
      message['notification']['title'].toString(),
      message['notification']['body'].toString(),
      platformChannelSpecifics,
    );
  }
}
