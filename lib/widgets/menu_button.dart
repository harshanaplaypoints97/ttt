import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:third_eye/constants/app_colors.dart';

InkWell menuButton({
  String buttonText,
  Size size,
  bool blinded,
  Function route,
}) {
  return InkWell(
    onTap: () {
      route();
    },
    child: Semantics(
      excludeSemantics: true,
      label: buttonText == "Bairaha Recipes" ? "bai raha recipes" : buttonText,
      child: Container(
        height: blinded ? size.height / 10 : size.height / 11,
        decoration: const BoxDecoration(
          color: AppColors.PRIMARY_RED,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24),
          ),
        ),
      ),
    ),
  );
}

InkWell recipeButton({
  String buttonText,
  String readText,
  Size size,
  Function route,
}) {
  return InkWell(
    onTap: () {
      route();
    },
    child: Semantics(
      excludeSemantics: true,
      label: readText,
      child: Container(
        height: size.height / 10,
        decoration: const BoxDecoration(
          color: AppColors.PRIMARY_RED,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AutoSizeText(
              buttonText,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
          ),
        ),
      ),
    ),
  );
}
