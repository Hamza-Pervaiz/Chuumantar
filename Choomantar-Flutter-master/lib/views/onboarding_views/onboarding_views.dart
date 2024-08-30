import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../select_main_category/select_onboardingcategories_view.dart';


class OnboardingViews extends StatefulWidget {
  const OnboardingViews({super.key});

  @override
  State<OnboardingViews> createState() => _OnboardingViewsState();
}

class _OnboardingViewsState extends State<OnboardingViews> {
  final pageController = PageController();
  var _currentPage = 0;
  bool showstatictext1 = false;
  bool showstatictext2 = false;
  bool showstatictext3 = false;
  bool showstatictext4 = false;
  bool showstatictext5 = false;
  @override
  void initState() {
    super.initState();
    getSP();
    preff?.setString('showPromo', "yes");
    pageController.addListener(() {
      setState(() {
        _currentPage = pageController.page!.toInt();
      });
    });
  }

  SharedPreferences? preff;
  getSP() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }

  List onboarding = [
    {
      "jif": AppConst.onboarding_one_gif,
      "title": AppConst.onboarding_one_title.tr(),
      "disc":
          AppConst.onboarding_one_desc.tr()
    },
    {
      "jif": AppConst.onboarding_two_gif,
      "title": AppConst.onboarding_two_title.tr(),
      "disc": AppConst.onboarding_two_desc.tr()
    },
    {
      "jif": AppConst.onboarding_three_gif,
      "title": AppConst.onboarding_three_title.tr(),
      "disc": AppConst.onboarding_three_desc.tr()
    },
    {
      "jif": AppConst.onboarding_four_gif,
      "title": AppConst.onboarding_four_title.tr(),
      "disc": AppConst.onboarding_four_desc.tr()
    },
    {
      "jif": AppConst.onboarding_five_gif,
      "title": AppConst.onboarding_five_title.tr(),
      "disc": AppConst.onboarding_five_desc.tr()
    }
  ];

  @override
  Widget build(BuildContext context) {
    preff?.setString('showPromo', "yes");
    MySize().init(context);
    return Scaffold(
      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: onboarding.length,
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                        onboarding[index]
                            ['jif'], // Replace with the path to your JSON file
                        fit: BoxFit.fill,
                        height: MySize.size300 + MySize.size50,
                        width: MySize.size300 + MySize.size80),
                    SizedBox(
                      height: MySize.scaleFactorHeight * 80,
                    ),


          //  TypeWriterText(
          //
          //   text:  Text('${onboarding[index]["title"]}',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontSize: MySize.size19,
          //       fontFamily: AppConst.primaryFont,
          //       fontWeight: FontWeight.w600,
          //       color: AppColors.whiteColor,
          //     ),
          //   ),
          //   maintainSize: false,
          //
          //   duration: Duration(milliseconds: 100),
          // ),

                    // Text(
                    //   '${onboarding[index]["title"]}',
                    //   textAlign: TextAlign.center,
                    //   textScaleFactor: 1.0,
                    //   style: TextStyle(
                    //     fontSize: MySize.size19,
                    //     fontFamily: AppConst.primaryFont,
                    //     fontWeight: FontWeight.w600,
                    //     color: AppColors.whiteColor,
                    //   ),
                    // ),

                    //
                    // TextWidget(
                    //   text: onboarding[index]["title"],
                    //   fontSize: MySize.size22,
                    //   fontFamily: AppConst.primaryFont,
                    //   fontWeight: FontWeight.w600,
                    // ),


                    SizedBox(height: MySize.size50,),

                Expanded(
                  child: Text('${onboarding[index]["disc"]}', style: TextStyle(
                    fontSize: MySize.size19,
                    height: 1.5,
                    fontFamily: AppConst.primaryFont,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor,
                  ),
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.0,
                  ).animate()
                      .scale(duration: 900.ms)
                      .then(delay: 500.ms)


                ),


                    // TypeWriterText(
                    //   text:  Text('${onboarding[index]["disc"]}',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       fontSize: MySize.size19,
                    //       height: 1.5,
                    //       fontFamily: AppConst.primaryFont,
                    //       fontWeight: FontWeight.w600,
                    //       color: AppColors.whiteColor,
                    //     ),
                    //   ),
                    //   maintainSize: false,
                    //
                    //   duration: Duration(milliseconds: 100),
                    // ),

                    // Text(
                    //   '${onboarding[index]["disc"]}',
                    //   textAlign: TextAlign.center,
                    //   textScaleFactor: 1.0,
                    //   style: TextStyle(
                    //     fontSize: MySize.size19,
                    //     fontFamily: AppConst.primaryFont,
                    //     fontWeight: FontWeight.w600,
                    //     color: AppColors.whiteColor,
                    //   ),
                    // ),

                    // TextWidget(
                    //   text: onboarding[index]["disc"],
                    //   fontSize: MySize.size22,
                    //   fontFamily: AppConst.primaryFont,
                    //   fontWeight: FontWeight.w600,
                    // ),
                    //
                    SizedBox(
                      height: MySize.scaleFactorHeight * 100,
                    )
                  ],
                ),
              ),
            ),
            _currentPage > 3
                ? ButtonWidget(
                    onTap: () {

                      // Navigator.pushReplacement(
                      //   context,
                      //   PageRouteBuilder(
                      //     pageBuilder: (_, __, ___) => SelectCategories(),
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
                            builder: (context) => const SelectCategories(),
                          ));
                    },
                    text: "I am excited to join".tr())
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MySize.scaleFactorWidth * 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SmoothPageIndicator(
                          controller: pageController,
                          onDotClicked: (index) {
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.ease);
                          },
                          count: 5,
                          effect: CustomizableEffect(
                              dotDecoration: DotDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius:
                                      BorderRadius.circular(MySize.size20)),
                              activeDotDecoration: DotDecoration(
                                  color: Colors.transparent,
                                  borderRadius:
                                      BorderRadius.circular(MySize.size20),
                                  dotBorder: const DotBorder(
                                      color: AppColors.whiteColor))),
                        ),
                        SizedBox(
                          width: MySize.scaleFactorWidth * 80,
                          height: MySize.size40,
                          child: ButtonWidget(
                              taped: false,
                              activeOff: true,
                              onTap: () {
                                pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.ease);
                              },
                              text: "Next".tr()),
                        )
                      ],
                    ),
                  ),
            SizedBox(
              height: MySize.scaleFactorHeight * 20,
            )
          ],
        ),
      ),
    );
  }
}
