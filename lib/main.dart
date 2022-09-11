import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_firebase_instagram/responsive/mobile_screen_layout.dart';
import 'package:flutter_firebase_instagram/responsive/reponsive_layout.dart';
import 'package:flutter_firebase_instagram/responsive/web_screen_layout.dart';
import 'package:flutter_firebase_instagram/screens/login_screen.dart';
import 'package:flutter_firebase_instagram/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAbQTPbqRYTBYyVFVwdtN4tyjg8aJEDxKY",
        appId: "1:987248681757:web:fa28108e055657799ab7f4",
        projectId: "flutter-instagram-625e2",
        storageBucket: "flutter-instagram-625e2.appspot.com",
        messagingSenderId: "987248681757",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Instagram Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width
                // of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              }
            }
            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          }),
    );
  }
}
