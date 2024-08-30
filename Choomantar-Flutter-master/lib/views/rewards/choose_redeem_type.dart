import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/configs/providers/usersignupdetails.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../configs/providers/calculating_profile_completion_percent_provider.dart';
import '../../configs/providers/get_user_points_provider.dart';



class ChooseRedeemType extends StatefulWidget {

  final Function(String) onTypeSelected;

  const ChooseRedeemType({super.key, required this.onTypeSelected});

  @override
  State<ChooseRedeemType> createState() => _ChooseRedeemTypeState();
}

class _ChooseRedeemTypeState extends State<ChooseRedeemType> {
  String? selectedPaymentType;
 // PageController pageController = PageController();
  int? PointsAvailable;
  double? resultAll;


  @override
  void initState() {
    super.initState();
    CommonFuncs.showToast("ChooseRedeemType");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final getUserPointsProvider = Provider.of<GetUserPoints>(context);
        final totalPercentage = Provider.of<CalculateProfileCompletionPercent>(context);

        final totalPerc = totalPercentage.all_Percents;

        final points = getUserPointsProvider.points;
        PointsAvailable = points;
        resultAll = totalPerc;

        return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MySize.size10),
              Text(
                'Redeem Type'.tr(),
                style: TextStyle(
                  fontFamily: AppConst.primaryFont,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondaryColor,
                  fontSize: MySize.size22,
                ),
              ),

              SizedBox(
                height: MySize.scaleFactorHeight * 15,
              ),

              CircularSeekBar(
                width: double.infinity,
                height: MySize.size100,
                progress: points.toDouble(),
                maxProgress: 50000,
                interactive: false,
                barWidth: MySize.size10,
                dashWidth: MySize.size4,
                startAngle: MySize.size90,
                sweepAngle: 360,
                strokeCap: StrokeCap.butt,
                progressColor: AppColors.primaryColor,
                trackColor: AppColors.whiteColor.withOpacity(0.8),
                animation: true,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: points != null && points < 0 ? '0' : points
                            .toString(),
                        fontSize: MySize.size20,
                        fontWeight: FontWeight.w700,
                      ),
                      TextWidget(
                        text: "Total Points".tr(),
                        fontColor: AppColors.primaryColor,
                        fontSize: MySize.size10,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: MySize.size54,),

              GestureDetector(
                onTap: () {
                  widget.onTypeSelected("luckydraw");
                },

                child: Container(
                  width: MySize.screenWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: MySize.size15,
                    vertical: MySize.size6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      width: MySize.size3,
                      color: AppColors.whiteColor,
                    ),
                    borderRadius: BorderRadius.circular(MySize.size12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/bingo.png',
                        height: MySize.size48,
                        width: MySize.size48,
                        fit: BoxFit.fill,
                      ),
                      const Spacer(),
                      TextWidget(
                        text: 'Lucky Draw ',
                        fontSize: MySize.size18,
                        fontFamily: AppConst.primaryFont,
                        fontColor: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                      const Spacer(),

                    ],
                  ),
                ),
              ),

              SizedBox(height: MySize.size12,),


              GestureDetector(
                onTap: () {
                  widget.onTypeSelected("cashdisbursement");
                },

                child: Container(
                  width: MySize.screenWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: MySize.size15,
                    vertical: MySize.size6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      width: MySize.size3,
                      color: AppColors.whiteColor,
                    ),
                    borderRadius: BorderRadius.circular(MySize.size12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/cashdisbursement.png',
                        height: MySize.size48,
                        width: MySize.size48,
                        fit: BoxFit.fill,
                      ),
                      const Spacer(),
                      TextWidget(
                        text: 'Cash Disbursement',
                        fontSize: MySize.size18,
                        fontFamily: AppConst.primaryFont,
                        fontColor: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                      const Spacer(),

                    ],
                  ),
                ),
              ),


              SizedBox(height: MySize.size12,),

              GestureDetector(
                onTap: () {
                  widget.onTypeSelected("donation");
                },
                child: Container(
                  width: MySize.screenWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: MySize.size15,
                    vertical: MySize.size6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      width: MySize.size3,
                      color: AppColors.whiteColor,
                    ),
                    borderRadius: BorderRadius.circular(MySize.size12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/donation.png',
                        height: MySize.size48,
                        width: MySize.size48,
                        fit: BoxFit.fill,
                      ),
                      const Spacer(),
                      TextWidget(
                        text: 'Donation',
                        fontSize: MySize.size18,
                        fontFamily: AppConst.primaryFont,
                        fontColor: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                      const Spacer(),


                    ],
                  ),
                ),
              ),

              Spacer(),
            ],
          ),
        );

      },
    );
  }
}

