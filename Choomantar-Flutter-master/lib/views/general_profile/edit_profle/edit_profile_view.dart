import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../../configs/providers/usersignupdetails.dart';

class EditGeneralProfileView extends StatefulWidget {
  const EditGeneralProfileView({super.key});

  @override
  State<EditGeneralProfileView> createState() => _EditGeneralProfileViewState();
}

class _EditGeneralProfileViewState extends State<EditGeneralProfileView> {
  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final phoneFocus = FocusNode();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? imagePath;
  String? imagePathUrl;
  String? fullName;
  String? uid;
  ProgressDialog? progressDialog;
  UserProvider? userProvider;
  SharedPreferences? prefs;
  SharedPreferences? prefs2;

  @override
  void initState() {
    getImagePath();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    phoneFocus.dispose();
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        imagePathUrl = null;
      });

      //  saveImagePath(imagePath);
    }
  }

  Future<void> saveImagePath(String? path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_image', path ?? '');
  }

  Future<void> getImagePath() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePathUrl = prefs!.getString("user_image") ?? null;
      //  imagePath = prefs!.getString('user_image') ?? null;


      if (kDebugMode) {
        print("jjjimgpathinedit $imagePathUrl");
      }

      uid = prefs!.get('uid').toString();

      emailController.text = prefs!.getString('user_email') ?? "";
      fullNameController.text = prefs!.getString('username') ?? "";
      fullName = prefs!.getString('username') ?? "";
      phoneController.text = prefs!.getString('user_mobile') ?? "";
      passwordController.text = prefs!.getString('user_password') ?? "";
    });
  }



  Future<void> saveProfileImage() async {

    // prefs2 = await SharedPreferences.getInstance();
    // prefs2?.setString('user_email', emailController.text);
    // prefs2?.setString('username', fullNameController.text);
    // prefs2?.setString('user_mobile', phoneController.text);
    // prefs2?.setString('user_password', passwordController.text);
    // setState(() {});


    try {
      // Create a MultipartRequest
      var request =
          http.MultipartRequest('POST', Uri.parse(AppUrls.saveProfileChanges));
      request.fields.addAll({
        "user_id": uid!,
      });

      // Add the image to the request
      var imageFile = File(imagePath!);
      //   log(imagePath!);
      request.files
          .add(await http.MultipartFile.fromPath('userimage', imageFile.path));

      var response = await request.send();

      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      if (response.statusCode == 200) {
        log(responseBody);
        saveImagePath(
            "https://dreammerchants.tech/api/${jsonResponse['userimage']}");

        saveOtherDetails();

      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Failed'.tr()),
              content: Text('${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'.tr()),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      progressDialog?.hide();
      Fluttertoast.showToast(msg: 'Server Error');
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  Future<void> saveOtherDetails() async {

    try {

      var response = await http.post(
        Uri.parse(AppUrls.saveProfileOtherDetails),
        body: {
          "user_id": uid,
          "password": passwordController.text,
          "phone": phoneController.text,
          "email": emailController.text,
          "name": fullNameController.text
        },
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        progressDialog?.hide();

        prefs2 = await SharedPreferences.getInstance();
        prefs2?.setString('user_email', emailController.text);
        prefs2?.setString('username', fullNameController.text);
        prefs2?.setString('user_mobile', phoneController.text);
        prefs2?.setString('user_password', passwordController.text);
        setState(() {});

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: MySize.scaleFactorWidth * 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySize.size16),
              ),
              child: Container(
                height: MySize.scaleFactorHeight * 230,
                width: MySize.screenWidth,
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
                  // Makes the column only as tall as its children
                  children: [
                    TextWidget(
                      text: 'Success!'.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      fontSize: MySize.size20,
                      fontFamily: AppConst.primaryFont,
                      fontColor: AppColors.primaryColor,
                    ),
                    SizedBox(
                      height: MySize.scaleFactorHeight * 20,
                    ),
                    TextWidget(
                      text: 'Profile Updated Successfully'.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      fontSize: MySize.size18,
                      fontFamily: AppConst.primaryFont,
                      fontColor: AppColors.purpleColor,
                    ),
                    SizedBox(
                      height: MySize.scaleFactorHeight * 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: Colors.black,
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(MySize.size8),
                        ),
                      ),
                      child: Text(
                        'Ok'.tr(),
                        style: const TextStyle(
                            fontFamily: AppConst.primaryFont,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );


      } else {

      }
    } catch (e) {
      progressDialog?.hide();
      log("Error fetching user points: $e");
    }

  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
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
                    text: "Edit Profile".tr(),
                    fontSize: MySize.size26,
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.secondaryColor,
                    fontFamily: AppConst.primaryFont,
                  ),
                  SizedBox(
                    width: MySize.scaleFactorWidth * 30,
                  )
                ],
              ),
              SizedBox(
                height: MySize.scaleFactorHeight * 20,
              ),
              Center(
                child: SizedBox(
                  width: MySize.screenWidth * 0.8,
                  child: Column(
                        children: [
                          TextWidget(
                            text: "Hello".tr(),
                            fontSize: MySize.size25,
                            fontColor: AppColors.whiteColor,
                            fontFamily: AppConst.primaryFont,
                          ),
                          TextWidget(
                            text: fullName!,
                            fontSize: MySize.size20,
                            fontFamily: AppConst.primaryFont,
                            fontColor: AppColors.primaryColor,
                            maxLines: 1,
                          )
                        ],
                      ),
                  ),
                ),

              SizedBox(
                height: MySize.scaleFactorHeight * 14,
              ),
              // Divider(
              //   thickness: MySize.size2,
              //   color: AppColors.whiteColor,
              // ),
              InkWell(
                onTap: () {
                  _getImage();
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        height: MySize.size90,
                        width: MySize.size100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                        child: Center(
                          child: imagePathUrl != null
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: imagePathUrl!,
                                    height: MySize.size90,
                                    width: MySize.size90,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Image.asset('assets/images/hi4.png'),
                                    errorWidget: (context, url, error) => Image.asset('assets/images/hi4.png'),

                                  ),
                                )
                              : imagePath != null
                                  ? ClipOval(
                                      child: Image.file(
                                        File(imagePath!),
                                        height: MySize.size90,
                                        width: MySize.size90,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.add,
                                      color: AppColors.whiteColor,
                                    ),
                        ),
                      ),
                      SizedBox(height: MySize.size5),
                      TextWidget(
                        text: "Add an image".tr(),
                        fontSize: MySize.size12,
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.whiteColor,
                      ),
                    ],
                  ),
                ),
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
                hintText: "Full Name".tr(),
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
                focusNode: passwordFocus,
                textInputType: TextInputType.visiblePassword,
                onfieldSubmit: (p0) =>
                    getFieldFocusChange(context, passwordFocus, phoneFocus),
                borderRadius: MySize.size10,
                prefix: const Icon(
                  Icons.mail_outline,
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
                disable: true,
                controller: phoneController,
                hintText: "Phone No".tr(),
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
                onTap: () {
                  progressDialog = ProgressDialog(context,
                      type: ProgressDialogType.normal, isDismissible: false);
                  progressDialog!.style(
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

                  progressDialog?.show();

                  if(imagePath!=null)
                    {
                      saveProfileImage();
                    }
                  else
                    {
                      saveOtherDetails();
                    }
                },
                text: "Save Changes".tr(),
                fontWeight: FontWeight.w700,
                fontColor: AppColors.purpleColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget headerComp(String title) => TextWidget(
        text: title,
        fontSize: MySize.size16,
        fontWeight: FontWeight.w600,
      );
}
