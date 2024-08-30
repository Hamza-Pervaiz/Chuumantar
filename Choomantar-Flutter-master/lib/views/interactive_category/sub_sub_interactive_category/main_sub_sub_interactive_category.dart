import 'dart:developer';

import 'package:chumanter/views/interactive_category/main_interactive_category_view/listof_company_names_interactive.dart';
import 'package:chumanter/views/interactive_category/main_interactive_category_view/listof_surveycompinteractive.dart';
import 'package:chumanter/views/interactive_category/sub_sub_interactive_category/sub_sub_category_view_interactive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_const.dart';
import '../../../res/reponsive_size.dart';
import '../../general_profile/general_profile.dart';

class MainSub_SubCategoryViewInteractive extends StatefulWidget {
  final List<dynamic> subSubCategoryData;
  final List<dynamic> surveyData;
  var matchingCompanies;
  List<String> companyNames;
  final List<dynamic> showInteractiveSurvey1;
  // final Future<List<dynamic>> showInteractiveSurvey;
  String selectedCategory = '';
  String selectedSurveyType = '';
  String selectedSubCategory;
  String? imageorVideo;

  MainSub_SubCategoryViewInteractive({
    super.key,
    required this.subSubCategoryData,
    required this.matchingCompanies,
    required this.surveyData,
    required this.showInteractiveSurvey1,
    required this.companyNames,
    required this.selectedCategory,
    required this.selectedSurveyType,
    required this.selectedSubCategory,
    this.imageorVideo,
  });

  @override
  State<MainSub_SubCategoryViewInteractive> createState() =>
      _MainSub_SubCategoryViewInteractiveState();
}

class _MainSub_SubCategoryViewInteractiveState
    extends State<MainSub_SubCategoryViewInteractive> {
  PageController pageController = PageController();
  String onSubSubCategorySelected = '';
  String selectedCompany = '';
  String? imagePath;
  int selectedIndex = 0;
  List<dynamic> matchingSurveys = [];
  Set<String> uniqueSurveyIds = Set();

  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('user_image'); // Load the image path
    });
  }

  @override
  void initState() {
    _loadUserImage();
    super.initState();

    log("showinteractive: ${widget.showInteractiveSurvey1}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (pageController.page == 0) {
          return true;
        } else {
          pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          return false;
        }
      },
      child: Scaffold(
        body: Container(
          height: MySize.screenHeight,
          width: MySize.screenWidth,
          padding: EdgeInsets.only(
            left: MySize.size20,
            right: MySize.size20,
            top: MySize.size20,
          ),
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
                height: MySize.scaleFactorHeight * 56,
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: const Icon(
                          CupertinoIcons.line_horizontal_3_decrease,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        AppConst.logo,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GeneralProfileView(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: MySize.size20,
                        backgroundImage: imagePath != null &&
                                imagePath!.isNotEmpty
                            ? NetworkImage(imagePath!) as ImageProvider
                            : const AssetImage(AppConst.hi4), // Default image
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SubSubCategoryViewInteractive(
                    imageorVideo: widget.imageorVideo,
                    selectedSurveyType: widget.selectedSurveyType,
                    selectedCategory: widget.selectedCategory,
                    selectedSubCategory: widget.selectedSubCategory,
                    subSubCategoryData: widget.subSubCategoryData,
                    matchingCompanies: widget.matchingCompanies,
                    surveyData: widget.surveyData,
                    showInteractiveSurvey1: widget.showInteractiveSurvey1,
                    companyNames: widget.companyNames,
                    onNextPagePressed: (n) async {
                      setState(() {
                        onSubSubCategorySelected = n;
                      });

                      var matchingCompanies = widget.showInteractiveSurvey1
                          .where((surveyData) =>
                              surveyData['parent_category'] ==
                                  widget.selectedCategory &&
                              surveyData['survey_type'] ==
                                  widget.selectedSurveyType &&
                              surveyData['child_category']
                                  .toString()
                                  .contains(onSubSubCategorySelected))
                          .map((surveyData) => surveyData['company_name'])
                          .toList();

                      print("jjjmatchingcompanies: ${matchingCompanies}");

                      List surveystoAdd = [];

                      for (int index = 0;
                          index < matchingCompanies.length;
                          index++) {
                        List surveysForCompany = widget.showInteractiveSurvey1
                            .where((surveyData) =>
                                surveyData['company_name'] ==
                                    matchingCompanies[index] &&
                                surveyData['parent_category'] ==
                                    widget.selectedCategory &&
                                surveyData['child_category']
                                    .toString()
                                    .contains(onSubSubCategorySelected) &&
                                surveyData['survey_type'] ==
                                    widget.selectedSurveyType)
                            .toList();
                        surveystoAdd.addAll(surveysForCompany);
                      }

                      log("jjjsurveystoadd: ${surveystoAdd}");

                      uniqueSurveyIds.clear();
                      matchingSurveys.clear();

                      for (var survey in surveystoAdd) {
                        String surveyId = survey['survey_id'];
                        log("surveyid: ${surveyId}");

                        if (!uniqueSurveyIds.contains(surveyId)) {
                          matchingSurveys.add(survey);
                          uniqueSurveyIds.add(surveyId);
                        }
                      }

                      log("jjjjmatchin: ${matchingSurveys}");

                      pageController.nextPage(
                        duration: const Duration(microseconds: 1),
                        curve: Curves.linear,
                      );
                    },
                  ),
                  ListOfCompanyNamesInteractive(
                    parentCatName: widget.selectedCategory,
                    matchinSurvey: matchingSurveys,
                    selectedSurveyType: widget.selectedSurveyType,
                    commingfFrom: 'sub_sub',
                    imageorVideo: widget.imageorVideo,
                    selectedSubCat: widget.selectedSubCategory,
                    selectedSubcategory: onSubSubCategorySelected,
                    companyNames: widget.companyNames,
                    onCompanySelected: (companyName, index) async {
                      setState(() {
                        selectedCompany = companyName;
                        selectedIndex = index;
                      });
                      await pageController.nextPage(
                        duration: const Duration(microseconds: 1),
                        curve: Curves.linear,
                      );
                    },
                    showInteractiveSurvey1: widget.showInteractiveSurvey1,
                  ),
                  ListOfSurveyCompInteractive(
                    onGoBack: (action) {},
                    matchinSurvey: matchingSurveys,
                    whereufrom: 'sub_sub',
                    selectedSubcategory: onSubSubCategorySelected,
                    selectedCompany: selectedCompany,
                    selectedCategoryName: widget.selectedCategory,
                    showInteractiveSurvey1: widget.showInteractiveSurvey1,
                    selectedIndex: selectedIndex,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
