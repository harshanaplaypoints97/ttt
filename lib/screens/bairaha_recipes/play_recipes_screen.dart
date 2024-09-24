import 'dart:async';
import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:third_eye/constants/app_colors.dart';
import 'package:third_eye/constants/shimmer.dart';
import 'package:third_eye/models/get_recipes.dart';
import 'package:third_eye/screens/bairaha_recipes/seek_bar.dart';
import 'package:third_eye/widgets/app_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlayRecipe extends StatefulWidget {
  StreamSubscription<InternetConnectionStatus> subscription;
  Timer timer;
  int totalRecipeCount;
  List<Recipes> recipes;
  Future<bool> Function() loadMore;
  bool loading;
  int index;
  bool isBlinded;
  PlayRecipe({
    this.timer,
    this.subscription,
    this.totalRecipeCount,
    this.recipes,
    this.index,
    this.loadMore,
    this.isBlinded,
    Key key,
  }) : super(key: key);

  @override
  State<PlayRecipe> createState() => _PlayRecipeState();
}

class _PlayRecipeState extends State<PlayRecipe> with WidgetsBindingObserver {
  StreamSubscription<InternetConnectionStatus> _subscription;
  bool connected = false;
  Timer timer;
  final player = AudioPlayer();
  FlutterTts tts = FlutterTts();
  bool backFocus = false;
  ProcessingState status = ProcessingState.idle;
  bool isInternetSnackbarVisible = true;
  bool appInBackground = false;
//  spinkit = ;

  /// FlutterTts tts = FlutterTts();
  int currentRecipeNu = 0;
  String title = '';

  Stream<DurationState> get _durationState =>
      Rx.combineLatest3<Duration, Duration, Duration, DurationState>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => DurationState(
              position, bufferedPosition, duration ?? Duration.zero));

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Future<bool> checkConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      setState(() {
        connected = true;
      });
      return true;
    } else {
      setState(() {
        connected = false;
      });
      isInternetSnackbarVisible
          ? !widget.isBlinded
              ? Get.snackbar("No Internet", "Check your network connection",
                  colorText: Colors.white, snackbarStatus: (status) {
                  if (status == SnackbarStatus.CLOSED) {
                    setState(() {
                      isInternetSnackbarVisible = true;
                    });
                  } else if (status == SnackbarStatus.OPENING) {
                    setState(() {
                      isInternetSnackbarVisible = false;
                    });
                  }
                }, backgroundColor: Colors.black.withOpacity(0.6))
              : () {}
          : () {};
      return false;
    }
  }

  void checkConnectionOnStart() async {
    bool c = await checkConnection();
    if (!c) {
      if (widget.isBlinded) {
        timer = Timer.periodic(
            const Duration(seconds: 5),
            (Timer t) => connected
                ? () {}
                : SemanticsService.announce(
                    "No connection, please connect to the Internet",
                    TextDirection.rtl));
      }
    }
  }

  @override
  void initState() {
    widget.timer?.cancel();
    WidgetsBinding.instance.addObserver(this);
    title = widget.recipes[widget.index].name;
    currentRecipeNu = widget.index;
    setAudio(widget.recipes[widget.index].mediaUrl);
    player.playerStateStream.listen((state) {
      print(state);
      switch (state.processingState) {
        case ProcessingState.idle:
          setState(() {
            status = ProcessingState.idle;
          });
          break;
        case ProcessingState.loading:
          // SemanticsService.announce("Audio loading", TextDirection.ltr);
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
          status == ProcessingState.loading
              ? SemanticsService.announce(
                  "Audio ready to play", TextDirection.ltr)
              : () {};

          setState(() {
            status = ProcessingState.ready;
          });
          break;
        case ProcessingState.completed:
          SemanticsService.announce("Audio Completed", TextDirection.ltr);
          setState(() {
            status = ProcessingState.completed;
          });
          break;
      }
    });
    checkConnectionOnStart();
    widget.subscription.pause();
    _subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          appInBackground ? () {} : player.play();
          timer?.cancel();
          // ignore: avoid_print
          if (mounted) {
            setState(() {
              connected = true;
            });
          }
          SemanticsService.announce("Network Connected", TextDirection.ltr);
          setState(() {});
          break;
        case InternetConnectionStatus.disconnected:
          player.pause();
          timer?.cancel();

          isInternetSnackbarVisible
              ? !widget.isBlinded
                  ? Get.snackbar("No Internet", "Check your network connection",
                      colorText: Colors.white, snackbarStatus: (status) {
                      if (status == SnackbarStatus.CLOSED) {
                        setState(() {
                          isInternetSnackbarVisible = true;
                        });
                      } else if (status == SnackbarStatus.OPENING) {
                        setState(() {
                          isInternetSnackbarVisible = false;
                        });
                      }
                    }, backgroundColor: Colors.black.withOpacity(0.6))
                  : () {}
              : () {};
          // ignore: avoid_print
          if (mounted) {
            setState(() {
              connected = false;
            });
          }
          if (widget.isBlinded) {
            timer = Timer.periodic(
                const Duration(seconds: 5),
                (Timer t) => connected
                    ? () {}
                    : SemanticsService.announce(
                        "No connection, please connect to the Internet",
                        TextDirection.rtl));
          }
          widget.isBlinded
              ? SemanticsService.announce(
                  "No connection, please connect to the Internet",
                  TextDirection.ltr)
              : () {};

          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                backFocus = true;
              });
            }
          });
          break;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.subscription.resume();
    _subscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    player.stop();
    player.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      setState(() {
        appInBackground = true;
        player.pause();
      });
    } else if (state == AppLifecycleState.resumed) {
      bool c = await checkConnection();
      if (c) {
        setState(() {
          appInBackground = false;
          player.play();
        });
      }
    }
  }

  void changeAudio(int playNum) async {
    setState(() {
      title = widget.recipes[playNum].name;
      // SemanticsService.announce(title, TextDirection.rtl);
      //tts.speak(title);
      setAudio(widget.recipes[playNum].mediaUrl);
    });
  }

  void setAudio(
    String audioUrl,
  ) async {
    try {
      await player.setAudioSource(
          AudioSource.uri(
            Uri.parse(audioUrl),
          ),
          preload: true);
      if (mounted) {
        setState(() {
          player.playing ? player.pause() : player.pause();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void nextRecipe() async {
    player.stop();
    if (currentRecipeNu != widget.recipes.length - 1) {
      setState(() {
        currentRecipeNu++;
      });
      changeAudio(currentRecipeNu);
    } else {
      bool c = await widget.loadMore();
      if (c) {
        setState(() {
          currentRecipeNu++;
        });
        changeAudio(currentRecipeNu);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: recipePlayerAppBar(
          focus: backFocus,
          backBtnSpeakText: "back to recipes list",
          onPressed: () {
            Navigator.pop(context);
          },
          title: title,
          size: size),
      body: Column(
        children: [
          const Spacer(),
          ExcludeSemantics(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2 - 16 >
                      MediaQuery.of(context).size.width - 16
                  ? MediaQuery.of(context).size.width - 16
                  : MediaQuery.of(context).size.height / 2 - 16,
              width: MediaQuery.of(context).size.width - 16,
              child: widget.recipes[currentRecipeNu].thumbImage != null
                  ? Image.network(
                      widget.recipes[currentRecipeNu].thumbImage,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return ShimmerWidget(
                              isCircle: false,
                              width: size.width - 16,
                              height: size.width - 16);
                        }
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          ShimmerWidget(
                              isCircle: false,
                              width: size.width - 16,
                              height: size.width - 16),
                      width: size.width - 16,
                      height: size.width - 16,
                    )
                  : Image.asset("assets/banners/place_holder.jpeg"),
              //child: Image.asset("assets/banners/2.png"),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return Semantics(
                    excludeSemantics: !backFocus,
                    child: SeekBar(
                      isConnected: connected,
                      isBlinded: widget.isBlinded,
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: player.seek,
                      onChanged: player.seek,
                    ));
              },
            ),
          ),
          Row(
            children: [
              const Spacer(),
              Semantics(
                excludeSemantics: !backFocus,
                child: Semantics(
                  onDidGainAccessibilityFocus: () {
                    SemanticsService.announce(
                        currentRecipeNu > 0
                            ? "Previous Recipe,${widget.recipes[currentRecipeNu - 1].name},"
                            : "Previous Recipe, No recipes,",
                        TextDirection.ltr);
                  },
                  child: IconButton(
                      /*    tooltip: currentRecipeNu > 0
                          ? "Previous Recipe,${widget.recipes[currentRecipeNu - 1].name},"
                          : "Previous Recipe, No recipes,", */
                      alignment: Alignment.center,
                      iconSize: 54,
                      onPressed: () async {
                        bool c = await checkConnection();
                        if (c) {
                          player.stop();
                          currentRecipeNu > 0
                              ? setState(() {
                                  backFocus = false;
                                })
                              : () {};
                          player.stop();
                          setState(() {
                            currentRecipeNu != 0
                                ? currentRecipeNu--
                                : currentRecipeNu = 0;
                            changeAudio(currentRecipeNu);
                            setState(() {
                              backFocus = false;
                            });
                          });
                        } else {
                          SemanticsService.announce(
                              "No internet", TextDirection.ltr);
                        }
                      },
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        color: AppColors.PRIMARY_RED,
                      )),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              status == ProcessingState.completed
                  ? Semantics(
                      tooltip:
                          "Re-Play ,${widget.recipes[currentRecipeNu].name},",
                      onDidGainAccessibilityFocus: () {
                        setState(() {
                          backFocus = true;
                        });
                      },
                      focused: true,
                      child: IconButton(
                          iconSize: 60,
                          alignment: Alignment.center,
                          onPressed: () async {
                            bool c = await checkConnection();
                            if (c) {
                              player.seek(Duration.zero);
                              player.play();
                              SemanticsService.announce(
                                  "Audio Playing", TextDirection.ltr);
                            } else {
                              SemanticsService.announce(
                                  "No internet", TextDirection.ltr);
                            }
                          },
                          icon: const Icon(
                            Icons.replay,
                            color: AppColors.PRIMARY_RED,
                          )),
                    )
                  : status == ProcessingState.loading &&
                          status != ProcessingState.buffering
                      ? Semantics(
                          //label: "Audio loading",
                          focusable: true,
                          excludeSemantics: backFocus,
                          onDidGainAccessibilityFocus: () {
                            SemanticsService.announce(
                                "Recipe loading", TextDirection.ltr);
                            setState(() {
                              backFocus = true;
                            });
                          },
                          focused: true,
                          child: IconButton(
                              iconSize: 60,
                              alignment: Alignment.center,
                              onPressed: () {},
                              icon: SpinKitWaveSpinner(
                                color: AppColors.PRIMARY_RED,
                                waveColor:
                                    AppColors.PRIMARY_RED.withOpacity(0.6),
                                trackColor:
                                    AppColors.PRIMARY_RED.withOpacity(0.4),
                                size: 60.0,
                              )),
                        )
                      : player.playing
                          ? Semantics(
                              tooltip: "pause",
                              onDidGainAccessibilityFocus: () {
                                setState(() {
                                  backFocus = true;
                                });
                              },
                              focused: true,
                              child: IconButton(
                                  iconSize: 60,
                                  alignment: Alignment.center,
                                  onPressed: () {
                                    player.pause();
                                    SemanticsService.announce(
                                        "Audio paused", TextDirection.ltr);
                                  },
                                  icon: const Icon(
                                    Icons.pause_circle_outline_rounded,
                                    color: AppColors.PRIMARY_RED,
                                  )),
                            )
                          : Semantics(
                              tooltip:
                                  "Play ,${widget.recipes[currentRecipeNu].name},",
                              onDidGainAccessibilityFocus: () {
                                SemanticsService.announce(
                                    "Play", TextDirection.ltr);

                                setState(() {
                                  backFocus = true;
                                });
                              },
                              focused: true,
                              child: IconButton(
                                  iconSize: 60,
                                  alignment: Alignment.center,
                                  onPressed: () async {
                                    bool c = await checkConnection();
                                    if (c) {
                                      player.play();
                                      SemanticsService.announce(
                                          "Audio Playing", TextDirection.ltr);
                                    } else {
                                      SemanticsService.announce(
                                          "No internet", TextDirection.ltr);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.play_circle_outline_sharp,
                                    color: AppColors.PRIMARY_RED,
                                  )),
                            ),
              const SizedBox(
                width: 8,
              ),
              Semantics(
                excludeSemantics: !backFocus,
                child: Semantics(
                  onDidGainAccessibilityFocus: () {
                    SemanticsService.announce(
                        currentRecipeNu < widget.recipes.length - 1
                            ? "Next Recipe,${widget.recipes[currentRecipeNu + 1].name},"
                            : currentRecipeNu < widget.totalRecipeCount - 1
                                ? "Load more for next recipe"
                                : "No next Recipes,",
                        TextDirection.ltr);
                  },
                  /*   label: currentRecipeNu < widget.recipes.length - 1
                      ? "Next Recipe,${widget.recipes[currentRecipeNu + 1].name},"
                      : currentRecipeNu < widget.totalRecipeCount - 1
                          ? "Load more for next recipe"
                          : "No next Recipes,", */
                  child: IconButton(
                      /* tooltip: currentRecipeNu < widget.recipes.length - 1
                          ? "Next Recipe,${widget.recipes[currentRecipeNu + 1].name},"
                          : currentRecipeNu < widget.totalRecipeCount - 1
                              ? "Load more for next recipe"
                              : "No next Recipes,", */
                      iconSize: 54,
                      alignment: Alignment.center,
                      onPressed: () async {
                        bool c = await checkConnection();
                        if (c) {
                          // player.stop();
                          currentRecipeNu < widget.totalRecipeCount - 1
                              ? setState(() {
                                  backFocus = false;
                                })
                              : () {};
                          currentRecipeNu < widget.totalRecipeCount - 1
                              ? nextRecipe()
                              : () {};
                        } else {
                          SemanticsService.announce(
                              "No internet", TextDirection.ltr);
                        }
                      },
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        color: AppColors.PRIMARY_RED,
                      )),
                ),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class DurationState {
  const DurationState(this.position, this.bufferedPosition, this.duration);
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
