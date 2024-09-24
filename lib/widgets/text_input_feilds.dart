import 'package:flutter/material.dart';
import 'package:third_eye/constants/app_colors.dart';

Column textField({
  TextEditingController controller,
  String labelText,
  TextInputType textInputType,
  int maxInputLength,
  String hintText,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6, bottom: 3),
        child: Text(
          labelText,
          style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
      ),
      TextFormField(
        validator: (value) {
          return textInputType == TextInputType.phone
              ? Validator().validateMobile(value)
              : labelText == "NIC"
                  ? Validator().nicValidator(labelText: labelText, value: value)
                  : Validator().validator(
                      labelText: labelText,
                      textInputType: textInputType,
                      value: value);
        },
        cursorColor: Colors.grey,
        maxLength: maxInputLength,
        buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey, width: 2)),
          fillColor: Colors.white,
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: AppColors.PRIMARY_RED, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey, width: 2)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: AppColors.PRIMARY_RED, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                  color: AppColors.PRIMARY_RED.withOpacity(0.7), width: 2)),
          contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        ),
        textInputAction: TextInputAction.done,
        keyboardType: textInputType,
      ),
    ],
  );
}

SizedBox dropDown(
  BuildContext context,
  TextEditingController controller,
  String title,
) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 6.0, right: 6, top: 6, bottom: 3),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ),
        TextFormField(
          validator: (value) {
            if (value.isEmpty || value == null) {
              return ("$title can't be empty");
            } else {
              return null;
            }
          },
          maxLength: 10,
          buildCounter: (BuildContext context,
                  {int currentLength, int maxLength, bool isFocused}) =>
              null,
          style: const TextStyle(color: Colors.black),
          controller: controller,
          onTap: () async {
            DateTime newDate = await showDatePicker(
                context: context,
                builder: (BuildContext context, Widget child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme:
                          const ColorScheme.light(primary: Color(0xFF57ABFA)),
                    ),
                    child: child,
                  );
                },
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));

            if (newDate == null) return;
            controller.text = "${newDate.year}/${newDate.month}/${newDate.day}";
          },
          readOnly: true,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              suffixIcon: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                ),
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 2)),
              errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide:
                      BorderSide(color: AppColors.PRIMARY_RED, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 2)),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide:
                      BorderSide(color: AppColors.PRIMARY_RED, width: 2)),
              contentPadding: const EdgeInsets.only(left: 15, right: 0),
              hintText: "YYYY/MM/DD",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
      ],
    ),
  );
}

Column dropDownList(
    {List<String> itemList,
    Function(String) valueSelected,
    String selectedGender,
    String title}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6, bottom: 3),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
      ),
      FormField<String>(
        validator: (value) => value == null ? ("$title can't be empty") : null,
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 2)),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide:
                      BorderSide(color: AppColors.PRIMARY_RED, width: 2)),
              errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide:
                      BorderSide(color: AppColors.PRIMARY_RED, width: 2)),
              errorStyle:
                  const TextStyle(color: Colors.redAccent, fontSize: 16.0),
            ),
            isEmpty: selectedGender == '',
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedGender,
                isDense: true,
                onChanged: (String newValue) {
                  valueSelected(newValue);
                  state.didChange(newValue);
                  state.validate();
                },
                items: itemList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    ],
  );
}

Column dropDownNew(
    {List<String> itemList,
    Function(String) valueSelected,
    String selectedGender,
    String title}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6, bottom: 3),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
      ),
      DropdownButtonFormField(
        value: selectedGender,
        items: itemList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          valueSelected(value);
        },
        validator: (value) {
          if (value == null) {
            return 'Please select an option';
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey, width: 2)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: AppColors.PRIMARY_RED, width: 2)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: AppColors.PRIMARY_RED, width: 1)),
          errorStyle: const TextStyle(
              color: Color.fromARGB(255, 201, 25, 31), fontSize: 12.0),
        ),
      ),
    ],
  );
}

class Validator {
  String validateMobile(String value) {
    String
        pattern = /* r'(^(?:[+0]9)?[0-9]{12}$)' */ /* r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$ '*/ r'^[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String validator(
      {String value, String labelText, TextInputType textInputType}) {
    /* RegExp emailRegex = RegExp(
        r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'); */
    RegExp emailRegex = RegExp(
        r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])');
    RegExp emojiRegex = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    if (value.isEmpty ||
        value == null ||
        RegExp(r'^\s*$').hasMatch(value) ||
        emojiRegex.hasMatch(value)) {
      return ("$labelText can't be empty or include emojis");
    } else {
      if (textInputType == TextInputType.emailAddress) {
        if (!emailRegex.hasMatch(value)) {
          return "Please enter a valid email address";
        }
        return null;
      }
    }
    return null;
  }

  String nicValidator(
      {String value, bool isOptional = false, String labelText}) {
    int minval = 10;

    // In case the NIC Input is optional
    if (isOptional && value.isEmpty) {
      return null;
    }
    Pattern pattern = r'^([0-9]{9}[x|X|v|V]|[0-9]{12})$';

    if (value.isEmpty) {
      return '$labelText cannot empty';
    } else if (value.length < minval) {
      return '$labelText is less than $minval digits. ';
    } else if (value.length == 10 || value.length == 12) {
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'Enter Valid NIC';
      } else {
        return null;
      }
    } else {
      return '$labelText is invalid. ';
    }
  }
}
