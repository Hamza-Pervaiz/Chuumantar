import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_const.dart';
import '../../../res/reponsive_size.dart';
import '../../../widgets/text_widget.dart';
import '../../../widgets/validate_dailog.dart';

class SubSubCategoryViewInteractive extends StatefulWidget {
  final List<dynamic> surveyData;
  var matchingCompanies;
  List<String> companyNames;
  final List<dynamic> showInteractiveSurvey1;
  // final Future<List<dynamic>> showInteractiveSurvey;
  final List<dynamic> subSubCategoryData;
  final Function(String) onNextPagePressed;
  String selectedCategory;
  String selectedSubCategory;
  String? selectedSurveyType;
  String? imageorVideo;

  SubSubCategoryViewInteractive(
      {super.key,
      required this.subSubCategoryData,
      required this.onNextPagePressed,
      required this.matchingCompanies,
      required this.surveyData,
      required this.showInteractiveSurvey1,
      required this.companyNames,
      required this.selectedSubCategory,
      required this.selectedCategory,
      this.selectedSurveyType,
      this.imageorVideo});

  @override
  State<SubSubCategoryViewInteractive> createState() =>
      _SubSubCategoryViewInteractiveState();
}

class _SubSubCategoryViewInteractiveState
    extends State<SubSubCategoryViewInteractive> {
  ProgressDialog? progressDialog;
  String notfound = 'No surveys are available right now.'.tr();
  int? numberCompanies;

  @override
  Widget build(BuildContext context) {
    numberCompanies = widget.companyNames.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 50,
        ),
        Text(
          'Interactive Surveys ${widget.imageorVideo} / ${widget.selectedCategory} / ${widget.selectedSubCategory}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MySize.size20,
            fontWeight: FontWeight.w500,
            fontFamily: AppConst.primaryFont,
            color: AppColors.secondaryColor,
          ),
        ),
        // TextWidget(
        //   text: "Sub-Sub Categories",
        //   fontSize: MySize.size20,
        //   fontWeight: FontWeight.w500,
        //   fontFamily: AppConst.primaryFont,
        // ),

        SizedBox(
          height: MySize.scaleFactorHeight * 30,
        ),
        Expanded(
          child: widget.subSubCategoryData.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.whiteColor,
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.subSubCategoryData.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: MySize.scaleFactorHeight * 15,
                  ),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () async {
                      String onsubsubctageorySelected =
                          widget.subSubCategoryData[index]['name'];
                      // progressDialog = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: false);
                      // progressDialog?.style(
                      //   textAlign: TextAlign.center,
                      //   message: 'Loading data',
                      //   elevation: 10,
                      //   padding: const EdgeInsets.symmetric(vertical: 10),
                      //   messageTextStyle: const TextStyle(
                      //     color: AppColors.purpleColor,
                      //     fontSize: 14.0,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // );
                      // progressDialog?.show();
                      bool matchingSurveys = widget.surveyData.any(
                          (surveyData) =>
                              surveyData['child_category']?.split('/ ')?.last ==
                                  onsubsubctageorySelected &&
                              surveyData['survey_type'] ==
                                  widget.selectedSurveyType);

                      int count = widget.surveyData
                          .where((item) => item['child_category']
                              .contains(onsubsubctageorySelected))
                          .length;

                      if (kDebugMode) {
                        print('matching survey = ${[matchingSurveys]}');
                      }
// progressDialog?.hide();
                      if (matchingSurveys) {
                        widget.onNextPagePressed(onsubsubctageorySelected);
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
                                  oprText: onsubsubctageorySelected.tr(),
                                  ontap: () {
                                Navigator.pop(context);
                              });
                            });
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
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MySize.size36,
                                height: MySize.size36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      "https://dreammerchants.tech/ajax/${widget.subSubCategoryData[index]['product_image']}",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          TextWidget(
                            text: widget.subSubCategoryData[index]['name'],
                            textAlign: TextAlign.center,
                            fontSize: MySize.size20,
                            fontFamily: AppConst.primaryFont,
                            fontColor: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                          Spacer(),
                          Container(
                            width: MySize.size36,
                            height: MySize.size36,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(MySize.size50),
                              color: countSurveys(widget
                                          .subSubCategoryData[index]['name']) !=
                                      0
                                  ? AppColors.secondaryColor
                                  : AppColors.redColor,
                            ),
                            child: Center(
                              child: TextWidget(
                                text: countSurveys(widget
                                        .subSubCategoryData[index]['name'])
                                    .toString(), // Replace with the actual data you want to display
                                fontSize: MySize.size14,
                                fontWeight: FontWeight.w700,
                                fontColor: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  int countSurveys(String input) {
    return widget.surveyData
        .where((item) =>
            item['child_category'].contains(input) &&
            item['survey_type'] == widget.selectedSurveyType)
        .length;
  }
}
