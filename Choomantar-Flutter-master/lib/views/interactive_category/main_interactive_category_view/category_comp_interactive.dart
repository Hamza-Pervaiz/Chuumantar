import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_const.dart';
import '../../../res/app_urls.dart';
import '../../../res/reponsive_size.dart';
import '../../../widgets/text_widget.dart';
import '../../select_main_category/select_onboardingcategories_view.dart';

class CategoryCompInteractive extends StatefulWidget {
  final Future<List<dynamic>> categoryItems;
  final Function(String) onCategorySelected;
  final Future<List<dynamic>> showInteractiveSurvey;
  String? imageorVideo;
  String? selectedSurveyType;

  CategoryCompInteractive(
      {super.key,
      required this.categoryItems,
      required this.onCategorySelected,
      required this.showInteractiveSurvey,
      this.imageorVideo,
      this.selectedSurveyType});

  @override
  State<CategoryCompInteractive> createState() =>
      _CategoryCompInteractiveState();
}

class _CategoryCompInteractiveState extends State<CategoryCompInteractive> {
  PageController pageController = PageController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Future<void> _refresh() async {
  //   await widget.showInteractiveSurvey;
  //   // Add any other refresh logic you need
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (kDebugMode) {
      print("jjimageorvieo: ${widget.selectedSurveyType}");
    }

    CommonFuncs.showToast("category_comp_interactive\nCategoryCompInteractive");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: MySize.scaleFactorHeight * 50,
        ),
        Text(
          "Interactive Surveys${widget.imageorVideo}".tr(),
          style: TextStyle(
            fontSize: MySize.size20,
            fontWeight: FontWeight.w500,
            fontFamily: AppConst.primaryFont,
            color: AppColors.secondaryColor,
          ),
          textAlign: TextAlign.center,
          textScaleFactor: 1.0,
        ),
        SizedBox(
          height: MySize.scaleFactorHeight * 20,
        ),
        SizedBox(
          height: MySize.scaleFactorHeight * 20,
        ),
        Flexible(
          child: FutureBuilder(
            future: widget.categoryItems,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                ));
              } else {
                List<dynamic> catList = snapshot.data!;
                if (catList == null || catList.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MySize.screenHeight / 8,
                      ),
                      noCategoryFound(),
                    ],
                  );
                } else if (catList.contains("zero")) {
                  final scode = catList[1];
                  return Column(
                    children: [
                      SizedBox(
                        height: MySize.screenHeight / 10,
                      ),
                      serverError(scode),
                    ],
                  );
                } else {
                  return ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: catList.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: MySize.scaleFactorHeight * 15,
                    ),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () async {
                        widget.onCategorySelected(catList[index]['name']);
                        pageController.nextPage(
                          duration: const Duration(microseconds: 1),
                          curve: Curves.linear,
                        );
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
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${AppUrls.imageUrl}${catList[index]['product_image']}",
                                width: MySize.size36,
                                height: MySize.size36,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Image.asset('assets/images/sc5.png'),
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/images/sc5.png'),
                              ),
                            ),
                            TextWidget(
                              text: catList[index]['name'],
                              fontSize: MySize.size20,
                              fontFamily: AppConst.primaryFont,
                              fontColor: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                            FutureBuilder(
                              future: widget.showInteractiveSurvey,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: Container(
                                    width: MySize.size32,
                                    height: MySize.size32,
                                    decoration: BoxDecoration(
                                      color: AppColors.redColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Center(
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 7.0, horizontal: 7.0),
                                      child: CircularProgressIndicator(
                                        color: AppColors.whiteColor,
                                        strokeWidth: 2.0,
                                      ),
                                    )),
                                  ));
                                } else {
                                  return Container(
                                    width: MySize.size32,
                                    height: MySize.size32,
                                    decoration: BoxDecoration(
                                      color: countSurveysByParentCategory(
                                                  snapshot.data!,
                                                  catList[index]['name'],
                                                  widget.selectedSurveyType) >
                                              0
                                          ? AppColors.secondaryColor
                                          : AppColors.redColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text(
                                        countSurveysByParentCategory(
                                                snapshot.data!,
                                                catList[index]['name'],
                                                widget.selectedSurveyType)
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: AppConst.primaryFont),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }

  int countSurveysByParentCategory(
      List<dynamic> surveys, String parentCategory, String? surveyType) {
    int count = 0;

    for (var survey in surveys) {
      if (survey['parent_category'] == parentCategory &&
          survey['survey_type'] == surveyType) {
        count++;
      }
    }

    return count;
  }

  Widget noCategoryFound() => Container(
        padding: EdgeInsets.all(MySize.size20),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(MySize.size16),
          image: const DecorationImage(
            image: AssetImage(AppConst.orgeyeBg),
            fit: BoxFit.scaleDown,
            scale: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              text: 'No category found!'.tr(),
              textAlign: TextAlign.center,
              maxLines: 2,
              fontSize: MySize.size22,
              fontFamily: AppConst.primaryFont,
              fontColor: AppColors.redColor,
            ),
            SizedBox(height: MySize.size22),

            Text(
              'You have not selected any category yet. Please select your preferred categories.'
                  .tr(),
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppConst.primaryFont,
                color: AppColors.purpleColor,
                fontSize: MySize.size18,
                fontWeight: FontWeight.w600,
              ),
            ),
            //

            SizedBox(height: MySize.size18),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectCategories()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.black,
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MySize.size8),
                ),
              ),
              child: const Text(
                'Ok',
                style: TextStyle(
                    fontFamily: AppConst.primaryFont,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor),
              ),
            ),
          ],
        ),
      );

  Widget serverError(String scode) => Container(
        padding: EdgeInsets.all(MySize.size20),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(MySize.size16),
          image: const DecorationImage(
            image: AssetImage(AppConst.orgeyeBg),
            fit: BoxFit.scaleDown,
            scale: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              text: "${'Error!'.tr()}\n$scode",
              textAlign: TextAlign.center,
              maxLines: 2,
              fontSize: MySize.size22,
              fontFamily: AppConst.primaryFont,
              fontColor: AppColors.redColor,
            ),
            SizedBox(height: MySize.size12),

            Image.asset(
              "assets/images/sad_emoji.png",
              width: 50,
              height: 50,
            ),

            SizedBox(height: MySize.size12),

            Text(
              'Sorry, something went wrong. We\'re working on getting this fixed as soon as we can'
                  .tr(),
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppConst.primaryFont,
                color: AppColors.purpleColor,
                fontSize: MySize.size18,
                fontWeight: FontWeight.w600,
              ),
            ),
            //

            SizedBox(height: MySize.size18),

            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.black,
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MySize.size8),
                  ),
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(
                      fontFamily: AppConst.primaryFont,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor),
                ),
              ),
            ),
          ],
        ),
      );
}
