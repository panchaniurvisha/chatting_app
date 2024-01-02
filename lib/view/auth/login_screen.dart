import 'dart:io';

import 'package:chatting_app/helper/dialogs.dart';
import 'package:chatting_app/res/constant/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/apis.dart';
import '../../res/common/media_query.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
    reverseDuration: Duration(seconds: 2),
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint("signInWithGoogle$e");
      Dialogs.showSnackbar(context, "Something Went Wrong(check Internet!");
    }
    return null;
    // Trigger the authentication flow
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to We Chat"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: FadeTransition(
              opacity: _animation,
              // child: Image.asset(AppImages.conversationIcon, width: 160.w),
              child: Image.asset(AppImages.liveChatIcon, width: 160.w),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40.w),
                backgroundColor: Colors.grey.shade200,
                shape: const StadiumBorder(),
                // maximumSize: Size(600.w, 100.h),
                elevation: 1),
            onPressed: () {
              Dialogs.showProgressBar(context);
              signInWithGoogle().then((user) async {
                Navigator.pop(context);
                if (user != null) {
                  debugPrint("\n User:${user.user}");
                  debugPrint("\n User Additional Information:$user");
                  if ((await APIs.userExists())) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  } else {
                    APIs.createUser().then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    });
                  }
                }
              });
            },
            icon: Image.asset(AppImages.googleIcon,
                height: height(context) * .03),
            label: RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 18.sp),
                  children: [
                    const TextSpan(text: "Sign in with "),
                    TextSpan(
                        text: "Google",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20.sp))
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
