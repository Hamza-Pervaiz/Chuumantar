import 'dart:developer';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


class EnterBankDetails extends StatefulWidget {
  String selectedPaymentType='';
  String redeemPoints='';
  String redeemAmount='';
  String? redeemtype;
  EnterBankDetails({super.key, required this.selectedPaymentType,required this.redeemPoints, required this.redeemAmount, this.redeemtype});

  @override
  State<EnterBankDetails> createState() => _EnterBankDetailsState();
}

class _EnterBankDetailsState extends State<EnterBankDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  //PageController pageController = PageController();
  ProgressDialog? progressDialog;
  String rs='Rs,'.tr();
  String sentto ='will be sent to your'.tr();
  String donateto = 'will be donated to ';
  String account='account'.tr();
  String accounttitle='Enter Your Account Title For'.tr();


  Future<void> submitDetails() async
  {
    if (kDebugMode) {
      print("redeemdebug: inside submitDetails()");
    }
    SharedPreferences preff=await SharedPreferences.getInstance();
    progressDialog?.show();
    try {

      if (kDebugMode) {
        print("redeemdebug: inside try");
      }

      var response = await http.post(Uri.parse(AppUrls.redeemPoints), body: {

        "userId": preff.get('uid').toString(),
        "points":widget.redeemPoints,
        "amount":widget.redeemAmount,
        "account_title":nameController.text,
        "phone": phoneController.text,
        "payment_method":widget.selectedPaymentType,
        "type": widget.redeemtype == "cashdisbursement" ? "Redeem" : "Donation"
      });
      progressDialog?.hide();

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding:
            EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MySize.size16),
            ),
            child: Container(
              height: MySize.scaleFactorHeight * 240,

              padding: EdgeInsets.all(MySize.size20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MySize.size16),
                image: const DecorationImage(
                  image: AssetImage(AppConst.eyeBg),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                text: widget.redeemtype == 'cashdisbursement' ? '$rs${widget.redeemAmount} $sentto ${widget.selectedPaymentType} $account'.tr() :
                '$rs${widget.redeemAmount} $donateto ${widget.selectedPaymentType}'.tr(),
                    textAlign: TextAlign.center,
                    maxLines:4,
                    fontSize: MySize.size22,
                    fontFamily: AppConst.primaryFont,
                    fontColor: AppColors.purpleColor,
                  ),
                  SizedBox(height: MySize.size30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  const BottomBarView(),
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
                    child: Text('Ok'.tr(),style: const TextStyle( fontFamily: AppConst.primaryFont,
                        fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
                  ),
                ],
              ),
            ),
          );
        },
      );

      var dataa = jsonDecode(response.body);
      if (response.statusCode == 200) {

        if (kDebugMode) {
          print("redeemdebug: inside response.statuscode == 200 if");
        }

        CommonFuncs.apiHitPrinter("200", AppUrls.redeemPoints, "POST",
            "userId: ${preff.get('uid').toString()}\n"
                "points: ${widget.redeemPoints}\n"
                "account_title: ${nameController.text}\n"
                "phone: ${phoneController.text}\n"
                "payment_method: ${widget.selectedPaymentType}",
            dataa, "enter_info_screen");

    //   log(jsonDecode(response.body));

      } else {

        if (kDebugMode) {
          print("redeemdebug: inside else");
        }

        CommonFuncs.apiHitPrinter(response.statusCode.toString(), AppUrls.redeemPoints, "POST",
            "userId: ${preff.get('uid').toString()}\n"
                "points: ${widget.redeemPoints}\n"
                "account_title: ${nameController.text}\n"
                "phone: ${phoneController.text}\n"
                "payment_method: ${widget.selectedPaymentType}",
            dataa, "enter_info_screen");

        log("Failed to fetch data from the API. Status code: ${response
            .statusCode}");
      }
    } catch (e) {

      if (kDebugMode) {
        print("redeemdebug: inside catch");
      }

      log("Error is $e");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoneFromPref();
    CommonFuncs.showToast("enter_info_screen\nEnterBankDetails");
  }


  Future<void> getPhoneFromPref()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phoneController.text = prefs!.getString('user_mobile') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          'Enter Following Details.'.tr(),
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: MySize.size22,
          ),
        ),
        SizedBox(height: MySize.size14,),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFieldWidget(controller:nameController,
            hintText: '$accounttitle ${widget.selectedPaymentType}'.tr(),
            hintTextSize: 14,
            autofocus: true,
            textInputType: TextInputType.name,
    prefix: const Icon(Icons.add,color: Colors.white,),
          ),
        ),
        SizedBox(height: MySize.size2,),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFieldWidget(
            disable: true,
            controller:phoneController,
            hintText: 'Enter Your Phone Number'.tr(),
            hintTextSize: 14,
            maxLength: 11,
            autofocus: true,
            textInputType: TextInputType.phone,
            prefix: const Icon(Icons.phone_android,color: Colors.white,),
          ),
        ),
        SizedBox(height: MySize.size22,),
        Center(
          child: ElevatedButton(
            onPressed: () {
              progressDialog = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: false);
              progressDialog?.style(
                textAlign: TextAlign.center,
                message: 'Submitting Details...'.tr(),
                elevation: 10,
                padding: const EdgeInsets.symmetric(vertical: 10),
                messageTextStyle: const TextStyle(
                  color: AppColors.purpleColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              );
if(nameController.text.isNotEmpty || phoneController.text.isNotEmpty)
  {
    submitDetails();
  }
     else{
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
    return Dialog(
      insetPadding:
      EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySize.size16),
      ),
      child: Container(
        height: MySize.scaleFactorHeight * 240,

        padding: EdgeInsets.all(MySize.size20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MySize.size16),
          image: const DecorationImage(
            image: AssetImage(AppConst.eyeBg),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text: 'One of the fields are empty!'.tr(),
              textAlign: TextAlign.center,
              maxLines: 2,
              fontSize: MySize.size22,
              fontFamily: AppConst.primaryFont,
              fontColor: AppColors.redColor,
            ),
            SizedBox(height: MySize.size22),
            TextWidget(
              text: 'Kindly fill all the fields.'.tr(),
              textAlign: TextAlign.center,
              maxLines: 2,
              fontSize: MySize.size18,
              fontFamily: AppConst.primaryFont,
              fontColor: AppColors.purpleColor,
            ),
            SizedBox(height: MySize.size18),

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

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: Colors.white,
              elevation: 10,
            ),
            child: const Text("Submit").tr(),
          ),
        )
      ],
    );
  }
}
