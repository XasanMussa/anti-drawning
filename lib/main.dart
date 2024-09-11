import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:remote_ad/local_notification.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDiB70fnTc3IOqaTc5IfZVrXBRtLs02sHg",
          appId: "1:884761559509:android:359bdc053856caf7237d5c",
          messagingSenderId: "remote-ad-5c550",
          projectId: "remote-ad-5c550"));
  await localNotifications.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
