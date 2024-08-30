import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../configs/imports/import_helper.dart';


class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();

  static _BottomBarViewState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BottomBarViewState>();

}

class _BottomBarViewState extends State<BottomBarView> {


  Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
    await showDialog(
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
              padding: EdgeInsets.symmetric(horizontal: MySize.size20, vertical: MySize.size35),
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
                  text: 'Confirmation'.tr(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontSize: MySize.size22,
                  fontFamily: AppConst.primaryFont,
                  fontColor: AppColors.redColor,
                ),
                SizedBox(height: MySize.size22),
                TextWidget(
                  text: 'Are you sure you want to exit app.'.tr(),
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
                          Navigator.of(context).pop(false); // Close the dialog
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
                                         exit(0);
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
  late List<Widget> viewList; // Declare viewList

  int index = 0;
  bool showSettingsBadge = false;

  void indexChange(int ind)
  {
    setState(() {
      index = ind;
    });
  }

  @override
  void initState() {
    super.initState();

     viewList = [
       const HomeView(),
      const RewardsView(),
      const QrCoderView(),
      const BussinessProfileView(),
      SettingsView(),
    ];
    _loadSettingsBadgeState();

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

    return WillPopScope(
      onWillPop: () async {
        if (index == 0) {
          bool confirm = await _showExitConfirmationDialog(context) ?? false;
          return confirm;
        }

        else if(index!=1){

          setState(() {
            index = 0;
          });
          return false;
        }
        else
          {
            if (kDebugMode) {
              print("jjrewardwillpop of bottombar");
            }
            return true;
          }
      },
      child: Scaffold(
        backgroundColor: AppColors.blackColor,
        body: viewList[index],
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(MySize.size25),
            topLeft: Radius.circular(MySize.size25),
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColors.whiteColor,
            type: BottomNavigationBarType.shifting,
            useLegacyColorScheme: false,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.home),
                activeIcon: const Icon(
                  CupertinoIcons.home,
                  color: AppColors.purpleColor,
                ),
                label: "Home".tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.gift),
                activeIcon: const Icon(
                  CupertinoIcons.gift,
                  color: AppColors.purpleColor,
                ),
                label: "Rewards".tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.qrcode_viewfinder),
                activeIcon: const Icon(
                  CupertinoIcons.qrcode_viewfinder,
                  color: AppColors.purpleColor,
                ),
                label: "QR Scanner".tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.person),
                activeIcon: const Icon(
                  CupertinoIcons.person,
                  color: AppColors.purpleColor,
                ),
                label: "Profile".tr(),
              ),
              BottomNavigationBarItem(
                icon: showSettingsBadge
                    ? Stack(
                  children: [
                    const Icon(CupertinoIcons.settings),
                    Positioned(
                      right: 0,
                      child: Container(
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
                    )
                  ],
                )
                    : const Icon(CupertinoIcons.settings),
                activeIcon: const Icon(
                  CupertinoIcons.settings,
                  color: AppColors.purpleColor,
                ),
                label: "Settings".tr(),
              ),

            ],
            selectedItemColor: AppColors.purpleColor,
            selectedLabelStyle: TextStyle(
              fontSize: MySize.size14,
              fontWeight: FontWeight.w500,
              color: AppColors.purpleColor,
            ),
            showSelectedLabels: true,
            showUnselectedLabels: false,
            currentIndex: index,
            onTap: (value) async {
    if (value == 4) {
    if (showSettingsBadge) {
    setState(() {
    showSettingsBadge = false;
    });
    }
    }

    setState(() {
    index = value;
    });

            },
            unselectedIconTheme: const IconThemeData(color: AppColors.purple500),
          ),
        ),
      ),
    );
  }
}

