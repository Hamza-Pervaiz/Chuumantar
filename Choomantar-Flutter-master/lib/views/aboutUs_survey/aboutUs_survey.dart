import 'package:chumanter/configs/imports/import_helper.dart';

import '../../widgets/textwidgets_for_about_us.dart';

class AboutUsSurveyView extends StatefulWidget {
  const AboutUsSurveyView({super.key});

  @override
  State<AboutUsSurveyView> createState() => _AboutUsSurveyViewState();
}

class _AboutUsSurveyViewState extends State<AboutUsSurveyView> {
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 20),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              SizedBox(
                height: MySize.scaleFactorHeight * 56,
                child: Row(
                  children: [

                    backBtn(context),

                    Expanded(
                      child: Image.asset(
                        AppConst.logo,
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: MySize.scaleFactorHeight * 20,
              ),
              TextWidget(
                text: "About Us",
                fontSize: MySize.size20,
                fontWeight: FontWeight.w500,
                fontFamily: AppConst.primaryFont,
              ),
              SizedBox(height: MySize.scaleFactorHeight * 20),

              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(
                  vertical: 30.0,
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
                    fit: BoxFit.scaleDown,
                    scale: 0.4,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextWidgetAboutUs(
                      text: "MAKE A DIFFERENCE AS IT PAYS\nIN MORE WAYS THAN ONE",
                      fontWeight: FontWeight.bold,
                      fontSize: MySize.size14,
                    ),
                    const Divider(color: AppColors.primaryColor),
                    TextWidgetAboutUs(text: "Share your thoughts and opinions"),
                    TextWidgetAboutUs(text: "Influence change"),
                    TextWidgetAboutUs(text: "Improve your knowledge"),
                    TextWidgetAboutUs(text: "Get rewarded in return"),
                    const SizedBox(height: 20),
                    TextWidgetAboutUs(
                      text: "We connect your voice to big brands and Decision Makers- Let's make this world a better place to live. Together",

                    ),
                    const SizedBox(height: 20),
                    TextWidgetAboutUs(
                      text: "Choomanter is a robust online community with over 1 million members dedicated to making a change and your voice heard. We endeavour to open the window of communication between you and the brands you love. We create an opportunity to see your opinions and suggestions reflected in the products and services of tomorrow.",
                    ),
                    const SizedBox(height: 20),
                    TextWidgetAboutUs(
                      text: "Complete your profiles carefully to get matching surveys",
                    ),
                    TextWidgetAboutUs(
                      text: "Take online surveys anywhere, anytime, and on any device.",
                    ),
                    TextWidgetAboutUs(
                      text: "Earn points by successfully completing each survey.",
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomBarView(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Start Taking Surveys"),
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

