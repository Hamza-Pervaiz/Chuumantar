import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/configs/providers/calculating_profile_completion_percent_provider.dart';
import 'package:chumanter/configs/providers/profile_completion_status.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../configs/providers/usersignupdetails.dart';
import '../smook_view/smook_view.dart';

// ignore: must_be_immutable
class BussinessProfileView extends StatefulWidget {
  const BussinessProfileView({super.key});

  @override
  State<BussinessProfileView> createState() => _BussinessProfileViewState();
}

class _BussinessProfileViewState extends State<BussinessProfileView> with SingleTickerProviderStateMixin {
  double? resultAll;
  bool? isCompletedGeneral;
  bool? isCompletedHealth;
  bool? isCompletedShopping;
  bool? isCompletedEntertainment;
  bool? isCompletedTechnology;
  bool? isCompletedFinancial;

  String imagePath = "";

  late AnimationController _controller;
  late Animation<double> _animation;



  List<CategoryModel> items = [
    CategoryModel(
        image: AppConst.foodIcon, name: "General Profile".tr(), amount: 14,),
    CategoryModel(image: AppConst.r2, name: "Health Profile".tr(), amount: 14, ),
    CategoryModel(image: AppConst.r4, name: "Shopping Profile".tr(), amount: 8, ),
    CategoryModel(image: AppConst.r5, name: "Entertainment".tr(), amount: 15, ),
    CategoryModel(image: AppConst.r6, name: "Technology".tr(), amount: 14,),
    CategoryModel(image: AppConst.r7, name: "Financial".tr(), amount: 15, ),
  ];

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      resultAll = prefs.getDouble('resultall') ?? 0;

    });
    if (kDebugMode) {
      print('result all is: $resultAll');
    }

  }


  Future<void> getCompleteionProfilesData() async
  {
    SharedPreferences preffs = await SharedPreferences.getInstance();
    setState(() {
     isCompletedGeneral = preffs.getBool('completedGeneral')?? false;
     isCompletedHealth = preffs.getBool('completedHealth')?? false;
     isCompletedShopping = preffs.getBool('completedShopping')?? false;
     isCompletedEntertainment = preffs.getBool('completedEntertainment')?? false;
     isCompletedTechnology = preffs.getBool('completedTechnology')?? false;
     isCompletedFinancial = preffs.getBool('completedFinancial')?? false;


    });
  }


@override
  void initState() {
 // loadData();
  CommonFuncs.showToast("bussiness_profile\nBussinessProfileView");

  _loadUserImage();

  _controller =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  _animation =
  CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  //
  // _controller = AnimationController(
  //   vsync: this,
  //   duration: Duration(milliseconds: 900), // Adjust duration as needed
  // );
  //
  // _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  //
  // // Start the animation
   _controller.forward();


    super.initState();
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

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("jjjbprofile  widget rebuild");
    }
    final getCompletionStatuses = Provider.of<ProfileCompletionStatus>(context, listen: false);
    final getPercentage = Provider.of<CalculateProfileCompletionPercent>(context, listen: false);
    getPercentage.calculateAllPercents();
    getCompletionStatuses.getCompleteionProfilesData();
    // print("jjjbprofile ${getUserPointsProvider.resultAl}");
    MySize().init(context);

     return FadeTransition(
       opacity: _animation,
       child: Scaffold(
            body: Container(
              height: MySize.screenHeight,
              width: MySize.screenWidth,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(MySize.size16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Consumer<CalculateProfileCompletionPercent>(
                        builder: (BuildContext context, CalculateProfileCompletionPercent value, Widget? child) {
                          double resultAll = value.resultAl;
                          if (kDebugMode) {
                            print("jjjbprofile $resultAll");
                          }
                         return CircularSeekBar(
                            interactive: false,
                            width: double.infinity,
                            height: MySize.size100,
                            progress: ((resultAll ?? 0).clamp(0, 100)).round().toDouble(),
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
                                    text: '${(resultAll ?? 0).toInt()}%',
                                    fontSize: MySize.size17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  TextWidget(
                                    text: "Profile".tr(),
                                    fontColor: AppColors.primaryColor,
                                    fontSize: MySize.size14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(
                        height: MySize.scaleFactorHeight * 30,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GeneralProfileView(),
                            ),
                          );
                        },
                        child: Container(
                          height: MySize.scaleFactorHeight * 70,
                          width: MySize.screenWidth,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(MySize.size16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  width: MySize.size60,
                                  height: MySize.size60,
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius:
                                      BorderRadius.circular(MySize.size10)),
                                  child:  ClipOval(
                                    child: CachedNetworkImage(
                                      width: MySize.size20*2,
                                      height: MySize.size20*2,
                                      imageUrl: imagePath,
                                      placeholder: (context, url) => Image.asset('assets/images/hi4.png',  fit: BoxFit.cover,),
                                      errorWidget: (context, url, error) =>  Image.asset('assets/images/hi4.png', fit: BoxFit.cover,),

                                    ),
                                  ),
                                ),
                              ),
                              Consumer<UserProvider>(
                                builder: (BuildContext context, UserProvider value, Widget? child) {
                                  String userName = value.userName ?? "";
                                  return TextWidget(
                                    text: userName,
                                    fontSize: MySize.size20,
                                    fontFamily: AppConst.primaryFont,
                                  );
                                },
                              ),
                              const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 10,
                      ),
                      SizedBox(
                        width: MySize.screenWidth * 0.8,
                        child: const Divider(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 20,
                      ),
                      Text(
                        "My Profile".tr(),
                       style: TextStyle(
                         fontSize: MySize.size20,
                         fontFamily: AppConst.primaryFont,
                         fontWeight: FontWeight.w600,
                         color: AppColors.secondaryColor,
                       ),

                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 20,
                      ),
                      Consumer<ProfileCompletionStatus>(
                        builder: (BuildContext context, ProfileCompletionStatus value, Widget? child) {
                          bool isCompletedGeneral = value.completedGeneral ?? false;
                          bool isCompletedShopping = value.completedShopping ?? false;
                          bool isCompletedHealth = value.completedHealth ?? false;
                          bool isCompletedEntertainment = value.completedEntertainment ?? false;
                          bool isCompletedTechnology = value.completedTechnology ?? false;
                          bool isCompletedFinancial = value.completedFinancial ?? false;

                          if (kDebugMode) {
                            print("jjjbprofile $isCompletedGeneral");
                            print("jjjbprofile $isCompletedShopping");
                            print("jjjbprofile $isCompletedHealth");
                            print("jjjbprofile $isCompletedEntertainment");
                            print("jjjbprofile $isCompletedTechnology");
                            print("jjjbprofile $isCompletedFinancial");
                          }

                         return ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (context, index) => SizedBox(
                              height: MySize.scaleFactorHeight * 20,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                // Use a switch statement to navigate to different screens based on the profile type
                                switch (index) {
                                  case 0:
                                    if(isCompletedGeneral == true)
                                    {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return completedDialog(index);
                                        },
                                      );
                                    }
                                    else{
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SmookView(index, viewMode: false,),
                                        ),
                                      );
                                    }
                                    break;
                                  case 1: // Health Profile
                                    if(isCompletedHealth == true)
                                    {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return completedDialog(index);
                                        },
                                      );
                                    }
                                    else if(!isCompletedGeneral)
                                    {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context)
                                          {
                                            return inCompleteProfilesDialog("Please complete General Profile first");
                                          }
                                      );
                                    }
                                    else{
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SmookView(index, viewMode: false,), // Use the new HealthProfileView
                                        ),
                                      );
                                    }
                                    break;
                                  case 2: // Shopping Profile
                                    if(isCompletedShopping == true)
                                    {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return completedDialog(index);
                                        },
                                      );
                                    }
                                    else if(isCompletedGeneral&&isCompletedHealth)
                                    {

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SmookView(index, viewMode: false,), // Use the new ShoppingProfileView
                                        ),
                                      );

                                    }
                                    else{
                                      String msg = !isCompletedGeneral&&!isCompletedHealth?
                                      "Please complete General and Health Profiles first" :
                                      isCompletedGeneral&&!isCompletedHealth?
                                      "Please complete Health Profile first" : "null";

                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context)
                                          {
                                            return inCompleteProfilesDialog(msg);
                                          }
                                      );
                                    }

                                    break;
                                  case 3: // Shopping Profile
                                    if(isCompletedEntertainment == true)
                                    {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return completedDialog(index);
                                        },
                                      );
                                    }
                                    else if(isCompletedGeneral&&isCompletedHealth&&isCompletedShopping)
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SmookView(index, viewMode: false,), // Use the new ShoppingProfileView
                                        ),
                                      );
                                    }
                                    else{
                                      String msg = !isCompletedGeneral&&!isCompletedHealth&&!isCompletedShopping?
                                      "Please complete General, Health and Shopping Profiles first" :
                                      isCompletedGeneral&&!isCompletedHealth&&!isCompletedShopping?
                                      "Please complete Health and Shopping Profiles first" :
                                      isCompletedGeneral&&isCompletedHealth&&!isCompletedShopping?
                                      "Please complete Shopping Profile first" : "null";

                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context)
                                          {
                                            return inCompleteProfilesDialog(msg);
                                          }
                                      );

                                    }

                                    break;
                                  case 4: // Shopping Profile
                                    if(isCompletedTechnology == true)
                                    {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return completedDialog(index);
                                        },
                                      );
                                    }
                                    else if(isCompletedGeneral&&isCompletedHealth&&isCompletedShopping&&
                                        isCompletedEntertainment)
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SmookView(index, viewMode: false,), // Use the new ShoppingProfileView
                                        ),
                                      );
                                    }
                                    else{

                                      String msg = !isCompletedGeneral&&!isCompletedHealth&&!isCompletedShopping&&!isCompletedEntertainment?
                                      "Please complete General, Health, Shopping and Entertainment Profiles first" :
                                      isCompletedGeneral&&!isCompletedHealth&&!isCompletedShopping&&!isCompletedEntertainment?
                                      "Please complete Health, Shopping and Entertainment Profiles first" :
                                      isCompletedGeneral&&isCompletedHealth&&!isCompletedShopping&&!isCompletedEntertainment?
                                      "Please complete Shopping and Entertainment Profiles first" :
                                      isCompletedGeneral&&isCompletedHealth&&isCompletedShopping&&!isCompletedEntertainment?
                                      "Please complete Entertainment Profile first" : "null";

                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context)
                                          {
                                            return inCompleteProfilesDialog(msg);
                                          }
                                      );

                                    }
                                    break;
                                  case 5: // Shopping Profile
                                    if(isCompletedFinancial == true)
                                    {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return completedDialog(index);
                                        },
                                      );
                                    }
                                    else if(isCompletedGeneral&&isCompletedHealth&&isCompletedShopping&&
                                        isCompletedEntertainment&&isCompletedTechnology)
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SmookView(index, viewMode: false,), // Use the new ShoppingProfileView
                                        ),
                                      );
                                    }
                                    else{

                                      String msg = !isCompletedGeneral&&!isCompletedHealth&&!isCompletedShopping&&!isCompletedEntertainment&&!isCompletedTechnology?
                                      "Please complete General, Health, Shopping, Entertainment and Technology Profiles first" :
                                      isCompletedGeneral&&!isCompletedHealth&&!isCompletedShopping&&!isCompletedEntertainment&&!isCompletedTechnology?
                                      "Please complete Health, Shopping, Entertainment and Technology Profiles first" :
                                      isCompletedGeneral&&isCompletedHealth&&!isCompletedShopping&&!isCompletedEntertainment&&!isCompletedTechnology?
                                      "Please complete Shopping, Entertainment and Technology Profiles first" :
                                      isCompletedGeneral&&isCompletedHealth&&isCompletedShopping&&!isCompletedEntertainment&&!isCompletedTechnology?
                                      "Please complete Entertainment and Technology Profiles first" :
                                      isCompletedGeneral&&isCompletedHealth&&isCompletedShopping&&isCompletedEntertainment&&!isCompletedTechnology?
                                      "Please complete Technology Profile first" :
                                      "null";

                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context)
                                          {
                                            return inCompleteProfilesDialog(msg);
                                          }
                                      );
                                    }
                                    break;
                                }
                              },
                              child: Container(
                                width: MySize.screenWidth,
                                padding: EdgeInsets.symmetric(
                                    horizontal: MySize.size15, vertical: MySize.size6),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      width: MySize.size3, color: AppColors.whiteColor),
                                  borderRadius: BorderRadius.circular(MySize.size12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      items[index].image,
                                      height: MySize.size48,
                                      width: MySize.size48,
                                      fit: BoxFit.fill,
                                    ),

                                    TextWidget(
                                      text: items[index].name,
                                      fontSize: MySize.size18,
                                      fontFamily: AppConst.primaryFont,
                                      fontColor: AppColors.whiteColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    Container(
                                      width: MySize.size38,
                                      height: MySize.size38,
                                      decoration: BoxDecoration(
                                        // border: Border.all(
                                        //     width: MySize.size2,
                                        //     color: AppColors.whiteColor),
                                          borderRadius:
                                          BorderRadius.circular(MySize.size50),
                                          color: AppColors.secondaryColor),
                                      child: Center(
                                        child: TextWidget(
                                          text: "${items[index].amount} ",
                                          fontColor: AppColors.whiteColor,
                                          fontSize: MySize.size14,
                                          fontFamily: AppConst.primaryFont,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
     );

  }

  Widget completedDialog(int indexo) => Dialog(
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
          fit: BoxFit.scaleDown,
          scale: 0.6,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
            text: 'Profile Completed!'.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            fontSize: MySize.size22,
            fontFamily: AppConst.primaryFont,
            fontColor: AppColors.redColor,
          ),
          SizedBox(height: MySize.size22),
          TextWidget(
            text: 'You have completed the profile.'.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            fontSize: MySize.size18,
            fontFamily: AppConst.primaryFont,
            fontColor: AppColors.purpleColor,
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
                  backgroundColor: AppColors.redColor,
                  foregroundColor: Colors.black,
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MySize.size8),
                  ),
                ),
                child: Text('Close'.tr(),style: const TextStyle( fontFamily: AppConst.primaryFont,
                    fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
              ),

              SizedBox(
                width: MySize.size10,
              ),

              ElevatedButton(

                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SmookView(indexo, viewMode: true,), // Use the new ShoppingProfileView
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
                child: Text('View'.tr(),style: const TextStyle( fontFamily: AppConst.primaryFont,
                    fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
              ),



            ],
          ),

        ],
      ),
    ),
  );


  Widget inCompleteProfilesDialog(String text) => Dialog(
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
          scale: 0.7,
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
          TextWidget(
            text: text.tr(),
            maxLines: 6,
            textAlign: TextAlign.center,
            fontSize: MySize.size18,
            fontFamily: AppConst.primaryFont,
            fontColor: AppColors.purpleColor,
          ),

          SizedBox(height: MySize.size18),

          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
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

}
