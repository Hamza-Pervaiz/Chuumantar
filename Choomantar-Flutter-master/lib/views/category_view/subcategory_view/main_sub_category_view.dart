import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import'package:flutter/material.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_const.dart';
import '../../../res/reponsive_size.dart';
import '../../../res/utils/CommonFuncs.dart';
import 'child_categories.dart';
import '../parent_category_view/listofcompanynamesformaincategory.dart';
import '../parent_category_view/listofsurveycompformaincategory.dart';


class MainSubCategoryView extends StatefulWidget {
  final List<dynamic> subcategoryNames;
  final List<dynamic> surveyData;
  var matchingCompanies;
  String selectedCategory ='';
  //final Future<List<dynamic>> showInteractiveSurvey;
  List<String> companyNames;
  List<dynamic> showInteractiveSurvey1;

 MainSubCategoryView({super.key, required this.subcategoryNames,required this.surveyData,required this.matchingCompanies,required this.companyNames,required this.showInteractiveSurvey1,required this.selectedCategory});

  @override
  State<MainSubCategoryView> createState() => _MainSubCategoryViewState();
}

class _MainSubCategoryViewState extends State<MainSubCategoryView> {
  String onSubCategorySelected='';
  String selectedCompany='';
  int selectedIndex = 0;
  PageController pageController = PageController();
  List<dynamic> matchingSurveys = [];
  Set<String> uniqueSurveyIds = Set();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFuncs.showToast("main_sub_category_view MainSubCategoryView");
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
                    SubCategoryNamesView(
                      selectedCategory: widget.selectedCategory,
                    subcategoryNames: widget.subcategoryNames,
                    surveyData: widget.surveyData,
                    matchingCompanies: widget.matchingCompanies,
                    companyNames: widget.companyNames,
                    showInteractiveSurvey1: widget.showInteractiveSurvey1,
                    onNextPagePressed: (String subcategoryselected) {
                                setState(() {
                                  onSubCategorySelected = subcategoryselected;

                                  if (kDebugMode) {
                                    print("jselectedsubcatname: $onSubCategorySelected");
                                    print("jselectedsubcatname: ${widget.matchingCompanies}");
                                  }
                                           });

                                var matchingCompanies = widget.showInteractiveSurvey1
                                    .where((surveyData) =>
                                surveyData['parent_category'] == widget.selectedCategory &&
                                    surveyData['child_category'] == subcategoryselected)
                                    .map((surveyData) => surveyData['company_name'])
                                    .toList();

                                for (int index = 0; index < matchingCompanies.length; index++) {
                                  var surveysToAdd = widget.showInteractiveSurvey1
                                      .where((surveyData) =>
                                  surveyData['company_name'] == matchingCompanies[index] &&
                                      surveyData['parent_category'] == widget.selectedCategory &&
                                      surveyData['child_category'] == subcategoryselected)
                                      .toList();

                                  for (var survey in surveysToAdd) {
                                    String surveyId = survey['survey_id'];
                                    if (!uniqueSurveyIds.contains(surveyId)) {
                                      matchingSurveys.add(survey);
                                      uniqueSurveyIds.add(surveyId);
                                    }
                                  }
                                }

                                if (kDebugMode) {
                                  print("j00700890000 matchinsurv: $matchingSurveys");
                                }

                      pageController.nextPage(
                        duration: const Duration(microseconds: 1),
                        curve: Curves.linear,
                      );
                    },
                  ),

                      ListOfCompanyNames(
                        commingfFrom: 'sub',
                        selectedSubcategory: onSubCategorySelected,
                        matchinSurvey: matchingSurveys,
                        parentCatName: widget.selectedCategory,
                        companyNames: widget.companyNames,
                        onCompanySelected: (companyName, index) {
                          setState(() {
                            selectedCompany = companyName;
                            selectedIndex = index;
                            if (kDebugMode) {
                              print("jjjselection: selected company $companyName");
                              print("jjjselection: selected index $index");
                            }
                          });
                          pageController.nextPage(
                            duration: const Duration(microseconds: 1),
                            curve: Curves.linear,
                          );
                        },
                        showInteractiveSurvey1: widget.showInteractiveSurvey1,
                      ),
                      ListOfSurveyComp(
                        onGoBack: (action){

                          if (kDebugMode) {
                            print("jjjactioninsub: $action");
                          }

                          if(action == "dontremove")
                            {
                              pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          else
                            {
                              setState(() {
                                matchingSurveys.removeAt(selectedIndex);
                              });

                              pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }

                        },
                        matchinSurvey: matchingSurveys,
                        whereufrom: 'sub',
                        selectedIndex: selectedIndex,
                        selectedSubcategory: onSubCategorySelected,
                        selectedCompany: selectedCompany,
                        selectedCategoryName: widget.selectedCategory,
                        showInteractiveSurvey1: widget.showInteractiveSurvey1,
                      ),
                  ],
                  ),
                ),
              ],
            ),
        ),
        ),
      );
  }
}