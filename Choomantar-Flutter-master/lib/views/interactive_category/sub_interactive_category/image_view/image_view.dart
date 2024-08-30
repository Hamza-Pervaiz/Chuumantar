import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../../../configs/providers/get_user_points_provider.dart';
import '../../../../configs/providers/usersignupdetails.dart';

class ImageView extends StatefulWidget {
  String imageLastUrl;

  ImageView({super.key, required this.imageLastUrl});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool seeImage = false;

  late Timer timer;
  int seconds = 0;
  double timeLeft = 0;
  String imagePath = '';
  bool isVisible = false;
  bool oneTimeTimer = false;
  bool _imageLoadFailed = false;
  bool showGoBack = false;
  bool picFailed = false;

  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('user_image')!;
    });
  }

  @override
  void initState() {
    _loadUserImage();
    super.initState();
    //   seeImage ? startTimer() : null;
    CommonFuncs.showToast("image_view\nImageView");
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (seconds < 15) {
          seconds = seconds + 1;
          timeLeft = seconds / 15;
        } else {
          seconds = 0;
          if (!picFailed) {

            if (kDebugMode) {
              print("inside startTimer() last if invoked");
            }

            isVisible = true;
            resetTimer();
          }
        }
      });
    });
  }

  void resetTimer() {
    timer.cancel();
    timeLeft = 0;
    seconds = 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    resetTimer();
    super.dispose();
  }

  PageController? pageController;

  @override
  Widget build(BuildContext context) {

    if (kDebugMode) {
      print("Widget is rebuilding");
    }

    MySize().init(context);

    return WillPopScope(
      onWillPop: () async {
        if (pageController?.page == 0) {
          return true;
        } else {

          if (kDebugMode) {
            print("inside else willpopscope");
          }

          Navigator.pop(context, "noopen");
          // pageController?.previousPage(
          //   duration: const Duration(milliseconds: 300),
          //   curve: Curves.easeOut,
          // );
          return false;
        }
      },
      child: Scaffold(
        body: Container(
          height: MySize.screenHeight,
          width: MySize.screenWidth,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
          child: Padding(
            padding: EdgeInsets.all(MySize.size16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: MySize.size20,
                          backgroundImage: imagePath != null &&
                                  imagePath.isNotEmpty
                              ? NetworkImage(imagePath) as ImageProvider
                              : const AssetImage(AppConst.hi4), // Default image
                        ),
                        SizedBox(
                          width: MySize.scaleFactorWidth * 10,
                        ),
                        Consumer<UserProvider>(
                            builder: (context, userProvider, child) {
                          String userName = userProvider.userName ?? "";
                          return TextWidget(
                            text: userName,
                            fontWeight: FontWeight.w800,
                            fontColor: AppColors.whiteColor,
                          );
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AppConst.c1,
                          height: MySize.size20,
                          width: MySize.size20,
                        ),
                        SizedBox(
                          width: MySize.scaleFactorHeight * 10,
                        ),
                        Consumer<UserProvider>(
                            builder: (context, userProvider, child) {
                          final getUserPointsProvider =
                              Provider.of<GetUserPoints>(context,
                                  listen: false);
                          final points = getUserPointsProvider.points;

                          return TextWidget(
                            text: points.toString(),
                            fontColor: Colors.deepOrangeAccent,
                          );
                        }),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: MySize.scaleFactorHeight * 20,
                ),
                seeImage
                    ? TextWidget(
                        text:
                            "Please see the image carefully before taking the survey."
                                .tr(),
                        maxLines: 2,
                        fontSize: MySize.size16,
                        fontWeight: FontWeight.w700,
                      )
                    : const SizedBox(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MySize.scaleFactorWidth * 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: "$seconds",
                        fontSize: MySize.size16,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppConst.primaryFont,
                        fontColor: seconds < 9
                            ? AppColors.primaryColor
                            : seconds > 9 && seconds > 12
                                ? AppColors.redColor
                                : Colors.orange,
                      ),
                      SizedBox(
                        height: MySize.size4,
                      ),
                      LinearProgressIndicator(
                        minHeight: MySize.size10,
                        borderRadius: BorderRadius.circular(MySize.size30),
                        color: AppColors.whiteColor,
                        semanticsLabel: seconds.toString(),
                        value: timeLeft,
                        semanticsValue: "Seconds",
                        valueColor: AlwaysStoppedAnimation(
                          seconds < 9
                              ? AppColors.primaryColor
                              : seconds > 9 && seconds > 12
                                  ? AppColors.redColor
                                  : Colors.orange,
                        ),
                      ),
                      SizedBox(
                        height: MySize.size4,
                      ),
                      TextWidget(
                        text: "Seconds".tr(),
                        fontColor: AppColors.primaryColor,
                        fontSize: MySize.size12,
                        fontFamily: AppConst.primaryFont,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MySize.scaleFactorHeight * 10,
                ),
                seeImage
                    ? Expanded(
                        child: Stack(
                          alignment: Alignment.topRight,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: MySize.screenHeight,
                              width: MySize.screenWidth * 0.9,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/gradientimage3.jpg"),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  "${AppUrls.imageUrl}uploads/${widget.imageLastUrl}",
                                  fit: BoxFit.contain,
                                  width: MySize.screenWidth * 0.9,
                                  height: MySize.screenHeight,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      Future.delayed(const Duration(seconds: 2), () {
                                        if (!oneTimeTimer) {
                                          setState(() {

                                            if (kDebugMode) {
                                              print("Image loaded success");
                                            }

                                            startTimer();
                                            oneTimeTimer = true;
                                          });
                                        }
                                      });

                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress.expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    if (!_imageLoadFailed) {
                                      Future.delayed(const Duration(seconds: 3), () {
                                        setState(() {
                                          if (!oneTimeTimer) {
                                            startTimer();
                                            oneTimeTimer = true;
                                          }

                                          picFailed = true;
                                          if (seconds > 13) {
                                            resetTimer();
                                            showGoBack = true;
                                            _imageLoadFailed = true;
                                          }
                                        });
                                      });
                                    }

                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/imagecorrupt.png',
                                          width: 180,
                                          height: 180,
                                        ),
                                        Transform.translate(
                                          offset: const Offset(0, -15),
                                          child: Text(
                                            'Failed to load image',
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: MySize.size20,
                                                fontFamily: AppConst.primaryFont,
                                                color: AppColors.redColor),
                                          ),
                                        )
                                      ],
                                    );
                                    // You can replace PlaceholderWidget with your own widget
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(MySize.size16),
                              child: Image.asset(
                                AppConst.logo,
                                width: MySize.scaleFactorWidth * 120,
                                height: MySize.scaleFactorHeight * 35,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              text:
                                  "Please see the image carefully before taking the survey."
                                      .tr(),
                              maxLines: 2,
                              fontSize: MySize.size16,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(
                              height: MySize.scaleFactorHeight * 20,
                            ),
                            ButtonWidget(
                                onTap: () {
                                  seeImage = !seeImage;
                                  setState(() {});
                                  // seeImage ? startTimer() : resetTimer();
                                },
                                text: "See the picture".tr()),
                          ],
                        ),
                      ),
                SizedBox(
                  height: MySize.size10,
                ),
                Visibility(
                  visible: isVisible,
                  child: ButtonWidget(
                    onTap: () {
                      Navigator.of(context).pop("opensur");
                    },
                    text: "Ready to take survey".tr(),
                  ),
                ),
                Visibility(
                  visible: showGoBack,
                  child: ButtonWidget(
                    onTap: () {
                      Navigator.pop(context, "noopen");
                    },
                    text: "Go Back".tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
