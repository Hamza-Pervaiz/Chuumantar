import 'package:chumanter/configs/providers/profile_completion_status.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/views/quize_view/quiz_questions_for_general_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../configs/providers/calculating_profile_completion_percent_provider.dart';

class UserResponse {
  int questionIndex;
  String selectedOptionText;

  UserResponse(this.questionIndex, this.selectedOptionText);
}

class QuizeViewGeneralProfile extends StatefulWidget {
  QuizeViewGeneralProfile({
    super.key,
    this.viewMode,
    this.isTimer = true,
    this.isInteractive = false,
    this.image = AppConst.quizeImg,
  });

  final bool isTimer;
  final bool isInteractive;
  bool? viewMode;
  final String image;

  @override
  State<QuizeViewGeneralProfile> createState() =>
      _QuizeViewGeneralProfileState();
}

class _QuizeViewGeneralProfileState extends State<QuizeViewGeneralProfile> {
  final _pageController = PageController();
  int? _currentPage;
  List<Map<String, dynamic>> questionItems = [];
  List<UserResponse?> userResponses = List.generate(14, (index) => null);
  List<bool> showOthersTextField = List.generate(14, (index) => false);
  List<TextEditingController> otherControllers = List.generate(14, (index) => TextEditingController());


  //List<String?> previoussavedOptions = List.generate(14, (index) => null);
 // int currIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    questionItems = QuizDataGeneral.getQuestions();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt() + 1;
      });
    });
    loadGeneralQuestion();
    //getSavedOptions();
    CommonFuncs.showToast(
        "quize_view_for_general_profile\nQuizeViewGeneralProfile");
  }

  void loadGeneralQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < userResponses.length; i++) {
      final selectedOption = prefs.getString('general_question_$i');

      if (kDebugMode) {
        print("jjuserresponse selectedoption: $selectedOption");
      }

      if (selectedOption != null && selectedOption != '') {
        userResponses[i] = UserResponse(i, selectedOption!);

        if (kDebugMode) {
          print("jjuserresponse: ${userResponses[i]?.questionIndex}");
          print("jjuserresponse: ${userResponses[i]?.selectedOptionText}");
        }

        if (i == taped) {
          taped = i;
        }
      }
    }

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  int taped = -1;

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConst.bgPrimary),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MySize.scaleFactorHeight * 20,
            ),
            paddingComp(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                backBtn(context),
                TextWidget(
                  text: "General Profile",
                  fontSize: MySize.size24,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppConst.primaryFont,
                  fontColor: AppColors.primaryColor,
                ),
                widget.isInteractive
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(MySize.size8),
                          child: Image.asset(
                            widget.image,
                            height: MySize.size35,
                            width: MySize.size35,
                            fit: BoxFit.fill,
                          ),
                        ))
                    : GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          CupertinoIcons.qrcode_viewfinder,
                          color: AppColors.whiteColor,
                        ))
              ],
            )),
            SizedBox(
              height: MySize.scaleFactorHeight * 20,
            ),
            paddingComp(
              Row(
                children: [
                  Expanded(
                    child: StepProgressIndicator(
                      size: MySize.size6,
                      roundedEdges: Radius.circular(MySize.size6),
                      totalSteps: 14,
                      currentStep: _currentPage!,
                      selectedColor: AppColors.primaryColor,
                      unselectedColor: AppColors.primaryColor.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(
                    width: MySize.scaleFactorWidth * 8,
                  ),
                  TextWidget(
                    text: "$_currentPage/14",
                    fontColor: AppColors.primaryColor,
                    fontSize: MySize.size18,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    width: MySize.scaleFactorWidth * 4,
                  ),
                  Image.asset(
                    AppConst.medal,
                    height: MySize.size22,
                    width: MySize.size22,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MySize.scaleFactorHeight * 10,
            ),
            SizedBox(
              height: MySize.scaleFactorHeight * 10,
            ),
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: questionItems.length,
                itemBuilder: (context, index) => Container(
                  height: MySize.screenHeight,
                  padding: EdgeInsets.symmetric(horizontal: MySize.size20),
                  margin: EdgeInsets.symmetric(horizontal: MySize.size20),
                  decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(MySize.size20),
                      image: const DecorationImage(
                          image: AssetImage(AppConst.eyeBg), fit: BoxFit.scaleDown, scale: 0.4)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MySize.scaleFactorHeight * 30,
                        ),
                        TextWidget(
                          maxLines: 4,
                          text: questionItems[index]['question'],
                          fontSize: MySize.size20,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppConst.primaryFont,
                          fontColor: AppColors.purpleColor,
                        ),
                        SizedBox(
                          height: MySize.scaleFactorHeight * 20,
                        ),
                        AnimationLimiter(
                            child: ListView.separated(
                          itemCount: questionItems[index]['options'].length,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => SizedBox(
                            height: MySize.scaleFactorHeight * 10,
                          ),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, ctx) =>
                              AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () {

                                    if(widget.viewMode!)
                                      {
                                        return;
                                      }

                                    userResponses[index] = UserResponse(
                                      index,
                                      questionItems[index]['options'][ctx],
                                    );
                                    saveSelectedOptions(userResponses);
                                    setState(() {});
                                  },

                                  child: Container(
                                    height: MySize.scaleFactorHeight * 56,
                                    width: MySize.screenWidth,
                                    decoration: BoxDecoration(
                                      color: userResponses[index]
                                                  ?.selectedOptionText ==
                                              questionItems[index]['options']
                                                  [ctx] && !widget.viewMode!
                                          ? AppColors.primaryColor :  userResponses[index]
                                          ?.selectedOptionText ==
                                          questionItems[index]['options']
                                          [ctx] && widget.viewMode! ? Colors.grey
                                          : Colors.transparent,
                                      border: Border.all(
                                        width: MySize.size2,
                                        color: userResponses[index]
                                                    ?.selectedOptionText ==
                                                questionItems[index]['options']
                                                    [ctx] && !widget.viewMode!
                                            ? AppColors.primaryColor : userResponses[index]
                                            ?.selectedOptionText ==
                                            questionItems[index]['options']
                                            [ctx] && widget.viewMode! ? Colors.grey
                                            : AppColors.purpleColor,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(MySize.size30),
                                    ),
                                    child: Center(
                                      child: TextWidget(
                                        text: questionItems[index]['options']
                                            [ctx],
                                        fontColor: userResponses[index]
                                                    ?.selectedOptionText ==
                                                questionItems[index]['options']
                                                    [ctx]
                                            ? AppColors.whiteColor
                                            : AppColors.blackColor,
                                        fontFamily: AppConst.primaryFont,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MySize.scaleFactorHeight * 10,
            ),
            paddingComp(ButtonWidget(
                onTap: onTapSubmit,
                text: _currentPage == 14&&!widget.viewMode! ? "Submit".tr() :
                _currentPage==14&&widget.viewMode! ? "Close".tr() : "Next".tr())),
            SizedBox(
              height: MySize.scaleFactorHeight * 10,
            ),
          ],
        ),
      ),
    );
  }

 // Future<void> getSavedOptions()
 // async {
 //    SharedPreferences prefs = await SharedPreferences.getInstance();
 //
 //    for (int i = 0; i < userResponses.length; i++) {
 //
 //      String? opt = prefs.getString('general_question_$i');
 //      if(opt == '')
 //        {
 //          opt = null;
 //        }
 //
 //      previoussavedOptions[i] = opt;
 //      // Print statement to log the saved data
 //     print('previous_saved_$i: $previoussavedOptions');
 //    }
 //  }

  void saveSelectedOptions(List<UserResponse?> userResponses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < userResponses.length; i++) {
      final selectedOption = userResponses[i]?.selectedOptionText;
      prefs.setString('general_question_$i', selectedOption ?? '');

      // Print statement to log the saved data
      if (kDebugMode) {
        print('Saved question_$i: $selectedOption');
      }
    }
  }

  void updateCompletionPercentage() async {

    int answeredQuestions =
        userResponses.where((response) => response != null).length;
    double completionPercentage = answeredQuestions * 1.2821;

    Provider.of<CalculateProfileCompletionPercent>(context, listen: false)
        .setGeneralCompletionPercent(completionPercentage);

    await Provider.of<CalculateProfileCompletionPercent>(context, listen: false)
        .calculateAllPercents();
  }

  Future<void> updateCompletionStatus()
  async {
    SharedPreferences preff = await SharedPreferences.getInstance();
    preff.setBool('completedGeneral', true);

    await Provider.of<ProfileCompletionStatus>(context, listen: false)
        .getCompleteionProfilesData();
  }


  Future<bool> submitGeneralProfile() async {
    SharedPreferences preff = await SharedPreferences.getInstance();
    try {
      var uid = preff!.getString('uid');

      var response = await post(Uri.parse(AppUrls.submitGeneralProfile), body: {
        "userid": uid ?? '',
        // Using the null-aware operator to handle a potential null value
        "gender": '${userResponses[0]?.selectedOptionText}',
        "education_level": '${userResponses[1]?.selectedOptionText}',
        "marital_status": '${userResponses[2]?.selectedOptionText}',
        "dependents": '${userResponses[3]?.selectedOptionText}',
        "childrens": '${userResponses[4]?.selectedOptionText}',
        "parentsliving": '${userResponses[5]?.selectedOptionText} living',
        "pet": '${userResponses[6]?.selectedOptionText} pet',
        "transport": '${userResponses[7]?.selectedOptionText}',
        "travel_abroad": '${userResponses[8]?.selectedOptionText} travel abroad',
        "color": '${userResponses[9]?.selectedOptionText}',
        "dream_car": '${userResponses[10]?.selectedOptionText}',
        "travel_fam": '${userResponses[11]?.selectedOptionText}',
        "industry": '${userResponses[12]?.selectedOptionText}',
        "travel_work": '${userResponses[13]?.selectedOptionText}',
      });

      var dataa = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter(
            "200",
            AppUrls.submitGeneralProfile,
            "POST",
            "userid: $uid\n"
                "gender: ${userResponses[0]?.selectedOptionText}\n"
                "education_level: ${userResponses[1]?.selectedOptionText}\n"
                "marital_status: ${userResponses[2]?.selectedOptionText}\n"
                "dependents: ${userResponses[3]?.selectedOptionText}\n"
                "childrens: ${userResponses[4]?.selectedOptionText}\n"
                "city: ${userResponses[5]?.selectedOptionText}\n"
                "pet: ${userResponses[6]?.selectedOptionText}\n"
                "transport: ${userResponses[7]?.selectedOptionText}\n"
                "travel_aboard: ${userResponses[8]?.selectedOptionText}\n"
                "color: ${userResponses[9]?.selectedOptionText}\n"
                "dream_car: ${userResponses[10]?.selectedOptionText}\n"
                "travel_fam: ${userResponses[11]?.selectedOptionText}\n"
                "industry: ${userResponses[12]?.selectedOptionText}\n"
                "travel_work: ${userResponses[13]?.selectedOptionText}\n",
            dataa,
            "quize_view_for_general_profile");

        return true;
      } else {
        CommonFuncs.apiHitPrinter(
            response.statusCode.toString(),
            AppUrls.submitGeneralProfile,
            "POST",
            "userid: $uid\n"
                "gender: ${userResponses[0]?.selectedOptionText}\n"
                "education_level: ${userResponses[1]?.selectedOptionText}\n"
                "marital_status: ${userResponses[2]?.selectedOptionText}\n"
                "dependents: ${userResponses[3]?.selectedOptionText}\n"
                "childrens: ${userResponses[4]?.selectedOptionText}\n"
                "city: ${userResponses[5]?.selectedOptionText}\n"
                "pet: ${userResponses[6]?.selectedOptionText}\n"
                "transport: ${userResponses[7]?.selectedOptionText}\n"
                "travel_aboard: ${userResponses[8]?.selectedOptionText}\n"
                "color: ${userResponses[9]?.selectedOptionText}\n"
                "dream_car: ${userResponses[10]?.selectedOptionText}\n"
                "travel_fam: ${userResponses[11]?.selectedOptionText}\n"
                "industry: ${userResponses[12]?.selectedOptionText}\n"
                "travel_work: ${userResponses[13]?.selectedOptionText}\n",
            dataa,
            "quize_view_for_general_profile");

        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
      //throw Exception('Error in registerWithAllOptions: $e');
    }
  }


  void printChoosenOptionsandQuestions() {
    for (var response in userResponses) {
      if (kDebugMode) {
        print(
          'JJProfiles\nQuestion: ${questionItems[response!.questionIndex]['question']}\n${response.selectedOptionText}'
          '\n============================================================');
      }
    }
  }


  void onTapSubmit() async {
  //  var len = previoussavedOptions.length;
    if (userResponses[_currentPage! - 1] != null) {

      saveSelectedOptions(userResponses);
      updateCompletionPercentage();

      if(_currentPage==14&&widget.viewMode!)
        {
          Navigator.pop(context);
        }

      if (_currentPage == 14&&!widget.viewMode!) {
       // updateCompletionStatus();
        // SharedPreferences preff = await SharedPreferences.getInstance();
        // preff.setBool('completedGeneral', true);

        printChoosenOptionsandQuestions();

        final isSuccess = await submitGeneralProfile();
        if (isSuccess) {

          updateCompletionStatus();

          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: EdgeInsets.symmetric(
                    horizontal: MySize.scaleFactorWidth * 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MySize.size16),
                ),
                child: Container(
                  padding: EdgeInsets.all(MySize.size20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(MySize.size16),
                    image: const DecorationImage(
                      image: AssetImage(AppConst.eyeBg),
                      fit: BoxFit.scaleDown,
                      scale: 0.6,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        text: 'Success!'.tr(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        fontSize: MySize.size22,
                        fontFamily: AppConst.primaryFont,
                        fontColor: AppColors.redColor,
                      ),
                      SizedBox(height: MySize.size22),
                      TextWidget(
                        text: 'Thank you for completing General Profile. Please complete other profiles too'.tr(),
                        textAlign: TextAlign.center,
                        maxLines: 6,
                        fontSize: MySize.size18,
                        fontFamily: AppConst.primaryFont,
                        fontColor: AppColors.purpleColor,
                      ),
                      SizedBox(height: MySize.size18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => SmookView(1),
                              //   ),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                              foregroundColor: Colors.black,
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(MySize.size8),
                              ),
                            ),
                            child: Text(
                              'Yes, Sure'.tr(),
                              style: const TextStyle(
                                  fontFamily: AppConst.primaryFont,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor),
                            ),
                          ),
                          SizedBox(
                            width: MySize.scaleFactorWidth * 8,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BottomBarView(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.redColor,
                              foregroundColor: Colors.black,
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(MySize.size8),
                              ),
                            ),
                            child: Text(
                              'Maybe, later'.tr(),
                              style: const TextStyle(
                                  fontFamily: AppConst.primaryFont,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      } else {

        _pageController.nextPage(
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeIn,

        );

      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option before proceeding.'),
        ),
      );
    }
  }
}
