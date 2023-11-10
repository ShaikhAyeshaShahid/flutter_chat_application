import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/api/apis.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/screens/auth/login_screen.dart';
import 'package:flutter_demo/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white, statusBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {
        log('\nUser : ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to Chat'),
      ),
      body: Stack(
        children: [
          ///Animation
          Positioned(
              top: mq.height * 0.15,
              right: mq.width * 0.25,
              width: mq.width * 0.5,
              child: Image.asset(
                'images/conversation.png',
                scale: 2,
              )),

          ///Sign in with google
          Positioned(
              bottom: mq.height * 0.15,
              width: mq.width,
              child: const Text(
                'Connecting people',
                style: TextStyle(
                    fontSize: 16, color: Colors.black87, letterSpacing: 0.5),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }
}
