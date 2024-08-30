import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/views/notifications_view/notifications_local.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../configs/providers/get_user_points_provider.dart';
import '../../configs/providers/usersignupdetails.dart';
import '../../res/utils/CommonFuncs.dart';
import '../select_main_category/main_page_main_view.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // -----------winner notifiation----------
  Timer? _timer;
  bool _hasShownNotification = false;
  void startNotificationCheck() {
    // Check for notifications every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await checkForNotifications();
    });
  }

  Future<void> checkForNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('uid') ?? '';
    String username = prefs.getString('username') ?? '';

    if (!_hasShownNotification) {
      try {
        // Fetch Lucky Draw Notification
        var luckyDrawResponse = await http.post(
          Uri.parse(AppUrls.luckydrawWinners),
          body: {"id": userId},
        );

        if (luckyDrawResponse.statusCode == 200) {
          var dataa = jsonDecode(luckyDrawResponse.body);

          if (dataa is Map<String, dynamic> &&
              dataa.containsKey('message') &&
              dataa['message'] != null &&
              dataa['message'].isNotEmpty) {
            // Mark that the notification has been shown to prevent repeats
            setState(() {
              _hasShownNotification = true;
            });

            // Show the dialog with the lucky draw message
            showAnimatedWinnerPopup();
          }
        } else {
          if (kDebugMode) {
            print(
                'Lucky draw notification request failed with status: ${luckyDrawResponse.statusCode}');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error fetching lucky draw notification: $e");
        }
      }
    }
  }

  void showAnimatedWinnerPopup() async {
    await _controllerInitializationCompleter.future;

    if (_controller.value.isInitialized) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final Size screenSize = MediaQuery.of(context).size;
          final double dialogWidth = screenSize.width * 0.8;
          final double dialogHeight = screenSize.height * 0.5;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: dialogWidth,
                  height: dialogHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsView(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: dialogWidth,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors
                                .urduBtn, // Background color of the header
                            //  gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0)),
                          ),
                          child: Text(
                            "WINNER",
                            style: TextStyle(
                                fontSize: MySize.size40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 3.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: dialogWidth * 0.65,
                                height: dialogWidth * 0.60,
                                child: VideoPlayer(_controller),
                              ),
                              // SizedBox(height: 10),
                              Text(
                                "Congratulations $userName!",
                                style: TextStyle(
                                  fontSize: MySize.size30,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                  // shadows: [
                                  //   Shadow(
                                  //     blurRadius: 5.0,
                                  //     color: Colors.black45,
                                  //     offset: Offset(2.0, 2.0),
                                  //   ),
                                  // ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'You are the lucky draw winner. Our representative will contact you soon.',
                                  style: TextStyle(
                                      fontSize: MySize.size15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height *
                      0.01, // 2% of screen height
                  right: MediaQuery.of(context).size.width *
                      0.02, // 2% of screen width
                  child: Container(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                        0.02), // Padding based on screen width
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(
                          0.5), // Semi-transparent background color
                      shape: BoxShape.circle, // Circular background
                    ),
                    child: Material(
                      color: Colors.transparent, // No background color
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width *
                                0.02), // Border radius based on screen width
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width *
                                  0.01), // Padding around the icon
                          child: Icon(
                            Icons.close,
                            color: Colors.white, // Icon color
                            size: MediaQuery.of(context).size.width *
                                0.05, // Icon size based on screen width
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      // Automatically close the dialog after a few seconds
      // Future.delayed(Duration(seconds: 5), () {
      //   Navigator.of(context).pop(); // Close the dialog
      // });
    } else {
      print("Video player not initialized");
    }
  }

  //----------------------------
  List categoryItems = [];
  late Future<int> namesLength;
  Set<String> names = {};
  var bannerImage = "";

  Future<int> numberOfCategories() async {
    SharedPreferences? preff = await SharedPreferences.getInstance();

    var uid = preff!.get('uid').toString();

    try {
      var response = await http.post(Uri.parse(AppUrls.myCategory), body: {
        "User_Id": uid,
      });

      Fluttertoast.showToast(msg: "ID: $uid");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        log('This is data: $data');
        if (data['data'] is List) {
          categoryItems = List.from(data['data']);

          categoryItems.forEach((category) {
            if (category['name'] != null) {
              names.add(category['name']);

              // namesLength= names.length;
              //   return names.length;
              //   log(namesLength.toString());
            }
          });
        }
        return names.length;
      } else {
        return -1;
      }
    } catch (e) {
      return -1;
    }
  }

  String userName = "";
  String imagePath = "";
  List<CategoryModel> homeItems = [
    CategoryModel(image: AppConst.c1, name: "My categories".tr(), amount: 0),
    CategoryModel(
        image: AppConst.c2, name: "Interactive Surveys".tr(), amount: 7),
    CategoryModel(image: AppConst.c3, name: "Live Polls".tr(), amount: 3),
    CategoryModel(image: AppConst.c4, name: "My Profile".tr(), amount: 6),
    CategoryModel(
        image: AppConst.c5, name: "Manage Categories".tr(), amount: 2),
    CategoryModel(image: AppConst.c5, name: "Change Language".tr(), amount: 1),
  ];
  late VideoPlayerController _controller;
  Completer<void> _controllerInitializationCompleter = Completer<void>();
  @override
  void initState() {
    final getUserPointsProvider =
        Provider.of<GetUserPoints>(context, listen: false);
    getUserPointsProvider.fetchUserPoints();
    namesLength = numberOfCategories();
    _loadUserImage();
    getBanner();
    super.initState();
    _controller = VideoPlayerController.asset(AppConst.tbox)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
          // Future.delayed(Duration(milliseconds: 300), () {
          //   _controller.pause();
          // });
        });
        _controllerInitializationCompleter
            .complete(); // Mark initialization complete
      });

    checkForNotifications();
  }

  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var bpath = prefs.getString("bannerimg");

    setState(() {
      imagePath = prefs.getString('user_image') ?? "";

      // if(bpath!=null&&bpath.isNotEmpty)
      //   {
      //     bannerImage = bpath;
      //     print("jjjjbanner"+bannerImage);
      //     print("jjjjfirstif");
      //   }
      // else
      //   {
      //     getBanner();
      //   }

      log(imagePath!);
    });
  }

  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CommonFuncs.showToast("home_view HomeView");
    MySize().init(context);
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        userProvider.loadUserDetails();
        String userName = userProvider.userName ?? "";
        final getUserPointsProvider = Provider.of<GetUserPoints>(
          context,
        );
        final points = getUserPointsProvider.points;

        return Scaffold(
          body: Container(
            height: MySize.screenHeight,
            width: MySize.screenWidth,
            decoration: const BoxDecoration(
              color: AppColors.blackColor,
              image: DecorationImage(
                image: AssetImage(AppConst.bgPrimary),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(MySize.size16),
                child: Column(
                  children: [
                    SizedBox(
                      height: MySize.scaleFactorHeight * 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GeneralProfileView()));
                              },
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  width: MySize.size20 * 2,
                                  height: MySize.size20 * 2,
                                  imageUrl: imagePath,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/images/hi4.png',
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/hi4.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            // CircleAvatar(
                            //   radius: MySize.size20,
                            //   backgroundImage: imagePath != null && imagePath!.isNotEmpty
                            //       ? FadeInImage.assetNetwork(
                            //     placeholder: 'assets/images/user.png',
                            //     image: imagePath!,
                            //     fit: BoxFit.cover,
                            //   ).image
                            //       : const AssetImage(AppConst.hi4),
                            // ),

                            SizedBox(
                              width: MySize.scaleFactorWidth * 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GeneralProfileView()));
                              },
                              child: TextWidget(
                                text: userName,
                                fontWeight: FontWeight.w800,
                                fontColor: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            BottomBarView.of(context)?.indexChange(1);
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                AppConst.c1,
                                height: MySize.size20,
                                width: MySize.size20,
                              ),
                              SizedBox(
                                width: MySize.scaleFactorHeight * 10,
                              ),
                              TextWidget(
                                text: points != null && points! < 0
                                    ? '0'
                                    : points.toString(),
                                fontColor: Colors.deepOrangeAccent,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MySize.scaleFactorHeight * 20,
                    ),
                    GestureDetector(
                      onLongPress: () async {
                        SharedPreferences preffs =
                            await SharedPreferences.getInstance();
                        preffs.setBool('completedGeneral', true);
                        preffs.setBool('completedHealth', true);
                        preffs.setBool('completedShopping', true);
                        preffs.setBool('completedFinancial', true);
                        preffs.setBool('completedEntertainment', true);
                        preffs.setBool('completedTechnology', true);
                        preffs.setDouble('resultgeneral', 16.67);
                        preffs.setDouble('resulthealth', 16.67);
                        preffs.setDouble('resultshopping', 16.67);
                        preffs.setDouble('resultentertainment', 16.67);
                        preffs.setDouble('resulttechnology', 16.67);
                        preffs.setDouble('resultfinancial', 16.67);

                        Fluttertoast.showToast(msg: "done");
                      },
                      child: Container(
                        width: MySize.screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MySize.size14),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(MySize.size14),
                          child: CachedNetworkImage(
                            imageUrl: AppUrls.imageUrl + bannerImage,
                            width: MySize.screenWidth,
                            height: MySize.size80,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(MySize.size14),
                                child: Image.asset(
                                  'assets/images/testgif.gif',
                                  width: MySize.screenWidth,
                                  height: MySize.size76,
                                  fit: BoxFit.fill,
                                )),
                            errorWidget: (context, url, error) => ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(MySize.size14),
                                child: Image.asset(
                                  'assets/images/testgif.gif',
                                  width: MySize.screenWidth,
                                  height: MySize.size76,
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MySize.scaleFactorHeight * 30,
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: homeItems.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: MySize.scaleFactorHeight * 20,
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          switch (index) {
                            case 0:

                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder: (_, __, ___) => MainCategoryView(),
                              //     transitionDuration: const Duration(milliseconds: AppConst.transitionDuration),
                              //     reverseTransitionDuration: const Duration(milliseconds: AppConst.reverseTransitionDuration),
                              //     transitionsBuilder: (_, animation, __, child) {
                              //
                              //       return FadeTransition(
                              //         opacity: animation,
                              //         child: child,
                              //       );
                              //     },
                              //   ),
                              // );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainCategoryView(),
                                ),
                              );

                              break;

                            case 1:

                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder: (_, __, ___) => MainInteractiveView(),
                              //     transitionDuration: const Duration(milliseconds: AppConst.transitionDuration),
                              //     reverseTransitionDuration: const Duration(milliseconds: AppConst.reverseTransitionDuration),
                              //     transitionsBuilder: (_, animation, __, child) {
                              //
                              //       return FadeTransition(
                              //         opacity: animation,
                              //         child: child,
                              //       );
                              //     },
                              //   ),
                              // );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainInteractiveView(),
                                ),
                              );

                              break;
                            case 2:

                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder: (_, __, ___) => MainLiveSurveyView(),
                              //     transitionDuration: const Duration(milliseconds: AppConst.transitionDuration),
                              //     reverseTransitionDuration: const Duration(milliseconds: AppConst.reverseTransitionDuration),
                              //     transitionsBuilder: (_, animation, __, child) {
                              //
                              //       return FadeTransition(
                              //         opacity: animation,
                              //         child: child,
                              //       );
                              //     },
                              //   ),
                              // );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainLiveSurveyView(),
                                ),
                              );
                              break;

                            case 3:

                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder: (_, __, ___) => BussinessProfileView(),
                              //     transitionDuration: const Duration(milliseconds: AppConst.transitionDuration),
                              //     reverseTransitionDuration: const Duration(milliseconds: AppConst.reverseTransitionDuration),
                              //     transitionsBuilder: (_, animation, __, child) {
                              //
                              //       return FadeTransition(
                              //         opacity: animation,
                              //         child: child,
                              //       );
                              //     },
                              //   ),
                              // );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BussinessProfileView(),
                                ),
                              );

                              break;

                            case 4:

                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder: (_, __, ___) => SelectUnselectCatgeoriesView(),
                              //     transitionDuration: const Duration(milliseconds: AppConst.transitionDuration),
                              //     reverseTransitionDuration: const Duration(milliseconds: AppConst.reverseTransitionDuration),
                              //     transitionsBuilder: (_, animation, __, child) {
                              //
                              //       return FadeTransition(
                              //         opacity: animation,
                              //         child: child,
                              //       );
                              //     },
                              //   ),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectUnselectCatgeoriesView(),
                                ),
                              );
                              break;

                            case 5:

                              //     Navigator.push(
                              //       context,
                              //       PageRouteBuilder(
                              //         pageBuilder: (_, __, ___) => LanguageView(whereFrom: 'home',),
                              // transitionDuration: const Duration(milliseconds: AppConst.transitionDuration),
                              //         reverseTransitionDuration: const Duration(milliseconds: AppConst.reverseTransitionDuration),
                              //         transitionsBuilder: (_, animation, __, child) {
                              //
                              //           return FadeTransition(
                              //             opacity: animation,
                              //             child: child,
                              //           );
                              //         },
                              //       ),
                              //     );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LanguageView(
                                    whereFrom: 'home',
                                  ),
                                ),
                              );
                              break;
                          }
                          log("taped");
                        },
                        child: Container(
                          width: MySize.screenWidth,
                          padding: EdgeInsets.symmetric(
                            horizontal: MySize.size15,
                            vertical: MySize.size6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: MySize.size3,
                              color: AppColors.whiteColor,
                            ),
                            borderRadius: BorderRadius.circular(MySize.size12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                homeItems[index].image,
                                height: MySize.size48,
                                width: MySize.size48,
                                fit: BoxFit.fill,
                              ),
                              TextWidget(
                                text: homeItems[index].name,
                                fontSize: MySize.size18,
                                fontFamily: AppConst.primaryFont,
                                fontColor: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                              Visibility(
                                visible: index <= 2 ? true : false,
                                replacement: SizedBox(
                                  width: MySize.size32,
                                  height: MySize.size32,
                                ),
                                child: Container(
                                  width: MySize.size32,
                                  height: MySize.size32,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(MySize.size50),
                                    color: AppColors.secondaryColor,
                                  ),
                                  child: FutureBuilder(
                                    future: namesLength,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<int> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        AppColors.whiteColor)),
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: TextWidget(
                                            text: (index <= 1)
                                                ? snapshot.data.toString()
                                                : "${homeItems[index].amount} ",
                                            fontColor: AppColors.whiteColor,
                                            fontSize: MySize.size14,
                                            fontFamily: AppConst.primaryFont,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MySize.scaleFactorHeight * 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String calculateForLiveSurveys() {
    if (names.contains("Entertainment") &&
        names.contains("Politics") &&
        names.contains("Sports")) {
      return "3";
    } else if (names.contains("Entertainment") &&
        names.contains("Politics") &&
        !names.contains("Sports")) {
      return "2";
    } else if (names.contains("Entertainment") &&
        !names.contains("Politics") &&
        names.contains("Sports")) {
      return "2";
    } else if (!names.contains("Entertainment") &&
        names.contains("Politics") &&
        names.contains("Sports")) {
      return "2";
    }
    return "0";
  }

  Future<void> getBanner() async {
    var response = await http.get(Uri.parse(AppUrls.banner));

    try {
      var data = jsonDecode(response.body);
      var listsize = List.from(data).length;

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter(
            "200", AppUrls.banner, "GET", "none", data, "home_view");

        if (kDebugMode) {
          print("jjjjbanner  ${data.toString()}");
          print("jjjjbanner  ${data[0]['bannerimage']}");
          print("jjjjbanner  $listsize");
        }

        SharedPreferences pref = await SharedPreferences.getInstance();
        setState(() {
          bannerImage = data[0]['bannerimage'];
          pref.setString("bannerimg", bannerImage);
        });
      } else {
        log("Invalid data format received from the API.");
        CommonFuncs.apiHitPrinter(response.statusCode.toString(),
            AppUrls.banner, "GET", "none", data, "home_view");
      }
    } catch (e) {
      log("Error is $e");
    }
  }
}
