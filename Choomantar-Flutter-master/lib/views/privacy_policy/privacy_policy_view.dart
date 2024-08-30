import 'package:chumanter/configs/imports/import_helper.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PrivacyPolicy(),
    );
  }
}

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 20),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              text: "Privacy Policy",
              fontSize: MySize.size20,
              fontWeight: FontWeight.w500,
              fontFamily: AppConst.primaryFont,
            ),
            SizedBox(height: MySize.scaleFactorHeight * 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(
                  vertical: 60.0,
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
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: privacyPolicySections.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                        child: Text(
                          privacyPolicySections[index],
                          style: const TextStyle(fontSize: 16, color: AppColors.blackColor),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Improved formatting for privacy policy sections
final List<String> privacyPolicySections = [
  'Privacy Policy\n',
  'Last updated: December 19, 2023\n',
  'This Privacy Policy describes Our policies and procedures on the collection, use, and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.\n',
  'We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.\n',
  'Usage Data\n',
  'Usage Data is collected automatically when using the Service. It may include Your Device\'s IP address, browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, and other diagnostic data.\n',
  'Information Collected while Using the Application\n',
  'We may collect information from Your device\'s camera and photo library with Your permission to provide and improve Our Service.\n',
  'Use of Your Personal Data\n',
  'The Company may use Personal Data for purposes such as maintaining the Service, managing Your Account, performing contracts, contacting You, providing You with offers, managing Your requests, and for business transfers.\n',
  'Retention and Transfer of Your Personal Data\n',
  'Your Personal Data will be retained as necessary and may be transferred to locations outside of Your jurisdiction. We ensure data security and privacy in accordance with this Privacy Policy.\n',
  'Delete Your Personal Data\n',
  'You have the right to delete Your Personal Data. We may retain certain information as required by law.\n',
  'Children\'s Privacy\n',
  'Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13.\n',
  'Changes to this Privacy Policy\n',
  'Our Privacy Policy may be updated periodically. We will notify You of any changes by updating the "Last updated" date of this Privacy Policy.\n',
  'Contact Us\n',
  'For any questions about this Privacy Policy, contact us at [http://FuntashTechnologies.com.pk](http://FuntashTechnologies.com.pk).\n',

];



