import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:third_eye/api/Api.dart';
import 'package:third_eye/constants/app_colors.dart';
import 'package:third_eye/models/Submit.dart';
import 'package:third_eye/widgets/app_bar.dart';
import 'package:third_eye/widgets/text_input_feilds.dart';

class EyeDonation extends StatefulWidget {
  const EyeDonation({
    Key key,
  }) : super(key: key);

  @override
  State<EyeDonation> createState() => _EyeDonationState();
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();
TextEditingController phNumberController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController dateOfBirth = TextEditingController();
TextEditingController NICController = TextEditingController();
TextEditingController nomineeController = TextEditingController();
TextEditingController nomineeMobileController = TextEditingController();
TextEditingController addressController = TextEditingController();

class _EyeDonationState extends State<EyeDonation> {
  bool formValidated = false;
  bool isSubmitting = false;
  final districts = [
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Matale',
    'Nuwara Eliya',
    'Galle',
    'Matara',
    'Hambantota',
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Vavuniya',
    'Mullaitivu',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Kurunegala',
    'Puttalam',
    'Anuradhapura',
    'Polonnaruwa',
    'Badulla',
    'Moneragala',
    'Ratnapura',
    'Kegalle'
  ];
  String selectedDistrict;
  final _gender = [
    "Male",
    "Female",
  ];
  String SelectedGender;
  final _type = [
    "Eyes & Tissues",
    "Eyes",
    "Tissues",
  ];
  String SelectedType;
  void validateAndSave() {
    FormState form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        formValidated = true;
      });
    } else {
      setState(() {
        formValidated = false;
      });
    }
  }

  void clearForm() {
    nameController.clear();
    phNumberController.clear();
    emailController.clear();
    emailController.clear();
    dateOfBirth.clear();
    NICController.clear();
    nomineeController.clear();
    nomineeMobileController.clear();
    addressController.clear();
    selectedDistrict = null;
    SelectedGender = null;
    SelectedGender = null;
  }

  @override
  void dispose() {
    clearForm();
    super.dispose();
  }

  void formSubmit() async {
    bool connected = await checkConnection();
    if (connected) {
      if (isSubmitting) {
        () {};
      } else {
        validateAndSave();
        if (formValidated) {
          setState(() {
            isSubmitting = true;
          });
          submit();
        } else {
          Vibrate.feedback(FeedbackType.error);
          Get.snackbar(
              "Form Validation Failed", "Check all fields and try again",
              colorText: Colors.white,
              backgroundColor: Colors.black.withOpacity(0.6));
          setState(() {
            isSubmitting = false;
          });
        }
      }
    } else {
      Vibrate.feedback(FeedbackType.error);
      Get.snackbar("No Connection", "please check your internet connection",
          colorText: Colors.white,
          backgroundColor: Colors.black.withOpacity(0.6));
    }
  }

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 240,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
            child: Column(
              children: [
                Container(
                    height: 240 / 3 * 2,
                    width: 240,
                    color: AppColors.PRIMARY_RED,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Image(
                          height: 100,
                          image: AssetImage("assets/logos/logo_1.png"),
                          fit: BoxFit.fitHeight,
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Text(
                              "Thank You! for your submission",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  decoration: TextDecoration.none),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    )),
                const Spacer(),
                MaterialButton(
                  color: AppColors.PRIMARY_RED,
                  onPressed: () {
                    clearForm();
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();

                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer()
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Future<bool> checkConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      return result;
    } else {
      return result;
    }
  }

  void submit() async {
    Submit response = await Api().submitEyeDonation(
        address: addressController.text,
        district: selectedDistrict,
        dob: dateOfBirth.text,
        email: emailController.text,
        nominee: nomineeController.text,
        gender: SelectedGender,
        name: nameController.text,
        nic: NICController.text,
        nomineePhoneNum: nomineeMobileController.text,
        phoneNum: phNumberController.text,
        type: SelectedType);
    if (response.done) {
      showCustomDialog(context);
      setState(() {
        isSubmitting = false;
      });
    } else {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  textField(
                    controller: nameController,
                    labelText: "Name",
                    textInputType: TextInputType.name,
                    maxInputLength: 50,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  textField(
                    hintText: "07XXXXXXXX",
                    controller: phNumberController,
                    labelText: "Phone Number",
                    textInputType: TextInputType.phone,
                    maxInputLength: 10,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  textField(
                    controller: emailController,
                    labelText: "Email Address",
                    textInputType: TextInputType.emailAddress,
                    maxInputLength: 100,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  dropDown(context, dateOfBirth, "BirthDay"),
                  const SizedBox(
                    height: 16,
                  ),
                  dropDownNew(
                    title: "Gender",
                    itemList: _gender,
                    selectedGender: SelectedGender,
                    valueSelected: (p0) {
                      setState(() {
                        SelectedGender = p0;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  dropDownNew(
                    title: "District",
                    itemList: districts,
                    selectedGender: selectedDistrict,
                    valueSelected: (p0) {
                      setState(() {
                        selectedDistrict = p0;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  textField(
                    controller: NICController,
                    labelText: "NIC",
                    textInputType: TextInputType.streetAddress,
                    maxInputLength: 12,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  dropDownNew(
                    title: "Type",
                    itemList: _type,
                    selectedGender: SelectedType,
                    valueSelected: (p0) {
                      setState(() {
                        SelectedType = p0;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  textField(
                    controller: nomineeController,
                    labelText: "Nominee",
                    textInputType: TextInputType.name,
                    maxInputLength: 50,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  textField(
                    hintText: "07XXXXXXXX",
                    controller: nomineeMobileController,
                    labelText: "Nominee-Mobile",
                    textInputType: TextInputType.phone,
                    maxInputLength: 10,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  textField(
                    controller: addressController,
                    labelText: "Address",
                    textInputType: TextInputType.streetAddress,
                    maxInputLength: 100,
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  InkWell(
                    onTap: () {
                      formSubmit();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.PRIMARY_RED),
                      child: Center(
                          child: Text(
                        isSubmitting ? "Submitting.." : "Submit",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
