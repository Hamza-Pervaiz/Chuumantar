// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/completed_surveys/completed_survey_view.dart';
import 'package:chumanter/views/rewards/luckydraw_history.dart';
import 'package:chumanter/views/rewards/rewards_history.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../configs/providers/get_user_points_provider.dart';
import '../../configs/providers/usersignupdetails.dart';
import '../aboutUs_survey/aboutUs_survey.dart';
import '../notifications_view/notifications_local.dart';
import '../privacy_policy/privacy_policy_view.dart';

class SettingsView extends StatefulWidget {
  String? currentLocale;

  SettingsView({super.key, this.currentLocale});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String nono = "No Navigation found for".tr();

  List items = [
    "My Profile Info".tr(),
    "Complete Your Profile".tr(),
    "Completed Surveys".tr(),
    "Reward History".tr(),
    "LuckyDraw History".tr(),
    // "Rewards".tr(),
    "Notifications".tr(),
    "How we work".tr(),
    "Privacy Policy".tr(),
  ];

  bool showSettingsBadge = false;
  String currLoc = "en-US";

  String imagePath = "";

  @override
  void initState() {
    final getUserPointsProvider =
        Provider.of<GetUserPoints>(context, listen: false);
    getUserPointsProvider.fetchUserPoints();
    super.initState();
    SharedPreferences.getInstance()
        .then((value) => currLoc = value.getString("language") ?? "en-US");
    _loadSettingsBadgeState();
    _loadUserImage();
    CommonFuncs.showToast("settings_view\nSettingsView");
  }

  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath =
          prefs.getString('user_image').toString(); // Load the image path
      if (kDebugMode) {
        print("jjjjjimagepath$imagePath");
      }
    });
  }

  Future<void> _loadSettingsBadgeState() async {
    final prefs = await SharedPreferences.getInstance();
    bool notificationValue = prefs.getBool('notification') ?? false;
    bool notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;

    setState(() {
      showSettingsBadge = notificationValue && notificationsEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        userProvider.loadUserDetails();
        String userName = userProvider.userName ?? "";
        final getUserPointsProvider = Provider.of<GetUserPoints>(
          context,
        );
        final points = getUserPointsProvider.points;
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: "Profile".tr(),
                        fontSize: MySize.size26,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.secondaryColor,
                        fontFamily: AppConst.primaryFont,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 40,
                  ),
                  Center(
                    child: SizedBox(
                      width: MySize.screenWidth,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              width: MySize.size50 * 2,
                              height: MySize.size50 * 2,
                              imageUrl: imagePath,
                              placeholder: (context, url) => Image.asset(
                                'assets/images/hi4.png',
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/hi4.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MySize.scaleFactorWidth * 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: userName,
                                  fontSize: MySize.size22,
                                  fontColor: AppColors.whiteColor,
                                  fontFamily: AppConst.primaryFont,
                                ),
                                // TextWidget(
                                //   text: "Edit Profile",
                                //   fontSize: MySize.size16,
                                //   fontFamily: AppConst.primaryFont,
                                //   fontColor: AppColors.whiteColor,
                                // ),
                                SizedBox(
                                  height: MySize.scaleFactorHeight * 15,
                                ),
                                Container(
                                  padding: EdgeInsets.all(MySize.size4),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(MySize.size4)),
                                  child: TextWidget(
                                      text:
                                          '${points != null && points! < 0 ? '0' : points.toString()} points'),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 30,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () async {
                        switch (index) {
                          case 0:

                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder: (_, __, ___) => GeneralProfileView(),
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

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const GeneralProfileView(),
                                ));

                          case 1:

                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder: (_, __, ___) => BussinessProfileView(),
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

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BussinessProfileView(),
                                ));

                          case 2:
                            //completed surveys

                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder: (_, __, ___) => CompletedSurveyView(),
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

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CompletedSurveyView(),
                                ));

                          case 3:

                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder: (_, __, ___) => RewardsHistory(),
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

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RewardsHistory(),
                                ));
                          case 4:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LuckydrawHistory(),
                                ));
                          case 5:
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('notification', false);

                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder: (_, __, ___) => NotificationsView(),
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

                            if (!mounted) return;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationsView()));

                          case 6:

                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder: (_, __, ___) => AboutUsSurveyView(),
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

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AboutUsSurveyView(),
                                ));

                          case 7:

                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder: (_, __, ___) => PrivacyPolicy(),
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

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicy(),
                                ));

                          default:
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) => validationDialog(
                                  isTitle: true,
                                  title: const SizedBox(),
                                  context,
                                  icon: AppConst.activeTick,
                                  oprText: "$nono \n ${items[index]}",
                                  ontap: () {
                                Navigator.pop(context);
                              }),
                            );
                        }
                      },
                      child: Column(
                        children: [
                          paddingComp(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    textAlign: TextAlign.start,
                                    text: items[index],
                                    maxLines: 1,
                                    fontSize: MySize.size18,
                                    fontFamily: AppConst.primaryFont,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (index == 4 &&
                                    showSettingsBadge) // Assuming index 5 is Notifications
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: const Text(
                                      '!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                Icon(
                                  currLoc == "en-US"
                                      ? CupertinoIcons.arrow_right
                                      : CupertinoIcons.arrow_left,
                                  color: AppColors.whiteColor,
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: MySize.size25,
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
      },
    );
  }
}
