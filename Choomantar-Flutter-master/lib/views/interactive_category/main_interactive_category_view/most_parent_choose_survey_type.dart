import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../models/choosesurvey_model.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_const.dart';
import '../../../res/reponsive_size.dart';
import '../../../widgets/text_widget.dart';

class selectImageOrVideoSurvey extends StatefulWidget {
  final Function(String) onSurveySelected;
  final int totalCats;

  const selectImageOrVideoSurvey(
      {super.key, required this.onSurveySelected, required this.totalCats});

  @override
  State<selectImageOrVideoSurvey> createState() =>
      _selectImageOrVideoSurveyState();
}

class _selectImageOrVideoSurveyState extends State<selectImageOrVideoSurvey> {
  PageController pageController = PageController();
  List<ChooseSurvyModel> surveyTypes1 = [
    ChooseSurvyModel(
        text: 'Picture Surveys'.tr(),
        imagePath: 'assets/images/image_survey.png'),
    ChooseSurvyModel(
        text: 'Video Surveys'.tr(),
        imagePath: 'assets/images/video_survey.png'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFuncs.showToast(
        "most_parent_choose_survey_type\nselectImageOrVideoSurvey");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 45,
        ),
        Text(
          "Interactive Surveys".tr(),
          style: TextStyle(
            fontSize: MySize.size20,
            fontWeight: FontWeight.w500,
            fontFamily: AppConst.primaryFont,
            color: AppColors.secondaryColor,
          ),
        ),
        const SizedBox(height: 50),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: surveyTypes1.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  widget.onSurveySelected(
                      index == 0 ? 'image_survey' : 'video_survey');
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.whiteColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(surveyTypes1[index].imagePath,
                          width: 50, height: 50), // Adjust size as needed

                      TextWidget(
                        text: surveyTypes1[index].text,
                        fontSize: MySize.size18,
                        fontFamily: AppConst.primaryFont,
                        fontColor: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),

                      Container(
                        width: MySize.size32,
                        height: MySize.size32,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            widget.totalCats.toString(),
                            style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppConst.primaryFont),
                          ),
                        ),
                      ),
                    ],
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
