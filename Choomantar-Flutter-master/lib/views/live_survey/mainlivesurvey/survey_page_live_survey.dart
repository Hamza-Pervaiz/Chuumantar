import 'dart:developer';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/smook_view/exit_smoke_view_for_surveys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:http/http.dart' as http;
import '../../../configs/imports/import_helper.dart';



class SurveyPageLiveSurvey extends StatefulWidget {
  final Map<String, dynamic> surveyData;
  final VoidCallback onPageFinished;
  final Function(String) onGoBack;
  final List<dynamic> allSurveyData; // Add this line
 final bool isTimer;
  const SurveyPageLiveSurvey({
    super.key,
    required this.surveyData,
    required this.onPageFinished,
    required this.allSurveyData,
    this.isTimer =true,// Add this line
    required this.onGoBack,

  });

  @override
  State<SurveyPageLiveSurvey> createState() => _SurveyPageLiveSurveyState();
}

class _SurveyPageLiveSurveyState extends State<SurveyPageLiveSurvey>  {

  late PageController questionPageController;
  List<String> selectedOptions = [];
  int currentQuestionIndex = 0;
  String? submit = 'Submit';
  String? nextQuestion ='Next Question';
  String? points;
String booltoString='';
  bool isVisible =false;
  late Timer timer;
  int seconds = 0;
  double timeLeft = 0;

  @override
  void initState() {
    super.initState();
    questionPageController = PageController();
    getPreff();

    Future.delayed(const Duration(seconds: 4), () {

      widget.isTimer ? startTimer() : null;
      // code to be executed after 2 seconds
    });

  //  widget.isTimer ? startTimer() : null;

    CommonFuncs.showToast("survey_page_live_survey\nSurveyPageLiveSurvey");

  }

  void startTimer() {
    if (kDebugMode) {
      print("jjjtimer: inside starttimer()");
    }
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (kDebugMode) {
          print("jjjtimer: inside setState()");
        }

        if (seconds < 25) {
          if (kDebugMode) {
            print("jjjtimer: inside seconds<15()");
          }

          seconds = seconds + 1;
          timeLeft = seconds / 25;
          if (kDebugMode) {
            print("jjjtimerseconds: $seconds");
          }

        }
        if (seconds == 25) {
          if (kDebugMode) {
            print("jjjtimer: inside seconds>=15()");
          }
          seconds = 0;
          timer.cancel();

          if (kDebugMode) {
            print("jjjtimerseconds: $seconds");
          }

          showAdaptiveDialog(
              context: context,
              barrierDismissible: false,
              builder: (index) =>
                  Dialog(
                    insetPadding: EdgeInsets.symmetric(
                        horizontal: MySize.scaleFactorWidth * 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                        height: MySize.scaleFactorHeight * 270,
                        width: MySize.screenWidth,
                        padding: EdgeInsets.all(MySize.size20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          image: const DecorationImage(
                            image: AssetImage(AppConst.eyeBg),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Image.asset(
                                AppConst.closeIcon,
                                height: MySize.size40,
                                width: MySize.size40,
                              ),
                            ),
                            Center(
                              child: TextWidget(
                                text: "Answer Timeout",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                fontSize: MySize.size20,
                                fontFamily: AppConst.primaryFont,
                                fontColor: AppColors.purpleColor,
                              ),
                            ),
                            TextWidget(
                              text: "Do you want to retake the survey",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              fontSize: MySize.size20,
                              fontFamily: AppConst.primaryFont,
                              fontColor: AppColors.purpleColor,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: MySize.scaleFactorHeight * 40,
                                    child: ButtonWidget(
                                        onTap: () {
                                          // Navigator.pop(context);
                                          // Navigator.of(context).pop();
                                          timer.cancel();
                                          seconds = 0;
                                          Navigator.pop(context);
                                          widget.onGoBack("dontremove");
                                          if (kDebugMode) {
                                            print("jjjtimerseconds: $seconds");
                                          }

                                        },
                                        text: "No"),
                                  ),
                                ),
                                SizedBox(
                                  width: MySize.scaleFactorWidth * 12,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: MySize.scaleFactorHeight * 40,
                                    child: ButtonWidget(
                                        onTap: () {
                                          resetTimer();
                                          resetSurveyState();
                                          questionPageController.jumpToPage(0);
                                          Navigator.pop(context);
                                        },
                                        text: "Yes"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ));
        }
      });
    });
  }
  void resetSurveyState() {
    selectedOptions.clear();
    currentQuestionIndex=0;
  }
  void resetTimer() {
    timer.cancel();
    seconds = 0;
    timeLeft = 0;
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel(); // Dispose of the timer
    questionPageController.dispose();
    super.dispose();
  }
  SharedPreferences? preff;

  Future getPreff() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }
  Future<void> submitSurveyQuestions(String questionId, List<String> answer, bool isLastQuestion) async {
    String boolToString = isLastQuestion ? 'true' : 'false';
    try {
      log('User ID: ${preff!.get('uid').toString()}, Question ID: $questionId, Answer: ${answer.join(',')}, Is Last Answer: $boolToString');

      var response = await http.post(
        Uri.parse(AppUrls.submitSurvey),
        body: {
          "userId": preff!.get('uid').toString(),
          "questionId": questionId,
          "answer": answer.join(','),
          "lastanswer": boolToString,
        },
      );


      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {

        CommonFuncs.apiHitPrinter("200", AppUrls.submitSurvey, "POST",
            "userId: ${preff!.get('uid').toString()}\n"
                "questionId: $questionId\n"
                "answer: ${answer.join(',')}\n"
                "lastanswer: $boolToString", responseData,
            "survey_page_live_survey");

        if (kDebugMode) {
          print('Survey question submitted successfully');
        }


        if (isLastQuestion) {
          final preffs= await SharedPreferences.getInstance();
          preffs.setBool('notification', true);
          var points = responseData['points'];
          if (kDebugMode) {
            print('Points: $points');
          }

        }
      } else {

        CommonFuncs.apiHitPrinter(response.statusCode.toString(), AppUrls.submitSurvey, "POST",
            "userId: ${preff!.get('uid').toString()}\n"
                "questionId: $questionId\n"
                "answer: ${answer.join(',')}\n"
                "lastanswer: $boolToString", responseData,
            "survey_page_live_survey");

        if (kDebugMode) {
          print('Error submitting survey question. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> questions = widget.surveyData['questions'];

    return PageView.builder(
      controller: questionPageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questions.length + 1,
      itemBuilder: (context, index) {
        if (index < questions.length) {
          return WillPopScope(
            onWillPop: () async {
              if (index > 0) {
                questionPageController.previousPage(
                  duration: const Duration(milliseconds:1),
                  curve: Curves.bounceOut,
                );
                return false;
              }
              return true;
            },
            child: buildQuestionPage(
              questions.entries.toList()[index].value,
              questionPageController,
              index,
              widget.allSurveyData.length,
              questions.length,
            ),
          );
        } else {
          return WillPopScope(
            onWillPop: () async {
              if (widget.allSurveyData.indexOf(widget.surveyData) ==
                  widget.allSurveyData.length - 1) {
                widget.onPageFinished();
                return false;
              } else {
                widget.onPageFinished();
                return true;
              }
            },
            child: buildFinishPage(),
          );
        }
      },
    );
  }

  Widget buildQuestionPage(
      Map<String, dynamic> questionData,
      PageController controller,
      int currentIndex,
      int totalSurveys,
      int totalQuestionsInSurvey,
      ) {

    bool isLastQuestion = currentIndex == totalQuestionsInSurvey - 1;
    List<String> localSelectedOptions = List.from(questionData['selected_options'] ?? []);
    ProgressDialog progressDialog;
    return Column(
      children: [

        Row(
          children: [
            Expanded(
              child: StepProgressIndicator(
                size: MySize.size6,
                roundedEdges: Radius.circular(MySize.size6),
                totalSteps: totalQuestionsInSurvey,
                currentStep: currentIndex+1!,
                selectedColor: AppColors.primaryColor,
                unselectedColor: AppColors.primaryColor.withOpacity(0.6),
              ),
            ),
            SizedBox(
              width: MySize.scaleFactorWidth * 8,
            ),
            TextWidget(
              text: "${currentIndex+1}/$totalQuestionsInSurvey",
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


        TextWidget(
          text: "$seconds",
          fontSize: MySize.size16,
          fontWeight: FontWeight.w600,
          fontFamily: AppConst.primaryFont,
          fontColor: seconds < 9
              ? AppColors.primaryColor
              : seconds > 9 && seconds > 12
              ? AppColors.redColor
              : Colors.orange,
        ),
        SizedBox(
          height: MySize.size4,
        ),
        LinearProgressIndicator(
          minHeight: MySize.size10,
          borderRadius: BorderRadius.circular(MySize.size30),
          color: AppColors.whiteColor,
          semanticsLabel: seconds.toString(),
          value: timeLeft,
          semanticsValue: "Seconds",
          valueColor: AlwaysStoppedAnimation(
            seconds < 9
                ? AppColors.primaryColor
                : seconds > 9 && seconds > 12
                ? AppColors.redColor
                : Colors.orange,
          ),
        ),
        SizedBox(
          height: MySize.size4,
        ),
        TextWidget(
          text: "Seconds",
          fontColor: AppColors.primaryColor,
          fontSize: MySize.size12,
          fontFamily: AppConst.primaryFont,
          fontWeight: FontWeight.w700,
        ),

        Expanded(

          child: Container(
          //  width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.symmetric(
              vertical: 15.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(MySize.size16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
              image: const DecorationImage(
                image: AssetImage(AppConst.eyeBg,),
                fit: BoxFit.none,
                alignment: Alignment.center,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${questionData['question_text']}',
                    maxLines: 4,
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MySize.size20,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppConst.primaryFont,
                      color: AppColors.purpleColor,
                    ),
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 10,
                  ),
                  for (var option in questionData['options'])
                    AnimationConfiguration.staggeredList(
                      position: questionData['options'].indexOf(option),
                      duration: const Duration(milliseconds: 900),
                      child: SlideAnimation(
                        verticalOffset: 100.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              if (kDebugMode) {
                                print('Option tapped: ${option['option_text']}');
                              }
                              setState(() {
                                if (questionData['question_type'] == 'busting') {

                                  localSelectedOptions.clear();
                                  localSelectedOptions.add(option['option_text']);
                                }
                                else if(questionData['question_type'] == 'radio')
                                {
                                  localSelectedOptions.clear();
                                  localSelectedOptions.add(option['option_text']);
                                }
                                else {

                                  if (localSelectedOptions.contains(option['option_text'])) {
                                    localSelectedOptions.remove(option['option_text']);
                                  } else {
                                    localSelectedOptions.add(option['option_text']);
                                  }
                                }
                              });

                              questionData['selected_options'] = List.from(localSelectedOptions);
                            },
                            child: Container(
                              height: MySize.scaleFactorHeight * 56,
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                bottom: MySize.size10,
                              ),
                              decoration: BoxDecoration(
                                color: localSelectedOptions.contains(option['option_text'])
                                    ? Colors.green
                                    : Colors.transparent,
                                border: Border.all(
                                  width: MySize.size2,
                                  color: AppColors.purpleColor,
                                ),
                                borderRadius: BorderRadius.circular(MySize.size30),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: MySize.size20,
                              ),
                              alignment: Alignment.center,
                              child: TextWidget(
                                text: option['option_text'],
                                fontColor: AppColors.blackColor,
                                fontFamily: AppConst.primaryFont,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.zero,
          child: ElevatedButton(
            onPressed: () async {

              progressDialog = ProgressDialog(context, type: ProgressDialogType.normal,isDismissible: false);
              progressDialog.style(

                textAlign: TextAlign.center,
                message: 'Submitting...'.tr(),
                elevation: 10,
                padding: const EdgeInsets.symmetric(vertical: 10),
                messageTextStyle: const TextStyle(
                  color: AppColors.purpleColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              );


              List<String> selectedOptions = List.from(questionData['selected_options'] ?? []);
              questionData['selected_options'] = selectedOptions;
              setState(() {
                log('selected option is: $selectedOptions');
              });

              if (selectedOptions.isEmpty) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return validationDialog(context,
                          isTitle: true,
                          title: TextWidget(
                            text: "Invalid Input".tr(),
                            fontSize: MySize.size28,
                            fontColor: AppColors.redColor,
                            fontWeight: FontWeight.w700,
                          ),
                          oprText: "Select at least one option".tr(),
                          ontap: () {
                            Navigator.pop(context);

                          });
                    });
              } else
              {
                if (questionData['question_type'] == 'busting') {
                  bool isCorrectAnswer = questionData['options'].any((opt) =>
                  selectedOptions.contains(opt['option_text']) && opt['is_correct'] == '1');
                  if (kDebugMode) {
                    print('correct answer: $isCorrectAnswer');
                  }

                  if (!isCorrectAnswer) {
                    if (kDebugMode) {
                      print('wrong answer: $isCorrectAnswer');
                    }

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return validationDialog(context,
                              isTitle: true,

                              title: TextWidget(
                                text: "Oops!".tr(),
                                fontSize: MySize.size23,
                                fontColor: AppColors.redColor,
                                fontWeight: FontWeight.w700,
                              ),
                              oprText: "You are not paying attention.\nYou will have to retake survey again. ".tr(),
                              ontap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                // questionPageController.previousPage(
                                //   duration: Duration(milliseconds: 1),
                                //   curve: Curves.easeOut,
                                // );

                              });
                        });

                    return;
                  }
                }
                progressDialog.show();

                await submitSurveyQuestions(
                  questionData['question_id'].toString(),
                  selectedOptions,
                  isLastQuestion,
                );

                progressDialog.hide();
                resetTimer();
                if (!isLastQuestion) {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 2),
                    curve: Curves.easeOut,
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExitSmokeViewForSurvey()),
                  );
                  questionPageController.nextPage(
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.easeOut,
                  );
                  setState(() {
                    currentQuestionIndex++;
                  });
                }
              }
            },
            style: ElevatedButton.styleFrom(
              surfaceTintColor: AppColors.whiteColor,
              elevation: 5,
              shadowColor: Colors.black,
            ),
            child: Center(
              child: Text(
                isLastQuestion ? '$submit' : '$nextQuestion',
                style: TextStyle(
                  fontSize: MySize.size16,
                  fontFamily: AppConst.primaryFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );

  }
  Widget buildFinishPage() {
    bool isLastSurvey =
        widget.allSurveyData.indexOf(widget.surveyData) ==
            widget.allSurveyData.length - 1;
    if(!isLastSurvey )
    {
      timer.cancel();
    }
    else{
      timer.cancel();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MySize.size20),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,

            offset: const Offset(0,3),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage(AppConst.eyeBg),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.all(MySize.size10),
      margin: isLastSurvey
          ? EdgeInsets.symmetric(
        vertical: MySize.size230,
        horizontal: 1,
      )
          : EdgeInsets.symmetric(
        vertical:MySize.size200,
        horizontal: 1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            isLastSurvey
                ? ''
                : "Good Job".tr(),
            style: TextStyle(
              fontSize: MySize.size22,
              fontFamily: AppConst.primaryFont,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryColor,

            ),
            textAlign: TextAlign.center,
          ),
          if (!isLastSurvey)
            Image.asset(
              "assets/images/thumbIcon.png",
              width: 200,
              height: 50,
              // Other properties as needed
            ),

          SizedBox(height: MySize.size16),
          Center(

            child: Text(
              isLastSurvey
                  ? "Thank you for your time. We will see you soon..".tr()
                  : "Do you want to take another survey".tr(),
              style: TextStyle(
                fontSize: MySize.size16,
                fontFamily: AppConst.primaryFont,
                fontWeight: FontWeight.w600,
                color: AppColors.blueColor,

              ),
              textAlign: TextAlign.center,
              textScaleFactor: 1.0,
            ),
          ),
          SizedBox(height: MySize.size16),
          if (!isLastSurvey)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                const SizedBox(height: 3,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        // startTimer();
                        // widget.onPageFinished();
                        widget.onGoBack("remove");


                      },
                      child: Container(
                        width:110,
                        height:40,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.9),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Yes'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    GestureDetector(
                      onTap: (){  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomBarView(),
                        ),
                      );},
                      child: Container(
                        width:110,
                        height:40,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.9),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'No'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),

          if (isLastSurvey)

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [

                const SizedBox(height: 3,),
                ElevatedButton(
                  onPressed: () {
                    timer.cancel();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomBarView(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: Colors.black,
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MySize.size8),
                    ),
                  ),
                  child: Text('Come Back Later'.tr(),style: const TextStyle( fontFamily: AppConst.primaryFont,
                      fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
                ),
              ],
            ),
        ],
      ),
    );
  }
  Widget customStyledButton({
    required String text,
    required Function onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0,right: 40),
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
          height: MySize.scaleFactorHeight * 40, // Adjust the height as needed
          decoration: BoxDecoration(
            border: Border.all(
              width: MySize.size2,
              color: AppColors.blackColor, // Black outline color
            ),
            borderRadius: BorderRadius.circular(MySize.size20),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MySize.size20,
          ),
          alignment: Alignment.center,
          child: TextWidget(
            text: text,
            fontColor: AppColors.blackColor,
            fontFamily: AppConst.primaryFont,
          ),
        ),
      ),
    );
  }

}