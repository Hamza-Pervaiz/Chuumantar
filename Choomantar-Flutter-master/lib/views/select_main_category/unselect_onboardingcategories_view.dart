import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/select_main_category/select_onboardingcategories_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart' hide CarouselController;

class UnselectCategories extends StatefulWidget {
  const UnselectCategories({super.key});

  @override
  State<UnselectCategories> createState() => _UnselectCategoriesState();
}

class _UnselectCategoriesState extends State<UnselectCategories> {
  List<Category> categories = [];
  List<bool> selectedCategories = [];
  bool isLoading = true;
  bool areCatsPresent = true;
  bool isSelectAllChecked = false;
  String areyouSure = 'Are you sure you want to remove'.tr();
  String outof = 'out of '.tr();
  String categoriestext = 'categories'.tr();

  Future<void> fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.post(Uri.parse(AppUrls.myCategory), body: {
      "User_Id": prefs.getString('uid') ?? '',
    });

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      CommonFuncs.apiHitPrinter(
          "200",
          AppUrls.myCategory,
          "POST",
          "User_Id: ${prefs.getString('uid')}",
          responseBody,
          "unselect_onboardingcategories_view");

      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('data')) {
        List<dynamic> categoryList = responseBody['data'];
        setState(() {
          categories =
              categoryList.map((item) => Category.fromJson(item)).toList();
          selectedCategories =
              List.generate(categories.length, (index) => false);
          isLoading = false;
          areCatsPresent = true;
        });
      } else {
        setState(() {
          isLoading = false;
          areCatsPresent = false;
        });
        throw Exception('Invalid data format');
      }
    } else {
      setState(() {
        isLoading = false;
        areCatsPresent = false;
      });
      CommonFuncs.apiHitPrinter(
          response.statusCode.toString(),
          AppUrls.myCategory,
          "POST",
          "User_Id: ${prefs.getString('uid')}",
          "Failed to load categories, Status code: ${response.statusCode}'",
          "unselect_onboardingcategories_view");
      // throw Exception('Failed to load categories, Status code: ${response.statusCode}');
    }
  }

  Future<void> removeCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var selectedCategoryIds = categories
        .asMap()
        .entries
        .where((entry) => selectedCategories[entry.key])
        .map((entry) => entry.value.id)
        .join(',')
        .trim();
    if (kDebugMode) {
      print(selectedCategoryIds);
    }
    var response =
        await http.post(Uri.parse(AppUrls.removeCategoriesApi), body: {
      'userId': prefs.getString('uid') ?? '',
      'CatId': selectedCategoryIds,
    });

    var dataa = jsonDecode(response.body);

    if (response.statusCode == 200) {
      CommonFuncs.apiHitPrinter(
          "200",
          AppUrls.removeCategoriesApi,
          "POST",
          "userId: ${prefs.getString("uid") ?? ''}\nCatId: $selectedCategoryIds",
          dataa,
          "unselect_onboardingcategories_view");
    } else {
      CommonFuncs.apiHitPrinter(
          response.statusCode.toString(),
          AppUrls.removeCategoriesApi,
          "POST",
          "userId: ${prefs.getString("uid") ?? ''}\nCatId: $selectedCategoryIds",
          dataa,
          "unselect_onboardingcategories_view");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
    CommonFuncs.showToast(
        "unselect_onboardingcategories_view\nUnselectCategories");
  }

  @override
  Widget build(BuildContext context) {
    int selectedCount = selectedCategories.where((item) => item).length;
    return Scaffold(
      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : !isLoading && areCatsPresent
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      paddingComp(logoComp(
                          height: MySize.size50,
                          width: MySize.screenWidth * 0.6)),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 20,
                      ),
                      TextWidget(
                        text: "Remove Categories".tr(),
                        fontSize: MySize.size17,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppConst.primaryFont,
                        fontColor: AppColors.whiteColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "You have selected $selectedCount out of ${categories.length} categories",
                          style: TextStyle(
                            fontSize: MySize.size17,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MySize.scaleFactorHeight * 60,
                      ),
                      Column(children: [
                        CarouselSlider.builder(
                          options: CarouselOptions(
                            viewportFraction: 0.6,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            height: MySize.screenHeight * 0.4,
                            reverse: false,
                            autoPlay: false,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.2,
                            scrollDirection: Axis.horizontal,
                          ),
                          itemBuilder: (context, index, realIndex) {
                            final Category category = categories[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategories[index] =
                                      !selectedCategories[index];
                                  isSelectAllChecked = selectedCategories
                                      .every((isSelected) => isSelected);
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(MySize.size12),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        // Image
                                        (category.productImage != null &&
                                                category
                                                    .productImage.isNotEmpty)
                                            ? Image.network(
                                                "https://dreammerchants.tech/ajax/${category.productImage}",
                                                height:
                                                    MySize.screenHeight * 0.7,
                                                width: MySize.screenWidth,
                                                fit: BoxFit.cover,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return SvgPicture.asset(
                                                    "assets/svg/backCard.svg",
                                                    height:
                                                        MySize.screenHeight *
                                                            0.7,
                                                    width: MySize.screenWidth,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            Colors.red,
                                                            BlendMode.srcIn),
                                                    semanticsLabel:
                                                        'A red up arrow',
                                                  );
                                                },
                                              )
                                            : SvgPicture.asset(
                                                "assets/svg/backCard.svg",
                                                height:
                                                    MySize.screenHeight * 0.7,
                                                width: MySize.screenWidth,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Colors.red,
                                                        BlendMode.srcIn),
                                                semanticsLabel:
                                                    'A red up arrow',
                                              ),

                                        // Positioned Text Container at the bottom
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 12),
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            // You can adjust the opacity as needed
                                            child: Text(
                                              category.name,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MySize.size16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Icon(
                                      selectedCategories[index]
                                          ? Icons.close
                                          : Icons.check_circle,
                                      color: selectedCategories[index]
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: categories.length,
                        ),
                        SizedBox(
                          height: MySize.scaleFactorHeight * 120,
                        ),
                        ButtonWidget(
                          onTap: () {
                            var selectedCategoryIds = categories
                                .asMap()
                                .entries
                                .where((entry) => selectedCategories[entry.key])
                                .map((entry) => entry.value.id)
                                .join(',');
                            if (kDebugMode) {
                              print("Selected cats: $selectedCategoryIds");
                            }

                            showAdaptiveDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: MySize.scaleFactorWidth * 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Container(
                                    height: MySize.scaleFactorHeight * 250,
                                    width: MySize.screenWidth,
                                    padding: EdgeInsets.all(MySize.size20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      image: const DecorationImage(
                                        image: AssetImage(AppConst.eyeBg),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            AppConst.activeTick,
                                            height: MySize.size60,
                                            width: MySize.size60,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        TextWidget(
                                          text:
                                              '$areyouSure $selectedCount $outof ${categories.length} $categoriestext',
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          fontSize: MySize.size18,
                                          fontFamily: AppConst.primaryFont,
                                          fontColor: AppColors.purpleColor,
                                        ),
                                        ButtonWidget(
                                          onTap: () async {
                                            await removeCategories();
                                            Navigator.pop(context);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BottomBarView(),
                                                ));
                                          },
                                          text: "Okay to go".tr(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          text: "Submit".tr(),
                        )
                      ]),
                    ],
                  )
                : Center(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: noCategoryFound(),
                  )),
      ),
    );
  }

  Widget noCategoryFound() => Column(
        children: [
          SizedBox(
            height: MySize.scaleFactorHeight * 50,
          ),
          Text("Remove Categories".tr(),
              style: TextStyle(
                fontSize: MySize.size22,
                fontWeight: FontWeight.w500,
                fontFamily: AppConst.primaryFont,
                color: AppColors.secondaryColor,
              )),
          Flexible(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(MySize.size20),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(MySize.size16),
                  image: const DecorationImage(
                    image: AssetImage(AppConst.orgeyeBg),
                    fit: BoxFit.scaleDown,
                    scale: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'No category found!'.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      fontSize: MySize.size22,
                      fontFamily: AppConst.primaryFont,
                      fontColor: AppColors.redColor,
                    ),
                    SizedBox(height: MySize.size22),

                    Text(
                      'There is no category to remove. You have not selected any category yet. Please select your preferred categories.'
                          .tr(),
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppConst.primaryFont,
                        color: AppColors.purpleColor,
                        fontSize: MySize.size18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    //

                    SizedBox(height: MySize.size18),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SelectCategories()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.black,
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(MySize.size8),
                        ),
                      ),
                      child: const Text(
                        'Ok',
                        style: TextStyle(
                            fontFamily: AppConst.primaryFont,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MySize.scaleFactorHeight * 50,
          ),
        ],
      );
}

class Category {
  final String id;
  final String name;
  final String productImage;

  Category({
    required this.id,
    required this.name,
    required this.productImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      productImage: json['product_image'],
    );
  }
}
