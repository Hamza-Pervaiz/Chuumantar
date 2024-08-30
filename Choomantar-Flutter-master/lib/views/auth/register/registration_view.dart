// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/auth/login_view/login_view.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../configs/imports/import_helper.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  String? selectedValue;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedYear = '1';
  String selectedMonth = '1';
  String selectedDate = '1950';

  // String? city;
  String? gender;

  SingleValueDropDownController _cnt = SingleValueDropDownController();
  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    getPreff();
    super.initState();
  }

  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _cnt.dispose();
    nameController.dispose();
    emailController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
  }

  getPreff() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<dynamic> registerApi(dynamic body) async {
    _status.setStatus(Status.LOADING);
    setState(() {});
    try {
      var responce = await post(Uri.parse(AppUrls.registerUrl), body: body);
      var data = jsonDecode(responce.body);

      if (responce.statusCode == 200) {
        CommonFuncs.apiHitPrinter("200", AppUrls.registerUrl, "POST",
            body.toString(), data, "registration_view");
        _status.setStatus(Status.COMPLETED);
        setState(() {});
        // log("API data is " + data.toString());
        preff?.setBool('isReg', true);

        showBar(context,
            message: "${data['ResponseMsg']}",
            color: AppColors.whiteColor.withOpacity(0.4));
        showAdaptiveDialog(
          context: context,
          builder: (context) => validationDialog(
              isTitle: true,
              title: const SizedBox(),
              icon: AppConst.activeTick,
              context,
              oprText: "You have registered successfully.Thank you!".tr(),
              ontap: () {
            preff?.setBool('isReg', true);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ));
          }),
        );

        return responce;
      } else {
        log("Else is Called");
        _status.setStatus(Status.FAILD);
        setState(() {});
        showBar(context,
            message: "${data['ResponseMsg']}", color: AppColors.redColor);
        CommonFuncs.apiHitPrinter(
            responce.statusCode.toString(),
            AppUrls.registerUrl,
            "POST",
            body.toString(),
            data,
            "registration_view");
        //    log("Wrong status code responce: $data}");
        return null;
      }
    } catch (e) {
      _status.setStatus(Status.FAILD);
      setState(() {});
      showBar(context,
          message: "The Error occured $e", color: AppColors.redColor);
      log("The error is $e");
    }
  }

  bool isEmail(String email) {
    final RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
    return emailRegExp.hasMatch(email);
  }

  PageController pageController = PageController();

  final StatusProvider _status = StatusProvider();

  String? countryValue;
  String? stateValue;
  String? city;
  String? address;

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return LoadingOverlay(
      isLoading: _status.getStatus == Status.LOADING,
      child: Scaffold(
          body: Container(
              height: MySize.screenHeight,
              width: MySize.screenWidth,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
              child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    logoComp(
                        height: MySize.size50, width: MySize.screenWidth * 0.6),
                    SizedBox(
                      height: MySize.size80,
                    ),
                    TextWidget(
                      text: "Registration".tr(),
                      fontSize: MySize.size25,
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.secondaryColor,
                      fontFamily: AppConst.primaryFont,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ExpandablePageView(
                        animationDuration: const Duration(milliseconds: 0),
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          nameComp(),
                          emailComp(),
                          dobComp(),
                          selectCityComp(),
                          genderComp()
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MySize.size20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: MySize.size40),
                      child: ButtonWidget(
                          activeOff: true,
                          onTap: () {
                            Map data = {
                              "name": nameController.text,
                              "email": emailController.text,
                              "password": preff!.get('pin').toString(),
                              "country": "Pakistan",
                              "state": stateValue.toString(),
                              "city": city.toString(),
                              "gender": _cnt.dropDownValue?.name.toString(),
                              "mobile": preff!.get('phone').toString(),
                              "dob":
                                  "$selectedDate - $selectedMonth - $selectedYear",
                            };

                            switch (pageController.page) {
                              case 0:
                                nameController.text.isEmpty
                                    ? showAdaptiveDialog(
                                        context: context,
                                        builder: (context) => validationDialog(
                                            context,
                                            oprText: "Name is required".tr(),
                                            ontap: () {
                                          Navigator.pop(context);
                                        }),
                                      )
                                    : pageController.nextPage(
                                        duration:
                                            const Duration(microseconds: 1),
                                        curve: Curves.linear);
                                break;
                              case 1:
                                emailController.text.isEmpty
                                    ? showAdaptiveDialog(
                                        context: context,
                                        builder: (context) => validationDialog(
                                            context,
                                            oprText: "Email is required".tr(),
                                            ontap: () {
                                          Navigator.pop(context);
                                        }),
                                      )
                                    : isEmail(emailController.text)
                                        ? pageController.nextPage(
                                            duration:
                                                const Duration(microseconds: 1),
                                            curve: Curves.linear)
                                        : null;
                                break;

                              case 2:
                                pageController.nextPage(
                                    duration: const Duration(microseconds: 1),
                                    curve: Curves.linear);
                                break;

                              case 3:
                                if (city == null) {
                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) => validationDialog(
                                        context,
                                        oprText: "Select City please".tr(),
                                        ontap: () {
                                      Navigator.pop(context);
                                    }),
                                  );
                                } else {
                                  setState(() {
                                    address =
                                        "$city, $stateValue, $countryValue";
                                  });
                                  pageController.nextPage(
                                      duration: const Duration(microseconds: 1),
                                      curve: Curves.linear);
                                }
                                break;

                              case 4:
                                log(data.toString());
                                registerApi(data);
                                break;
                            }
                          },
                          text: "Submit".tr()),
                    ),
                  ]))),
    );
  }

  List<DropDownValueModel> dropDownItems = [
    DropDownValueModel(name: 'Male'.tr(), value: "value1"),
    DropDownValueModel(name: 'Female'.tr(), value: "value2"),
    DropDownValueModel(name: 'Others'.tr(), value: "value3"),
  ];

  DateTime dateTime = DateTime.now();

  SharedPreferences? preff;

  Widget nameComp() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleComp("Name".tr()),
          SizedBox(height: MySize.scaleFactorHeight * 15),
          TextFieldWidget(
            controller: nameController,
            hintText: "Enter your full name".tr(),
            autofocus: true,
            textInputType: TextInputType.name,
            onfieldSubmit: (p0) {
              nameController.text.isNotEmpty
                  ? pageController.nextPage(
                      duration: const Duration(microseconds: 1),
                      curve: Curves.linear)
                  : getUnfocusFieldChange(context);
            },
            borderRadius: MySize.size10,
            prefix: const Icon(
              Icons.person_outline,
              color: AppColors.whiteColor,
            ),
          ),
          // SizedBox(
          //   height: MySize.scaleFactorHeight * 25,
          // ),
          // Row(
          //   children: [
          //     Expanded(
          //         child: Divider(
          //       thickness: MySize.size2,
          //       color: AppColors.whiteColor,
          //     )),
          //     Padding(
          //       padding: EdgeInsets.symmetric(
          //           horizontal: MySize.scaleFactorWidth * 10),
          //       child: TextWidget(
          //         text: "or".tr(),
          //         fontColor: AppColors.whiteColor,
          //       ),
          //     ),
          //     Expanded(
          //         child: Divider(
          //       thickness: MySize.size2,
          //       color: AppColors.whiteColor,
          //     )),
          //   ],
          // ),
          // SizedBox(
          //   height: MySize.scaleFactorHeight * 5,
          // ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: TextWidget(
          //     text: "Continue with social sites".tr(),
          //     fontFamily: AppConst.secondaryFont,
          //     fontColor: AppColors.whiteColor,
          //   ),
          // ),
          // SizedBox(
          //   height: MySize.scaleFactorHeight * 25,
          // ),
          // Center(
          //   child: SizedBox(
          //     width: MySize.screenWidth * 0.7,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         socialComp(AppConst.googleIcon, () {
          //           showAdaptiveDialog(
          //             context: context,
          //             builder: (context) => validationDialog(context,
          //                 icon: AppConst.activeTick,
          //                 oprText: "Login with google".tr(), ontap: () {
          //               Navigator.pop(context);
          //             }),
          //           );
          //         }),
          //         socialComp(AppConst.facebookIcon, () {
          //           showAdaptiveDialog(
          //             context: context,
          //             builder: (context) => validationDialog(context,
          //                 icon: AppConst.activeTick,
          //                 oprText: "Loggin with facebook".tr(), ontap: () {
          //               Navigator.pop(context);
          //             }),
          //           );
          //         }),
          //         socialComp(AppConst.emailIcon, () {
          //           showAdaptiveDialog(
          //             context: context,
          //             builder: (context) => validationDialog(context,
          //                 icon: AppConst.activeTick,
          //                 oprText: "Login with email".tr(), ontap: () {
          //               Navigator.pop(context);
          //             }),
          //           );
          //         })
          //       ],
          //     ),
          //   ),
          // )
        ],
      );

  Widget emailComp() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleComp("Email".tr()),
          SizedBox(height: MySize.scaleFactorHeight * 15),
          TextFieldWidget(
            controller: emailController,
            hintText: "Enter your valid email".tr(),
            autofocus: true,
            textInputType: TextInputType.emailAddress,
            onfieldSubmit: (p0) {
              emailController.text.isNotEmpty
                  ? isEmail(emailController.text)
                      ? pageController.nextPage(
                          duration: const Duration(microseconds: 1),
                          curve: Curves.linear)
                      : showAdaptiveDialog(
                          context: context,
                          builder: (context) => validationDialog(context,
                              oprText: "Incorrect email type".tr(), ontap: () {
                            Navigator.pop(context);
                          }),
                        )
                  : getUnfocusFieldChange(context);
            },
            borderRadius: MySize.size10,
            prefix: const Icon(
              CupertinoIcons.mail_solid,
              color: AppColors.whiteColor,
            ),
          ),
          // SizedBox(
          //   height: MySize.scaleFactorHeight * 20,
          // ),
        ],
      );
  Widget dobComp() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MySize.scaleFactorHeight * 15,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: MySize.size2, color: AppColors.whiteColor),
                borderRadius: BorderRadius.circular(MySize.size12)),
            child: BottomPicker.date(
              displayCloseIcon: false,
              initialDateTime: DateTime(2000),
              // title: "",
              titleAlignment: Alignment.center,
              titlePadding: EdgeInsets.zero,
              buttonPadding: 0,
              dateOrder: DatePickerDateOrder.dmy,
              maxDateTime: DateTime(2023),
              backgroundColor: Colors.transparent,
              // height: 300,
              pickerTextStyle: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AppConst.secondaryFont,
                fontWeight: FontWeight.bold,
                fontSize: MySize.size16,
              ),

              // descriptionStyle: TextStyle(
              //   fontWeight: FontWeight.bold,
              //   fontSize: MySize.size18,
              //   fontFamily: AppConst.primaryFont,
              //   color: AppColors.whiteColor,
              // ),

              pickerDescription: Text('Set your Birthday'),
              // description: "Set your Birthday".tr(),

              // iconColor: AppColors.whiteColor,
              closeIconColor: AppColors.whiteColor,
              displaySubmitButton: false,
              onChange: (index) {
                if (kDebugMode) {
                  print(index);
                }
                dateTime = index;
                selectedDate = dateTime.day.toString();
                selectedMonth = dateTime.month.toString();
                selectedYear = dateTime.year.toString();
                setState(() {});
                log(dateTime.toString());
              },
              onSubmit: (index) {
                if (kDebugMode) {
                  print(index);
                }
              },
              bottomPickerTheme: BottomPickerTheme.plumPlate,
              pickerTitle: Text(''),
            ),
          ),
        ],
      );

  Widget selectCityComp() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleComp("Select City".tr()),
          SizedBox(
            height: MySize.scaleFactorHeight * 15,
          ),
          CSCPicker(
            showStates: true,
            currentCountry: "Pakistan",
            showCities: true,
            flagState: CountryFlag.DISABLE,
            dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(MySize.size10)),
                color: Colors.transparent,
                border: Border.all(
                    color: AppColors.whiteColor, width: MySize.size2)),
            disabledDropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(MySize.size12)),
                color: Colors.transparent,
                border: Border.all(
                    color: AppColors.whiteColor, width: MySize.size2)),
            countrySearchPlaceholder: "Country".tr(),
            stateSearchPlaceholder: "State".tr(),
            citySearchPlaceholder: "City".tr(),
            countryDropdownLabel: "*Country".tr(),
            stateDropdownLabel: "*State".tr(),
            cityDropdownLabel: "*City".tr(),
            disableCountry: true,
            countryFilter: const [
              CscCountry.Pakistan,
            ],
            selectedItemStyle: TextStyle(
              color: AppColors.whiteColor,
              fontFamily: AppConst.primaryFont,
              fontSize: MySize.size16,
            ),
            dropdownHeadingStyle: TextStyle(
                color: AppColors.blackColor,
                fontSize: MySize.size18,
                fontFamily: AppConst.secondaryFont,
                fontWeight: FontWeight.bold),
            dropdownItemStyle: TextStyle(
                color: AppColors.blackColor,
                fontSize: MySize.size14,
                fontFamily: AppConst.secondaryFont),
            dropdownDialogRadius: MySize.size12,
            searchBarRadius: MySize.size14,
            onCountryChanged: (value) {
              setState(() {
                countryValue = value;
                log(countryValue.toString());
              });
            },
            onStateChanged: (value) {
              setState(() {
                stateValue = value;
              });
            },
            onCityChanged: (value) {
              setState(() {
                city = value;
              });
            },
          ),
        ],
      );

  Widget genderComp() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleComp("Gender".tr()),
          SizedBox(
            height: MySize.scaleFactorHeight * 15,
          ),
          Container(
              width: MySize.screenWidth,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(MySize.size10),
                  border: Border.all(
                      width: MySize.size2, color: AppColors.whiteColor)),
              child: Row(children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                    ),
                    child: DropDownTextField(
                      controller: _cnt,
                      clearOption: true,
                      readOnly: true,
                      textFieldDecoration: InputDecoration(
                          contentPadding: EdgeInsets.all(MySize.size15),
                          hintText: "Gender".tr(),
                          hintStyle: const TextStyle(
                              color: AppColors.whiteColor,
                              fontFamily: AppConst.primaryFont,
                              fontWeight: FontWeight.w600)),
                      searchDecoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Gender".tr(),
                          hintStyle:
                              const TextStyle(color: AppColors.whiteColor)),
                      validator: (value) {
                        if (value == null) {
                          return "Required field".tr();
                        } else {
                          return null;
                        }
                      },
                      dropDownItemCount: 3,

                      // dropdownColor: AppColors.whiteColor,
                      // dropDownIconProperty: IconProperty(
                      //   color: AppColors.whiteColor,
                      // ),
                      dropDownList: dropDownItems,
                      onChanged: (val) {},
                      listPadding: ListPadding(
                          bottom: MySize.size20, top: MySize.size20),
                      listTextStyle: TextStyle(
                          fontSize: MySize.size14,
                          fontFamily: AppConst.secondaryFont,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600),
                      textStyle: const TextStyle(
                        fontFamily: AppConst.primaryFont,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ])),
          // SizedBox(
          //   height: MySize.scaleFactorHeight * 20,
          // ),
        ],
      );
  // Widget socialComp(String icon, Function ontap) => GestureDetector(
  //     onTap: () {
  //       ontap();
  //     },
  //     child: Container(
  //       height: MySize.size68,
  //       width: MySize.size68,
  //       decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: AppColors.whiteColor,
  //           image: DecorationImage(
  //             image: AssetImage(
  //               icon,
  //             ),
  //             fit: BoxFit.none,
  //           )),
  //     ));
}

Widget titleComp(String title) => TextWidget(
      text: title,
      fontSize: MySize.size20,
      fontWeight: FontWeight.w600,
      fontColor: AppColors.whiteColor,
      fontFamily: AppConst.primaryFont,
    );
