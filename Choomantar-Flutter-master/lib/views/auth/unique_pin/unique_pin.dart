import 'dart:developer';

import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class UniquePinView extends StatefulWidget {
  const UniquePinView({super.key});

  @override
  State<UniquePinView> createState() => _UniquePinViewState();
}

class _UniquePinViewState extends State<UniquePinView> {
  final pinOneController = TextEditingController();
  final pinTwoController = TextEditingController();
  final focusNode = FocusNode();
  final focusNode2 = FocusNode();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSP();
  }

  SharedPreferences? preff;
  getSP() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void dispose() {
    pinOneController.dispose();
    pinTwoController.dispose();
    focusNode.dispose();
    super.dispose();
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
            //  height: MySize.screenHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MySize.size20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    logoComp(
                        height: MySize.size50, width: MySize.screenWidth * 0.6),

                    SizedBox(height: MySize.size30,),

                    Column(
                      children: [
                        TextWidget(
                          text: "Enter a Unique 5 digit Pin".tr(),
                          fontSize: MySize.size26,
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.secondaryColor,
                          fontFamily: AppConst.primaryFont,
                        ),
                        SizedBox(
                          height: MySize.scaleFactorHeight * 30,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: MySize.size30),
                            child: TextWidget(
                              text: "Enter Pin".tr(),
                              fontSize: MySize.size16,
                              fontWeight: FontWeight.w700,
                              fontColor: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MySize.scaleFactorHeight * 20,
                        ),
                        Pinput(
                          controller: pinOneController,
                          focusNode: focusNode,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsUserConsentApi,

                          listenForMultipleSmsOnAndroid: true,
                          preFilledWidget: Container(
                            height: MySize.size64,
                            width: MySize.size56,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(MySize.size8),
                            ),
                          ),
                          length: 5,
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
                                margin:
                                    EdgeInsets.only(bottom: MySize.size10),
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
                              borderRadius:
                                  BorderRadius.circular(MySize.size10),
                              border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: AppColors.redColor),
                          ),
                        ),
                        SizedBox(
                          height: MySize.scaleFactorHeight * 30,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: MySize.size30),
                            child: TextWidget(
                              text: "ReEnter Pin".tr(),
                              fontSize: MySize.size16,
                              fontWeight: FontWeight.w700,
                              fontColor: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MySize.scaleFactorHeight * 20,
                        ),
                        Pinput(
                          controller: pinTwoController,
                          focusNode: focusNode2,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsUserConsentApi,
                          listenForMultipleSmsOnAndroid: true,
                          preFilledWidget: Container(
                            height: MySize.size64,
                            width: MySize.size56,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(MySize.size8),
                            ),
                          ),
                          length: 5,
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
                                margin:
                                    EdgeInsets.only(bottom: MySize.size10),
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
                              borderRadius:
                                  BorderRadius.circular(MySize.size10),
                              border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: AppColors.redColor),
                          ),
                        ),
                        SizedBox(
                          height: MySize.scaleFactorHeight * 40,
                        ),
                        SizedBox(
                          width: MySize.screenWidth * 0.8,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: "Note:".tr(),
                                fontSize: MySize.size16,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppConst.primaryFont,
                                fontColor: AppColors.primaryColor,
                              ),
                              SizedBox(
                                width: MySize.scaleFactorWidth * 2,
                              ),
                              Expanded(
                                child: TextWidget(
                                  text:
                                      "Please Don't share this pin with anyone it's your login Pin.".tr(),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  fontSize: MySize.size16,
                                  fontWeight: FontWeight.w400,
                                  // fontFamily: AppConst.baloo,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MySize.scaleFactorHeight * 25,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: MySize.size40),
                      child: ButtonWidget(
                        onTap: () {
                          if (pinOneController.text.isEmpty ||
                              pinTwoController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return validationDialog(context,
                                      isTitle: true,
                                      title: TextWidget(
                                        text: "Pin".tr(),
                                        fontSize: MySize.size28,
                                        fontColor: AppColors.redColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      oprText: "Enter Pin for you login".tr(),
                                      ontap: () {
                                    Navigator.pop(context);
                                  });
                                });
                          } else if (pinOneController.length < 5 ||
                              pinTwoController.length < 5) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return validationDialog(context,
                                      isTitle: true,
                                      title: TextWidget(
                                        text: "Pin".tr(),
                                        fontSize: MySize.size28,
                                        fontColor: AppColors.redColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      oprText:
                                          "Enter 5 digit Pin for you login".tr(),
                                      ontap: () {
                                    Navigator.pop(context);
                                  });
                                });
                          } else if (pinOneController.text !=
                              pinTwoController.text) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return validationDialog(context,
                                      isTitle: false,
                                      btnText: "Ok".tr(),
                                      oprText:
                                          "Pincode in both field should be same".tr(),
                                      ontap: () {
                                    Navigator.pop(context);
                                  });
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return validationDialog(context,
                                      icon: AppConst.thumbIcon,
                                      oprText:
                                          "Your 5 digit Pin is Successfully Saved! ".tr(),
                                      ontap: () {
                                    preff?.setString('pin',
                                        pinOneController.text.toString());
                                    log(preff!.get('pin').toString());

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegistrationView(),
                                        ));
                                  });
                                });
                          }
                        },
                        text: "Submit".tr(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
      textStyle: TextStyle(
          fontSize: MySize.size22,
          fontFamily: AppConst.secondaryFont,
          color: Colors.white),
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
