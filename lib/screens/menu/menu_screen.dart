import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:third_eye/api/Api.dart';
import 'package:third_eye/constants/app_colors.dart';
import 'package:third_eye/constants/routes.dart';
import 'package:third_eye/constants/shimmer.dart';
import 'package:third_eye/models/get_banners.dart';
import 'package:third_eye/screens/eye_donation/eye_donation_instruction.dart';
import 'package:third_eye/screens/getx_object_detection/camera/camera_screen.dart';
import 'package:third_eye/screens/bairaha_recipes/recipes.dart';
import 'package:third_eye/screens/text_reading/text_scaner.dart';
import 'package:third_eye/screens/vision/vision.dart';
import 'package:third_eye/widgets/menu_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({
    Key key,
  }) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final platform = const MethodChannel('com.example.flutter_app/swift_screen');
  bool isBlinded = false;
  bool userChecked = false;
  bool swiftScreenEnabled = false;
  Future<void> _openSwiftScreen() async {
    try {
      await platform.invokeMethod('openSwiftScreen');
    } on PlatformException catch (e) {
      print('Failed to open Swift screen: ${e.message}');
      // Optionally, add a fallback or handle the error gracefully.
    }
  }

  @override
  void initState() {
    checkUser();
    // ignore: missing_return
    platform.setMethodCallHandler((call) {
      if (call.method == 'closed') {
        setState(() {
          swiftScreenEnabled = false;
        });
      } else if (call.method == 'opened') {
        setState(() {
          swiftScreenEnabled = true;
        });
      }
    });
    SemanticsService.announce("Third Eye Menu Screen", TextDirection.ltr);
    super.initState();
  }

  getBanners() async {
    GetBanners response = await Api().getBanners();
    if (response.done) {}
  }

  void checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isBlinded = prefs.getBool("blinded");
      userChecked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: AppColors.PRIMARY_RED,
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: size * 0.13,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Container(
                  // height: size.height * 0,
                  decoration: const BoxDecoration(
                      color: AppColors.PRIMARY_RED,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Column(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: SizedBox(
                          // width: size.width * 0.4,
                          height: size.height * 0.1,
                          child: Image.asset(
                            // "assets/logos/bairaha logo_1.png",
                            "assets/logos/logo samples5_eye_2.png",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: GestureDetector(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, top: 15, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // menuButton(
                          //     buttonText: "Money Identify",
                          //     size: size,
                          //     blinded: isBlinded,
                          //     route: () {
                          //       !swiftScreenEnabled
                          //           ? _openSwiftScreen()
                          //           : () {};
                          //       /*  setState(
                          //         () {
                          //           swiftScreenEnabled = true;
                          //         },
                          //       ); */
                          //       /*  DefaultRouter.defaultRouter(
                          //           const MoneyIdentify(), context);*/
                          //     }),
                          menuButton(
                              buttonText: "Object Identify",
                              size: size,
                              blinded: isBlinded,
                              route: () {
                                print(isBlinded.toString());
                                !swiftScreenEnabled
                                    ? DefaultRouter.defaultRouter(
                                        CameraScreen(isBlinded: true), context)
                                    : () {};
                              }),
                          menuButton(
                              buttonText: "Text Identify",
                              size: size,
                              blinded: isBlinded,
                              route: () {
                                !swiftScreenEnabled
                                    ? DefaultRouter.defaultRouter(
                                        const TextCameraScreen(), context)
                                    : () {};
                              }),
                          if (!isBlinded)
                            menuButton(
                                buttonText: "Eye Donation",
                                size: size,
                                blinded: isBlinded,
                                route: () {
                                  !swiftScreenEnabled
                                      ? DefaultRouter.defaultRouter(
                                          Eyedonationinstruction() /* EyeDonation() */,
                                          context)
                                      : () {};
                                }),
                          menuButton(
                              buttonText: "Bairaha Recipes",
                              size: size,
                              blinded: isBlinded,
                              route: () {
                                !swiftScreenEnabled
                                    ? DefaultRouter.defaultRouter(
                                        const RecipesScreen(), context)
                                    : () {};
                              }),
                          menuButton(
                              buttonText: "Vision",
                              size: size,
                              blinded: isBlinded,
                              route: () {
                                !swiftScreenEnabled
                                    ? DefaultRouter.defaultRouter(
                                        Vision(isBlind: isBlinded), context)
                                    : () {};
                              }),
                        ],
                      ),
                    ),
                  ),
                  userChecked
                      ? isBlinded
                          ? Container()
                          : FutureBuilder(
                              future: Api().getBanners(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data.body != null) {
                                  print(
                                    snapshot.data.body.media.length,
                                  );
                                  return CarouselSlider.builder(
                                    itemCount: snapshot.data.body.media.length,
                                    itemBuilder: (context, index, realIndex) =>
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Image.network(
                                              snapshot.data.body.media[index]
                                                  .mediaUrl
                                                  .toString(),
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  ShimmerWidget(
                                                height: size.width / 4,
                                                width: size.width,
                                                isCircle: false,
                                              ),
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return ShimmerWidget(
                                                    height: size.width / 4,
                                                    width: size.width,
                                                    isCircle: false,
                                                  );
                                                }
                                              },
                                              fit: BoxFit.fitWidth,
                                            )),
                                    options: CarouselOptions(
                                      enableInfiniteScroll: true,
                                      autoPlay: true,
                                      aspectRatio: 4 / 1,
                                      enlargeCenterPage: true,
                                      viewportFraction: 1,
                                    ),
                                  );
                                } else {
                                  return ShimmerWidget(
                                    height: size.width / 4,
                                    width: size.width,
                                    isCircle: false,
                                  );
                                }
                              })
                      : Container(),
                  Visibility(
                    visible: !isBlinded,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(color: Colors.blue.shade600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              !swiftScreenEnabled
                                  ? launchUrl(Uri.parse(
                                      "https://thirdeye.avanux.com/privacy-policy.html"))
                                  : () {};
                            },
                        ),
                        const TextSpan(
                            text: " And ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                          text: "Terms & Conditions",
                          style: TextStyle(color: Colors.blue.shade600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              !swiftScreenEnabled
                                  ? launchUrl(Uri.parse(
                                      "https://thirdeye.avanux.com/terms-and-conditions.html"))
                                  : () {};
                            },
                        ),
                      ])),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
