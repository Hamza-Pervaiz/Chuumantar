import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:showcaseview/showcaseview.dart';

class CompletedSurveyView extends StatefulWidget {
  const CompletedSurveyView({super.key});

  @override
  State<CompletedSurveyView> createState() => _MainCategoryViewState();
}


class _MainCategoryViewState extends State<CompletedSurveyView> {

  late Future<List<Map<String, dynamic>>> surveyData;
  String imagePath='';
  final GlobalKey oneoneone = GlobalKey();
  bool showOnce = true;



  @override
  void initState() {
    super.initState();
    _loadUserImage();
    surveyData = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{

      final response = await http.post(Uri.parse(AppUrls.takenSurveys), body: {
        "userId": prefs!.get('uid').toString(),
      });

      var dataa = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter("200", AppUrls.takenSurveys, "POST",
            "userId: ${prefs!.get('uid').toString()}", dataa, "completed_survey_view");

        return jsonDecode(response.body).cast<Map<String, dynamic>>();

        // setState(() {
        //   surveyData = jsonDecode(response.body).cast<Map<String, dynamic>>();
        // });

      } else {
        CommonFuncs.apiHitPrinter(response.statusCode.toString(), AppUrls.takenSurveys, "POST",
            "userId: ${prefs!.get('uid').toString()}", dataa, "completed_survey_view");

        return [];
      }
    }
    catch(e)
    {

      if (kDebugMode) {
        print(e.toString());
      }

      return [];
    }
  }

  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('user_image').toString(); // Load the image path

      if (kDebugMode) {
        print("jjjjjimagepath: $imagePath");
      }

    });
  }
  SharedPreferences? preff;

  Future getPreff() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
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
            const SizedBox(height: 10,),
            SizedBox(
              height: MySize.scaleFactorHeight * 56,
              child: Row(
                children: [
                  backBtn(context),
                  // Builder(
                  //   builder: (context) => GestureDetector(
                  //     onTap: () => Scaffold.of(context).openDrawer(),
                  //     child: const Icon(
                  //       CupertinoIcons.line_horizontal_3_decrease,
                  //       color: AppColors.whiteColor,
                  //     ),
                  //   ),
                  // ),
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
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imagePath,
                        width: MySize.size20*2,
                        height: MySize.size20*2,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset('assets/images/hi4.png'),
                        errorWidget: (context, url, error) => Image.asset('assets/images/hi4.png'),
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: MySize.scaleFactorHeight*20,),

            TextWidget(
              text: "Completed Surveys".tr(),
              maxLines: 2,
              textAlign: TextAlign.center,
              fontSize: MySize.size20,
              fontWeight: FontWeight.w400,
              fontFamily: AppConst.primaryFont,
              fontColor: AppColors.primaryColor,
            ),

            SizedBox(height: MySize.scaleFactorHeight*25,),


            ShowCaseWidget(
              builder: Builder(builder: (context){

                if(showOnce)
                {
                  Future.delayed(const Duration(seconds: 2), () {
                    ShowCaseWidget.of(context).startShowCase([oneoneone]);

                    setState(() {
                      showOnce = false;
                    });

                  }).then((value) {
                    Future.delayed(const Duration(seconds: 4), () {
                      ShowCaseWidget.of(context).dismiss();
                    });

                  });

                }



                return Expanded(
                  child: FutureBuilder(
                    future: surveyData,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(!snapshot.hasData)
                      {
                        return const Center(child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.urduBtn)
                        ));
                      }
                      else
                      {
                        List<Map<String, dynamic>> surveyDataa = snapshot.data;

                        if(surveyDataa==null || surveyDataa.isEmpty)
                        {
                          return Center(child: TextWidget(text: "No completed surveys found!", fontWeight: FontWeight.w700,));
                        }
                        else
                        {
                          return ListView.separated(
                            itemCount: surveyDataa.length,
                            separatorBuilder: (BuildContext context, int index) => SizedBox(height: MySize.scaleFactorHeight*15,),
                            itemBuilder: (context, index) {
                              if(index == 0)
                                {
                                  final survey = surveyDataa[index];
                                  return Showcase(
                                    key: oneoneone,
                                    description: 'Swipe left to delete',
                                    targetPadding: const EdgeInsets.only(top: 40, bottom: -40),
                                    child: Dismissible(
                                      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                                      resizeDuration: const Duration(milliseconds: 5),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) {
                                        setState(() {
                                          surveyDataa.removeAt(index);
                                        });

                                      },
                                      background: Container(
                                        padding: EdgeInsets.symmetric(horizontal: MySize.size20, vertical: MySize.size20),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(MySize.size16),
                                        ),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(horizontal: MySize.size20, vertical: MySize.size20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(MySize.size16),
                                          image: const DecorationImage(
                                            image: AssetImage(AppConst.eyeBg),
                                            fit: BoxFit.scaleDown,
                                            scale: 0.7,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [

                                                TextWidget(
                                                  text: 'Title:',
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily: AppConst.primaryFont,
                                                  fontColor: AppColors.purpleColor,
                                                ),

                                                SizedBox(width: MySize.size5,),

                                                Expanded(
                                                  child: TextWidget(
                                                    text: survey['title'],
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start,
                                                    fontSize: MySize.size16,
                                                    fontFamily: AppConst.primaryFont,
                                                    fontColor: AppColors.urduBtn,
                                                  ),
                                                ),

                                              ],
                                            ),


                                            Row(
                                              children: [

                                                TextWidget(
                                                  text: 'Category:',
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily: AppConst.primaryFont,
                                                  fontColor: AppColors.purpleColor,
                                                ),


                                                SizedBox(width: MySize.size5,),


                                                TextWidget(
                                                  text: survey['child_category']!='Select Category' && survey['child_category']!='No Child'?
                                                  survey['parent_category']+" / "+survey['child_category'] :  survey['parent_category'],
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily: AppConst.primaryFont,
                                                  fontColor: AppColors.urduBtn,
                                                ),

                                              ],
                                            ),



                                            Row(
                                              children: [

                                                TextWidget(
                                                  text: 'Points:',
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily: AppConst.primaryFont,
                                                  fontColor: AppColors.purpleColor,
                                                ),

                                                SizedBox(width: MySize.size5,),


                                                TextWidget(
                                                  text: survey['survey_points'],
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily: AppConst.primaryFont,
                                                  fontColor: AppColors.urduBtn,
                                                ),

                                              ],
                                            ),

                                            Row(
                                              children: [

                                                TextWidget(
                                                  text: 'Type:',
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily: AppConst.primaryFont,
                                                  fontColor: AppColors.purpleColor,
                                                ),

                                                SizedBox(width: MySize.size5,),


                                                TextWidget(
                                                  text: survey['survey_type'],
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily: AppConst.primaryFont,
                                                  fontColor: AppColors.urduBtn,
                                                ),

                                              ],
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              else
                                {
                                  final survey = surveyDataa[index];
                                  return Dismissible(

                                    key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                                    resizeDuration: const Duration(milliseconds: 5),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      setState(() {
                                        surveyDataa.removeAt(index);
                                      });

                                    },
                                    background: Container(
                                      padding: EdgeInsets.symmetric(horizontal: MySize.size20, vertical: MySize.size20),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(MySize.size16),
                                      ),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(horizontal: MySize.size20, vertical: MySize.size20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(MySize.size16),
                                        image: const DecorationImage(
                                          image: AssetImage(AppConst.eyeBg),
                                          fit: BoxFit.scaleDown,
                                          scale: 0.7,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [

                                              TextWidget(
                                                text: 'Title:',
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily: AppConst.primaryFont,
                                                fontColor: AppColors.purpleColor,
                                              ),

                                              SizedBox(width: MySize.size5,),

                                              Expanded(
                                                child: TextWidget(
                                                  text: survey['title'],
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                  fontSize: MySize.size16,
                                                  fontFamily: AppConst.primaryFont,
                                                  fontColor: AppColors.urduBtn,
                                                ),
                                              ),

                                            ],
                                          ),


                                          Row(
                                            children: [

                                              TextWidget(
                                                text: 'Category:',
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily: AppConst.primaryFont,
                                                fontColor: AppColors.purpleColor,
                                              ),


                                              SizedBox(width: MySize.size5,),


                                              TextWidget(
                                                text: survey['child_category']!='Select Category' && survey['child_category']!='No Child'?
                                                survey['parent_category']+" / "+survey['child_category'] :  survey['parent_category'],
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily: AppConst.primaryFont,
                                                fontColor: AppColors.urduBtn,
                                              ),

                                            ],
                                          ),



                                          Row(
                                            children: [

                                              TextWidget(
                                                text: 'Points:',
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily: AppConst.primaryFont,
                                                fontColor: AppColors.purpleColor,
                                              ),

                                              SizedBox(width: MySize.size5,),


                                              TextWidget(
                                                text: survey['survey_points'],
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily: AppConst.primaryFont,
                                                fontColor: AppColors.urduBtn,
                                              ),

                                            ],
                                          ),

                                          Row(
                                            children: [

                                              TextWidget(
                                                text: 'Type:',
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily: AppConst.primaryFont,
                                                fontColor: AppColors.purpleColor,
                                              ),

                                              SizedBox(width: MySize.size5,),


                                              TextWidget(
                                                text: survey['survey_type'],
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily: AppConst.primaryFont,
                                                fontColor: AppColors.urduBtn,
                                              ),

                                            ],
                                          ),


                                        ],
                                      ),
                                    ),
                                  );
                                }

                            },
                          );
                        }

                      }
                    },
                  ),

                );
              }),
            ),

            const SizedBox(height: 10.0),
            // Expanded(child:
            // Center(child: TextWidget(text: "Completed Surveys View", fontSize: 16, fontWeight: FontWeight.w800,)))
          ],
        ),
      ),
    );
  }
}






