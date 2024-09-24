import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:third_eye/animation/transition.dart';
import 'package:third_eye/config.dart';
import 'package:third_eye/constants/app_colors.dart';
import 'package:third_eye/screens/menu/menu_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isBlinded = false;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      route();
    });

    super.initState();
  }

  _saveOptions(bool blinded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('blinded', blinded);
    return;
  }

  void route() {
    if (isBlinded) {
      _saveOptions(true);
      Navigator.pushReplacement(
          context, FadeTransitionRouter(child: const MenuScreen()));
    } else {
      _saveOptions(false);
      Navigator.pushReplacement(
          context, FadeTransitionRouter(child: const MenuScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (MediaQuery.of(context).accessibleNavigation) {
      setState(() {
        isBlinded = true;
      });
    } else {
      setState(() {
        isBlinded = false;
      });
    }
    return Scaffold(
      backgroundColor: AppColors.PRIMARY_RED,
      body: Stack(
        children: [
          Center(
            child: Image.asset("assets/logos/logo_1.png"),
          ),
          Positioned(
            bottom: 0,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                height: 25,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: ExcludeSemantics(
                    child: Row(
                  children: const [
                    Text(
                      "Third-eye",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontFamily: "Inter"),
                    ),
                    Spacer(),
                    Text(
                      'Version $currentVersion',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontFamily: "Inter"),
                    )
                  ],
                ))),
          )
        ],
      ),
    );
  }
}
