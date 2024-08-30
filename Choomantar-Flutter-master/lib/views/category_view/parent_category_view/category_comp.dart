import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/views/select_main_category/select_onboardingcategories_view.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../res/utils/CommonFuncs.dart';

class CategoryComp extends StatefulWidget {
  final Future<List<dynamic>> categoryItems;
 // final Future<List<dynamic>> showInteractiveSurveys;
  final List<dynamic> showInteractiveSurveys;
  final Function(String) onCategorySelected;

  const CategoryComp({super.key,
    required this.categoryItems,
    required this.onCategorySelected,
    required this.showInteractiveSurveys,
  });

  @override
  State<CategoryComp> createState() => _CategoryCompState();

}

class _CategoryCompState extends State<CategoryComp> {
  PageController pageController = PageController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFuncs.showToast("category_comp CategoryComp");

  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MySize.scaleFactorHeight*50,),
        Text(
         "My Categories".tr(),
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

        SizedBox(
          height: MySize.scaleFactorHeight * 20,
        ),

        Flexible(
          child: FutureBuilder(
            future: widget.categoryItems,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(!snapshot.hasData)
                {
                  return const Center(child: CircularProgressIndicator(color: AppColors.whiteColor,));
                }
              else
                {
                  List<dynamic> catList = snapshot.data;
                  if(catList.isEmpty)
                    {
                      return Column(
                        children: [
                          SizedBox(height: MySize.screenHeight/8,),
                          noCategoryFound(),
                        ],
                      );
                     //   return Center(child: Text('Nothing to show'));
                    }
                  else if(catList.contains("zero"))
                    {
                      final scode = catList[1];
                      return Column(
                        children: [
                          SizedBox(height: MySize.screenHeight/8,),
                          serverError(scode),
                        ],
                      );
                    }
                  else
                    {
                    //  log(catList[0]["product_image"]);
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
                                    imageUrl: "${AppUrls.imageUrl}${catList[index]['product_image']}",
                                    width: MySize.size36,
                                    height: MySize.size36,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset('assets/images/sc5.png'),
                                    errorWidget: (context, url, error) => Image.asset('assets/images/sc5.png'),
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
                                  future: Future.value(widget.showInteractiveSurveys),
                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                    if(!snapshot.hasData)
                                      {
                                        return Center(
                                            child: Container(
                                              width: MySize.size32,
                                              height: MySize.size32,
                                              decoration: BoxDecoration(
                                                color: AppColors.redColor,
                                                borderRadius: BorderRadius.circular(50),
                                              ),
                                              child: const Center(child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                                child: CircularProgressIndicator(color: AppColors.whiteColor, strokeWidth: 2.0,),
                                              )),
                                            )
                                        );
                                      }
                                    else
                                      {
                                        return Center(
                                            child: Container(
                                              width: MySize.size32,
                                              height: MySize.size32,
                                              decoration: BoxDecoration(
                                                color: countSurveysByParentCategory(snapshot.data, catList[index]['name'])>0 ? AppColors.secondaryColor
                                                : AppColors.redColor,
                                                borderRadius: BorderRadius.circular(50),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  countSurveysByParentCategory(snapshot.data, catList[index]['name']).toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors.whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: AppConst.primaryFont
                                                  ),
                                                ),
                                              ),
                                            )
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

        // Expanded(
        //   child: widget.categoryItems.isEmpty
        //       ? Center(
        //     child: CircularProgressIndicator(
        //       color: AppColors.whiteColor,
        //     ),
        //   )
        //       : RefreshIndicator(
        //     key:_refreshIndicatorKey ,
        //     onRefresh:()async{
        //       await Future.delayed(const Duration(seconds: 2));
        //       _refresh();
        //       return Future.value(true);
        //     },
        //     triggerMode: RefreshIndicatorTriggerMode.anywhere,
        //         child: ListView.separated(
        //                     scrollDirection: Axis.vertical,
        //                     itemCount: widget.categoryItems.length,
        //                     separatorBuilder: (context, index) => SizedBox(
        //         height: MySize.scaleFactorHeight * 15,
        //                     ),
        //                     itemBuilder: (context, index) => GestureDetector(
        //         onTap: () async {
        //           widget.onCategorySelected(widget.categoryItems[index]['name']);
        //           pageController.nextPage(
        //             duration: const Duration(microseconds: 1),
        //             curve: Curves.linear,
        //           );
        //         },
        //         child: Container(
        //           width: MySize.screenWidth,
        //           padding: EdgeInsets.symmetric(
        //             horizontal: MySize.size15,
        //             vertical: MySize.size6,
        //           ),
        //           decoration: BoxDecoration(
        //             color: Colors.transparent,
        //             border: Border.all(
        //               width: MySize.size3,
        //               color: AppColors.whiteColor,
        //             ),
        //             borderRadius: BorderRadius.circular(MySize.size12),
        //           ),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Row(
        //                 children: [
        //                   Container(
        //                     width: MySize.size36,
        //                     height: MySize.size36,
        //                     decoration: BoxDecoration(
        //                       shape: BoxShape.circle,
        //                       image: DecorationImage(
        //                         fit: BoxFit.fill,
        //                         image: NetworkImage(
        //                           "https://projects.funtashtechnologies.com/choo_dashboard/ajax/" +
        //                               (widget.categoryItems[index]['product_image'] ?? "assets/images/sc5.png"),
        //                         ),
        //
        //                       ),
        //                     ),
        //                   ),
        //                   SizedBox(width: MySize.size10),
        //                   TextWidget(
        //                     text: widget.categoryItems[index]['name'],
        //                     fontSize: MySize.size20,
        //                     fontFamily: AppConst.primaryFont,
        //                     fontColor: AppColors.whiteColor,
        //                     fontWeight: FontWeight.w600,
        //                   ),
        //                 ],
        //               ),
        //                Center(
        //                   child: Container(
        //                     width: 40,
        //                     height: 30,
        //                     decoration: BoxDecoration(
        //                       color: AppColors.secondaryColor,
        //                       borderRadius: BorderRadius.circular(10),
        //                     ),
        //                     child: Icon(
        //                       Icons.arrow_forward_ios,
        //                       color: AppColors.whiteColor,
        //                     ),
        //                   )
        //                 ),
        //
        //             ],
        //           ),
        //         ),
        //                     ),
        //                   ),
        //       ),
        // ),

        SizedBox(
          height: MySize.scaleFactorHeight * 20,
        ),

      ],
    );
  }


  int countSurveysByParentCategory(List<dynamic> surveys, String parentCategory) {
    int count = 0;

    for (var survey in surveys) {
      if (survey['parent_category'] == parentCategory) {
        count++;
      }
    }

    // Random random = Random();
    // // Generate a random integer between 0 and 3
    // int randomNumber = random.nextInt(4);
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
          'You have not selected any category yet. Please select your preferred categories.'.tr(),
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
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectCategories()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.black,
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MySize.size8),
            ),
          ),
          child: const Text('Ok',style: TextStyle( fontFamily: AppConst.primaryFont,
              fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
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

        Image.asset("assets/images/sad_emoji.png", width: 50, height: 50,),

        SizedBox(height: MySize.size12),


        Text(
          'Sorry, something went wrong. We\'re working on getting this fixed as soon as we can'.tr(),
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
            child: const Text('Ok',style: TextStyle( fontFamily: AppConst.primaryFont,
                fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
          ),
        ),

      ],
    ),
  );
}


