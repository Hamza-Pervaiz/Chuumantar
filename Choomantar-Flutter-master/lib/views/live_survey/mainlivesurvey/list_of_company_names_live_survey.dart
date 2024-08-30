import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/views/category_view/rich_text_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_const.dart';
import '../../../res/app_urls.dart';
import '../../../res/reponsive_size.dart';
import '../../../res/utils/CommonFuncs.dart';
import '../../../widgets/text_widget.dart';
import '../../smook_view/smoke_view_for_surveys.dart';

class ListOfCompanyNamesLiveSurvey extends StatefulWidget {
  // final Set<String> companyNames;
  final List<String> companyNames;
  final Function(String, int) onCompanySelected;
  //final Future<List<dynamic>> showInteractiveSurvey;
  List<dynamic> showInteractiveSurvey1;
  List<dynamic> matchinSurvey;
  String selectedSubcategory;
  String? parentCatName;
  String? selectedSubCat;

  String commingfFrom;
  ListOfCompanyNamesLiveSurvey(
      {super.key,
      required this.companyNames,
      required this.onCompanySelected,
      required this.showInteractiveSurvey1,
      required this.selectedSubcategory,
      required this.commingfFrom,
      required this.matchinSurvey,
      this.parentCatName,
      this.selectedSubCat});

  @override
  State<ListOfCompanyNamesLiveSurvey> createState() =>
      _ListOfCompanyNamesLiveSurveyState();
}

class _ListOfCompanyNamesLiveSurveyState
    extends State<ListOfCompanyNamesLiveSurvey> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  //PageController pageController = PageController();
  // Set<String> filteredCompanyNames={};
  List<String> filteredCompanyNames = [];

  // Future<void> _refresh() async {
  //   //await widget.showInteractiveSurvey;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFuncs.showToast(
        "list_of_company_names_live_survey\nListOfCompanyNamesLiveSurvey");

    print("selectedSubCategory: ${widget.selectedSubcategory}");
    print("comingfrom: ${widget.commingfFrom}");

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
                  ? "Live Polls / ${widget.parentCatName}".tr()
                  : widget.commingfFrom == 'sub'
                      ? "Live Polls / ${widget.parentCatName} / ${widget.selectedSubcategory}"
                          .tr()
                      : "Live Polls / ${widget.parentCatName} / ${widget.selectedSubCat} / ${widget.selectedSubcategory}"
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
                      height: MySize.screenHeight * 0.5,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: widget.matchinSurvey.length,
                        itemBuilder: (context, index) {
                          if (kDebugMode) {
                            print("jj34233333: ${widget.matchinSurvey}");
                          }
                          //   var companyName = filteredCompanyNames.elementAt(index);
                          //  print("jjjcompgeneral: ${filteredCompanyNames}");

                          // var matchingSurvey = widget.showInteractiveSurvey1.where(
                          //         (surveyData) =>
                          //     surveyData['company_name'] == companyName &&
                          //         (widget.commingfFrom == 'main' ||
                          //             (widget.commingfFrom == 'sub' &&
                          //                 surveyData['child_category'] == widget.selectedSubcategory) ||
                          //             (widget.commingfFrom == 'sub_sub' &&
                          //                 surveyData['child_category']
                          //                     .split('/ ')
                          //                     ?.last ==
                          //                     widget.selectedSubcategory))).toList();
                          //
                          //
                          // log("jjjmatchingsurvey: ${matchingSurvey.toString()}");

                          return GestureDetector(
                            onTap: () async {
                              await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    insetPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            MySize.scaleFactorWidth * 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(MySize.size16),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(MySize.size20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            MySize.size16),
                                        image: const DecorationImage(
                                          image: AssetImage(AppConst.eyeBg),
                                          fit: BoxFit.scaleDown,
                                          scale: 0.6,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                'assets/images/hi4.png',
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: 80,
                                              ),
                                            ),
                                          ),

                                          //    Image.asset('assets/images/compLogo1.png', width: 65, height: 65),
                                          SizedBox(height: MySize.size19),

                                          TextWidget(
                                            text:
                                                "${"This survey is sponsored by ".tr()}${widget.matchinSurvey[index]["company_name"]}",
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            fontSize: MySize.size18,
                                            fontFamily: AppConst.primaryFont,
                                            fontColor: AppColors.purpleColor,
                                          ),

                                          SizedBox(height: MySize.size18),

                                          ElevatedButton(
                                            onPressed: () async {
                                              //  Navigator.of(context).pop("ok");

                                              if (widget.commingfFrom ==
                                                  'main') {
                                                Navigator.pop(context);
                                                //   Navigator.of(context).pop();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SmokeViewForSurveys()),
                                                );

                                                widget.onCompanySelected(
                                                    widget.matchinSurvey[index]
                                                        ['company_name'],
                                                    index);

                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(builder: (context) => SmokeViewForSurveys()),
                                                // ).then((value){
                                                //   Navigator.pop(context);
                                                //   widget.onCompanySelected(widget.matchinSurvey[index]['company_name'], index);
                                                // });
                                              } else if (widget.commingfFrom ==
                                                  'sub') {
                                                Navigator.pop(context);
                                                //  Navigator.of(context).pop();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SmokeViewForSurveys()),
                                                );

                                                widget.onCompanySelected(
                                                    widget.matchinSurvey[index]
                                                        ['company_name'],
                                                    index);

                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(builder: (context) => SmokeViewForSurveys()),
                                                // ).then((value){
                                                //   Navigator.pop(context);
                                                //   widget.onCompanySelected(widget.matchinSurvey[index]['company_name'], index);
                                                // });
                                              } else if (widget.commingfFrom ==
                                                  'sub_sub') {
                                                Navigator.pop(context);
                                                //   Navigator.of(context).pop();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SmokeViewForSurveys()),
                                                );

                                                widget.onCompanySelected(
                                                    widget.matchinSurvey[index]
                                                        ['company_name'],
                                                    index);

                                                // Navigator.pop(context);
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(builder: (context) => SmokeViewForSurveys()),
                                                // ).then((value){
                                                //   widget.onCompanySelected(widget.matchinSurvey[index]['company_name'], index);
                                                // });
                                              }
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
                                              'Continue'.tr(),
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
