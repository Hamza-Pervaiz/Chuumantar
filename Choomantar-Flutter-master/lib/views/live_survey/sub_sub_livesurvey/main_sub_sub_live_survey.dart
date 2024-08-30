import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/live_survey/mainlivesurvey/list_of_company_names_live_survey.dart';
import 'package:chumanter/views/live_survey/mainlivesurvey/list_of_survey_comp_live_survey.dart';
import 'package:chumanter/views/live_survey/sub_sub_livesurvey/sub_sub_live_survey.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_const.dart';
import '../../../res/reponsive_size.dart';

class MainSub_SubCategoryViewLiveSurvey extends StatefulWidget {
  final List<dynamic> subSubCategoryData;
  final List<dynamic> surveyData;
  var matchingCompanies;
  List<String> companyNames;
  //final Future<List<dynamic>> showInteractiveSurvey;
  final List<dynamic> showInteractiveSurvey1;
  String selectedCategory = '';
  String selectedSubcategory;

  MainSub_SubCategoryViewLiveSurvey({
    super.key,
    required this.subSubCategoryData,
    required this.matchingCompanies,
    required this.surveyData,
    required this.showInteractiveSurvey1,
    required this.companyNames,
    required this.selectedCategory,
    required this.selectedSubcategory,
  });

  @override
  State<MainSub_SubCategoryViewLiveSurvey> createState() =>
      _MainSub_SubCategoryViewLiveSurveyState();
}

class _MainSub_SubCategoryViewLiveSurveyState
    extends State<MainSub_SubCategoryViewLiveSurvey> {
  PageController pageController = PageController();
  String onSubSubCategorySelected = '';
  String selectedCompany = '';
  int selectedIndex = 0;
  List<dynamic> matchingSurveys = [];
  Set<String> uniqueSurveyIds = Set();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFuncs.showToast(
        "main_sub_sub_live_survey\nMainSub_SubCategoryViewLiveSurvey");
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
                  ],
                ),
              ),
              Expanded(
                  child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SubSubCategoryViewLiveSurvey(
                    selectedCategory: widget.selectedCategory,
                    selectedSubcategory: widget.selectedSubcategory,
                    subSubCategoryData: widget.subSubCategoryData,
                    matchingCompanies: widget.matchingCompanies,
                    surveyData: widget.surveyData,
                    showInteractiveSurvey1: widget.showInteractiveSurvey1,
                    companyNames: widget.companyNames,
                    onNextPagePressed: (n) {
                      setState(() {
                        onSubSubCategorySelected = n;
                      });

                      var matchingCompanies = widget.showInteractiveSurvey1
                          .where((surveyData) =>
                              surveyData['parent_category'] ==
                                  widget.selectedCategory &&
                              surveyData['child_category']
                                  .toString()
                                  .contains(onSubSubCategorySelected))
                          .map((surveyData) => surveyData['company_name'])
                          .toList();

                      print("jjjmatchincompssubsub: ${matchingCompanies}");

                      for (int index = 0;
                          index < matchingCompanies.length;
                          index++) {
                        var surveysToAdd = widget.showInteractiveSurvey1
                            .where((surveyData) =>
                                surveyData['company_name'] ==
                                    matchingCompanies[index] &&
                                surveyData['parent_category'] ==
                                    widget.selectedCategory &&
                                surveyData['child_category']
                                    .toString()
                                    .contains(onSubSubCategorySelected))
                            .toList();

                        print("jjjsurveystoadd: ${surveysToAdd}");

                        uniqueSurveyIds.clear();
                        matchingSurveys.clear();

                        for (var survey in surveysToAdd) {
                          String surveyId = survey['survey_id'];
                          if (!uniqueSurveyIds.contains(surveyId)) {
                            matchingSurveys.add(survey);
                            uniqueSurveyIds.add(surveyId);
                          }
                        }
                      }

                      pageController.nextPage(
                        duration: const Duration(microseconds: 1),
                        curve: Curves.linear,
                      );
                    },
                  ),
                  ListOfCompanyNamesLiveSurvey(
                    parentCatName: widget.selectedCategory,
                    matchinSurvey: matchingSurveys,
                    commingfFrom: 'sub_sub',
                    selectedSubcategory: onSubSubCategorySelected,
                    selectedSubCat: widget.selectedSubcategory,
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
                  ListOfSurveyCompLiveSurvey(
                    onGoBack: (action) {},
                    matchinSurvey: matchingSurveys,
                    whereufrom: 'sub_sub',
                    selectedIndex: selectedIndex,
                    selectedSubcategory: onSubSubCategorySelected,
                    selectedCompany: selectedCompany,
                    selectedCategoryName: widget.selectedCategory,
                    showInteractiveSurvey1: widget.showInteractiveSurvey1,
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
