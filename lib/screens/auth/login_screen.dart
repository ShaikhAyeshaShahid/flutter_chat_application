import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api/apis.dart';
import 'package:flutter_demo/helper/dialogs.dart';
import 'package:flutter_demo/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick() {
    _signInWithGoogle().then((user) async {
      if (user != null) {
        log('User: ${user.user}');
        log('User Additional info: ${user.additionalUserInfo}');

        if (await APIs.userExists()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              // signInOption: SignInOption.games,
              )
          .signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n _signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'Something went wrong (check internet!)');
      return null;
    }

    // if (googleAuth != null) {
    // Create a new credential
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
          AnimatedPositioned(
              top: mq.height * 0.15,
              right: _isAnimate ? mq.width * 0.25 : -mq.width * .5,
              width: mq.width * 0.5,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              child: Image.asset(
                'images/conversation.png',
                scale: 2,
              )),

          ///Sign in with google
          Positioned(
              bottom: mq.height * 0.15,
              left: mq.width * 0.05,
              width: mq.width * 0.9,
              height: mq.height * 0.07,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen.shade100,
                      shape: const StadiumBorder(),
                      elevation: 1),
                  onPressed: () {
                    _handleGoogleBtnClick();

                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (_) => const HomeScreen()));
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'images/google.png',
                      height: mq.height * 0.06,
                    ),
                  ),

                  ///Login with google label
                  label: RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 19),
                        children: [
                          TextSpan(
                            text: 'Login with',
                          ),
                          TextSpan(
                              text: ' Google',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ]),
                  ))),
        ],
      ),
    );
  }
}
