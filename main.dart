import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:milky_ease/UI/screens/dashboard.dart';
import 'firebase_options.dart';

import 'UI/const/themes.dart';
import 'UI/screens/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Milky Ease',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(primary: Themes.mainColor, seedColor: Themes.mainColor),
        primaryColor: Themes.mainColor,
        // backgroundColor: Themes.lightColor,
        brightness: Brightness.light,
      ),
      home:(FirebaseAuth.instance.currentUser!=null)?const Dashboard():const LoginScreen(),
    );
  }
}


