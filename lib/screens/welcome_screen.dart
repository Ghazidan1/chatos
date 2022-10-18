import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatos/components/rounded_button.dart';
import 'package:chatos/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    controller?.forward();
    //TODO : Tween Animation
    //Tween can be happened between any two values not just Color
    animation = ColorTween(begin: Colors.cyan, end: Colors.blueAccent)
        .animate(controller!);

    // TODO: CurvedAnimation
    // animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);
    // // controller?.reverse(from: 1.0);
    // animation?.addStatusListener((status) {
    //   if (status == AnimationStatus.completed)
    //     controller?.reverse(from: 1.0);
    //   else if (status == AnimationStatus.dismissed) controller?.forward();
    // });
    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Chatos',
                        textStyle: TextStyle(
                          color: animation?.value,
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                        ),
                        speed: Duration(milliseconds: 100),
                        cursor: '.')
                  ],
                ),
                SizedBox(
                  width: 48.0,
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              text: 'Log In',
              color: Colors.lightBlueAccent,
              onTap: () => Navigator.pushNamed(context, LoginScreen.id),
            ),
            RoundedButton(
              text: 'Register',
              color: Colors.blueAccent,
              onTap: () => Navigator.pushNamed(context, RegistrationScreen.id),
            )
          ],
        ),
      ),
    );
  }
}
