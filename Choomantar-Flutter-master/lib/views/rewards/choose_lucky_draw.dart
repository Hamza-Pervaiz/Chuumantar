import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/providers/calculating_profile_completion_percent_provider.dart';
import 'package:chumanter/models/choose_lucky_draw_model.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../configs/imports/import_helper.dart';
import '../../configs/providers/get_user_points_provider.dart';
import '../../configs/providers/usersignupdetails.dart';
import '../../models/choose_redeem_points_model.dart';
import 'package:carousel_slider/carousel_slider.dart' hide CarouselController;

import 'package:http/http.dart' as http;

class ChooseLuckyDraw extends StatefulWidget {
  final Function(String, String, ChooseLuckyDrawModel chooseLuckyDrawModel,
      String, String, String) onPressed;
  const ChooseLuckyDraw({super.key, required this.onPressed});

  @override
  State<ChooseLuckyDraw> createState() => _ChooseLuckyDrawState();
}

class _ChooseLuckyDrawState extends State<ChooseLuckyDraw> {
  List<ChooseLuckyDrawModel> chooseLuckyDrawItems = [
    ChooseLuckyDrawModel(
        id: '999',
        name: 'headphone',
        inventoryimage: 'abcd.com',
        points: '500'),
    ChooseLuckyDrawModel(
        id: '999',
        name: 'headphone',
        inventoryimage: 'abcd.com',
        points: '500'),
    ChooseLuckyDrawModel(
        id: '999', name: 'headphone', inventoryimage: 'abcd.com', points: '500')
  ];
  int? PointsAvailable;
  String currLoc = "en-US";
  double? resultAll;
  String pointstr = 'points'.tr();
  bool _isloading = true;
  String userid = '77';
  String username = 'bruce';
  String phone = '';
  ProgressDialog? progressDialog;

  void initProgressDialog() {
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false);
    progressDialog?.style(
      textAlign: TextAlign.center,
      message: 'Please wait...'.tr(),
      elevation: 10,
      padding: const EdgeInsets.symmetric(vertical: 10),
      messageTextStyle: const TextStyle(
        color: AppColors.purpleColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Future<void> fetchLuckyDrawItems() async {
    try {
      var response =
          await http.post(Uri.parse(AppUrls.getLuckyDrawItems), body: {
        'id': userid,
      });
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter("200", AppUrls.getLuckyDrawItems, "POST",
            "none", data, "choose_lucky_draw");
        if (data is List) {
          // Clear the existing list
          chooseLuckyDrawItems.clear();

          // Populate the list with data from the API
          chooseLuckyDrawItems =
              data.map((item) => ChooseLuckyDrawModel.fromMap(item)).toList();

          // Print the processed data
          if (kDebugMode) {
            print('Processed Data:');
          }
          chooseLuckyDrawItems.forEach((model) {
            if (kDebugMode) {
              //    print('Points: ${model.points}, Image: ${model.image}, Amount: ${model.pkr}');
            }
          });

          _isloading = false;
          // Update the UI
          setState(() {});
        }
      } else {
        CommonFuncs.apiHitPrinter(
            response.statusCode.toString(),
            AppUrls.getLuckyDrawItems,
            "GET",
            "none",
            data,
            "choose_lucky_draw");
        if (kDebugMode) {
          print('API request failed with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<void> submitLuckyDrawRequest(String inventoryId, String points) async {
    progressDialog?.show();
    try {
      var response =
          await http.post(Uri.parse(AppUrls.submitLuckYDrawRequest), body: {
        'id': userid,
        'inventoryid': inventoryId,
        'name': username,
        'points': points,
        'phone': phone,
        'method': 'Lucky Draw'
      });
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter("200", AppUrls.submitLuckYDrawRequest, "POST",
            "none", data, "choose_lucky_draw");

        progressDialog?.hide();

        Fluttertoast.showToast(
            msg:
                'Lucky draw request has been submitted and is currently pending',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            backgroundColor: AppColors.urduBtn);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomBarView()));
      } else {
        progressDialog?.hide();

        Navigator.pop(context);

        CommonFuncs.apiHitPrinter(
            response.statusCode.toString(),
            AppUrls.submitLuckYDrawRequest,
            "POST",
            "none",
            data,
            "choose_lucky_draw");
        if (kDebugMode) {
          print('API request failed with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      progressDialog?.hide();

      if (kDebugMode) {
        print('Error: $e');
      }

      Navigator.pop(context);

      Fluttertoast.showToast(
          msg: 'Server Error: 500',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: AppColors.urduBtn);
    }
  }

  @override
  void initState() {
    final getUserPointsProvider =
        Provider.of<GetUserPoints>(context, listen: false);
    final totalPercentage =
        Provider.of<CalculateProfileCompletionPercent>(context, listen: false);
    getUserPointsProvider.fetchUserPoints();
    totalPercentage.calculateAllPercents();
    super.initState();

    SharedPreferences.getInstance().then((value) {
      currLoc = value.getString("language") ?? "en-US";
      userid = value.getString("uid")!;
      username = value.getString("username")!;
      phone = value.getString("user_mobile")!;
    });

    fetchLuckyDrawItems();
    CommonFuncs.showToast("choose_points_to_redeem\nChooseLuckyDraw");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final getUserPointsProvider = Provider.of<GetUserPoints>(context);
        final totalPercentage =
            Provider.of<CalculateProfileCompletionPercent>(context);

        final totalPerc = totalPercentage.all_Percents;

        if (kDebugMode) {
          print("totalPercent: $totalPerc");
        }

        final points = getUserPointsProvider.points;
        PointsAvailable = points;
        resultAll = totalPerc;

        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Center(
            child: TextWidget(
              text: "Choose Your Prize".tr(),
              maxLines: 2,
              textAlign: TextAlign.center,
              fontSize: MySize.size24,
              fontWeight: FontWeight.w400,
              fontFamily: AppConst.primaryFont,
              fontColor: AppColors.primaryColor,
            ),
          ),
          SizedBox(
            height: MySize.scaleFactorHeight * 10,
          ),
          CircularSeekBar(
            width: double.infinity,
            height: MySize.size100,
            progress: points.toDouble(),
            maxProgress: 50000,
            interactive: false,
            barWidth: MySize.size10,
            dashWidth: MySize.size4,
            startAngle: MySize.size90,
            sweepAngle: 360,
            strokeCap: StrokeCap.butt,
            progressColor: AppColors.primaryColor,
            trackColor: AppColors.whiteColor.withOpacity(0.8),
            animation: true,
            child: Padding(
                padding: EdgeInsets.all(MySize.size20),
                child: Column(
                  children: [
                    TextWidget(
                      text: points != null && points < 0
                          ? '0'
                          : points.toString(),
                      fontSize: MySize.size20,
                      fontWeight: FontWeight.w700,
                    ),
                    TextWidget(
                      text: "Total Points".tr(),
                      fontColor: AppColors.primaryColor,
                      fontSize: MySize.size10,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                )),
          ),
          const Spacer(),
          chooseLuckyDrawItems.isNotEmpty
              ? Skeletonizer(
                  enabled: _isloading,
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      viewportFraction: 0.62,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      height: MySize.screenHeight * 0.44,
                      reverse: false,
                      autoPlay: false,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.2,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      int itemPoints =
                          int.tryParse(chooseLuckyDrawItems[index].points) ?? 0;
                      bool isLocked = PointsAvailable != null &&
                          itemPoints > PointsAvailable!;
                      bool isProfileCompleted =
                          resultAll != null && resultAll! >= 100.0;

                      return GestureDetector(
                        onTap: () {
                          if (isLocked) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: MySize.scaleFactorWidth * 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(MySize.size16),
                                  ),
                                  child: Container(
                                    height: MySize.scaleFactorHeight * 230,
                                    width: MySize.screenWidth,
                                    padding: EdgeInsets.all(MySize.size20),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(MySize.size16),
                                      image: const DecorationImage(
                                        image: AssetImage(AppConst.eyeBg),
                                        fit: BoxFit.scaleDown,
                                        scale: 0.6,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize
                                          .min, // Makes the column only as tall as its children
                                      children: [
                                        TextWidget(
                                          text: 'Error!'.tr(),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          fontSize: MySize.size20,
                                          fontFamily: AppConst.primaryFont,
                                          fontColor: AppColors.redColor,
                                        ),
                                        SizedBox(
                                          height: MySize.scaleFactorHeight * 20,
                                        ),
                                        TextWidget(
                                          text:
                                              'Not Enough Points. Complete more surveys to get more points.'
                                                  .tr(),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          fontSize: MySize.size18,
                                          fontFamily: AppConst.primaryFont,
                                          fontColor: AppColors.purpleColor,
                                        ),
                                        SizedBox(
                                          height: MySize.scaleFactorHeight * 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.secondaryColor,
                                            foregroundColor: Colors.black,
                                            elevation: 7,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      MySize.size8),
                                            ),
                                          ),
                                          child: Text(
                                            'Ok'.tr(),
                                            style: const TextStyle(
                                                fontFamily:
                                                    AppConst.primaryFont,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.whiteColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (!isProfileCompleted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: MySize.scaleFactorWidth * 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(MySize.size16),
                                  ),
                                  child: Container(
                                    height: MySize.scaleFactorHeight * 230,
                                    width: MySize.screenWidth,
                                    padding: EdgeInsets.all(MySize.size20),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(MySize.size16),
                                      image: const DecorationImage(
                                        image: AssetImage(AppConst.eyeBg),
                                        fit: BoxFit.scaleDown,
                                        scale: 0.6,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize
                                          .min, // Makes the column only as tall as its children
                                      children: [
                                        TextWidget(
                                          text: 'Error!'.tr(),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          fontSize: MySize.size20,
                                          fontFamily: AppConst.primaryFont,
                                          fontColor: AppColors.redColor,
                                        ),
                                        SizedBox(
                                          height: MySize.scaleFactorHeight * 20,
                                        ),
                                        TextWidget(
                                          text:
                                              'Please complete your profile section in order to proceed further'
                                                  .tr(),
                                          textAlign: TextAlign.center,
                                          maxLines: 4,
                                          fontSize: MySize.size18,
                                          fontFamily: AppConst.primaryFont,
                                          fontColor: AppColors.purpleColor,
                                        ),
                                        SizedBox(
                                          height: MySize.scaleFactorHeight * 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.secondaryColor,
                                            foregroundColor: Colors.black,
                                            elevation: 7,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      MySize.size8),
                                            ),
                                          ),
                                          child: Text(
                                            'Ok'.tr(),
                                            style: const TextStyle(
                                                fontFamily:
                                                    AppConst.primaryFont,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.whiteColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return Dialog(
                            //       insetPadding:
                            //       EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 16),
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(MySize.size16),
                            //       ),
                            //       child: Container(
                            //         width: MySize.screenWidth,
                            //         padding: EdgeInsets.all(MySize.size20),
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(MySize.size16),
                            //           image: const DecorationImage(
                            //             image: AssetImage(AppConst.eyeBg),
                            //             fit: BoxFit.scaleDown,
                            //             scale: 0.6,
                            //           ),
                            //         ),
                            //         child: Column(
                            //           mainAxisSize: MainAxisSize.min, // Makes the column only as tall as its children
                            //           children: [
                            //             TextWidget(
                            //               text: 'Confirm!'.tr(),
                            //               textAlign: TextAlign.center,
                            //               maxLines: 2,
                            //               fontSize: MySize.size20,
                            //               fontFamily: AppConst.primaryFont,
                            //               fontColor: AppColors.redColor,
                            //             ),
                            //             SizedBox(
                            //               height: MySize.scaleFactorHeight * 10,
                            //             ),
                            //
                            //             ClipOval(
                            //               child: CachedNetworkImage(
                            //                 fit: BoxFit.fill,
                            //                 width: MySize.size54*2,
                            //                 height: MySize.size54*2,
                            //                 imageUrl: "${AppUrls.imageUrl}${chooseLuckyDrawItems[index].inventoryimage}",
                            //                 placeholder: (context, url) => Image.asset('assets/images/hi4.png',  fit: BoxFit.cover,),
                            //                 errorWidget: (context, url, error) =>  Image.asset('assets/images/hi4.png', fit: BoxFit.cover,),
                            //
                            //               ),
                            //             ),
                            //
                            //             SizedBox(
                            //               height: MySize.scaleFactorHeight * 20,
                            //             ),
                            //
                            //             TextWidget(
                            //               text: 'A chance to win "${chooseLuckyDrawItems[index].name}" for ${chooseLuckyDrawItems[index].points} points'.tr(),
                            //               textAlign: TextAlign.center,
                            //               maxLines: 2,
                            //               fontSize: MySize.size18,
                            //               fontFamily: AppConst.primaryFont,
                            //               fontColor: AppColors.primaryColor,
                            //             ),
                            //
                            //             SizedBox(height: 5,),
                            //
                            //             TextWidget(
                            //               text: 'You will be entered in the list of lucky draw participants. Lucky draw is conducted on 15th of every month, we will notify you if you are the prize winner'.tr(),
                            //               textAlign: TextAlign.center,
                            //               maxLines: 6,
                            //               fontSize: MySize.size18,
                            //               fontFamily: AppConst.primaryFont,
                            //               fontColor: AppColors.purpleColor,
                            //             ),
                            //
                            //             SizedBox(height: 5,),
                            //
                            //             TextWidget(
                            //               text: "Note: You won't get your points back in case you are not the winner",
                            //               textAlign: TextAlign.center,
                            //               maxLines: 6,
                            //               fontSize: MySize.size14,
                            //               fontFamily: AppConst.primaryFont,
                            //               fontColor: AppColors.redColor,
                            //             ),
                            //
                            //             SizedBox(
                            //               height: MySize.scaleFactorHeight * 20,
                            //             ),
                            //             ElevatedButton(
                            //               onPressed: () {
                            //                 submitLuckyDrawRequest(chooseLuckyDrawItems[index].id, chooseLuckyDrawItems[index].points);
                            //             //    Navigator.push(context, MaterialPageRoute(builder: (_) => BottomBarView()));
                            //                // Navigator.pop(context);
                            //               },
                            //               style: ElevatedButton.styleFrom(
                            //                 backgroundColor: AppColors.secondaryColor,
                            //                 foregroundColor: Colors.black,
                            //                 elevation: 7,
                            //                 shape: RoundedRectangleBorder(
                            //                   borderRadius: BorderRadius.circular(MySize.size8),
                            //                 ),
                            //               ),
                            //               child: Text('Ok'.tr(),style: const TextStyle( fontFamily: AppConst.primaryFont,
                            //                   fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // );

                            widget.onPressed(
                                chooseLuckyDrawItems[index].points,
                                chooseLuckyDrawItems[index].points,
                                chooseLuckyDrawItems[index],
                                userid,
                                username,
                                phone);
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(MySize.size12),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  // Image
                                  CachedNetworkImage(
                                    imageUrl:
                                        "${AppUrls.imageUrl}${chooseLuckyDrawItems[index].inventoryimage}",
                                    height: MySize.screenHeight * 0.8,
                                    width: MySize.screenWidth,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Container(
                                        width: 50,
                                        height: 50,
                                        child: const Center(
                                            child:
                                                CircularProgressIndicator())),
                                    errorWidget: (context, url, error) =>
                                        SvgPicture.asset(
                                      "assets/svg/backCard.svg",
                                      height: MySize.screenHeight * 0.8,
                                      width: MySize.screenWidth,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.red, BlendMode.srcIn),
                                      semanticsLabel: 'A red up arrow',
                                    ),
                                  ),

                                  // Positioned Text Container at the bottom
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      color: Colors.white.withOpacity(0.8),
                                      // You can adjust the opacity as needed
                                      child: Column(
                                        children: [
                                          Text(
                                            "${chooseLuckyDrawItems[index].name} ",
                                            style: TextStyle(
                                              fontFamily: AppConst.primaryFont,
                                              color: AppColors.blueColor,
                                              fontSize: MySize.size19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "${chooseLuckyDrawItems[index].points} points",
                                            style: TextStyle(
                                              fontFamily: AppConst.primaryFont,
                                              color: AppColors.urduBtn,
                                              fontSize: MySize.size19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color:
                                        AppColors.whiteColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  isLocked ? Icons.lock : Icons.lock_open,
                                  color: isLocked ? Colors.red : Colors.green,
                                  size: MySize.size25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: chooseLuckyDrawItems.length,
                  ),
                )
              : Container(
                  child: Text(
                    'No prizes available right now',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppConst.primaryFont,
                        fontSize: 15),
                  ),
                ),
          const Spacer(),
        ]);
      },
    );
  }
}
