import 'dart:developer';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/views/auth/otp_view/otp_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class SigninPhoneView extends StatefulWidget {
  const SigninPhoneView({super.key});

  @override
  State<SigninPhoneView> createState() => _SigninPhoneViewState();
}

class _SigninPhoneViewState extends State<SigninPhoneView> {
  final phoneController = TextEditingController();
  late ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    getSP();
    number = phoneController.text.replaceAll(' - ', '');
  }

  SharedPreferences? preff;
  getSP() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }

  String? number;

  @override
  Widget build(BuildContext context) {
    MySize().init(context);


    return Scaffold(
      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: SizedBox(
          //  height: MySize.screenHeight * 0.98,
            width: MySize.screenWidth,
            child: Padding(
              padding: EdgeInsets.all(MySize.size20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  logoComp(
                      height: MySize.size50, width: MySize.screenWidth * 0.6),

                  SizedBox(height: MySize.size15,),

                  Column(
                    children: [
                      TextWidget(
                        text: "Please Enter Your Mobile Number".tr(),
                        fontSize: MySize.size22,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.secondaryColor,
                        fontFamily: AppConst.primaryFont,
                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 20,
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [PhoneNumberFormatter()],
                        maxLength: 14,
                        onFieldSubmitted: (value) {
                          preff?.setString('phone'.tr(), phoneController.text);
                        },
                        style: const TextStyle(color: AppColors.whiteColor),
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
                                color: AppColors.whiteColor,
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
                      SizedBox(
                        height: MySize.scaleFactorHeight * 15,
                      ),

                      TextWidget(
                        text:
                        "Please provide the mobile number which is linked with mobile wallet account".tr(),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                      TextWidget(
                        fontColor: AppColors.redColor,
                        text:
                        "Mobile number once provided cannot be changed later".tr(),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5.0,),
                      TextWidget(
                        text:
                            "One Time Password will be sent to this number for verification".tr(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const LoginView(),
                          //     ));
                        },
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "Already have a account? ".tr(),
                              style: TextStyle(
                                  fontFamily: AppConst.primaryFont,
                                  fontSize: MySize.size16,
                                  color: AppColors.whiteColor)),
                          TextSpan(
                              text: "Login".tr(),
                              style: TextStyle(
                                  fontSize: MySize.size18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryColor,
                                  fontFamily: AppConst.primaryFont)),
                        ])),
                      ),

                         SizedBox(
                           height: MySize.size15,
                         ),

                    ],
                  ),
                  ButtonWidget(
                      onTap: () {
                        number = phoneController.text.replaceAll(' - ', '');
                        setState(() {});
                        preff?.setString('phone', number.toString());
                        log(preff!.getString('phone').toString());
                        if (phoneController.text.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return validationDialog(context,
                                    btnText: "Ok".tr(),
                                    oprText: "Please enter your phone number".tr(),
                                    ontap: () {
                                  Navigator.pop(context);
                                });
                              });
                        } else {
                          // phoneController.text.toString();
                          preff?.get('phone').toString();
                          showProgressDialog();
                          verifyNumber("+92${number!}");
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const OTPView(),
                          //     ));
                        }
                      },
                      text: "Submit".tr()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget warningDialog() => Dialog(
    insetPadding:
    EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 16),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TextWidget(
          //   text: 'Warning!'.tr(),
          //   textAlign: TextAlign.center,
          //   maxLines: 2,
          //   fontSize: MySize.size22,
          //   fontFamily: AppConst.primaryFont,
          //   fontColor: AppColors.redColor,
          // ),
          Image.asset('assets/images/warning.png', width: 30, height: 30,),
          SizedBox(height: MySize.size22),
          TextWidget(
            text: 'Please provide the mobile number which is linked with mobile wallet account'.tr(),
            textAlign: TextAlign.center,
            maxLines: 3,
            fontSize: MySize.size18,
            fontFamily: AppConst.primaryFont,
            fontColor: AppColors.purpleColor,
          ),
          SizedBox(height: MySize.size15),
          TextWidget(
            text: 'Mobile number once provided cannot be changed later'.tr(),
            textAlign: TextAlign.center,
            maxLines: 3,
            fontSize: MySize.size14,
            fontFamily: AppConst.primaryFont,
            fontColor: AppColors.redColor,
          ),

          SizedBox(height: MySize.size18),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.black,
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MySize.size8),
                  ),
                ),
                child: Text('Ok'.tr(),style: const TextStyle( fontFamily: AppConst.primaryFont,
                    fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
              ),

              SizedBox(
                width: MySize.size10,
              ),


            ],
          ),

        ],
      ),
    ),
  );




  void showProgressDialog()
  {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.normal,isDismissible: false);
    progressDialog.style(

      textAlign: TextAlign.center,
      message: 'Loading...'.tr(),
      elevation: 10,
      padding: const EdgeInsets.symmetric(vertical: 10),
      messageTextStyle: const TextStyle(
        color: AppColors.purpleColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    );

    progressDialog.show();
  }

  void hideProgressDialog()
  {
    progressDialog.hide();
  }

  Future<void> verifyNumber(String phoneNum)
  async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNum,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        hideProgressDialog();
        Fluttertoast.showToast(msg: e.message.toString());
      },
      codeSent: (String verificationId, int? resendToken) {
        hideProgressDialog();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  OTPView(verificationId: verificationId,),
            ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {

      },
    );
  }

}


class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final unformattedText = newValue.text.replaceAll(' - ', '');
    String formattedText = '';

    for (int i = 0; i < unformattedText.length; i++) {
      formattedText += unformattedText[i];
      if (i == 3 && i < unformattedText.length - 1) {
        formattedText += ' - ';
      }
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
