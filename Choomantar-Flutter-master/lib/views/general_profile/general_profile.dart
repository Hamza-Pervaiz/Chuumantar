import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/auth/login_view/login_view.dart';
import 'package:chumanter/views/general_profile/edit_profle/edit_profile_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../configs/providers/usersignupdetails.dart';

class GeneralProfileView extends StatefulWidget {
  const GeneralProfileView({super.key});

  @override
  State<GeneralProfileView> createState() => _GeneralProfileViewState();
}

class _GeneralProfileViewState extends State<GeneralProfileView> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final phoneFocus = FocusNode();
  bool passwordVisible = false;

  String imagePath = "";

  @override
  void initState() {
    super.initState();
    _loadUserImage();
    CommonFuncs.showToast("general_profile\nGeneralProfileView");
  }



  @override
  void dispose() {
    super.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    phoneFocus.dispose();
  }


  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('user_image').toString(); // Load the image path
      if (kDebugMode) {
        print("jjjjjimagepath$imagePath");
      }
    });
  }

  Future<void> logout() async {
    try {

      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);
    } catch (e) {

      if (kDebugMode) {
        print("Error during logout: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        String userName = userProvider.userName ?? "";
        String userEmail  = userProvider.userEmail ?? "";
        String userPhone = userProvider.userPhoneNumber?? "";
        String userPin = userProvider.userPin??"";
        emailController.text = userEmail;
        fullNameController.text=userName;
        phoneController.text =userPhone;
        passwordController.text =userPin;
        return Scaffold(
          body: Container(
            height: MySize.screenHeight,
            width: MySize.screenWidth,
            padding: EdgeInsets.all(MySize.size16),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(alignment: Alignment.topLeft, child: backBtn(context)),
                      TextWidget(
                        text: "Profile".tr(),
                        fontSize: MySize.size26,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.secondaryColor,
                        fontFamily: AppConst.primaryFont,
                      ),
                      GestureDetector(
                        onTap: () {

                          // Navigator.pushReplacement(
                          //   context,
                          //   PageRouteBuilder(
                          //     pageBuilder: (_, __, ___) => EditGeneralProfileView(),
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
                                builder: (context) => const EditGeneralProfileView(
                                ),
                              ));


                        },
                        child: Icon(
                          Icons.app_registration_rounded,
                          color: AppColors.whiteColor,
                          size: MySize.size40,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 60,
                  ),
                  Center(
                    child: SizedBox(
                      width: MySize.screenWidth ,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              width: MySize.size50*2,
                              height: MySize.size50*2,
                              imageUrl: imagePath,
                              placeholder: (context, url) => Image.asset('assets/images/hi4.png',  fit: BoxFit.cover,),
                              errorWidget: (context, url, error) =>  Image.asset('assets/images/hi4.png', fit: BoxFit.cover,),

                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: "Hello".tr(),
                                fontSize: MySize.size18,
                                fontColor: AppColors.whiteColor,
                                fontFamily: AppConst.primaryFont,
                              ),
                              TextWidget(
                                text: userName,
                                fontSize: MySize.size18,
                                fontFamily: AppConst.primaryFont,
                                fontColor: AppColors.primaryColor,
                              )
                            ],
                          ),
                          SizedBox(
                            width: MySize.scaleFactorWidth * 60,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 14,
                  ),
                  Divider(
                    thickness: MySize.size2,
                    color: AppColors.whiteColor,
                  ),


                  SizedBox(
                    height: MySize.scaleFactorHeight * 20,
                  ),
                  headerComp("Full Name".tr()),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 5,
                  ),
                  TextFieldWidget(
                    controller: fullNameController,
                    hintText: userName,
                    disable: true,
                    focusNode: nameFocus,
                    textInputType: TextInputType.name,
                    onfieldSubmit: (p0) =>
                        getFieldFocusChange(context, nameFocus, emailFocus),
                    borderRadius: MySize.size10,
                    prefix: const Icon(
                      CupertinoIcons.person,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 15,
                  ),
                  headerComp("Email".tr()),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 5,
                  ),
                  TextFieldWidget(
                    controller: emailController,
                    hintText: "Email".tr(),
                    disable: true,
                    focusNode: emailFocus,
                    textInputType: TextInputType.emailAddress,
                    onfieldSubmit: (p0) =>
                        getFieldFocusChange(context, emailFocus, passwordFocus),
                    borderRadius: MySize.size10,
                    prefix: const Icon(
                      Icons.mail_outline,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 15,
                  ),
                  headerComp("Password".tr()),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 5,
                  ),
                  TextFieldWidget(
                    controller: passwordController,
                    hintText: "Password".tr(),
                    disable: true,
                    focusNode: passwordFocus,
                    textInputType: TextInputType.visiblePassword,
                    onfieldSubmit: (p0) =>
                        getFieldFocusChange(context, passwordFocus, phoneFocus),
                    borderRadius: MySize.size10,
                    prefix: const Icon(
                      Icons.password_outlined,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 15,
                  ),
                  headerComp("Phone No".tr()),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 5,
                  ),
                  TextFieldWidget(
                    controller: phoneController,
                    hintText: "Phone No".tr(),
                    disable: true,
                    focusNode: phoneFocus,
                    textInputType: TextInputType.number,
                    onfieldSubmit: (p0) => getUnfocusFieldChange(context),
                    borderRadius: MySize.size10,
                    prefix: const Icon(
                      CupertinoIcons.device_phone_portrait,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 20,
                  ),
                  ButtonWidget(
                    onTap: () async {
                      // Logout logic
                      await logout();

                      // Navigate to the login view
                    //  Navigator.of(context).popUntil((route) => route.isFirst);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                      );
                    },
                    text: "Logout".tr(),
                    color: AppColors.redColor,
                    fontColor: AppColors.whiteColor,
                  ),

                ],
              ),
            ),
          ),
        );

      },
    );
  }

  Widget headerComp(String title) => TextWidget(
        text: title,
        fontSize: MySize.size16,
        fontWeight: FontWeight.w600,
      );
}
