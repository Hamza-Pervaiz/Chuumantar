import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/category_view/rich_text_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../smook_view/smoke_view_for_surveys.dart';

class ListOfCompanyNamesInteractive extends StatefulWidget {
  final List<String> companyNames;
  final Function(String, int) onCompanySelected;
  // final Future<List<dynamic>> showInteractiveSurvey;
  final List<dynamic> showInteractiveSurvey1;
  String selectedSubcategory;
  String commingfFrom;
  String selectedSurveyType;
  String? parentCatName;
  String? imageorVideo;
  List<dynamic> matchinSurvey;
  String? selectedSubCat;

  ListOfCompanyNamesInteractive(
      {super.key,
      required this.companyNames,
      required this.onCompanySelected,
      required this.showInteractiveSurvey1,
      required this.selectedSubcategory,
      required this.commingfFrom,
      required this.selectedSurveyType,
      required this.matchinSurvey,
      this.parentCatName,
      this.imageorVideo,
      this.selectedSubCat});

  @override
  State<ListOfCompanyNamesInteractive> createState() =>
      _ListOfCompanyNamesInteractiveState();
}

class _ListOfCompanyNamesInteractiveState
    extends State<ListOfCompanyNamesInteractive> {
  PageController pageController = PageController();
  List<String> filteredCompanyNames = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Future<void> _refresh() async {
  // //  await widget.showInteractiveSurvey;
  //
  //
  // }
  void showDialogBox(BuildContext context, bool isGift, int index,
      PageController pageController, Function(String, int) onCompanySelected) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MySize.size16),
          ),
          child: Container(
            padding: EdgeInsets.all(MySize.size20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MySize.size16),
              image: const DecorationImage(
                image: AssetImage(AppConst.eyeBg),
                fit: BoxFit.scaleDown,
                scale: 0.6,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  text: 'Sponsored Survey!'.tr(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontSize: MySize.size22,
                  fontFamily: AppConst.primaryFont,
                  fontColor: AppColors.redColor,
                ),
                SizedBox(height: MySize.size22),

                ClipOval(
                  child: CachedNetworkImage(
                    width: 80,
                    height: 80,
                    fit: BoxFit.fill,
                    imageUrl:
                        "${AppUrls.imageUrl}${widget.matchinSurvey[index]["companylogoimage"]}",
                    placeholder: (context, url) => Image.asset(
                      'assets/images/hi4.png',
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 80,
                    ),
                  ),
                ),
                //   Image.asset('assets/images/compLogo1.png', width: 65, height: 65),
                SizedBox(height: MySize.size19),

                TextWidget(
                  text: isGift
                      ? "${"This gift survey is sponsored by ".tr()}${widget.matchinSurvey[index]["company_name"]}"
                      : "${"This survey is sponsored by ".tr()}${widget.matchinSurvey[index]["company_name"]}",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontSize: MySize.size18,
                  fontFamily: AppConst.primaryFont,
                  fontColor: AppColors.purpleColor,
                ),

                SizedBox(height: MySize.size18),

                isGift
                    ? Column(
                        children: [
                          TextWidget(
                            text:
                                "On completion, you might get a chance to win this item",
                            textAlign: TextAlign.center,
                            maxLines: 7,
                            fontSize: MySize.size18,
                            fontFamily: AppConst.primaryFont,
                            fontColor: AppColors.purpleColor,
                          ),
                          SizedBox(
                            height: MySize.size10,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.secondaryColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(15)),
                              height: 200,
                              width: MySize.screenWidth,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Image.network(
                                  "https://projects.funtashtechnologies.com/choo_dashboard/ajax/uploads/simon-lee-R_6A6CovgIM-unsplash.jpg",
                                  height: 200,
                                  width: MySize.screenWidth,
                                  fit: BoxFit.fill,
                                ),
                              )),
                          SizedBox(
                            height: MySize.size10,
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 1,
                      ),

                ElevatedButton(
                  onPressed: () async {
                    //  Navigator.of(context).pop("ok");

                    if (widget.commingfFrom == 'main') {
                      if (widget.matchinSurvey[index]['survey_type'] ==
                          'image_survey') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SmokeViewForSurveys()),
                        ).then((value) async {
                          Navigator.pop(context);
                          final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageView(
                                imageLastUrl: widget.matchinSurvey[index]
                                    ['survey_image'],
                              ),
                            ),
                          );

                          if (res == "opensur") {
                            if (kDebugMode) {
                              print("result is opensur");
                              print("coming back after selecting company");
                            }

                            //     Navigator.pop(context);
                            // await Future.delayed(Duration(seconds: 3));
                            widget.onCompanySelected(
                                widget.matchinSurvey[index]["company_name"],
                                index);
                            pageController.nextPage(
                              duration: const Duration(microseconds: 1),
                              curve: Curves.linear,
                            );
                          }
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SmokeViewForSurveys()),
                        ).then((value) async {
                          Navigator.pop(context);
                          final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoView(
                                videoLastUrl: widget.matchinSurvey[index]
                                    ['survey_image'],
                              ),
                            ),
                          );

                          if (res == "opensur") {
                            if (kDebugMode) {
                              print("result is opensur");
                              print("coming back after selecting company");
                            }
                            //     Navigator.pop(context);
                            // await Future.delayed(Duration(seconds: 3));
                            widget.onCompanySelected(
                                widget.matchinSurvey[index]["company_name"],
                                index);
                            pageController.nextPage(
                              duration: const Duration(microseconds: 1),
                              curve: Curves.linear,
                            );
                          }
                        });
                      }
                    } else if (widget.commingfFrom == 'sub') {
                      if (widget.matchinSurvey[index]['survey_type'] ==
                          'image_survey') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SmokeViewForSurveys()),
                        ).then((value) async {
                          Navigator.pop(context);
                          final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageView(
                                imageLastUrl: widget.matchinSurvey[index]
                                    ['survey_image'],
                              ),
                            ),
                          );

                          if (res == "opensur") {
                            if (kDebugMode) {
                              print("result is opensur");
                              print("coming back after selecting company");
                            }
                            //     Navigator.pop(context);
                            // await Future.delayed(Duration(seconds: 3));
                            widget.onCompanySelected(
                                widget.matchinSurvey[index]["company_name"],
                                index);
                            pageController.nextPage(
                              duration: const Duration(microseconds: 1),
                              curve: Curves.linear,
                            );
                          }
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SmokeViewForSurveys()),
                        ).then((value) async {
                          Navigator.pop(context);
                          final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoView(
                                videoLastUrl: widget.matchinSurvey[index]
                                    ['survey_image'],
                              ),
                            ),
                          );

                          if (res == "opensur") {
                            if (kDebugMode) {
                              print("result is opensur");
                              print("coming back after selecting company");
                            }
                            //     Navigator.pop(context);
                            // await Future.delayed(Duration(seconds: 3));
                            widget.onCompanySelected(
                                widget.matchinSurvey[index]["company_name"],
                                index);
                            pageController.nextPage(
                              duration: const Duration(microseconds: 1),
                              curve: Curves.linear,
                            );
                          }
                        });
                      }
                    } else if (widget.commingfFrom == 'sub_sub') {
                      if (widget.matchinSurvey[index]['survey_type'] ==
                          'image_survey') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SmokeViewForSurveys()),
                        ).then((value) async {
                          Navigator.pop(context);
                          final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageView(
                                imageLastUrl: widget.matchinSurvey[index]
                                    ['survey_image'],
                              ),
                            ),
                          );

                          if (res == "opensur") {
                            if (kDebugMode) {
                              print("result is opensur");
                              print("coming back after selecting company");
                            }
                            //     Navigator.pop(context);
                            // await Future.delayed(Duration(seconds: 3));
                            widget.onCompanySelected(
                                widget.matchinSurvey[index]["company_name"],
                                index);
                            pageController.nextPage(
                              duration: const Duration(microseconds: 1),
                              curve: Curves.linear,
                            );
                          }
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SmokeViewForSurveys()),
                        ).then((value) async {
                          Navigator.pop(context);
                          final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoView(
                                videoLastUrl: widget.matchinSurvey[index]
                                    ['survey_image'],
                              ),
                            ),
                          );

                          if (res == "opensur") {
                            if (kDebugMode) {
                              print("result is opensur");
                              print("coming back after selecting company");
                            }
                            //     Navigator.pop(context);
                            // await Future.delayed(Duration(seconds: 3));
                            widget.onCompanySelected(
                                widget.matchinSurvey[index]["company_name"],
                                index);
                            pageController.nextPage(
                              duration: const Duration(microseconds: 1),
                              curve: Curves.linear,
                            );
                          }
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: Colors.black,
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MySize.size8),
                    ),
                  ),
                  child: Text(
                    'Continue'.tr(),
                    style: const TextStyle(
                        fontFamily: AppConst.primaryFont,
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFuncs.showToast(
        "listof_company_names_interactive\nListOfCompanyNamesInteractive");

    log("jibranmatchinsurvey: ${widget.matchinSurvey}");

    if (widget.commingfFrom == 'main') {
      filteredCompanyNames = widget.companyNames;

      if (kDebugMode) {
        print("jjfilteredcompnames: $filteredCompanyNames");
      }
    } else if (widget.commingfFrom == 'sub') {
      filteredCompanyNames = widget.companyNames.where((companyName) {
        return widget.showInteractiveSurvey1.any((surveyData) =>
            surveyData['child_category'].split(' /')?.first ==
                widget.selectedSubcategory &&
            surveyData['company_name'] == companyName);
      }).toList();
      if (kDebugMode) {
        print('filtered company found is $filteredCompanyNames');
      }
    } else if (widget.commingfFrom == 'sub_sub') {
      if (kDebugMode) {
        print('im in sub_sub');
      }

      log(widget.selectedSubcategory);
      filteredCompanyNames = widget.companyNames.where((companyName) {
        return widget.showInteractiveSurvey1.any((surveyData) {
          // Splitting child_category based on '/'
          List<String> categories = surveyData['child_category'].split('/ ');

          // Getting the last part after the last '/'
          String lastCategory = categories.last.trim();

          return lastCategory == widget.selectedSubcategory &&
              surveyData['company_name'] == companyName;
        });
      }).toList();
      if (kDebugMode) {
        print('filtered company found is $filteredCompanyNames');
      }
    }

    log("jjj232matchinsurv: ${widget.matchinSurvey}");
  }

  @override
  Widget build(BuildContext context) {
    log('not delayed ${[widget.selectedSubcategory]}');
    return Scaffold(
      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConst.bgPrimary),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MySize.scaleFactorHeight * 20,
            ),
            Text(
              widget.commingfFrom == 'main'
                  ? "Interactive Surveys ${widget.imageorVideo} / ${widget.parentCatName}"
                      .tr()
                  : "Interactive Surveys ${widget.imageorVideo} / ${widget.parentCatName} / ${widget.selectedSubcategory}"
                      .tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MySize.size20,
                fontWeight: FontWeight.w500,
                fontFamily: AppConst.primaryFont,
                color: AppColors.secondaryColor,
              ),
            ),
            SizedBox(
              height: MySize.scaleFactorHeight * 20,
            ),
            widget.matchinSurvey.isNotEmpty
                ? Expanded(
                    child: Container(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: widget.matchinSurvey.length,
                        itemBuilder: (context, index) {
                          if (kDebugMode) {
                            print("jj34233333: ${widget.matchinSurvey}");
                          }

                          return GestureDetector(
                            onTap: () async {
                              var surpoints =
                                  widget.matchinSurvey[index]['survey_points'];
                              //  bool isGift = surpoints == 0 ? true : false;
                              bool isGift = false;

                              showDialogBox(
                                  context,
                                  isGift,
                                  widget.matchinSurvey[index],
                                  pageController,
                                  widget.onCompanySelected);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: MySize.size10),
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
                                borderRadius:
                                    BorderRadius.circular(MySize.size12),
                              ),
                              child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        text: widget.matchinSurvey[index]
                                            ['company_name'],
                                        fontSize: MySize.size14,
                                        fontFamily: AppConst.primaryFont,
                                        fontWeight: FontWeight.w600,
                                        fontColor: AppColors.whiteColor,
                                      ),
                                      CircleAvatar(
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          child: widget.matchinSurvey[index]
                                                      ['survey_points'] !=
                                                  "0"
                                              ? Text(
                                                  '${widget.matchinSurvey[index]['survey_points'] ?? 0}',
                                                  style: const TextStyle(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                )
                                              : const Icon(
                                                  CupertinoIcons.gift,
                                                  color: Colors.yellow,
                                                )),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichTextHelperCategory(
                                        firstText: 'Survey Title: ',
                                        secondText:
                                            '${widget.matchinSurvey[index]['title']}',
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: Text(
                        'No companies found',
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppConst.primaryFont),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
