import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:third_eye/constants/app_colors.dart';

PreferredSize customAppBar(
    {Size size,
    String title,
    String backBtnSpeakText,
    bool focus,
    Function onPressed}) {
  return PreferredSize(
    preferredSize: size * 0.18,
    child: Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
      child: Stack(
        children: [
          AppBar(
            leading: focus
                ? IconButton(
                    tooltip: backBtnSpeakText,
                    iconSize: 24,
                    alignment: Alignment.center,
                    onPressed: () {
                      onPressed();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ))
                : ExcludeSemantics(
                    child: IconButton(
                        tooltip: backBtnSpeakText,
                        iconSize: 24,
                        alignment: Alignment.center,
                        onPressed: () {
                          onPressed();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                        )),
                  ),
            toolbarHeight: size.width * 0.2,
            backgroundColor: AppColors.PRIMARY_RED,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: size.width * 0.14,
                child: Image.asset(
                  "assets/logos/logo samples5_eye_2.png",
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(45),
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, bottom: 12, top: 6),
                child: Center(
                  child: ExcludeSemantics(
                      child: LayoutBuilder(builder: (context, constraints) {
                    final fontSize = constraints.maxWidth * 0.07;
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        title,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    );
                  })),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

PreferredSize recipePlayerAppBar(
    {Size size,
    String title,
    String backBtnSpeakText,
    bool focus,
    Function onPressed}) {
  return PreferredSize(
    preferredSize: size * 0.18,
    child: Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
      child: Stack(
        children: [
          AppBar(
            leading: focus
                ? IconButton(
                    tooltip: backBtnSpeakText,
                    iconSize: 24,
                    alignment: Alignment.center,
                    onPressed: () {
                      onPressed();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ))
                : ExcludeSemantics(
                    child: IconButton(
                        tooltip: backBtnSpeakText,
                        iconSize: 24,
                        alignment: Alignment.center,
                        onPressed: () {
                          onPressed();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                        )),
                  ),
            toolbarHeight: size.width * 0.2,
            backgroundColor: AppColors.PRIMARY_RED,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: size.width * 0.14,
                child: Image.asset(
                  "assets/logos/logo samples5_eye_2.png",
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(45),
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, bottom: 12, top: 6),
                child: Center(
                  child: ExcludeSemantics(
                    child: AutoSizeText(
                      title,
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
            ],
          ),
        ],
      ),
    ),
  );
}
