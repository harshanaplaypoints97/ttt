import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:just_audio/just_audio.dart';
import 'package:third_eye/constants/app_colors.dart';
import 'package:third_eye/widgets/app_bar.dart';

class Vision extends StatefulWidget {
  bool isBlind;

  Vision({Key key, this.isBlind}) : super(key: key);

  @override
  State<Vision> createState() => _VisionState();
}

class _VisionState extends State<Vision> {
  AudioPlayer player = AudioPlayer();
  bool focusable = false;
  ProcessingState status = ProcessingState.idle;

  Future<void> loadVisionAudio() async {
    try {
      await player
          .setAudioSource(AudioSource.asset('assets/vision/AramunaDub.mp3'));
    } catch (e) {
      print(e);
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      setState(() {
        player.pause();
      });
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        player.play();
      });
    }
  }

  @override
  void initState() {
    loadVisionAudio();
    player.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.idle:
          setState(() {
            status = ProcessingState.idle;
          });
          break;
        case ProcessingState.loading:
          setState(() {
            status = ProcessingState.loading;
          });
          break;
        case ProcessingState.buffering:
          setState(() {
            status = ProcessingState.buffering;
          });
          break;
        case ProcessingState.ready:
          setState(() {
            status = ProcessingState.ready;
          });
          break;
        case ProcessingState.completed:
          // SemanticsService.announce("Audio Completed", TextDirection.ltr);
          setState(() {
            status = ProcessingState.completed;
          });

          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: customAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        backBtnSpeakText: "Back to Menu",
        size: size,
        title: "Vision",
        focus: focusable,
      ),
      body: Stack(
        children: [
          ExcludeSemantics(
            child: Container(
              decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/logos/logo_1.png"),
                  ),
                  color: AppColors.PRIMARY_RED.withOpacity(0.05)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(
                  children: const [
                    Text(
                      "Bairaha 3rd Eye අරමුණ",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "ලංකාවේ මෙන්ම ලෝකය තුල මිලියන 300කට අධි​ක සංඛ්‍යාවක් දශ්‍යාබාධිත ​හෝ අර්ධ පෙනීමකින් සහිත වෙති. ඒ අතරින්  ලංකාවේ තුල ද දෑස් නොපෙනෙන අපේම සහෝදර සහෝදරියන් බොහෝමකට සමාජ​ය තුලදී ක්‍රියාකාරී වන්නට, දැනුම සොයා යන්නට, තවත් අයෙකුගේ උපකාරයක් අවශ්‍ය වූ විට, ඒ අවැසි සහය ඔවුන්ගේ දෑතට​ම ලබා දීම අප​ගේ අරමුණයි. ",
                      style: TextStyle(),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "මේ ඔවුන්ගේ ජීවිතය තවත් පහසු කරවන්නට ඔවුන් නොදකින ලෝකයක් ඔවුන් වෙතට ගෙන එන්නට, එදිනෙදා ජීවිතයේ ඔවුන්ගේ කටයුතු තවත් පහසු කරවන, බයිරහා 3rd Eye මෙම ජංග​ම යෙදවු​ම,​ ඔවුන්ගේ තෙවැනි ඇස වෙන්නට බයිරහා තබන්නා වූ පළමු පියවරයි.",
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    Text(
                      "Bairaha 3rd Eye Vision Statement",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "The global count on visually impaired communities exceeds 300 million, each struggling and facing challenges to get by the day without any assistance. This presumes a significant demand in providing the visual impaired communities with guidance and support to fulfill their daily requirements with ease.",
                      style: TextStyle(),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Bairaha 3rd Eye is an initial attempt to make life convenient and ordinary for the visually impaired community in Sri Lanka through a mobile application that benefits them in completing their daily chores.",
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    Text(
                      "Bairaha 3rd Eye நோக்க அறிக்கை",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "உலகளாவிய ரீதியில் 300 மில்லியனுக்கும் மேற்பட்டோர் பார்வைக்குறைபாடு உள்ளவர்கள் ஆவர். அவர்கள் தமது அன்றாட வாழ்க்கையை நடாத்துவதே பெரும் சிரமங்களை எதிர்நோக்குகின்றனர். இது பார்வைக்குறைபாடு உள்ளோர் தமது அன்றாட வாழ்க்கையை சிரமமின்றி கொண்டு நடாத்த தேவையான உதவிகளையும் வழிகாட்டுதல்களையும் வழங்க வேண்டியதன் அவசியத்தை வலியுறுத்தி நிற்கின்றது. ",
                      style: TextStyle(),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Bairaha 3rd Eye ஆனது இலங்கையை சேர்ந்த பார்வைக்குறைபாடு உள்ளோர் ஒரு மொபைல் application தமது நாளாந்த செயற்பாடுகளை எவ்விதமான தடங்கலுமின்றி பூர்த்தி செய்வதே ஆகும்.",
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 36,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: status == ProcessingState.completed
                ? Semantics(
                    label: "Replay",
                    // tooltip: "Replay",
                    focused: true,
                    child: IconButton(
                        iconSize: 60,
                        alignment: Alignment.center,
                        onPressed: () async {
                          setState(() {
                            player.seek(Duration.zero);
                            player.play();
                          });
                          SemanticsService.announce(
                              "Vision Playing", TextDirection.ltr);
                        },
                        icon: const Icon(
                          Icons.replay,
                          color: AppColors.PRIMARY_RED,
                        )),
                  )
                : player.playing
                    ? Semantics(
                        focused: true,
                        child: IconButton(
                          tooltip: "paused",
                          iconSize: 60,
                          alignment: Alignment.center,
                          onPressed: () {
                            setState(() {
                              player.pause();
                            });
                            SemanticsService.announce(
                                "Paused", TextDirection.ltr);
                          },
                          icon: const Icon(
                            Icons.pause_circle_outline_rounded,
                            color: AppColors.PRIMARY_RED,
                          ),
                        ),
                      )
                    : Semantics(
                        onDidGainAccessibilityFocus: () {
                          setState(() {
                            focusable = true;
                          });
                        },
                        focused: true,
                        child: IconButton(
                          tooltip: "Play Vision",
                          iconSize: 60,
                          alignment: Alignment.center,
                          onPressed: () {
                            setState(() {
                              player.play();
                            });
                            SemanticsService.announce(
                                "Vision Playing", TextDirection.ltr);
                          },
                          icon: const Icon(
                            Icons.play_circle_outline_sharp,
                            color: AppColors.PRIMARY_RED,
                          ),
                        ),
                      ),
          )
        ],
      ),
    );
  }
}
