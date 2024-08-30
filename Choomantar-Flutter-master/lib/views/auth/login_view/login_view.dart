// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/consent_view/consent_screen.dart';
import 'package:chumanter/views/onboarding_views/onboarding_views.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import '../../select_main_category/select_onboardingcategories_view.dart';
import 'forgot_password_view.dart';



class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String? userEmail;
  String? userName;
  SharedPreferences? preff;
  bool _isConnected = true;
  final Connectivity _connectivity = Connectivity();

  getSP() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }
  Future<void> initConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSP();
    initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void addToPrefs(dynamic data)
  {
    preff?.setString('uid', data['user_id']);
    preff?.setString('user_email', data['user_email']);
    preff?.setString('user_password', data['user_password']);
    preff?.setString('user_mobile', data['user_phone']);
    preff?.setString('username', data['username']);
    String propic = data['userimage'];
    String profile_image= propic.isNotEmpty && propic!=null ?
    'https://dreammerchants.tech/api/$propic' : "https://dreammerchants.techd/ajax/uploads/pexels-suzy-hazelwood-1098592.jpg";
    if (kDebugMode) {
      print("jjjjjjjjjjjpropic: $profile_image");
    }
    preff?.setString('user_image', profile_image);
    log("Yahn se ${preff!.get('uid')}");
    preff?.setBool('isLoggedIn', true);
    preff?.setBool('isReg', true);
  }

  Future loginApi(dynamic body) async {
    _status.setStatus(Status.LOADING);
    setState(() {});

    var responce = await post(Uri.parse(AppUrls.loginUrl), body: body);

    try {
    //  log("Response Code is  :${responce.statusCode}");
      var data = jsonDecode(responce.body);

      // log(jsonEncode(data));
      if (responce.statusCode == 200) {
        CommonFuncs.apiHitPrinter("200", AppUrls.loginUrl, "POST", body.toString(), data, "login_view");
    //   print(jsonDecode(responce.body.toString()));
        addToPrefs(data);

        _status.setStatus(Status.COMPLETED);
        setState(() {});

        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsentScreen()));
      //   final result = await  Navigator.push(
      //     context,
      //     PageRouteBuilder(
      //       pageBuilder: (_, __, ___) => ConsentScreen(),
      //       transitionDuration: const Duration(milliseconds: AppConst.transitionDuration),
      //       reverseTransitionDuration: const Duration(milliseconds: AppConst.reverseTransitionDuration),
      //       transitionsBuilder: (_, animation, __, child) {
      //
      //         return FadeTransition(
      //           opacity: animation,
      //           child: child,
      //         );
      //       },
      //     ),
      //   );


        if(result)
          {
            if (preff!.get('showPromo') == null) {

              // Navigator.pushReplacement(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (_, __, ___) => OnboardingViews(),
              //     transitionDuration: const Duration(milliseconds: AppConst.transitionDuration),
              //     reverseTransitionDuration: const Duration(milliseconds: AppConst.reverseTransitionDuration),
              //     transitionsBuilder: (_, animation, __, child) {
              //
              //       return FadeTransition(
              //         opacity: animation,
              //         child: child,
              //       );
              //     },
              //   ),
              // );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnboardingViews(),
                ),
              );


            } else if (preff!.getBool('categoriesSelected') == false) {

              // Navigator.pushReplacement(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (_, __, ___) => SelectCategories(),
              //     transitionDuration: const Duration(milliseconds: AppConst.transitionDuration),
              //     reverseTransitionDuration: const Duration(milliseconds: AppConst.reverseTransitionDuration),
              //     transitionsBuilder: (_, animation, __, child) {
              //
              //       return FadeTransition(
              //         opacity: animation,
              //         child: child,
              //       );
              //     },
              //   ),
              // );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectCategories(),
                ),
              );

            } else {

            //   Navigator.pushReplacement(
            //     context,
            //     PageRouteBuilder(
            //       pageBuilder: (_, __, ___) => BottomBarView(),
            //       transitionDuration: const Duration(milliseconds: AppConst.transitionDuration),
            //       reverseTransitionDuration: const Duration(milliseconds: AppConst.reverseTransitionDuration),
            //       transitionsBuilder: (_, animation, __, child) {
            //
            //         return FadeTransition(
            //           opacity: animation,
            //           child: child,
            //         );
            //       },
            //     ),
            //   );
            //
            // }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomBarView(),
                ),
              );
             }
          }

        return responce;
      } else {
        log("Else is Called");
        _status.setStatus(Status.FAILD);
        setState(() {});
        showAdaptiveDialog(
          context: context,
          builder: (context) => validationDialog(context,
              oprText: "${data['error']}".tr(), btnText: "Try Again".tr(), ontap: () {
            Navigator.pop(context);
          }),
        );
        CommonFuncs.apiHitPrinter(responce.statusCode.toString(), AppUrls.loginUrl, "POST", body.toString(), data, "login_view");
        //log("Wrong status code responce: ${data.toString()}");
        return null;
      }
    } catch (e) {
      _status.setStatus(Status.FAILD);
      setState(() {});

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return serverError();
        },
      );

      // showBar(
      //   context,
      //   message: "Login failed. Check Phone number and Password".tr(), // Use e if not null, otherwise 'unknown error'
      //   color: AppColors.redColor,
      // );

      log("The error is ${e.toString()}");
      log("The code is ${responce.statusCode}");

    }
  }

  final StatusProvider _status = StatusProvider();
  String? number;
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    const focusedBorderColor = AppColors.lightGreen;
    const fillColor = Colors.transparent;
    const borderColor = AppColors.lightGreen;

    final defaultPinTheme = PinTheme(
      width: MySize.size60,
      height: MySize.size68,
      textStyle: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: AppConst.primaryFont),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MySize.size10),
        border: Border.all(color: borderColor, width: MySize.size2),
      ),
    );
    return LoadingOverlay(
        isLoading: _status.getStatus == Status.LOADING,
        child: Scaffold(
          body: Container(
            height: MySize.screenHeight,
            width: MySize.screenWidth,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
            child: SingleChildScrollView(
              child: SizedBox(
              //  height: MySize.screenHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MySize.size20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      logoComp(
                          width: MySize.screenWidth * 0.6,
                          height: MySize.size56),

                      SizedBox(
                        height: MySize.size15,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: TextWidget(
                              text: "Please enter your mobile number and pin to login".tr(),
                              fontSize: MySize.size22,
                              fontWeight: FontWeight.w400,
                              fontColor: AppColors.secondaryColor,
                              fontFamily: AppConst.primaryFont,
                            ),
                          ),
                          SizedBox(
                            height: MySize.scaleFactorHeight * 40,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: MySize.size30),
                            child: TextWidget(
                              text: "Enter your mobile number".tr(),
                              fontSize: MySize.size18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: MySize.scaleFactorHeight * 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MySize.scaleFactorWidth * 20),
                            child: TextFormField(
                              autofocus: true,
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [PhoneNumberFormatter()],
                              maxLength: 14,
                              onFieldSubmitted: (value) {
                                preff?.setString('phone'.tr(), phoneController.text);
                              },
                              style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppConst.primaryFont,
                                  fontSize: MySize.size24),
                              cursorColor: AppColors.primaryColor,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Type your mobile number".tr(),
                                hintStyle: TextStyle(
                                  fontFamily: AppConst.secondaryFont,
                                  fontSize: MySize.size14,
                                  color: AppColors.whiteColor.withOpacity(0.6),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(MySize.size12),
                                    borderSide: const BorderSide(
                                      color: AppColors.lightGreen,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(MySize.size12),
                                    borderSide: const BorderSide(
                                      color: AppColors.whiteColor,
                                    )),
                                prefixIcon: const Icon(
                                  Icons.phone_android,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: MySize.size30),
                            child: TextWidget(
                              text: "Enter Pin".tr(),
                              fontSize: MySize.size18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: MySize.scaleFactorHeight * 20,
                          ),
                          Center(
                            child: Pinput(
                              controller: pinController,
                              focusNode: focusNode,
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
                              hapticFeedbackType:
                                  HapticFeedbackType.lightImpact,
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
                                decoration:
                                    defaultPinTheme.decoration!.copyWith(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: focusedBorderColor),
                                ),
                              ),
                              submittedPinTheme: defaultPinTheme.copyWith(
                                decoration:
                                    defaultPinTheme.decoration!.copyWith(
                                  color: fillColor,
                                  borderRadius:
                                      BorderRadius.circular(MySize.size10),
                                  border:
                                      Border.all(color: focusedBorderColor),
                                ),
                              ),
                              errorPinTheme: defaultPinTheme.copyBorderWith(
                                border: Border.all(color: AppColors.redColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MySize.scaleFactorHeight * 20,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgotPasswordView()));
                              },
                              child: TextWidget(
                                  text: 'Forgot password!'.tr(),
                                textAlign: TextAlign.right,
                                  fontSize: MySize.size14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppConst.primaryFont

                              ),
                            ),
                          ),
                          SizedBox(
                            height: MySize.scaleFactorHeight * 30,
                          ),
                          GestureDetector(
                            onTap: () {

                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder: (_, __, ___) => SigninPhoneView(),
                              //     transitionDuration: const Duration(milliseconds: AppConst.transitionDuration),
                              //     reverseTransitionDuration: const Duration(milliseconds: AppConst.reverseTransitionDuration),
                              //     transitionsBuilder: (_, animation, __, child) {
                              //
                              //       return FadeTransition(
                              //         opacity: animation,
                              //         child: child,
                              //       );
                              //     },
                              //   ),
                              // );

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SigninPhoneView(),
                                  ));

                            },
                            child: Center(
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: "Don't have an account? ".tr(),
                                    style: TextStyle(
                                        fontFamily: AppConst.primaryFont,
                                        fontSize: MySize.size16,
                                        color: AppColors.whiteColor)),
                                TextSpan(
                                    text: "Sign Up".tr(),
                                    style: TextStyle(
                                        fontSize: MySize.size18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondaryColor,
                                        fontFamily: AppConst.primaryFont)),
                              ])),
                            ),
                          ),

                          SizedBox(
                            height: MySize.size15,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: MySize.size40),
                        child: ButtonWidget(
                          onTap: () {
                          //  Navigator.push(context, MaterialPageRoute(builder: (context) => ConsentScreen()));
                            if (pinController.text.isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return validationDialog(context,
                                        isTitle: true,
                                        title: TextWidget(
                                          text: "Login".tr(),
                                          fontSize: MySize.size28,
                                          fontColor: AppColors.redColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        oprText: "Enter a valid Pin code".tr(),
                                        ontap: () {
                                      Navigator.pop(context);
                                    });
                                  });
                            } else if(_isConnected==false) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return validationDialog(context,
                                        isTitle: true,
                                        title: TextWidget(
                                          text: "Error!".tr(),
                                          fontSize: MySize.size28,
                                          fontColor: AppColors.redColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        oprText: "No Internet Connection Found".tr(),
                                        ontap: () {
                                          Navigator.pop(context);
                                        });
                                  });
                            }
                            else{
                              number =
                                  phoneController.text.replaceAll(' - ', '');
                              setState(() {});
                              preff
                                  ?.setString('phone', number.toString())
                                  .then((value) {
                                Map data = {
                                  "phone": preff?.get('phone').toString(),
                                  'password': pinController.text.toString(),
                                };
                                log(data.toString());
                                loginApi(data);
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
          ),
        ));
  }

  TextStyle style({Color color = AppColors.secondaryColor}) => TextStyle(
      fontSize: MySize.size16, fontWeight: FontWeight.w600, color: color);


  Widget serverError() => Dialog(
    insetPadding:
    EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 16),
    child: Container(
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
            text: 'Error!'.tr(),
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
    ),
  );

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
