import 'dart:developer';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/interactive_category/main_interactive_category_view/listof_surveycompinteractive.dart';
import 'package:chumanter/views/interactive_category/sub_interactive_category/main_sub_interactive_category_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'category_comp_interactive.dart';
import 'listof_company_names_interactive.dart';
import 'most_parent_choose_survey_type.dart';

class MainInteractiveView extends StatefulWidget {
  const MainInteractiveView({super.key});

  @override
  State<MainInteractiveView> createState() => _MainInteractiveViewState();
}

class _MainInteractiveViewState extends State<MainInteractiveView> {
  var showMyCategory;

  String selectedCompany = "";
  int surveyIndex = 0;
  List<String> companyNames = [];
  int selectedCategoryIndex = 0;
  String selectedCategoryName = '';
  late Future<List<dynamic>> showInteractiveSurvey = showInteractiveSurveyApi();
  List categoryItems = [];
  late Future<List<dynamic>> categoryItemss;
  List<dynamic> showInteractiveSurvey1 = [];

  @override
  void initState() {
    super.initState();

    getPreff().then((value) {
      categoryItemss = showMyCategoryApi();
      showInteractiveSurvey = showInteractiveSurveyApi();
    });

    CommonFuncs.showToast(
        "main_interactive_category_view\nMainInteractiveView");
  }

  PageController surveyPageController = PageController();
  PageController pageController = PageController();
  List tapedIndex = [];
  List imagesList = [];
  String notfound = 'No surveys are available right now.'.tr();
  String tapedCateg = '';
  String selectedSurveyType = '';
  String selectedSurveyType2 = '';
  String imageorVideo = '';
  List<dynamic> matchingSurveys = [];
  Set<String> uniqueSurveyIds = Set();
  int namesLength = 0;
  Set<String> names = {};

  Future<List<dynamic>> showMyCategoryApi() async {
    var response = await http.post(Uri.parse(AppUrls.myCategory), body: {
      "User_Id": preff!.get('uid').toString(),
    });

    try {
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter(
            "200",
            AppUrls.myCategory,
            "POST",
            "User_Id: ${preff!.get('uid').toString()}",
            data,
            "main_interactive_category_view");

        if (data['data'] is List) {
          log(data.toString());
          categoryItems = List.from(data['data']);

          categoryItems.forEach((category) {
            if (category['name'] != null) {
              names.add(category['name']);
              namesLength = names.length;
            }
          });

          imagesList = categoryItems.map((category) {
            if (category['product_image'] != null) {
              return category['product_image'];
            } else {
              return "https://dreammerchants.tech/ajax/uploads/soccer-football-soccer-player-sport-159684.jpeg/sc4.png";
            }
          }).toList();
          setState(() {});
          return categoryItems;
        } else {
          log("Invalid data format received from the API.");
          return [];
        }
      } else {
        CommonFuncs.apiHitPrinter(
            response.statusCode.toString(),
            AppUrls.myCategory,
            "POST",
            "User_Id: ${preff!.get('uid').toString()}",
            data,
            "main_interactive_category_view");

        log("Failed to fetch data from the API. Status code: ${response.statusCode}");

        return [];
      }
    } catch (e) {
      log("Error is $e");
      return ["zero", response.statusCode.toString()];
    }
  }

  Future<List<dynamic>> showInteractiveSurveyApi() async {
    try {
      var response = await http.post(
        Uri.parse(AppUrls.interactiveApi),
        body: {
          "userId": preff!.getString('uid').toString(),
        },
      );
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter(
            "200",
            AppUrls.interactiveApi,
            "POST",
            "userId: ${preff!.getString('uid').toString()}",
            data,
            "main_interactive_category_view");
        //   log("Data from API: $data");

        List<String> companies = [];

        for (var surveyData in data) {
          companies.add(surveyData['company_name']);
        }
        setState(() {
          companyNames = companies;
          if (kDebugMode) {
            print("jjjcompanies 1   $companyNames");
          }
        });
        showInteractiveSurvey1.clear();
        showInteractiveSurvey1 = data;
        return showInteractiveSurvey1;
      } else {
        CommonFuncs.apiHitPrinter(
            response.statusCode.toString(),
            AppUrls.interactiveApi,
            "POST",
            "userId: ${preff!.getString('uid').toString()}",
            data,
            "main_interactive_category_view");

        log("Failed to fetch data from the API. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      log("Error is $e");
      return [];
    }
  }

  Future<List<dynamic>> subCategoryApi() async {
    try {
      var response = await http.post(
        Uri.parse(AppUrls.subCategory),
        body: {
          "User_Id": preff!.getString('uid').toString(),
          "parentcatname": selectedCategoryName,
        },
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter(
            "200",
            AppUrls.subCategory,
            "POST",
            "User_Id: ${preff!.getString('uid').toString()}\nparentcatname: $selectedCategoryName",
            data,
            "main_interactive_category_view");

        if (data['products'] is List) {
          List<dynamic> subcategoryData = data['products'];
          log("Subcategory Data from API: $data");
          progressDialog?.hide();
          return subcategoryData; // Return the subcategory data
        } else {
          log("Invalid data format received from the subcategory API.");
        }
      } else {
        CommonFuncs.apiHitPrinter(
            response.statusCode.toString(),
            AppUrls.subCategory,
            "POST",
            "User_Id: ${preff!.getString('uid').toString()}\nparentcatname: $selectedCategoryName",
            data,
            "main_interactive_category_view");

        log("Failed to fetch data from the subcategory API. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("Error is $e");
    }

    return [];
  }

  String? imagePath;
  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('user_image'); // Load the image path
    });
  }

  ProgressDialog? progressDialog;
  SharedPreferences? preff;

  Future getPreff() async {
    preff = await SharedPreferences.getInstance();
    _loadUserImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
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
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsView())),
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
                    selectImageOrVideoSurvey(
                      onSurveySelected: (String surveyType) {
                        setState(() {
                          if (kDebugMode) {
                            print('select survey type is: $surveyType');
                          }

                          if (surveyType == 'image_survey') {
                            imageorVideo = " / Picture Survey";
                          } else if (surveyType == 'video_survey') {
                            imageorVideo = " / Video Survey";
                          }
                          //   surveyType == 'image_survey' ? imageorVideo = " / Picture Survey" : " / Video Survey";
                          selectedSurveyType = surveyType;
                        });
                        pageController.nextPage(
                          duration: const Duration(microseconds: 1),
                          curve: Curves.linear,
                        );
                      },
                      totalCats: namesLength,
                    ),
                    CategoryCompInteractive(
                      showInteractiveSurvey: showInteractiveSurvey,
                      imageorVideo: imageorVideo,
                      selectedSurveyType: selectedSurveyType,
                      categoryItems: categoryItemss,
                      onCategorySelected: (categoryName) async {
                        preff?.setString(
                            'product_id',
                            categoryItems[selectedCategoryIndex]['id']
                                .toString());
                        selectedCategoryName = categoryName;

                        if (kDebugMode) {
                          print(
                              'selectedCategoryname is : $selectedCategoryName');
                        }

                        progressDialog = ProgressDialog(context,
                            type: ProgressDialogType.normal,
                            isDismissible: false);
                        progressDialog?.style(
                          textAlign: TextAlign.center,
                          message: 'Loading data'.tr(),
                          elevation: 10,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          messageTextStyle: const TextStyle(
                            color: AppColors.purpleColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                        progressDialog?.show();

                        var subcategoryData = await subCategoryApi();
                        progressDialog?.hide(); // Hide progress dialog

                        if (subcategoryData.isNotEmpty) {
                          var surveyDataList = await showInteractiveSurvey;

                          var matchingSubcategories = subcategoryData
                              .where((subcategory) => surveyDataList.any(
                                  (surveyData) =>
                                      surveyData['child_category']
                                          .split('/')
                                          .first
                                          .trim() ==
                                      subcategory['name']))
                              .toList();

                          var matchingCompanies = matchingSubcategories
                              .map((subcategory) {
                                var matchingSurveyData = surveyDataList
                                    .where((surveyData) =>
                                        surveyData['child_category']
                                            .split('/')
                                            .first
                                            .trim() ==
                                        subcategory['name'])
                                    .toList();

                                var matchingCompaniesForSubcategory =
                                    matchingSurveyData
                                        .map<String>((surveyData) =>
                                            surveyData['company_name'])
                                        .toList();
                                return matchingCompaniesForSubcategory
                                        .isNotEmpty
                                    ? matchingCompaniesForSubcategory
                                    : null;
                              })
                              .where((companies) => companies != null)
                              .expand<String>((companies) => companies!)
                              .toSet()
                              .toList();

                          setState(() {
                            companyNames = matchingCompanies
                                .map((company) => company.toString())
                                .toList();
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MainSubCategoryViewInteractive(
                                subcategoryNames: subcategoryData,
                                surveyData: surveyDataList,
                                matchingCompanies: matchingCompanies,
                                companyNames: companyNames,
                                showInteractiveSurvey1: showInteractiveSurvey1,
                                selectedCategory: selectedCategoryName,
                                selectedSurveytype: selectedSurveyType,
                                imageorVideo: imageorVideo,
                              ),
                            ),
                          );
                        } else {
                          //   var surveyDataList = await showInteractiveSurvey;
                          matchingSurveys.clear();
                          uniqueSurveyIds.clear();

                          var matchingCompanies = showInteractiveSurvey1
                              .where((surveyData) =>
                                  surveyData['parent_category'] ==
                                      selectedCategoryName &&
                                  surveyData['survey_type'] ==
                                      selectedSurveyType)
                              .map((surveyData) => surveyData['company_name'])
                              .toList();

                          log('matching company found is : $matchingCompanies');
                          log('matching company found is: $selectedSurveyType');

                          for (int index = 0;
                              index < matchingCompanies.length;
                              index++) {
                            var surveysToAdd = showInteractiveSurvey1
                                .where((surveyData) =>
                                    surveyData['company_name'] ==
                                        matchingCompanies[index] &&
                                    surveyData['parent_category'] ==
                                        selectedCategoryName &&
                                    surveyData['survey_type'] ==
                                        selectedSurveyType)
                                .toList();

                            for (var survey in surveysToAdd) {
                              String surveyId = survey['survey_id'];
                              if (!uniqueSurveyIds.contains(surveyId)) {
                                matchingSurveys.add(survey);
                                uniqueSurveyIds.add(surveyId);
                              }
                            }
                          }

                          log("jjjjinteractivematchingsurv: $matchingSurveys");

                          if (matchingCompanies.isNotEmpty) {
                            setState(() {
                              companyNames = matchingCompanies
                                  .map((company) => company.toString())
                                  .toList();
                            });
                            pageController
                                .nextPage(
                                  duration: const Duration(microseconds: 1),
                                  curve: Curves.linear,
                                )
                                .then((value) =>
                                    showMyCategory = showMyCategoryApi());
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return validationDialog(context,
                                      isTitle: true,
                                      title: TextWidget(
                                        text: notfound.tr(),
                                        fontSize: MySize.size16,
                                        fontColor: AppColors.redColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      oprText: selectedCategoryName.tr(),
                                      ontap: () {
                                    Navigator.pop(context);
                                  });
                                });
                          }
                        }
                      },
                    ),
                    ListOfCompanyNamesInteractive(
                      parentCatName: selectedCategoryName,
                      imageorVideo: imageorVideo,
                      matchinSurvey: matchingSurveys,
                      commingfFrom: 'main',
                      selectedSubcategory: selectedCategoryName,
                      selectedSurveyType: selectedSurveyType,
                      companyNames: companyNames,
                      onCompanySelected: (companyName, index) {
                        setState(() {
                          selectedCompany = companyName;
                          surveyIndex = index;
                        });
                        pageController.nextPage(
                          duration: const Duration(microseconds: 1),
                          curve: Curves.linear,
                        );
                      },
                      showInteractiveSurvey1: showInteractiveSurvey1,
                    ),
                    ListOfSurveyCompInteractive(
                      onGoBack: (action) {
                        if (action == "dontremove") {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        } else {
                          setState(() {
                            matchingSurveys.removeAt(surveyIndex);
                          });

                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      matchinSurvey: matchingSurveys,
                      selectedIndex: surveyIndex,
                      whereufrom: 'main',
                      selectedSubcategory: 'main',
                      selectedCompany: selectedCompany,
                      selectedCategoryName: selectedCategoryName,
                      showInteractiveSurvey1: showInteractiveSurvey1,
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
