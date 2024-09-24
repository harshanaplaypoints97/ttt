import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:third_eye/widgets/app_bar.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key key}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  /*  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>(); */
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String pathPDF = "";
  @override
  void initState() {
    super.initState();
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(
          size: size,
          title: "Terms and Conditions & Privacy Policy ",
          onPressed: () {
            Navigator.pop(context);
          }),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: ListView(
          children: const [
            SizedBox(
              height: 16,
            ),
            Text(
              "Privacy policy",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "This privacy policy statement describes how a  "
              "Bairaha 3rd eye app"
              " will engage with your personal information when you use any of the services provided by us. The policy statement is created with the purpose of making an assurance of our user protection and transparency toward your information",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "   1. Information Privacy",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Information we collect",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Biraha 3rd eye app might utilize registration, online surveys and such web based forms for information purposes such as name, email address, and other contact information.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Furthermore, we will ask whether you are visually impaired or sighted. As well as there is a possibility to ask for further information in future. We gather and store Fasthe data required to provide and enhance our services.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Cookies and similar technologies",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "From time to time you can use the standard cookie feature or major browser applications , wearable devices or mobile devices to access our services. We do not set any personal identifiers for cookies.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "How we use and share information",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Personnel information:",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Personal information refers to identifiable information about a person. In other words, the information which provides an opportunity to identify a person directly or indirectly.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "   A. As mentioned in this policy,",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Text(
              "   B. As essential to provide a services for you,",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Text(
              "   C. As needed to comply with the law,",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "We ensure to not share your personal information with third parties.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "We ensure that you do not sell your personal information.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              leading: Text("-"),
              title: Text(
                "Your personnel information might be used to ensure your identity, check your qualifications, re - evaluate the performance of our service.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              leading: Text("-"),
              title: Text(
                "In addition to that, personal information can be used with the purpose of updating changes about bairaha 3rd eye apps, sending additional information, and sending newsletters.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Cookie or similar technology:",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "We might use cookies or similar technology when you use our services to provide the contents upon your preferences.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Disclosure of personal information:",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "We might disclose your personal information with good faith belief to comply with any legal requirement.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Date security :",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "we have a security system against misuse of the information which we obtained from you. But we do not ensure absolute security for your information from such a third party.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Update and Changes",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "We may update this Privacy Policy from time to time. The updated version will be posted on our app, and your continued use of the app constitutes your acceptance of the revised policy.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Access and delete your information:",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "If you are required to delete your information which you provided for us, please",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Text(
              "contact ..................",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              "Terms and Conditions",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Welcome to bairaha third eye app!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              "  - Overview",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Bairaha 3rd eye app introduced with the objective of making a better tomorrow for blind and visually impaired people through making their day to day life convenient. This application allows blind and visually impaired people different aspects including money reading, text reading, and as well as this app consist of food recipes which allows them to make simple food.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Legal Agreement",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "This is a legal agreement. Therefore, read this carefully, you agree with these conditions with using our services.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Third eye app reserve the right to change the terms and conditions at any time without your concern and you agreed that we may do so. We will send a notice regarding these changes for your email address. To ensure that you understand each and every condition, please read this statement carefully.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "App Usage",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "According to the agreement in complying with these terms and conditions, you have the opportunity to access the third eye app. If you violate this agreement's terms and conditions, the permission will end.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              //contentPadding: EdgeInsets.zero,
              leading: Text("A."),
              title: Text(
                "When registering, you are responsible to provide true and current information",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              //contentPadding: EdgeInsets.zero,
              leading: Text("B."),
              title: Text(
                "You promise not to use the app for any improper, forbidden, or illegal activity.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Intellectual property",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              //contentPadding: EdgeInsets.zero,
              leading: Text("A."),
              title: Text(
                "All contents and materials including accessibility features, texts, recipes provided within the app are an intellectual property of Bairaha 3rd eye app.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              //contentPadding: EdgeInsets.zero,
              leading: Text("B."),
              title: Text(
                "You may not reproduce, modify, or distribute any apps content without written permission.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Limitation Of Liability",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 8,
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              //contentPadding: EdgeInsets.zero,
              leading: Text("A."),
              title: Text(
                "If you use or are unable to utilize Biraha 3rd EyeApp, we are not responsible for any direct, indirect, incidental, or consequential losses.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              //contentPadding: EdgeInsets.zero,
              leading: Text("B."),
              title: Text(
                "The truthfulness, dependability, or accessibility of the app's features or content are not warranted by us.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Advertising",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "advertisements can be displayed in the app. The mode and type of those promotions and advertisements can be changed without prior notice.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "User Restrictions",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "You agreed to not do the following things.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              //contentPadding: EdgeInsets.zero,
              leading: Text("-"),
              title: Text(
                "Registering as a blind or visually impaired one while you aren't such a kind of person.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              //contentPadding: EdgeInsets.zero,
              leading: Text("-"),
              title: Text(
                "Using this service as a way to obtain emergency medical facilities or receive medical services.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              //contentPadding: EdgeInsets.zero,
              leading: Text("-"),
              title: Text(
                "Share health information through this service.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              horizontalTitleGap: 1,
              visualDensity: VisualDensity.compact,
              //contentPadding: EdgeInsets.zero,
              leading: Text("-"),
              title: Text(
                "Use the service for illegal purposes.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              visualDensity: VisualDensity.compact, horizontalTitleGap: 1,
              //contentPadding: EdgeInsets.zero,
              leading: Text("-"),
              title: Text(
                "Use the service for any commercial purpose without any written permission from a third eye app.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
