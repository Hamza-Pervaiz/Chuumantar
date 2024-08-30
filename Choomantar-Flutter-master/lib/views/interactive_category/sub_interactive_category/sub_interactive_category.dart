import 'dart:developer';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:http/http.dart' as http;
import '../sub_sub_interactive_category/main_sub_sub_interactive_category.dart';



class SubCategoryNamesViewInteractive extends StatefulWidget {
  final List<dynamic> subcategoryNames;
  final List<dynamic> surveyData;
  var matchingCompanies;
  List<String> companyNames;
  final List<dynamic> showInteractiveSurvey1;
 // final Future<List<dynamic>> showInteractiveSurvey;
  final Function(String) onNextPagePressed;
  String selectedCategory='';
  String selectedSurveyType='';
  String? imageorVideo;

  SubCategoryNamesViewInteractive({super.key,
    required this.subcategoryNames,
    required this.surveyData,
    required this.matchingCompanies,
    required this.companyNames,
    required this.showInteractiveSurvey1,
    required this.onNextPagePressed,
    required this.selectedCategory,
required this.selectedSurveyType,
    this.imageorVideo
  });

  @override
  State<SubCategoryNamesViewInteractive> createState() => _SubCategoryNamesViewInteractiveState();
}

class _SubCategoryNamesViewInteractiveState extends State<SubCategoryNamesViewInteractive> {
  String selectedCompany = "";
  ProgressDialog? progressDialog;
  String notfound='No surveys are available right now.'.tr();

  Future<List< dynamic>> sub_sub_CategoryApi(String subcategoryName) async {
    try {
      SharedPreferences preff = await SharedPreferences.getInstance();
      var response = await http.post(
        Uri.parse(AppUrls.sub_sub_Category),
        body: {
          "User_Id": preff!.getString('uid').toString(),
          "parentcatname": subcategoryName,
        },
      );

      // Print the response in the log
      if (kDebugMode) {
        print("API Response: ${response.body}");
      }

      // Parse the response
      var responseData = jsonDecode(response.body);

      CommonFuncs.apiHitPrinter(response.statusCode.toString(),
          AppUrls.sub_sub_Category, "POST", "User_Id: ${preff!.getString('uid').toString()}\n"
              "parentcatname: $subcategoryName", responseData, "sub_interactive_category");

      // Extract the list of products from the response
      List<dynamic> subSubCategoryData = responseData['products'];
      return subSubCategoryData;
    } catch (e) {
      log("Error is $e");
      // Return an empty list or handle the error as needed
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50,),

        Text(
          "Interactive Surveys ${widget.imageorVideo} / ${widget.selectedCategory}".tr(),
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

        Expanded(
          child: ListView.builder(
            itemCount: widget.subcategoryNames.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: MySize.size15),
                child: GestureDetector(
                  onTap: () async {
                    progressDialog = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: false);
                    progressDialog?.style(
                      textAlign: TextAlign.center,
                      message: 'Loading data',
                      elevation: 10,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      messageTextStyle: const TextStyle(
                        color: AppColors.purpleColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                    progressDialog?.show();

                    var subcategoryData = await sub_sub_CategoryApi(widget.subcategoryNames[index]['name']);

                    progressDialog?.hide();

                    if(subcategoryData.isNotEmpty)
                    {
                      String selectedSubcategoryName = widget.subcategoryNames[index]['name'];
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>MainSub_SubCategoryViewInteractive(
                          selectedSubCategory: selectedSubcategoryName,
                          imageorVideo: widget.imageorVideo,
                          selectedSurveyType:widget.selectedSurveyType ,
                          selectedCategory: widget.selectedCategory,
                          subSubCategoryData: subcategoryData,
                          matchingCompanies: widget.matchingCompanies,
                          surveyData:widget.surveyData,
                          showInteractiveSurvey1:widget.showInteractiveSurvey1,
                          companyNames: widget.companyNames ,

                        ),
                      ),
                    );
                    }
                    else{
                      String selectedSubcategoryName = widget.subcategoryNames[index]['name'];
                      bool hasMatchingSurveyData = widget.surveyData.any(
                            (surveyData) =>
                        surveyData['child_category']?.split(' /')?.first == selectedSubcategoryName,
                      );


                      if (hasMatchingSurveyData) {
                        widget.onNextPagePressed(
                            selectedSubcategoryName
                        ); // Call the callback to navigate to the next page
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
                                  oprText: selectedSubcategoryName.tr(),
                                  ontap: () {
                                    Navigator.pop(context);
                                  });
                            });
                      }
                    }

                  },
                  child: Container(
                    width: MySize.screenWidth,
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
                      borderRadius: BorderRadius.circular(MySize.size12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MySize.size36,
                          height: MySize.size36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                "https://dreammerchants.tech/ajax/" +
                                    (widget.subcategoryNames[index]['product_image'] ?? "assets/images/sc5.png"),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: TextWidget(
                            text: widget.subcategoryNames[index]['name'],
                            fontSize: MySize.size20,
                            fontFamily: AppConst.primaryFont,
                            fontColor: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(
                          height: MySize.size36,
                          width: MySize.size36,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
