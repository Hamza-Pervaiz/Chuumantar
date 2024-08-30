import 'package:easy_localization/easy_localization.dart';

import '../../configs/imports/import_helper.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool isSwitched4 = false;


  bool isAllChecked()
  {
    return isSwitched1&&isSwitched2&&isSwitched3&&isSwitched4;
  }

  void toggleSwitch(bool value, int switchNumber) {
    switch(switchNumber)
    {
      case 0:
        setState(() {
          isSwitched1 = !isSwitched1;
        });

      case 1:
        setState(() {
          isSwitched2 = !isSwitched2;
        });

      case 2:
        setState(() {
          isSwitched3 = !isSwitched3;
        });

      case 3:
        setState(() {
          isSwitched4 = !isSwitched4;
        });
    }

  }


  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MySize.screenHeight,
          width: MySize.screenWidth,
          padding: EdgeInsets.only(top: MySize.size15, left: MySize.size15, right: MySize.size15),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppConst.bgPrimary),
              fit: BoxFit.fill,
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppConst.logo,
                height: MySize.scaleFactorHeight * 56,
              ),


              Flexible(
                child: Center(
                  child: Container(
                    //this one

                    padding: EdgeInsets.symmetric(horizontal: MySize.size10),
                    width: MySize.screenWidth,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(MySize.size15),
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
                      children: [

                        SizedBox(
                          height: MySize.size35,
                        ),

                        // TextWidget(text: 'Welcome to Choomanter', fontColor: AppColors.secondaryColor,
                        // fontSize: MySize.size19,
                        // fontFamily: AppConst.primaryFont,),

                        Text(
                          'Welcome to Choomanter'.tr(),
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryColor,
                            fontFamily: AppConst.primaryFont,
                            fontSize: MySize.size19,
                          ),
                        ),

                        SizedBox(
                          height: MySize.size15,
                        ),


                        Text(
                          'We like you already. But we won\'t proceed without your consent.'.tr(),
                          softWrap: true,
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppConst.secondaryFont,
                            fontSize: MySize.size15
                          ),

                        ),


                        // TextWidget(text: 'We like you already. But we won\'t proceed without your consent.',
                        // fontColor: Colors.black54, fontWeight: FontWeight.w600, textAlign: TextAlign.center, ),

                        SizedBox(
                          height: MySize.size10,
                        ),


                        Row(
                          children: [
                            Theme(
                              data: ThemeData(useMaterial3: false),
                              child: Switch(
                                activeColor: AppColors.urduBtn,
                                value: isSwitched1,
                                onChanged: (bool value) {
                                  toggleSwitch(value, 0);
                                },
                              ),
                            ),

                            Text(
                              'Read the questions carefully'.tr(),
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.blueColor,
                                fontFamily: AppConst.secondaryFont,
                                fontSize: MySize.size16,
                              ),
                            ),

                          ],
                        ),


                        Row(
                          children: [
                            Theme(
                              data: ThemeData(useMaterial3: false),
                              child: Switch(
                                activeColor: AppColors.urduBtn,
                                value: isSwitched2,
                                onChanged: (bool value) {
                                  toggleSwitch(value, 1);
                                },
                              ),
                            ),

                            Text(
                              'Answer all questions truthfully'.tr(),
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.blueColor,
                                fontFamily: AppConst.secondaryFont,
                                fontSize: MySize.size16,
                              ),
                            ),


                            // TextWidget(text: 'Answer all questions truthfully', fontWeight: FontWeight.w700,
                            //   fontColor: AppColors.blueColor, fontSize: MySize.size16,)

                          ],
                        ),


                        Row(
                          children: [
                            Theme(
                              data: ThemeData(useMaterial3: false),
                              child: Switch(
                                activeColor: AppColors.urduBtn,
                                value: isSwitched3,
                                onChanged: (bool value) {
                                  toggleSwitch(value, 2);
                                },
                              ),
                            ),

                            Text(
                              'Be nice and respectful'.tr(),
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.blueColor,
                                fontFamily: AppConst.secondaryFont,
                                fontSize: MySize.size16,
                              ),
                            ),

                            // TextWidget(text: 'Be nice and respectful', fontWeight: FontWeight.w700,
                            //   fontColor: AppColors.blueColor, fontSize: MySize.size16,)

                          ],
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Theme(
                              data: ThemeData(useMaterial3: false),
                              child: Switch(
                                activeColor: AppColors.urduBtn,
                                value: isSwitched4,
                                onChanged: (bool value) {
                                  toggleSwitch(value, 3);
                                },
                              ),
                            ),


                            Expanded(
                              child: Text(
                                'Only one account per user/mobile number'.tr(),
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blueColor,
                                  fontFamily: AppConst.secondaryFont,
                                  fontSize: MySize.size16,
                                ),
                                softWrap: true,
                              ),
                            ),

                          ],
                        ),

                        SizedBox(
                          height: MySize.size10,
                        ),

                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Choomanter'.tr(),
                                style: const TextStyle(
                                    color: AppColors.urduBtn,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              TextSpan(
                                text: ' reserves the right to suspend an\naccount that violates these terms'.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: MySize.size20,),

                        GestureDetector(

                          onTap: (){
                            if(isAllChecked())
                            {
                              Navigator.pop(context, true);
                            }
                            else
                            {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return checkAllDialog();
                                },
                              );
                            }
                          },

                          child: Container(

                            alignment: Alignment.center,
                            width: MySize.screenWidth,
                            height: MySize.scaleFactorHeight * 50,
                            decoration: BoxDecoration(
                              color: isAllChecked() ? AppColors.secondaryColor : AppColors.secondaryColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(30),

                            ),

                            child: TextWidget(text: 'I AGREE!'.tr(), fontSize: 18, fontWeight: FontWeight.bold,
                              fontColor: isAllChecked() ? AppColors.whiteColor : AppColors.whiteColor.withOpacity(0.5),
                            ),

                          ),
                        ),

                        SizedBox(
                          height: MySize.size30,
                        ),


                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
      )),
    );
  }


  Widget checkAllDialog() => Dialog(
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
          TextWidget(
            text: 'Error!'.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            fontSize: MySize.size22,
            fontFamily: AppConst.primaryFont,
            fontColor: AppColors.redColor,
          ),
          SizedBox(height: MySize.size22),

          Text(
            'Please agree to all options provided in order to proceed further'.tr(),
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

        ],
      ),
    ),
  );

}
