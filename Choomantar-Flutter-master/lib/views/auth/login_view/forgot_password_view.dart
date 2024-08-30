import 'package:easy_localization/easy_localization.dart';

import '../../../configs/imports/import_helper.dart';



class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController emailController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MySize.scaleFactorWidth * 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                logoComp(
                    width: MySize.screenWidth * 0.6,
                    height: MySize.size56
                ),

                SizedBox(height:MySize.scaleFactorHeight*150,),
                Center(
                  child: Lottie.asset(
                    'assets/json/forgot_password_animation.json',
                  height: MySize.scaleFactorHeight*200,
                    width: MySize.scaleFactorHeight*250,

                  ),
                ),
                SizedBox(height:MySize.scaleFactorHeight*30,),
                TextWidget(
                  text: "Provide your Email to receive a verification code.".tr(),
                  fontSize: MySize.size18,
                  fontWeight: FontWeight.w400,
                  fontColor: AppColors.secondaryColor,
                  fontFamily: AppConst.primaryFont,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height:MySize.scaleFactorHeight*30,),
                TextFormField(
                  autofocus: true,
                  controller:emailController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConst.primaryFont,
                      fontSize: MySize.size24),
                  cursorColor: AppColors.primaryColor,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: "Email".tr(),
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
                      Icons.email_outlined,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
                SizedBox(height:MySize.scaleFactorHeight*140,),
                Padding(
                  padding: EdgeInsets.only(bottom: MySize.size30),
                  child: ButtonWidget(onTap: (){}, text: 'Submit'.tr()),
                ),
              ],

            ),
          ),
        ),
      ),
    );
  }
}
