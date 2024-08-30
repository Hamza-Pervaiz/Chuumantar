import 'package:chumanter/views/quize_view/quiz_question_financial.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../configs/providers/calculating_profile_completion_percent_provider.dart';
import '../../configs/providers/profile_completion_status.dart';
import '../../res/utils/CommonFuncs.dart';

class UserResponse {
  int questionIndex;
  String selectedOptionText;

  UserResponse(this.questionIndex, this.selectedOptionText);
}

class QuizeViewFinancial extends StatefulWidget {
  QuizeViewFinancial({
    super.key,
    this.isTimer = true,
    this.isInteractive = false,
    this.viewMode,
    this.image = AppConst.quizeImg,
  });

  final bool isTimer;
  bool? viewMode;
  final bool isInteractive;
  final String image;

  @override
  State<QuizeViewFinancial> createState() =>
      _QuizeViewFinancialState();
}

class _QuizeViewFinancialState extends State<QuizeViewFinancial> {
  final _pageController = PageController();
  int? _currentPage;
  List<Map<String, dynamic>> questionItems = [];
  List<UserResponse?> userResponses = List.generate(15, (index) => null);
  SharedPreferences? preff;
  Future getPreff() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }
  @override
  void initState() {
    super.initState();

    _currentPage = 1;
    questionItems = QuizDataFinancial.getFinanceQuestions();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt() + 1;
      });
    });
    loadFinancialQuestion();

  }


  void loadFinancialQuestion() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < userResponses.length; i++) {
      final selectedOption = prefs.getString('financial_question_$i');
      if (selectedOption != null && selectedOption != '') {
        userResponses[i] = UserResponse(i, selectedOption);
        // Check if the loaded option matches the currently selected option
        if (i == taped) {
          taped = i; // Update the taped variable
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
                  text: "Financial Profile",
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
                      totalSteps: 15,
                      currentStep: _currentPage!,
                      selectedColor: AppColors.primaryColor,
                      unselectedColor: AppColors.primaryColor.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(
                    width: MySize.scaleFactorWidth * 8,
                  ),
                  TextWidget(
                    text: "$_currentPage/15",
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
                                              color: userResponses[index]?.selectedOptionText ==
                                                  questionItems[index]['options'][ctx] && !widget.viewMode!
                                                  ? AppColors.primaryColor : userResponses[index]?.selectedOptionText ==
                                                  questionItems[index]['options'][ctx] && widget.viewMode! ?
                                                  Colors.grey
                                                  : Colors.transparent,
                                              border: Border.all(
                                                width: MySize.size2,
                                                color: userResponses[index]?.selectedOptionText ==
                                                    questionItems[index]['options'][ctx] && !widget.viewMode!
                                                    ? AppColors.primaryColor : userResponses[index]?.selectedOptionText ==
                                                    questionItems[index]['options'][ctx] && widget.viewMode! ?
                                                    Colors.grey
                                                    : AppColors.purpleColor,
                                              ),
                                              borderRadius: BorderRadius.circular(MySize.size30),
                                            ),
                                            child: Center(
                                              child: TextWidget(
                                                text: questionItems[index]['options'][ctx],
                                                fontColor: userResponses[index]?.selectedOptionText ==
                                                    questionItems[index]['options'][ctx]
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
                            ))
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
                text: _currentPage == 15&&!widget.viewMode! ? "Submit".tr() :  _currentPage == 15&&widget.viewMode! ?
                "Close".tr() : "Next".tr()
            )),
            SizedBox(
              height: MySize.scaleFactorHeight * 10,
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     printSelectedOptions();
            //   },
            //   child: Text('Print Selected Options'),
            // ),
          ],
        ),
      ),
    );
  }

  // void printSelectedOptions() {
  //   for (int i = 0; i < userResponses.length; i++) {
  //     final question = questionItems[i]['question'];
  //     final selectedOption = userResponses[i]?.selectedOptionText;
  //     if (selectedOption != null) {
  //       print('$question: $selectedOption');
  //     }
  //   }
  // }
  void saveSelectedOptions(List<UserResponse?> userResponses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < userResponses.length; i++) {
      final selectedOption = userResponses[i]?.selectedOptionText;
      prefs.setString('financial_question_$i', selectedOption ?? '');

      // Print statement to log the saved data
      if (kDebugMode) {
        print('Saved question_$i: $selectedOption');
      }
    }
  }

  void updateCompletionPercentage()async{
    int answeredQuestions = userResponses.where((response) => response != null).length;
    double completionPercentage = answeredQuestions * 1.12;

    Provider.of<CalculateProfileCompletionPercent>(context, listen: false)
        .setFinancialCompletionPercent(completionPercentage);
    await Provider.of<CalculateProfileCompletionPercent>(context, listen: false)
        .calculateAllPercents();
  }

  Future<void> updateCompletionStatus()
  async {
    SharedPreferences preff = await SharedPreferences.getInstance();
    preff.setBool('completedFinancial', true);
    await Provider.of<ProfileCompletionStatus>(context, listen: false)
        .getCompleteionProfilesData();
  }


  Future<bool> submitFinancialProfile() async {
    SharedPreferences preff = await SharedPreferences.getInstance();
    try {
      var uid = preff!.getString('uid');

      var response = await post(Uri.parse(AppUrls.submitTechnologyProfile), body: {
        "userid": uid ?? '',
        // Using the null-aware operator to handle a potential null value
        "devices": '${userResponses[0]?.selectedOptionText}',
        "video_gmaes": '${userResponses[1]?.selectedOptionText}',
        "onmobile": '${userResponses[2]?.selectedOptionText}',
        "computer_lap": '${userResponses[3]?.selectedOptionText}',
        "online_earn": '${userResponses[4]?.selectedOptionText}',
        "qr_payment": '${userResponses[5]?.selectedOptionText}',
        "mobile_banking": '${userResponses[6]?.selectedOptionText}',
        "otherpayment_method": userResponses[7]?.selectedOptionText,
        "raast_account": '${userResponses[8]?.selectedOptionText}',
        "machine": '${userResponses[9]?.selectedOptionText}',
        "mobile_brand": '${userResponses[10]?.selectedOptionText}',
        "latoptechnology": '${userResponses[11]?.selectedOptionText}',
        "bankingapp": '${userResponses[12]?.selectedOptionText}',
        "tech": '${userResponses[13]?.selectedOptionText}',
        "tech": '${userResponses[14]?.selectedOptionText}',
      });

      var dataa = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter(
            "200",
            AppUrls.submitShoppingProfile,
            "POST",
            "userid: $uid\n"
                "devices: ${userResponses[0]?.selectedOptionText}\n"
                "video_gmaes: ${userResponses[1]?.selectedOptionText}\n"
                "onmobile: ${userResponses[2]?.selectedOptionText}\n"
                "computer_lap: ${userResponses[3]?.selectedOptionText}\n"
                "online_earn: ${userResponses[4]?.selectedOptionText}\n"
                "qr_payment: ${userResponses[5]?.selectedOptionText}\n"
                "mobile_banking: ${userResponses[6]?.selectedOptionText}\n"
                "otherpayment_method: ${userResponses[7]?.selectedOptionText}\n"
                "raast_account: ${userResponses[8]?.selectedOptionText}\n"
                "machine: ${userResponses[9]?.selectedOptionText}\n"
                "mobile_brand: ${userResponses[10]?.selectedOptionText}\n"
                "latoptechnology: ${userResponses[11]?.selectedOptionText}\n"
                "bankingapp: ${userResponses[12]?.selectedOptionText}\n"
                "tech: ${userResponses[13]?.selectedOptionText}\n"
                "tech: ${userResponses[14]?.selectedOptionText}\n",
            dataa,
            "quize_view_for_general_profile");

        return true;
      } else {
        CommonFuncs.apiHitPrinter(
            response.statusCode.toString(),
            AppUrls.submitShoppingProfile,
            "POST",
            "userid: $uid\n"
                "devices: ${userResponses[0]?.selectedOptionText}\n"
                "video_gmaes: ${userResponses[1]?.selectedOptionText}\n"
                "onmobile: ${userResponses[2]?.selectedOptionText}\n"
                "computer_lap: ${userResponses[3]?.selectedOptionText}\n"
                "online_earn: ${userResponses[4]?.selectedOptionText}\n"
                "qr_payment: ${userResponses[5]?.selectedOptionText}\n"
                "mobile_banking: ${userResponses[6]?.selectedOptionText}\n"
                "otherpayment_method: ${userResponses[7]?.selectedOptionText}\n"
                "raast_account: ${userResponses[8]?.selectedOptionText}\n"
                "machine: ${userResponses[9]?.selectedOptionText}\n"
                "mobile_brand: ${userResponses[10]?.selectedOptionText}\n"
                "latoptechnology: ${userResponses[11]?.selectedOptionText}\n"
                "bankingapp: ${userResponses[12]?.selectedOptionText}\n"
                "tech: ${userResponses[13]?.selectedOptionText}\n"
                "tech: ${userResponses[14]?.selectedOptionText}\n",
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



  void onTapSubmit() async{

    if (userResponses[_currentPage! - 1] != null) {
      saveSelectedOptions(userResponses);

      updateCompletionPercentage();

      if(_currentPage == 15 && widget.viewMode!)
        {
          Navigator.pop(context);
        }

      if (_currentPage == 15&&!widget.viewMode!) {

        // for (var response in userResponses) {
        //   print('Question ${response!.questionIndex + 1}:${response.selectedOptionText}');
        // }
        updateCompletionStatus();

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding:
              EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySize.size16),
              ),
              child: Container(
              //  height: MySize.scaleFactorHeight * 240,

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
                      text: 'Thank you for completing all profiles'.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 6,
                      fontSize: MySize.size18,
                      fontFamily: AppConst.primaryFont,
                      fontColor: AppColors.purpleColor,
                    ),
                    SizedBox(height: MySize.size18),

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
                          borderRadius: BorderRadius.circular(MySize.size8),
                        ),
                      ),
                      child: Text('Ok'.tr(),style: const TextStyle( fontFamily: AppConst.primaryFont,
                          fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => BottomBarView(),
        //   ),
        // );
      } else {
        taped = -1; // Reset the taped variable
        _pageController.nextPage(
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeIn,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an option before proceeding.'.tr()),
        ),
      );
    }
  }

}