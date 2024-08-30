import 'dart:developer';

import 'package:chumanter/views/category_view/sub_sub_category_view/sub_child_categories_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_const.dart';
import '../../../res/reponsive_size.dart';
import '../../../res/utils/CommonFuncs.dart';
import '../parent_category_view/listofcompanynamesformaincategory.dart';
import '../parent_category_view/listofsurveycompformaincategory.dart';

class MainSub_SubCategoryView extends StatefulWidget {
  final List<dynamic> subSubCategoryData;
  final List<dynamic> surveyData;
  var matchingCompanies;
  List<String> companyNames;
  //final Future<List<dynamic>> showInteractiveSurvey;
  List<dynamic> showInteractiveSurvey1;
  String selectedCategory = '';
  String selectedSubCategory;

  MainSub_SubCategoryView({
    super.key,
    required this.subSubCategoryData,
    required this.matchingCompanies,
    required this.surveyData,
    required this.showInteractiveSurvey1,
    required this.companyNames,
    required this.selectedCategory,
    required this.selectedSubCategory,
  });

  @override
  State<MainSub_SubCategoryView> createState() =>
      _MainSub_SubCategoryViewState();
}

class _MainSub_SubCategoryViewState extends State<MainSub_SubCategoryView> {
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
    CommonFuncs.showToast("main_sub_sub_category_view MainSub_SubCategoryView");
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
                  SubSubCategoryView(
                    selectedCategory: widget.selectedCategory,
                    selectedSubCategory: widget.selectedSubCategory,
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
                          log("surveyid: ${surveyId}");
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
                  ListOfCompanyNames(
                    parentCatName: widget.selectedCategory,
                    matchinSurvey: matchingSurveys,
                    commingfFrom: 'sub_sub',
                    selectedSubcategory: onSubSubCategorySelected,
                    selectedSubCat: widget.selectedSubCategory,
                    companyNames: widget.companyNames,
                    onCompanySelected: (companyName, index) async {
                      setState(() {
                        selectedCompany = companyName;
                        selectedIndex = index;

                        print("jjjselectedcomp: ${selectedCompany}");
                        print("jjjselectedcomp: ${selectedIndex}");
                      });
                      await pageController.nextPage(
                        duration: const Duration(microseconds: 1),
                        curve: Curves.linear,
                      );
                    },
                    showInteractiveSurvey1: widget.showInteractiveSurvey1,
                  ),
                  ListOfSurveyComp(
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
