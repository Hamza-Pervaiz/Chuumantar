
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/interactive_category/main_interactive_category_view/listof_surveycompinteractive.dart';
import 'package:chumanter/views/interactive_category/sub_interactive_category/sub_interactive_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_const.dart';
import '../../../res/reponsive_size.dart';
import '../../general_profile/general_profile.dart';
import '../main_interactive_category_view/listof_company_names_interactive.dart';



class MainSubCategoryViewInteractive extends StatefulWidget {
  final List<dynamic> subcategoryNames;
  final List<dynamic> surveyData;
  var matchingCompanies;
  List<String> companyNames;
  String selectedCategory ='';
String selectedSurveytype='';
String? imageorVideo;
final List<dynamic> showInteractiveSurvey1;

 // final Future<List<dynamic>> showInteractiveSurvey;
  MainSubCategoryViewInteractive({super.key,
    required this.subcategoryNames,
    required this.surveyData
    ,required this.matchingCompanies,
    required this.companyNames,
    required this.showInteractiveSurvey1,
    required this.selectedCategory,
    required this.selectedSurveytype,
    this.imageorVideo
  }

      );

  @override
  State<MainSubCategoryViewInteractive> createState() => _MainSubCategoryViewInteractiveState();
}

class _MainSubCategoryViewInteractiveState extends State<MainSubCategoryViewInteractive> {

  String onSubCategorySelected='';
  String selectedCompany='';
  int selectedIndex = 0;
  PageController pageController = PageController();
  String? imagePath;
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
    CommonFuncs.showToast("main_sub_interactive_category_view\nMainSubCategoryViewInteractive");
    super.initState();
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
                        backgroundImage: imagePath != null && imagePath!.isNotEmpty
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
                    SubCategoryNamesViewInteractive(
                      selectedSurveyType: widget.selectedSurveytype,
                      selectedCategory: widget.selectedCategory,
                      subcategoryNames: widget.subcategoryNames,
                      surveyData: widget.surveyData,
                      imageorVideo: widget.imageorVideo,
                      matchingCompanies: widget.matchingCompanies,
                      companyNames: widget.companyNames,
                      showInteractiveSurvey1: widget.showInteractiveSurvey1,
                      onNextPagePressed: (String subcategoryselected) {
                        setState(() {
                          onSubCategorySelected = subcategoryselected;
                        });


                        var matchingCompanies = widget.showInteractiveSurvey1
                            .where((surveyData) =>
                        surveyData['parent_category'] == widget.selectedCategory &&
                            surveyData['child_category'] == subcategoryselected && surveyData['survey_type'] == widget.selectedSurveytype)
                            .map((surveyData) => surveyData['company_name'])
                            .toList();

                        for (int index = 0; index < matchingCompanies.length; index++) {
                          var surveysToAdd = widget.showInteractiveSurvey1
                              .where((surveyData) =>
                          surveyData['company_name'] == matchingCompanies[index] &&
                              surveyData['parent_category'] == widget.selectedCategory &&
                              surveyData['child_category'] == subcategoryselected && surveyData['survey_type'] == widget.selectedSurveytype)
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

                    ListOfCompanyNamesInteractive(
selectedSurveyType: widget.selectedSurveytype,
                      commingfFrom: 'sub',
                      selectedSubcategory: onSubCategorySelected,
                      companyNames: widget.companyNames,
                      matchinSurvey: matchingSurveys,
                      parentCatName: widget.selectedCategory,
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

                    ListOfSurveyCompInteractive(
                      onGoBack: (action)
                      {

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
                      whereufrom: 'sub',
                      selectedSubcategory: onSubCategorySelected,
                      selectedCompany: selectedCompany,
                      selectedCategoryName: widget.selectedCategory,
                      showInteractiveSurvey1: widget.showInteractiveSurvey1,
                      selectedIndex: selectedIndex,
                      matchinSurvey: matchingSurveys,
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