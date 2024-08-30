import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../configs/imports/import_helper.dart';
import '../../configs/providers/get_user_points_provider.dart';
import '../../configs/providers/usersignupdetails.dart';




 class RedeemPoints extends StatefulWidget {
   final VoidCallback onYesPressed;
   String redeemPoints;
    RedeemPoints({super.key, required this.onYesPressed,required this.redeemPoints});

   @override
   State<RedeemPoints> createState() => _RedeemPointsState();
 }

 class _RedeemPointsState extends State<RedeemPoints> {
   int? PointsAvailable;
 //  PageController pageController = PageController();
   Future<void> _showRedeemConfirmation() async {
     await showDialog(
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
                   text: 'Confirmation'.tr(),
                   textAlign: TextAlign.center,
                   maxLines: 2,
                   fontSize: MySize.size22,
                   fontFamily: AppConst.primaryFont,
                   fontColor: AppColors.redColor,
                 ),
                 SizedBox(height: MySize.size22),
                 TextWidget(
                   text: 'Are you sure you want to redeem your points.'.tr(),
                   textAlign: TextAlign.center,
                   maxLines: 2,
                   fontSize: MySize.size18,
                   fontFamily: AppConst.primaryFont,
                   fontColor: AppColors.purpleColor,
                 ),
                 SizedBox(height: MySize.size20),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     SizedBox(
                       width: MySize.scaleFactorWidth*100,
                       child: ElevatedButton(
                         onPressed: () {
                           Navigator.of(context).pop(); // Close the dialog
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: AppColors.secondaryColor,
                           foregroundColor: Colors.white,
                         ),
                         child: Text("No".tr()),
                       ),
                     ),
                     SizedBox(
                       width: MySize.scaleFactorWidth*100,
                       child: ElevatedButton(
                         onPressed: () {
                           Navigator.of(context).pop();
                           widget.onYesPressed();
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: AppColors.primaryColor,
                           foregroundColor: Colors.white,
                         ),
                         child: Text("Yes".tr()),
                       ),
                     ),
                   ],
                 ),
               ],
             ),
           ),
         );
       },
     );

   }


@override
  void initState() {
  final getUserPointsProvider = Provider.of<GetUserPoints>(context, listen: false);
  getUserPointsProvider.fetchUserPoints();
  CommonFuncs.showToast("redeem_points\nRedeemPoints");
    super.initState();
  }

   @override
   Widget build(BuildContext context) {
     return Consumer<UserProvider>(
         builder: (context, userProvider, child) {
       userProvider.loadUserDetails();
       String userName = userProvider.userName ?? "";
       final getUserPointsProvider = Provider.of<GetUserPoints>(context);
       final points = getUserPointsProvider.points;
       PointsAvailable = points;

       return SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             CircularSeekBar(
               width: double.infinity,
               height: MySize.size100,
               maxProgress: 50000,
               interactive: false,
               progress: points.toDouble(),
               barWidth: MySize.size10,
               dashWidth: MySize.size4,
               startAngle: MySize.size90,
               sweepAngle: 360,
               strokeCap: StrokeCap.butt,
               progressColor: AppColors.primaryColor,
               trackColor: AppColors.whiteColor.withOpacity(0.8),
               animation: true,
               child: Padding(
                   padding: EdgeInsets.all(MySize.size20),
                   child: Column(
                     children: [
                       TextWidget(
                         text: points != null && points < 0 ? '0' : points.toString(),
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
                   )),
             ),
             SizedBox(
               height: MySize.scaleFactorHeight * 20,
             ),
             TextWidget(
               text: "Customer Reward Milestone".tr(),
               fontSize: MySize.size20,
               fontFamily: AppConst.primaryFont,
               fontWeight: FontWeight.w900,
               fontColor: AppColors.secondaryColor,
             ),
             SizedBox(
               height: MySize.scaleFactorHeight * 20,
             ),

             Container(
               padding: const EdgeInsets.all(16.0),
               margin: EdgeInsets.symmetric(
                 vertical: MySize.size22,
                 horizontal: MySize.size42,
               ),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(MySize.size16),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.5),
                     spreadRadius: 2,
                     blurRadius: 4,
                     offset: const Offset(0, 3),
                   ),
                 ],
                 image: const DecorationImage(
                   image: AssetImage(AppConst.eyeBg),
                   fit: BoxFit.cover,
                 ),
               ),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Lottie.asset('assets/json/giftanimation.json'),

                   Center(
                     child: ElevatedButton(
                       onPressed: () {
                         _showRedeemConfirmation();
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: AppColors.secondaryColor,
                         foregroundColor: Colors.white,
                         elevation: 10,
                       ),
                       child: Text("Redeem Points".tr()),
                     ),
                   )
                 ],
               ),
             )
           ],
         ),
       );
     },
     );
   }
 }
