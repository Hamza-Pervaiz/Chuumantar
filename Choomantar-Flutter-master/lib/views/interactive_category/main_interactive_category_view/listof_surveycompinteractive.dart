import 'dart:developer';

import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/interactive_category/main_interactive_category_view/survey_page_interactive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_const.dart';
import '../../../res/reponsive_size.dart';
import '../../../widgets/text_widget.dart';

class ListOfSurveyCompInteractive extends StatefulWidget {
  final String selectedCompany;
  final int selectedIndex;
  final String selectedCategoryName;
  // final Future<List<dynamic>> showInteractiveSurvey;
  final String selectedSubcategory;
  final Function(String) onGoBack;
  String whereufrom;
  List<dynamic> showInteractiveSurvey1;
  List<dynamic> matchinSurvey;

  ListOfSurveyCompInteractive(
      {super.key,
      required this.selectedCompany,
      required this.selectedCategoryName,
      required this.showInteractiveSurvey1,
      required this.selectedSubcategory,
      required this.onGoBack,
      required this.whereufrom,
      required this.selectedIndex,
      required this.matchinSurvey});

  @override
  State<ListOfSurveyCompInteractive> createState() =>
      _ListOfSurveyCompInteractiveState();
}

class _ListOfSurveyCompInteractiveState
    extends State<ListOfSurveyCompInteractive> {
  PageController surveyPageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFuncs.showToast(
        "listof_surveycompinteractive\nListOfSurveyCompInteractive");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          text: "Surveys for ${widget.selectedCompany}",
          fontSize: MySize.size20,
          fontColor: AppColors.primaryColor,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(
          height: MySize.scaleFactorHeight * 20,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            child: FutureBuilder(
              future: Future.value(widget.matchinSurvey),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.whiteColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return TextWidget(
                    text: "Error: ${snapshot.error}",
                    fontSize: MySize.size20,
                    fontWeight: FontWeight.w700,
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  //  List<dynamic> filteredSurveys;
                  List<dynamic> matchsurvey = snapshot.data!;
                  List<Map<String, dynamic>> filteredSurveys;
                  Map<String, dynamic> surveyMap = {};

                  if (widget.whereufrom == 'main') {
                    // filteredSurveys = snapshot.data!
                    //     .where((surveyData) =>
                    // surveyData['company_name'] == widget.selectedCompany &&
                    //     surveyData['parent_category'] ==
                    //         widget.selectedCategoryName)
                    //     .toList();

                    filteredSurveys =
                        matchsurvey.toList().cast<Map<String, dynamic>>();

                    surveyMap = filteredSurveys.elementAt(widget.selectedIndex);

                    log("jjjfilteredsurv: $filteredSurveys");
                  } else if (widget.whereufrom == 'sub') {
                    // filteredSurveys = snapshot.data!
                    //     .where((surveyData) =>
                    // surveyData['company_name'] == widget.selectedCompany &&
                    //     surveyData['child_category'] ==
                    //         widget.selectedSubcategory)
                    //     .toList();

                    filteredSurveys =
                        matchsurvey.toList().cast<Map<String, dynamic>>();
                    surveyMap = filteredSurveys.elementAt(widget.selectedIndex);
                    log("jjjfilteredsurv: $filteredSurveys");
                  } else {
                    // filteredSurveys = snapshot.data!
                    //     .where((surveyData) =>
                    // surveyData['company_name'] == widget.selectedCompany &&
                    //     surveyData['child_category']?.split('/ ')?.last ==
                    //         widget.selectedSubcategory)
                    //     .toList();

                    filteredSurveys =
                        matchsurvey.toList().cast<Map<String, dynamic>>();
                    surveyMap = filteredSurveys.elementAt(widget.selectedIndex);
                    log("jjjfilteredsurv: $filteredSurveys");
                  }
                  if (filteredSurveys.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(MySize.size20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              image: const DecorationImage(
                                image: AssetImage(AppConst.eyeBg),
                                fit: BoxFit.cover,
                              ),
                            ),
                            padding: EdgeInsets.all(
                                MySize.size16), // Reduced padding

                            child: Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Makes the column only as tall as its children
                              children: [
                                Image.asset(
                                  "assets/images/thumbIcon.png",
                                  width: 200,
                                  height: 50,
                                  // Other properties as needed
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'No survey found for ${widget.selectedCompany}. Come back later...',
                                  style: TextStyle(
                                    color: AppColors.blueColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: MySize.size14,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondaryColor,
                                    foregroundColor: Colors.black,
                                    elevation: 7,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(MySize.size8),
                                    ),
                                  ),
                                  child: Text(
                                    'Ok'.tr(),
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

                  int currentSurveyIndex = 0;

                  return PageView.builder(
                    controller: surveyPageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredSurveys.length,
                    itemBuilder: (context, index) {
                      return SurveyPageInteractive(
                        onGoBack: (action) {
                          widget.onGoBack(action);
                        },
                        surveyData: surveyMap,
                        onPageFinished: () {
                          setState(() {
                            currentSurveyIndex = index + 1;
                          });

                          surveyPageController.animateToPage(
                            currentSurveyIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                        allSurveyData: filteredSurveys,
                      );
                    },
                  );
                } else {
                  return TextWidget(
                    text: "No data available.",
                    fontSize: MySize.size20,
                    fontWeight: FontWeight.w700,
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
