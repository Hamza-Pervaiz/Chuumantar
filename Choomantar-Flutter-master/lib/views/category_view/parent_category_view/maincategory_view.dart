import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'category_comp.dart';
import 'listofcompanynamesformaincategory.dart';
import 'listofsurveycompformaincategory.dart';
import '../subcategory_view/main_sub_category_view.dart';

class MainCategoryView extends StatefulWidget {
  const MainCategoryView({super.key});

  @override
  State<MainCategoryView> createState() => _MainCategoryViewState();
}


class _MainCategoryViewState extends State<MainCategoryView> {
  var showMyCategory;
String notfound='No surveys are available right now.'.tr();
 List<String> companyNames = [];
  String selectedCompany = "";
  int surveyIndex = 0;
  int selectedCategoryIndex = 0;
  String selectedCategoryName = '';
  late Future<List<dynamic>> showInteractiveSurvey = showGeneralSurveyApi();
  List<dynamic> showInteractiveSurvey1 = [];
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    _loadUserImage();
    getPreff().then((value) {
      categoryItemss = showMyCategoryApi();
      showInteractiveSurvey = showGeneralSurveyApi();
    });
    CommonFuncs.showToast("maincategory_view MainCategoryView");

  }

  PageController surveyPageController = PageController();
  PageController pageController = PageController();
  List tapedIndex = [];
  List categoryItems = [];
  late Future<List<dynamic>> categoryItemss;
  List imagesList = [];
  List<dynamic> matchingSurveys = [];
  Set<String> uniqueSurveyIds = Set();

  String tapedCateg = '';

  bool isValidJson(String responseBody) {
    try {
      jsonDecode(responseBody);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> showMyCategoryApi() async {

    var response = await http.post(Uri.parse(AppUrls.myCategory), body: {
      "User_Id": preff!.get('uid').toString(),
    });

    try {

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter("200", AppUrls.myCategory, "POST", "User_Id: ${preff!.get('uid').toString()}", data, "maincategory_view");
        if (data['data'] is List) {
     //     log(data.toString());
          categoryItems = List.from(data['data']);
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
          return [];
        }
      }
      else if(response.statusCode == 404)
        {
          if (kDebugMode) {
            print("jjjservererror");
          }
          return [];
        }
      else {
        CommonFuncs.apiHitPrinter(response.statusCode.toString(), AppUrls.myCategory, "POST", "User_Id: ${preff!.get('uid').toString()}", data, "maincategory_view");

        log("Failed to fetch data from the API. Status code: ${response
            .statusCode}");
        return [];
      }
    } catch (e) {
      log("Error is $e");
      return ["zero", response.statusCode.toString()];
    }
  }

  Future<List<dynamic>> showGeneralSurveyApi() async {
    if (kDebugMode) {
      print("compnames invoked showGeneralSurveyAPI");
    }
    try {
      var response = await http.post(
        Uri.parse(AppUrls.generalSurvey),
        body: {
          "userId": preff!.getString('uid').toString(),
        },
      );

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {

        CommonFuncs.apiHitPrinter("200", AppUrls.generalSurvey, "POST",
            "userId: ${preff!.getString('uid').toString()}", data, "maincategory_view");

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

        CommonFuncs.apiHitPrinter(response.statusCode.toString(), AppUrls.generalSurvey, "POST",
            "userId: ${preff!.getString('uid').toString()}", data, "maincategory_view");

        log("Failed to fetch data from the API. Status code: ${response
            .statusCode}");
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
        CommonFuncs.apiHitPrinter("200", AppUrls.subCategory, "POST", "User_Id: ${preff!.getString('uid').toString()}\nparentcatname: $selectedCategoryName"
            , data, "maincategory_view");

        if (data['products'] is List) {
          List<dynamic> subcategoryData = data['products'];
          log("Subcategory Data from API: $data");
          progressDialog?.hide();
          return subcategoryData; // Return the subcategory data
        } else {
          log("Invalid data format received from the subcategory API.");
        }
      } else {

        CommonFuncs.apiHitPrinter(response.statusCode.toString(), AppUrls.subCategory, "POST", "User_Id: ${preff!.getString('uid').toString()}\nparentcatname: $selectedCategoryName"
            , data, "maincategory_view");

        log("Failed to fetch data from the subcategory API. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("Error is $e");
    }

    return [];
  }
  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('user_image').toString(); // Load the image path
      if (kDebugMode) {
        print("jjjjjimagepath$imagePath");
      }
    });
  }

  ProgressDialog? progressDialog;
  SharedPreferences? preff;

  Future getPreff() async {
    preff = await SharedPreferences.getInstance();
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
                      //  onTap: () => Scaffold.of(context).openDrawer(),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsView())),
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
                      child:  ClipOval(
                        child: CachedNetworkImage(
                          width: MySize.size20*2,
                          height: MySize.size20*2,
                          imageUrl: imagePath,
                          placeholder: (context, url) => Image.asset('assets/images/hi4.png',  fit: BoxFit.cover,),
                          errorWidget: (context, url, error) =>  Image.asset('assets/images/hi4.png', fit: BoxFit.cover,),

                        ),
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
                    CategoryComp(
                      showInteractiveSurveys: showInteractiveSurvey1,
                      categoryItems: categoryItemss,
                      onCategorySelected: (categoryName) async {
                        preff?.setString('product_id', categoryItems[selectedCategoryIndex]['id'].toString());
                        selectedCategoryName = categoryName;
                        if (kDebugMode) {
                          print("selectedCategoryName: $selectedCategoryName");
                        }
                        progressDialog = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: false);
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

                        if (kDebugMode) {
                          print("JJ=subCatData: $subcategoryData");
                        }

                        if (subcategoryData.isNotEmpty) {
                          var surveyDataList = await showInteractiveSurvey;

                          bool hasSlash = false;

                          var matchingSubcategories = subcategoryData
                              .where((subcategory) {
                                print("jjjsubcatname: ${subcategory['name']}");
                            return surveyDataList.any((surveyData) {
                              print("jjjfullcatname: ${surveyData['child_category']}");
                              return surveyData['child_category']
                                  .split('/')
                                  .first
                                  .trim() == subcategory['name'];
                            });
                          })
                              .toList();


                          if (kDebugMode) {
                            print("JJ=matchingSubCat: $matchingSubcategories");
                          }


                          var matchingCompanies = matchingSubcategories
                              .map((subcategory) {
                            var matchingSurveyData = surveyDataList
                                .where((surveyData) =>
                            surveyData['child_category']
                                .split('/')
                                .first
                                .trim() == subcategory['name'])
                                .toList();

                            var matchingCompaniesForSubcategory = matchingSurveyData
                                .map<String>((surveyData) => surveyData['company_name'])
                                .toList();
                            return matchingCompaniesForSubcategory.isNotEmpty
                                ? matchingCompaniesForSubcategory
                                : null;
                          })
                              .where((companies) => companies != null)
                              .expand<String>((companies) => companies!)
                              .toSet()
                              .toList();

                          if (kDebugMode) {
                            print("JJ=matchingCompanies: $matchingCompanies");
                          }


                          setState(() {
                            companyNames = matchingCompanies.map((company) => company.toString()).toList();

                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainSubCategoryView(subcategoryNames: subcategoryData,surveyData:surveyDataList,matchingCompanies: matchingCompanies,companyNames: companyNames,showInteractiveSurvey1: showInteractiveSurvey1,selectedCategory: selectedCategoryName,),
                            ),
                          );
                        }
                        else {
                         // List<dynamic> matchingSurveys = [];
                         //  print("jjjjjjline66above showgeneralsurveyapi");
                         //  await showGeneralSurveyApi();
                         //  print("jjjjjjline66below showgeneralsurveyapi");
                          matchingSurveys.clear();
                          uniqueSurveyIds.clear();


                          //  var surveyDataList = await showInteractiveSurvey;

                          var matchingCompanies = showInteractiveSurvey1
                              .where((surveyData) => surveyData['parent_category'] == selectedCategoryName)
                              .map((surveyData) => surveyData['company_name'])
                              .toList();


                          for (int index = 0; index < matchingCompanies.length; index++) {
                            var surveysToAdd = showInteractiveSurvey1
                                .where((surveyData) =>
                            surveyData['company_name'] == matchingCompanies[index] &&
                                surveyData['parent_category'] == selectedCategoryName)
                                .toList();

                            for (var survey in surveysToAdd) {
                              String surveyId = survey['survey_id'];
                              if (!uniqueSurveyIds.contains(surveyId)) {
                                matchingSurveys.add(survey);
                                uniqueSurveyIds.add(surveyId);
                              }
                            }
                          }

                          //  for (int index = 0; index < matchingCompanies.length; index++) {
                          //    matchingSurveys.addAll(showInteractiveSurvey1.where(
                          //            (surveyData) =>
                          //        surveyData['company_name'] == matchingCompanies[index])
                          //        .where((surveyData) => surveyData['parent_category'] == selectedCategoryName)
                          //        .toList());
                          //   // matchingSurveys = showInteractiveSurvey1.where(
                          //   //         (surveyData) =>
                          //   //     surveyData['company_name'] == matchingCompanies[index])
                          //   //     .where((surveyData) => surveyData['parent_category'] == selectedCategoryName)
                          //   //     .toList();
                          // }


                          if (kDebugMode) {
                            print("jjjcompanies 2: $matchingCompanies");
                          }
                          log("j12345899999999: $matchingSurveys");


                       //   log('matching companies =${[matchingCompanies]} and company name =${[companyNames]}');
                          if (matchingCompanies.isNotEmpty) {
                            setState(() {
                              companyNames = matchingCompanies.map((company) => company.toString()).toList();
                              if (kDebugMode) {
                                print("jjjcompanies 3: $companyNames");
                              }
                            });
                            pageController.nextPage(
                              duration: const Duration(microseconds: 1),
                              curve: Curves.linear,
                            ).then((value) => showMyCategory = showMyCategoryApi());
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
                    ListOfCompanyNames(
                      matchinSurvey: matchingSurveys,
                      parentCatName: selectedCategoryName,
                      commingfFrom: 'main',
                      selectedSubcategory: 'main',
                      companyNames: companyNames,

                      onCompanySelected: (companyName, index) {
                        if (kDebugMode) {
                          print("jjjselection: selected company $companyName");
                          print("jjjselection: selected index $index");
                        }
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
                    ListOfSurveyComp(
                      onGoBack: (action){

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
                             // showInteractiveSurvey1.remove(matchingSurveys[surveyIndex]);
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






