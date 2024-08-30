import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';


class OTPView extends StatefulWidget {
  final String verificationId;

  const OTPView({super.key, required this.verificationId});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  String _commingSms = 'Unknown';
  final formKey = GlobalKey<FormState>();
  late SharedPreferences preff;
  int timerDuration = 120;
  bool isTimerActive = false;
  late Timer _timer;
   String buttonText = "Submit".tr();
   late String verId;

  @override
  void initState() {
    super.initState();
    getSP();
    initSmsListener();
    isTimerActive = true;
    verId = widget.verificationId;
    _initTimer();
  //  _verifyPhoneNumber();
  }

  Future<void> initSmsListener() async {

    String? commingSms;

    try {
      commingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      commingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;

    extractVerificationCode(commingSms!);
    // setState(() {
    //   _commingSms = commingSms!;
    //   print("coming sms: "+_commingSms);
    // });

  }


  void extractVerificationCode(String message) {
    try
    {
      RegExp regExp = RegExp(r'\b(\d{6})\b');
      RegExpMatch? match = regExp.firstMatch(message);
      if (match != null) {
        //return match.group(0);
        setState(() {
          pinController.text = match.group(0)!;
        });
      }
    }
    catch(e)
    {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void dispose() {
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }


  void _initTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (timerDuration == 0) {
        setState(() {
          isTimerActive = false;
        });
        timer.cancel();
      } else {
        setState(() {
          timerDuration--;
        });
      }
    });
  }
  Future<void> getSP() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }


  Future<void> _verifyPhoneNumber() async {
    try {
      final PhoneVerificationCompleted verificationCompleted =
          (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      };

      final PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException e) {
        if (kDebugMode) {
          print('Error: $e');
        }
      };

      final PhoneCodeSent codeSent =
          (String verificationId, int? resendToken) async {
        setState(() {
          this.verId = verId;
          isTimerActive = true;
          timerDuration = 120;
          buttonText = "Submit".tr();// Reset timer duration
        });

        _initTimer();
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        setState(() {
          this.verId = verificationId;
        });
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+92${preff.get('phone').toString().substring(1)}',
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> _signInWithPhoneNumber(String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return validationDialog(context,
            icon: AppConst.activeTick,
            btnText: "Ok".tr(),
            oprText: "Your OTP is successfully verified".tr(),
            ontap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UniquePinView(),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return validationDialog(context,
            isTitle: true,
            title: TextWidget(
              text: "Verification".tr(),
              fontSize: MySize.size28,
              fontColor: AppColors.redColor,
              fontWeight: FontWeight.w700,
            ),
            oprText: "Invalid OTP. Please try again.".tr(),
            ontap: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    const focusedBorderColor = AppColors.lightGreen;
    const fillColor = Colors.transparent;
    const borderColor = AppColors.lightGreen;

    final defaultPinTheme = PinTheme(
      width: MySize.size60,
      height: MySize.size68,
      textStyle: TextStyle(
          fontSize: MySize.size22,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: AppConst.primaryFont),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySize.size10),
        border: Border.all(color: borderColor, width: MySize.size2),
      ),
    );
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MySize.screenHeight,
            width: MySize.screenWidth,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
          ),
          SingleChildScrollView(
            child: SizedBox(
           //   height: MySize.screenHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  logoComp(height: MySize.size50, width: MySize.screenWidth * 0.6),
                  SizedBox(height: MySize.size90,),
                  Column(
                    children: [
                      TextWidget(
                        text: "Enter Verification Code".tr(),
                        fontSize: MySize.size26,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.secondaryColor,
                        fontFamily: AppConst.primaryFont,
                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 10,
                      ),
                      TextWidget(
                        text: "Press enter verification code sent to: ".tr(),
                        fontSize: MySize.size16,
                        textAlign: TextAlign.center,
                        fontColor: AppColors.secondaryColor,
                      ),
                      TextWidget(
                        text: "${preff?.get('phone')}",
                        fontSize: MySize.size16,
                        textAlign: TextAlign.center,
                        fontColor: AppColors.secondaryColor,
                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 20,
                      ),
                      Pinput(
                        androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                        controller: pinController,
                        focusNode: focusNode,
                        preFilledWidget: Container(
                          height: MySize.size64,
                          width: MySize.size56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(MySize.size8),
                            // color: AppColors.whiteColor,
                            // boxShadow: [AppStyles.primaryShadow]
                          ),
                        ),
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        // validator: (value) {
                        //   return value == '0000' ? null : "Invalid";
                        // },
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onCompleted: (pin) {
                          debugPrint('onCompleted: $pin');
                        },
                        onChanged: (value) {
                          debugPrint('onChanged: $value');
                        },
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: MySize.size10),
                              width: MySize.size22,
                              height: 1,
                              color: focusedBorderColor,
                            ),
                          ],
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: focusedBorderColor),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: fillColor,
                            borderRadius: BorderRadius.circular(MySize.size10),
                            border: Border.all(color: focusedBorderColor),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyBorderWith(
                          border: Border.all(color: AppColors.redColor),
                        ),
                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 20,
                      ),
                      RichText(
                          text: TextSpan(children: [
                            TextSpan(text: "Resend Code in  ".tr(), style: style()),
                            TextSpan(
                                text: "${timerDuration ~/ 60}:${timerDuration % 60}",
                                style: style(color: AppColors.whiteColor)),
                          ])),
                    ],
                  ),

                  SizedBox(
                    height: MySize.scaleFactorHeight * 20,
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: MySize.size40),
                    child: ButtonWidget(
                      onTap: () {
                        // if (!isTimerActive) {
                        //   _verifyPhoneNumber();
                        // } else {
                          if (pinController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return validationDialog(context,
                                      oprText:
                                      "Please enter your Verification Pin code".tr(),
                                      ontap: () {
                                        Navigator.pop(context);
                                      });
                                });
                          } else if (pinController.length < 6) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return validationDialog(context,
                                      isTitle: true,
                                      title: TextWidget(
                                        text: "Verification".tr(),
                                        fontSize: MySize.size28,
                                        fontColor: AppColors.redColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      oprText:
                                      "Please enter your Verification Pin code".tr(),
                                      ontap: () {
                                        Navigator.pop(context);
                                      });
                                });
                          } else {
                            _signInWithPhoneNumber(pinController.text);
                          }
                    //    }
                      },
                      text: buttonText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }

  TextStyle style({Color color = AppColors.secondaryColor}) => TextStyle(
      fontSize: MySize.size16,
      fontWeight: FontWeight.w600,
      color: color,
      fontFamily: AppConst.secondaryFont);
}

class OTPWidget extends StatefulWidget {
  const OTPWidget({super.key});

  @override
  State<OTPWidget> createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    const focusedBorderColor = AppColors.primaryColor;
    const fillColor = Colors.transparent;
    const borderColor = AppColors.secondaryColor;

    final defaultPinTheme = PinTheme(
      width: MySize.size60,
      height: MySize.size60,
      textStyle: const TextStyle(fontSize: 22, color: Colors.white),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySize.size10),
        border: Border.all(color: borderColor),
      ),
    );
    return Material(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Pinput(
              controller: pinController,
              focusNode: focusNode,
              androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              preFilledWidget: Container(
                height: MySize.size56,
                width: MySize.size56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MySize.size8),
                  // color: AppColors.whiteColor,
                  // boxShadow: [AppStyles.primaryShadow]
                ),
              ),
              defaultPinTheme: defaultPinTheme,
              validator: (value) {
                return value == '2222' ? null : 'Pin is incorrect'.tr();
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(MySize.size10),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: AppColors.redColor),
              ),
            ),
            TextButton(
              onPressed: () {
                focusNode.unfocus();
                formKey.currentState!.validate();
              },
              child: TextWidget(text: 'Validate'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
