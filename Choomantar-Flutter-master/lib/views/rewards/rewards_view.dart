// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/rewards/before_submission_screen.dart';
import 'package:chumanter/views/rewards/choose_donation.dart';
import 'package:chumanter/views/rewards/choose_lucky_draw.dart';
import 'package:chumanter/views/rewards/choose_redeem_type.dart';
import 'package:chumanter/views/rewards/redeem_points.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../models/choose_lucky_draw_model.dart';
import 'choose_points_to_redeem.dart';
import 'enter_info_screen.dart';
import 'selectpaymenttype.dart';

class RewardsView extends StatefulWidget {
  const RewardsView({super.key});

  @override
  State<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<RewardsView> {
  List munuItems = [
    "My Profile Info".tr(),
    "Complete Your Profile".tr(),
    "Pending Survey".tr(),
    "Total Points".tr(),
    "Rewards".tr(),
    "Notifications".tr(),
    "How we work".tr(),
    "Privacy Policy".tr(),
  ];

  String selectedPaymentType='';
  String choosenType = '';
  String imagePath = '';
  String userId = '';
  String userName = '';
  String userphone = '';
  late ChooseLuckyDrawModel _chooseLuckyDrawModel;
  PageController pageController = PageController();
  ProgressDialog? progressDialog;

  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('user_image').toString(); // Load the image path

      if (kDebugMode) {
        print("jjjjjimagepath$imagePath");
      }

    });
  }

String pointstoRedeeem='';
String amountRedeem='';


  @override
  void initState() {
    _loadUserImage();
    initProgressDialog();
    CommonFuncs.showToast("rewards_view\nRewardsView");
    super.initState();

  }




  Future<void> submitLuckyDrawRequest(String inventoryId, String points, String inventoryName) async {
    progressDialog?.show();
    try {
      var response = await http.post(Uri.parse(AppUrls.submitLuckYDrawRequest), body: {
        'id':userId,
        'inventoryid':inventoryId,
        'name':userName,
        'points': points,
        'phone':userphone,
        'method':'Lucky Draw',
        'inventoryname':inventoryName,

      });
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter("200", AppUrls.submitLuckYDrawRequest, "POST", "none", data, "choose_lucky_draw");

        progressDialog?.hide();

        Fluttertoast.showToast(msg: 'Lucky draw request has been submitted and is currently pending',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            backgroundColor: AppColors.urduBtn);


        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBarView()));

      } else {

        progressDialog?.hide();

        Navigator.pop(context);
        pageController.jumpToPage(0);


        CommonFuncs.apiHitPrinter(response.statusCode.toString(), AppUrls.submitLuckYDrawRequest, "POST", "none", data, "choose_lucky_draw");
        if (kDebugMode) {
          print('API request failed with status code: ${response.statusCode}');
        }
      }
    } catch (e) {

      progressDialog?.hide();

      if (kDebugMode) {
        print('Error: $e');
      }

      Navigator.pop(context);
      pageController.jumpToPage(0);


      Fluttertoast.showToast(msg: 'Server Error: 500',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: AppColors.urduBtn);
    }
  }


  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return WillPopScope(
      onWillPop: () async {
        if (kDebugMode) {
          print("jjrewardwillpop");
        }
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomBarView()));
        // return false;
        if (pageController.page == 0) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBarView()));
          return false;
        }
        else
          {
            pageController.jumpToPage(0);
            return false;
          }
        // else if(pageController.page == 5)
        //   {
        //     pageController.jumpToPage(2);
        //         return false;
        //   }
        // else if(pageController.page == 4)
        //   {
        //     if(choosenType == "cashdisbursement")
        //       {
        //         pageController.previousPage(
        //           duration: const Duration(milliseconds: 1),
        //           curve: Curves.easeOut,
        //         );
        //         return false;
        //       }
        //     else
        //       {
        //         pageController.jumpToPage(5);
        //         return false;
        //       }
        //   }
        // else {
        //
        //   pageController.previousPage(
        //     duration: const Duration(milliseconds: 1),
        //     curve: Curves.easeOut,
        //   );
        //   return false;
        // }
      },
      child: Scaffold(
     //   drawer: drawerComp(),
        body: Container(
          height: MySize.screenHeight,
          width: MySize.screenWidth,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
          child: Padding(
            padding: EdgeInsets.only(top: MySize.size16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                paddingComp(
                  SizedBox(
                    height: MySize.scaleFactorHeight * 56,
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) => GestureDetector(
                          //  onTap: () => Scaffold.of(context).openDrawer(),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsView())),
                            child: const Icon(
                              CupertinoIcons.line_horizontal_3_decrease,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            AppConst.logo,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const GeneralProfileView(),
                                  ));
                            },
                            child:   ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: imagePath,
                                width: MySize.size20*2,
                                height: MySize.size20*2,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image.asset('assets/images/hi4.png'),
                                errorWidget: (context, url, error) => Image.asset('assets/images/hi4.png'),
                              ),
                            ),)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MySize.scaleFactorHeight * 20,
                ),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [

                      ChooseRedeemType(
                        onTypeSelected: (String type){
                          if(type == "cashdisbursement")
                          {
                            setState(() {
                              choosenType = "cashdisbursement";
                            });

                            pageController.jumpToPage(2);
                            // pageController.nextPage(

                            // pageController.nextPage(
                            //   duration: const Duration(milliseconds: 300),
                            //   curve: Curves.easeOut,
                            // );
                          }
                          else if(type == "donation")
                          {
                            setState(() {
                              choosenType = "donation";
                            });


                            pageController.jumpToPage(2);

                            //    pageController.jumpToPage(5);
                            // pageController.nextPage(
                            //   duration: const Duration(milliseconds: 300),
                            //   curve: Curves.easeOut,
                            // );


                            //   pageController.jumpToPage(5);
                          }
                          else
                          {

                            setState(() {
                              choosenType = "luckydraw";
                            });

                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );

                            // pageController.jumpToPage(7);
                          }
                        },
                      ),

                      ChooseLuckyDraw(
                          onPressed:(String points, String amt, ChooseLuckyDrawModel chooseLuckyDraw, userid, username, phone){
                            setState(() {
                              pointstoRedeeem=points;
                              amountRedeem = amt;
                              _chooseLuckyDrawModel = chooseLuckyDraw;
                              userId = userid;
                              userName = username;
                              userphone = phone;

                              if (kDebugMode) {
                                print("jjredeem $pointstoRedeeem");
                                print("jjredeem $amountRedeem");
                              }


                              pageController.jumpToPage(3);
                              // pageController.nextPage(
                              //   duration: const Duration(milliseconds: 300),
                              //   curve: Curves.easeOut,
                              // );
                            });
                          }

                      ),

                      ChoosePointsToRedeem(
                          onPressed:(String points, String amt){
                            setState(() {
                              pointstoRedeeem=points;
                              amountRedeem = amt;

                              if (kDebugMode) {
                                print("jjredeem $pointstoRedeeem");
                                print("jjredeem $amountRedeem");
                              }


                        //      pageController.jumpToPage(5);

                              pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            });
                          }

                      ),


                      RedeemPoints(
                        redeemPoints: pointstoRedeeem,
                        onYesPressed: (){

                          if(choosenType == "donation")
                            {
                              pageController.jumpToPage(5);
                            }
                          else if(choosenType == "luckydraw")
                            {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    insetPadding:
                                    EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(MySize.size16),
                                    ),
                                    child: Container(
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
                                        mainAxisSize: MainAxisSize.min, // Makes the column only as tall as its children
                                        children: [
                                          TextWidget(
                                            text: 'Confirm!'.tr(),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            fontSize: MySize.size20,
                                            fontFamily: AppConst.primaryFont,
                                            fontColor: AppColors.redColor,
                                          ),
                                          SizedBox(
                                            height: MySize.scaleFactorHeight * 10,
                                          ),

                                          ClipOval(
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              width: MySize.size54*2,
                                              height: MySize.size54*2,
                                              imageUrl: "${AppUrls.imageUrl}${_chooseLuckyDrawModel.inventoryimage}",
                                              placeholder: (context, url) => Image.asset('assets/images/hi4.png',  fit: BoxFit.cover,),
                                              errorWidget: (context, url, error) =>  Image.asset('assets/images/hi4.png', fit: BoxFit.cover,),

                                            ),
                                          ),

                                          SizedBox(
                                            height: MySize.scaleFactorHeight * 20,
                                          ),

                                          TextWidget(
                                            text: 'A chance to win "${_chooseLuckyDrawModel.name}" for ${_chooseLuckyDrawModel.points} points'.tr(),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            fontSize: MySize.size18,
                                            fontFamily: AppConst.primaryFont,
                                            fontColor: AppColors.primaryColor,
                                          ),

                                          SizedBox(height: 5,),

                                          TextWidget(
                                            text: 'You will be entered in the list of lucky draw participants. Lucky draw is conducted on 15th of every month, we will notify you if you are the prize winner'.tr(),
                                            textAlign: TextAlign.center,
                                            maxLines: 6,
                                            fontSize: MySize.size18,
                                            fontFamily: AppConst.primaryFont,
                                            fontColor: AppColors.purpleColor,
                                          ),

                                          SizedBox(height: 5,),

                                          TextWidget(
                                            text: "Note: You won't get your points back in case you are not the winner",
                                            textAlign: TextAlign.center,
                                            maxLines: 6,
                                            fontSize: MySize.size14,
                                            fontFamily: AppConst.primaryFont,
                                            fontColor: AppColors.redColor,
                                          ),

                                          SizedBox(
                                            height: MySize.scaleFactorHeight * 20,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              submitLuckyDrawRequest(_chooseLuckyDrawModel.id, _chooseLuckyDrawModel.points, _chooseLuckyDrawModel.name);
                                          //    Navigator.push(context, MaterialPageRoute(builder: (_) => BottomBarView()));
                                             // Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.secondaryColor,
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
                            }
                          else

                            {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }

                        },),

                      ChoosePaymenType(onYesPressed:(String payment){
                        setState(() {
                          selectedPaymentType = payment;
                        });

                        pageController.jumpToPage(6);

                        // pageController.nextPage(
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.easeOut,
                        // );
                      } ,),


                      ChooseDonation(onYesPressed:(String payment){
                        setState(() {
                          selectedPaymentType = payment;
                          if (kDebugMode) {
                            print("jjselectedpayment: $selectedPaymentType");
                          }
                        });
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      } ,),


                      BeforeSubmissionScreen(
                        amounttoRedeem: amountRedeem, pointstoRedeem: pointstoRedeeem, choosenType: choosenType,
                        onOkPressed: () {
                          if(choosenType == 'cashdisbursement')
                          {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                          else if(choosenType == 'donation')
                          {

                            submitDonation();
                            // pageController.nextPage(
                            //   duration: const Duration(milliseconds: 300),
                            //   curve: Curves.easeOut,
                            // );
                          }
                          else
                          {

                          }
                        },
                      ),


                      EnterBankDetails(
                        redeemtype: choosenType,
                        redeemAmount: amountRedeem,
                          redeemPoints: pointstoRedeeem,
                          selectedPaymentType: selectedPaymentType
                      ),



                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> submitDonation() async
  {

    SharedPreferences preff=await SharedPreferences.getInstance();
    var name = preff!.getString('username') ?? "Jibran";
    var phone = preff!.getString('user_mobile') ?? "03015894305";

    progressDialog?.show();

    try {

      var response = await http.post(Uri.parse(AppUrls.redeemPoints), body: {

        "userId": preff.get('uid').toString(),
        "points":pointstoRedeeem,
        "amount":amountRedeem,
        "account_title":name,
        "phone": phone,
        "payment_method":selectedPaymentType,
        "type": "Donation"

      });

      var dataa = jsonDecode(response.body);
      if (response.statusCode == 200) {

        progressDialog?.hide();
        Navigator.push(context, MaterialPageRoute(builder: (_) => BottomBarView()));


      } else {

        progressDialog?.hide();


      }
    } catch (e) {

      progressDialog?.hide();

    }
  }


  void initProgressDialog()
  {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: false);
    progressDialog?.style(
      textAlign: TextAlign.center,
      message: 'Please wait...'.tr(),
      elevation: 10,
      padding: const EdgeInsets.symmetric(vertical: 10),
      messageTextStyle: const TextStyle(
        color: AppColors.purpleColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget drawerComp() => Drawer(
        child: Container(
          height: MySize.screenHeight,
          width: MySize.screenWidth,
          padding: EdgeInsets.only(
              left: MySize.size22, top: MySize.size22, right: MySize.size22),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MySize.scaleFactorHeight * 40,
                ),
                TextWidget(
                  text: "Ali Ahmed",
                  fontColor: AppColors.whiteColor,
                  fontSize: MySize.size22,
                  fontWeight: FontWeight.w700,
                ),

                Container(
                  width: MySize.size80,
                  padding: EdgeInsets.all(MySize.size4),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(MySize.size6)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: "0.92",
                        fontSize: MySize.size14,
                        fontWeight: FontWeight.w700,
                        fontColor: AppColors.whiteColor,
                      ),
                      TextWidget(
                        text: "Points".tr(),
                        fontSize: MySize.size14,
                        fontWeight: FontWeight.w700,
                        fontColor: AppColors.whiteColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MySize.scaleFactorHeight * 50,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: munuItems.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      switch (index) {
                        case 0:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const GeneralProfileView(),
                              ));
                        case 1:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BussinessProfileView(),
                              ));

                        case 2:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainLiveSurveyView(),
                              ));
                        case 4:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RewardsView(),
                              ));
                        default:
                          showBar(context, message: "No Navigation");
                      }
                    },
                    child: Column(
                      children: [
                        paddingComp(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextWidget(
                                    text: munuItems[index].toString(),
                                    maxLines: 1,
                                    fontSize: MySize.size18,
                                    fontFamily: AppConst.primaryFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Icon(
                                CupertinoIcons.arrow_right,
                                color: AppColors.whiteColor,
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: MySize.size30,
                          thickness: MySize.size2,
                          color: AppColors.whiteColor,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
