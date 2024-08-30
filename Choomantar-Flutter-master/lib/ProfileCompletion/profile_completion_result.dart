import 'dart:developer';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ProfileCompletion extends StatefulWidget {
  const ProfileCompletion({super.key});

  @override
  State<ProfileCompletion> createState() => _ProfileCompletionState();
}

class _ProfileCompletionState extends State<ProfileCompletion> {
  SharedPreferences? preff;
  bool isLoading = false;
  String? completionMessage;

  Future getPreff() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future<List<String>> loadGeneralOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> selectedOptions = [];

    for (int i = 0; i < 14; i++) {
      final selectedOption = prefs.getString('general_question_$i') ?? '';
      selectedOptions.add(selectedOption);

      // Print statement to log the loaded data
      if (kDebugMode) {
        print(selectedOption);
      }
    }

    return selectedOptions;
  }

  Future<List<String>> loadHealthyOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> selectedOptions = [];

    for (int i = 0; i < 14; i++) {
      final selectedOption = prefs.getString('health_question_$i') ?? '';
      selectedOptions.add(selectedOption);

      // Print statement to log the loaded data
      if (kDebugMode) {
        print(selectedOption);
      }
    }

    return selectedOptions;
  }

  Future<List<String>> loadShoppingOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> selectedOptions = [];

    for (int i = 0; i < 8; i++) {
      final selectedOption = prefs.getString('shopping_question_$i') ?? '';
      selectedOptions.add(selectedOption);

      // Print statement to log the loaded data
      if (kDebugMode) {
        print(selectedOption);
      }
    }

    return selectedOptions;
  }

  Future<List<String>> loadEntertainmentOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> selectedOptions = [];

    for (int i = 0; i < 15; i++) {
      final selectedOption = prefs.getString('entertainment_question_$i') ?? '';
      selectedOptions.add(selectedOption);

      // Print statement to log the loaded data
      if (kDebugMode) {
        print(selectedOption);
      }
    }

    return selectedOptions;
  }

  Future<List<String>> loadTechnologyOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> selectedOptions = [];

    for (int i = 0; i < 12; i++) {
      final selectedOption = prefs.getString('technology_question_$i') ?? '';
      selectedOptions.add(selectedOption);

      // Print statement to log the loaded data
      if (kDebugMode) {
        print(selectedOption);
      }
    }

    return selectedOptions;
  }

  Future<List<String>> loadFinancialOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> selectedOptions = [];

    for (int i = 0; i < 15; i++) {
      final selectedOption = prefs.getString('financial_question_$i') ?? '';
      selectedOptions.add(selectedOption);

      // Print statement to log the loaded data
      if (kDebugMode) {
        print(selectedOption);
      }
    }

    return selectedOptions;
  }

  Future<Map<String, String>> loadAllOptions() async {
    Map<String, String> allOptionsMap = {};

    List<String> generalOptions = await loadGeneralOptions();
    List<String> healthyOptions = await loadHealthyOptions();
    List<String> shoppingOptions = await loadShoppingOptions();
    List<String> entertainmentOptions = await loadEntertainmentOptions();
    List<String> technologyOptions = await loadTechnologyOptions();
    List<String> financialOptions = await loadFinancialOptions();

    // Check if each list has the required number of options
    if (
    generalOptions.length >= 14 &&
        healthyOptions.length >= 14 &&
        shoppingOptions.length >= 8 &&
        entertainmentOptions.length >= 15 &&
        technologyOptions.length >= 12 &&
        financialOptions.length >= 15
    ) {
      // Store options in allOptionsMap
      for (int i = 0; i < generalOptions.length; i++) {
        allOptionsMap['generalOption${i + 1}'] = generalOptions[i];
      }

      for (int i = 0; i < healthyOptions.length; i++) {
        allOptionsMap['healthyOption${i + 1}'] = healthyOptions[i];
      }

      for (int i = 0; i < shoppingOptions.length; i++) {
        allOptionsMap['shoppingOption${i + 1}'] = shoppingOptions[i];
      }

      for (int i = 0; i < entertainmentOptions.length; i++) {
        allOptionsMap['entertainmentOption${i + 1}'] = entertainmentOptions[i];
      }

      for (int i = 0; i < technologyOptions.length; i++) {
        allOptionsMap['technologyOption${i + 1}'] = technologyOptions[i];
      }

      for (int i = 0; i < financialOptions.length; i++) {
        allOptionsMap['financialOption${i + 1}'] = financialOptions[i];
      }
      log('im options in log $allOptionsMap');
      registerWithAllOptions(allOptionsMap);
    } else {
      // Handle the case where the number of options is less than required
      if (kDebugMode) {
        print("Error: Not enough options in at least one category");
      }
    }

    return allOptionsMap;
  }

  Future<dynamic> registerWithAllOptions(
      Map<String, String> allOptionsMap) async {
    setState(() {});

    try {
      var uid = preff!.getString('uid');

      var response = await post(Uri.parse(AppUrls.userProfile), body: {
        "id": uid ?? '',
        // Using the null-aware operator to handle a potential null value
        "gender": allOptionsMap['generalOption1'],
        "education_level": allOptionsMap['generalOption2'],
        "marital_status": allOptionsMap['generalOption3'],
        "dependents": allOptionsMap['generalOption4'],
        "childrens": allOptionsMap['generalOption5'],
        "city": allOptionsMap['generalOption6'],
        "pet": allOptionsMap['generalOption7'],
        "transport": allOptionsMap['generalOption8'],
        "travel_abroad": allOptionsMap['generalOption9'],
        "color": allOptionsMap['generalOption10'],
        "dream_car": allOptionsMap['generalOption11'],
        "travel_fam": allOptionsMap['generalOption12'],
        "industry": allOptionsMap['generalOption13'],
        "travel_work": allOptionsMap['generalOption14'],
        "blood_group": allOptionsMap['healthyOption1'],
        "pain_killer": allOptionsMap['healthyOption2'],
        "height": allOptionsMap['healthyOption3'],
        "weight": allOptionsMap['healthyOption4'],
        "exercise": allOptionsMap['healthyOption5'],
        "exercise_mode": allOptionsMap['healthyOption6'],
        "smoke": allOptionsMap['healthyOption7'],
        "regularcheckup": allOptionsMap['healthyOption8'],
        "illness": allOptionsMap['healthyOption9'],
        "medication": allOptionsMap['healthyOption10'],
        "fruit": allOptionsMap['healthyOption11'],
        "covidvaccinated": allOptionsMap['healthyOption12'],
        "water": allOptionsMap['healthyOption13'],
        "coffee": allOptionsMap['healthyOption14'],
        "grocery": allOptionsMap['shoppingOption1'],
        "onlineshop": allOptionsMap['shoppingOption2'],
        "shopping_type": allOptionsMap['shoppingOption3'],
        "groceries_from": allOptionsMap['shoppingOption4'],
        "store": allOptionsMap['shoppingOption5'],
        "brand_con": allOptionsMap['shoppingOption6'],
        "monthly_grocery": allOptionsMap['shoppingOption7'],
        "brands_online": allOptionsMap['shoppingOption8'],
        "dramas": allOptionsMap['entertainmentOption1'],
        "music": allOptionsMap['entertainmentOption2'],
        "movies": allOptionsMap['entertainmentOption3'],
        "watchmovies": allOptionsMap['entertainmentOption4'],
        "cinema_movie": allOptionsMap['entertainmentOption5'],
        "music_source": allOptionsMap['entertainmentOption6'],
        "free_time": allOptionsMap['entertainmentOption7'],
        "current_affairs": allOptionsMap['entertainmentOption8'],
        "news_channel": allOptionsMap['entertainmentOption9'],
        "drama_channel": allOptionsMap['entertainmentOption10'],
        "watchingtv": allOptionsMap['entertainmentOption11'],
        "avg_time": allOptionsMap['entertainmentOption12'],
        "fav_sports": allOptionsMap['entertainmentOption13'],
        "fav_platform": allOptionsMap['entertainmentOption14'],
        "other_channels": allOptionsMap['entertainmentOption15'],
        "devices": allOptionsMap['technologyOption1'],
        "video_gmaes": allOptionsMap['technologyOption2'],
        "onmobile": allOptionsMap['technologyOption3'],
        "computer_lap": allOptionsMap['technologyOption4'],
        "online_earn": allOptionsMap['technologyOption5'],
        "qr_payment": allOptionsMap['technologyOption6'],
        "mobile_banking": allOptionsMap['technologyOption7'],
        "otherpayment_method": allOptionsMap['technologyOption8'],
        "raast_account": allOptionsMap['technologyOption9'],
        "machine": allOptionsMap['technologyOption10'],
        "mobile_brand": allOptionsMap['technologyOption11'],
        "tech": allOptionsMap['technologyOption12'],
        "primary_earner": allOptionsMap['financialOption1'],
        "montly_income": allOptionsMap['financialOption2'],
        "earning_mode": allOptionsMap['financialOption3'],
        "own_house": allOptionsMap['financialOption4'],
        "house_size": allOptionsMap['financialOption5'],
        "online_bankingg": allOptionsMap['financialOption6'],
        "personal_account": allOptionsMap['financialOption7'],
        "credit_card": allOptionsMap['financialOption8'],
        "debit_card": allOptionsMap['financialOption9'],
        "utility_bills": allOptionsMap['financialOption10'],
        "financial": allOptionsMap['financialOption11'],
        "secondsource": allOptionsMap['financialOption12'],
        "gateway": allOptionsMap['financialOption13'],
        "kid_education": allOptionsMap['financialOption14'],
        "rent": allOptionsMap['financialOption15'],
      });
      if (response != null) {
        return response;
      } else {
        // Throw an exception if the response is null
        throw Exception('Null response from server');
      }
    } catch (e) {
      throw Exception('Error in registerWithAllOptions: $e');
    }
  }

  Future<void> completeProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map<String, String> allOptionsMap = await loadAllOptions();
      Response response = await registerWithAllOptions(allOptionsMap);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          // Successful completion
          setState(() {
            completionMessage = "Profile completed successfully!".tr();
          });
        } else if (responseData['status'] == 'error') {
          // Handle specific error messages
          if (responseData['message'] == 'Profile update failed') {
            setState(() {
              completionMessage = "Error: Profile update failed.".tr();
            });
          } else if (responseData['message'] == 'Invalid input data.') {
            setState(() {
              completionMessage = "Error: Invalid input data.".tr();
            });
          } else {
            // Handle other error cases
            setState(() {
              completionMessage = "Error completing profile. Please try again.".tr();
            });
          }
        }
      } else {
        // Handle unexpected response status code
        setState(() {
          completionMessage =
          "Unexpected response status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      // Handle other exceptions
      setState(() {
        completionMessage = "Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getPreff();
    loadAllOptions();
    completeProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConst.bgPrimary),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(MySize.size16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MySize.scaleFactorHeight * 56,
                      child: Row(
                        children: [
                          Builder(
                            builder: (context) => GestureDetector(
                              onTap: () => Scaffold.of(context).openDrawer(),
                              child: const Icon(
                                CupertinoIcons.line_horizontal_3_decrease,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Image.asset(
                              AppConst.logo,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GeneralProfileView(),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: MySize.size20,
                              backgroundImage: const AssetImage(AppConst.hi4),
                            ),
                          )
                        ],
                      ),
                    ),
                    isLoading
                        ? const SizedBox.shrink()
                        : completionMessage != null
                        ? _buildCompletionMessageWidget()
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            if (isLoading) _buildLoadingWidget(),
          ],
        ),
      ),
    );
  }


  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
    );
  }

  Widget _buildCompletionMessageWidget() {
    return Container(
      padding: const EdgeInsets.all(30.0),
      margin: const EdgeInsets.symmetric(
        vertical: 260.0,
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
          Image.asset(
            "assets/images/correct_tick.png",
            width: 200,
            height: 100,
            // Other properties as needed
          ),
          TextWidget(
            text: completionMessage!,
            fontColor: AppColors.primaryColor,
            fontSize: MySize.size22,
            fontWeight: FontWeight.w600,
            fontFamily: AppConst.primaryFont,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              setState(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BottomBarView()),
                );
              });

            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5.0,
              backgroundColor: Colors.deepOrange,
            ),
            child: Text(
              'Continue'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

