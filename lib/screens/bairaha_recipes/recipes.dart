import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:third_eye/api/Api.dart';
import 'package:third_eye/constants/app_colors.dart';
import 'package:third_eye/constants/routes.dart';
import 'package:third_eye/constants/shimmer.dart';
import 'package:third_eye/main.dart';
import 'package:third_eye/models/get_recipes.dart';
import 'package:third_eye/screens/bairaha_recipes/play_recipes_screen.dart';
import 'package:third_eye/widgets/app_bar.dart';
import 'package:third_eye/widgets/menu_button.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({
    Key key,
  }) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  List<Recipes> recipes = [];
  StreamSubscription<InternetConnectionStatus> _subscription;
  bool connected = false;
  bool isLoading = false;
  bool backFocus = false;
  bool isBlinded = false;
  bool recipeLoaded = false;
  int totalRecipeCount = 0;
  int offset = 0;
  int limit = 10;
  int loadingCount = 0;
  ScrollController _scrollController = ScrollController();
  Timer timer;
  bool isInternetSnackbarVisible = true;

  Future<List<Recipes>> getRecipes() async {
    GetRecipes response = await Api().getRecipes(limit: limit, offset: offset);
    if (response.body != null && response.body != null) {
      if (response.done) {
        setState(() {
          totalRecipeCount = response.body.count;
        });
        return response.body.recipes;
      } else {
        return null;
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!isLoading) {
        setState(() {
          isLoading = true;
          offset += limit;
        });
        getRecipes().then((newItems) {
          setState(() {
            isLoading = false;
            recipes.addAll(newItems);
          });
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          print('Error: $error');
        });
      }
    }
  }

  void getres() async {
    List<Recipes> pp = await getRecipes();
    if (mounted) {
      setState(() {
        recipes.addAll(pp);
      });
    }
    isBlinded
        ? SemanticsService.announce("Recipes loaded", TextDirection.rtl)
        : () {};

    setState(() {
      recipeLoaded = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          backFocus = true;
        });
      }
    });
  }

  Future<bool> loadMoreFromPlayer() async {
    setState(() {
      isLoading = true;
      offset += limit;
    });
    List<Recipes> res = await getRecipes();
    if (res.isNotEmpty) {
      recipes.addAll(res);
      setState(() {
        isLoading = false;
      });
      return true;
    } else {
      return false;
    }
  }

  void checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        isBlinded = prefs.getBool("blinded");
      });
    }
    isBlinded
        ? SemanticsService.announce("Bai raha Recipe List", TextDirection.rtl)
        : () {};
  }

  void loadingCheck() {
    loadingCount++;
    if (!recipeLoaded) {
      SemanticsService.announce("recipes loading", TextDirection.rtl);
      if (loadingCount == 2) {
        setState(() {
          backFocus = true;
        });
      }
    }
  }

  @override
  void initState() {
    //getres();
    checkUser();
    _scrollController.addListener(_scrollListener);
    _subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          timer?.cancel();
          // ignore: avoid_print
          if (mounted) {
            setState(() {
              connected = true;
            });
          }
          getres();
          if (isBlinded) {
            SemanticsService.announce("recipes", TextDirection.rtl);
            timer = Timer.periodic(
                Duration(seconds: 5), (Timer t) => loadingCheck());
          }

          break;
        case InternetConnectionStatus.disconnected:
          timer?.cancel();
          isInternetSnackbarVisible
              ? !isBlinded
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
          SemanticsService.announce(
              "No connection, please connect to the Internet",
              TextDirection.ltr);

          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                backFocus = true;
              });
            }
          });
          break;
      }
      if (isBlinded) {
        timer = Timer.periodic(
            const Duration(seconds: 5),
            (Timer t) => connected
                ? () {}
                : SemanticsService.announce(
                    "No connection, please connect to the Internet",
                    TextDirection.rtl));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _scrollController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      setState(() {
        connected = true;
      });
    } else {
      setState(() {
        connected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: customAppBar(
            onPressed: () {
              navigator.pop(context);
            },
            size: size,
            title: "Bairaha Recipes",
            backBtnSpeakText: "Back to Menu",
            focus: backFocus),
        body: Stack(
          children: [
            Semantics(
                focused: true,
                child: const SizedBox(
                  height: 1,
                  width: 1,
                )),
            ListView.builder(
              controller: _scrollController,
              itemCount: recipes.length + 1,
              // ignore: missing_return
              itemBuilder: (BuildContext context, int index) {
                if (index < recipes.length) {
                  return ListTile(
                      title: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: index == 0
                        ? Semantics(
                            focused: true,
                            child: recipeButton(
                                readText: recipes[index].readName,
                                buttonText: recipes[index].name,
                                size: size,
                                route: () {
                                  DefaultRouter.defaultRouter(
                                      PlayRecipe(
                                        timer: timer,
                                        isBlinded: isBlinded,
                                        subscription: _subscription,
                                        totalRecipeCount: totalRecipeCount,
                                        recipes: recipes,
                                        index: index,
                                        loadMore: () async {
                                          bool c = await loadMoreFromPlayer();
                                          if (c) {
                                            return true;
                                          } else {
                                            return false;
                                          }
                                        },
                                      ),
                                      context);
                                }),
                          )
                        : recipeButton(
                            readText: recipes[index].readName,
                            buttonText: recipes[index].name,
                            size: size,
                            route: () {
                              DefaultRouter.defaultRouter(
                                  PlayRecipe(
                                    timer: timer,
                                    isBlinded: isBlinded,
                                    subscription: _subscription,
                                    totalRecipeCount: totalRecipeCount,
                                    recipes: recipes,
                                    index: index,
                                    loadMore: () async {
                                      bool c = await loadMoreFromPlayer();
                                      if (c) {
                                        return true;
                                      } else {
                                        return false;
                                      }
                                    },
                                  ),
                                  context);
                            }),
                  ));
                } else if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.PRIMARY_RED,
                    ),
                  );
                } else if (recipes.isEmpty) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      ShimmerWidget(
                        height: 200,
                        width: size.width - 50,
                        isCircle: false,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ShimmerWidget(
                        height: 200,
                        width: size.width - 50,
                        isCircle: false,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ShimmerWidget(
                        height: 200,
                        width: size.width - 50,
                        isCircle: false,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ));
  }
}

Container musicPlayer() {
  return Container();
}
