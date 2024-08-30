import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';

import '../auth/login_view/login_view.dart';

class LanguageView extends StatelessWidget {
   LanguageView({super.key,required this.whereFrom});

  String? whereFrom;
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    CommonFuncs.showToast("language_view\nLanguageView");
    return Scaffold(
      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
        child: Padding(
          padding: EdgeInsets.all(MySize.size20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              logoComp(height: MySize.size50, width: MySize.screenWidth * 0.6),
              SizedBox(
                height: MySize.scaleFactorHeight * 100,
              ),
              Column(
                children: [
                  TextWidget(
                    text: "Preferred Language".tr(),
                    fontSize: MySize.size25,
                    fontWeight: FontWeight.w600,
                    fontColor: AppColors.secondaryColor,
                    fontFamily: AppConst.primaryFont,
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 40,
                  ),
                  SizedBox(
                    width: MySize.screenWidth * 0.8,
                    child: ButtonWidget(
                      onTap: () {
                        _setAndSaveLocale(context, 'en', 'US');
                      },
                      text: "English".tr(),
                    ),
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 30,
                  ),
                  SizedBox(
                    width: MySize.screenWidth * 0.8,
                    child: ButtonWidget(
                      onTap: () {
                        _setAndSaveLocale(context, 'ur', 'PK');
                      },
                      text: "Urdu".tr(),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MySize.screenHeight * 0.3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setAndSaveLocale(BuildContext context, String languageCode, String countryCode) {
    context.setLocale(Locale(languageCode, countryCode));
    // Save the user's choice to shared preferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('language', '$languageCode-$countryCode');
    });
    if(whereFrom =='splash') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
    else if(whereFrom == 'home')
      {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomBarView()),
        );
      }
  }
}
