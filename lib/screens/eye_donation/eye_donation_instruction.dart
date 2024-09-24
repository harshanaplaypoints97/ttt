import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:third_eye/constants/app_colors.dart';
import 'package:third_eye/widgets/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Eyedonationinstruction extends StatefulWidget {
  bool isBlind;

  Eyedonationinstruction({Key key, this.isBlind}) : super(key: key);

  @override
  State<Eyedonationinstruction> createState() => _EyedonationinstructionState();
}

class _EyedonationinstructionState extends State<Eyedonationinstruction> {
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: customAppBar(
            onPressed: () {
              Navigator.pop(context);
            },
            focus: true,
            size: size,
            title: "Eye Donation",
            backBtnSpeakText: "Back Button, double tap to activate"),
        body: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/logos/logo_1.png"),
                ),
                color: AppColors.PRIMARY_RED.withOpacity(0.05)),
            child: ListView(
              children: [
                const SizedBox(height: 24),
                const Text(
                    "You can get the necessary instructions to register as an eye donor by contacting the following authorities",
                    textAlign: TextAlign.center),
                const SizedBox(height: 18),
                const Text("Sri Lanka Eye Donation Society ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const Text("Dr. Hudson Silva Eye Donation Head Quarters",
                    textAlign: TextAlign.center),
                const Text("120/12, Vidya Mawatha, Colombo 07, Sri Lanka",
                    textAlign: TextAlign.center),
                const Text("Phone: 0094 11 2698040, 2698041, 2698043",
                    textAlign: TextAlign.center),
                const Text("Fax: 0094 11 2698042", textAlign: TextAlign.center),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      const TextSpan(
                          text: " Email: ",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "sleds@dialogsl.net",
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                "mailto:sleds@dialogsl.net?subject=&body="));
                          },
                      ),
                    ])),
                const SizedBox(height: 12),
                const Text("Sri Jayewardenepura General Hospital",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const Text("Health Education Unit,",
                    textAlign: TextAlign.center),
                const Text("Thalapathpitiya,Nugegoda.",
                    textAlign: TextAlign.center),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      const TextSpan(
                          text: " Email: ",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "otu@sjghsrilanka.lk",
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                "mailto:otu@sjghsrilanka.lk?subject=&body="));
                            /* launchUrl(Uri.parse(
                                "https://thirdeye.avanux.com/terms-and-conditions.html")); */
                          },
                      ),
                    ])),
                const Text("WhatsApp: +94 770 344 344",
                    textAlign: TextAlign.center),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      const TextSpan(
                          text: " For more details ",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "click here",
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                "https://sjgh.health.gov.lk/donor-registration.php"));
                          },
                      ),
                    ])),
                const SizedBox(height: 12),
                const Divider(thickness: 2),
                const SizedBox(height: 12),
                const Text(
                    "අක්ෂි දායකයකු ලෙස ලියාපදිංචි වීමට පහත ආයත හා සම්බන්ද වීමෙන් ඔබට අවශ්‍ය මගපෙන්වීම් ලබාගත හැකිය,",
                    textAlign: TextAlign.center),
                const SizedBox(height: 18),
                const Text("ශ්‍රී ලංකා අක්ෂිදාන සංගමය",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const Text("ආචාර්ය හඩ්සන් සිල්වා අක්ෂිදාන මූලස්ථානය",
                    textAlign: TextAlign.center),
                const Text("120/12, විද්‍යා මාවත, කොළඹ 07, ශ්‍රී ලංකාව",
                    textAlign: TextAlign.center),
                const Text("දුරකථන: 0094 11 2698040, 2698041, 2698043",
                    textAlign: TextAlign.center),
                const Text("ෆැක්ස්: 0094 11 2698042",
                    textAlign: TextAlign.center),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      const TextSpan(
                          text: "විද්‍යුත් තැපෑල: ",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "sleds@dialogsl.net",
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                "mailto:sleds@dialogsl.net?subject=&body="));
                            /* launchUrl(Uri.parse(
                                "https://thirdeye.avanux.com/terms-and-conditions.html")); */
                          },
                      ),
                    ])),
                const SizedBox(height: 12),
                const Text("ශ්‍රී ජයවර්ධනපුර මහ රෝහල",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const Text("සෞඛ්‍ය අධ්‍යාපන ඒකකය,",
                    textAlign: TextAlign.center),
                const Text("තලපත්පිටිය, නුගේගොඩ.", textAlign: TextAlign.center),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      const TextSpan(
                          text: " විද්‍යුත් තැපෑල: ",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          decoration: TextDecoration.underline,
                        ),
                        text: "otu@sjghsrilanka.lk",
                        //style: TextStyle(color: Colors.blue.shade600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                "mailto:otu@sjghsrilanka.lk?subject=&body="));
                          },
                      ),
                    ])),
                const Text("WhatsApp: +94 770 344 344",
                    textAlign: TextAlign.center),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      const TextSpan(
                          text: " වැඩි විස්තර සඳහා ",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "මෙතනි​න්",
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                "https://sjgh.health.gov.lk/donor-registration.php"));
                          },
                      ),
                    ])),
                const SizedBox(height: 24),
              ],
            )));
  }
}
