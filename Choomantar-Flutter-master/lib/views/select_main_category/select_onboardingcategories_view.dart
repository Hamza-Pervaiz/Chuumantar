import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart' hide CarouselController;
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/models/api_model.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectCategories extends StatefulWidget {
  const SelectCategories({super.key});

  @override
  State<SelectCategories> createState() => _SelectCategoriesState();
}

class _SelectCategoriesState extends State<SelectCategories> {
  bool check = false;
  var showCategoryAPI;
  String selected = "You have selected".tr();
  String outof = "out of".tr();
  String categories = "categories".tr();
  bool isSelectAll = false;
  // ignore: prefer_typing_uninitialized_variables
  late List<Category> apiData;
  int tapedCount = 0;

  Future<ShowCatModel?> showCategoryApi() async {
    var response = await post(Uri.parse(AppUrls.getCategories), body: {
      "User_Id": "${preff!.get('uid')}",
    });
    try {
      var data = jsonDecode(response.body);
      CommonFuncs.apiHitPrinter(
          "200",
          AppUrls.getCategories,
          "POST",
          "User_Id: ${preff!.get('uid')}",
          data,
          "select_onboardingcategories_view");

      var categoryModel = ShowCatModel.fromJson(data);
      totalCategory = categoryModel.products.length;
      setState(() {});
      return categoryModel;
    } catch (e) {
      log("Error is $e");
    }
    return null;
  }

  Future<void> setCategoriesSelected(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('categoriesSelected', value);
  }

  Future<dynamic> selectCategoryAPI() async {
    _status.setStatus(Status.LOADING);
    setState(() {});
    var response = await post(Uri.parse(AppUrls.selectCat), body: {
      "User_Id": preff!.get('uid').toString(),
      "Category_Id": selectedJoin.toString()
    });
    try {
      var data = jsonDecode(response.body);
      CommonFuncs.apiHitPrinter(
          response.statusCode.toString(),
          AppUrls.selectCat,
          "POST",
          "User_Id: ${preff!.get('uid')}\nCategory_Id: ${selectedJoin.toString()}",
          data,
          "select_onboardingcategories_view");

      showBar(context, message: data.toString());
      setState(() {});
    } catch (e) {
      _status.setStatus(Status.FAILD);
      setState(() {});
      log("Error is $e");
    }
  }

  final StatusProvider _status = StatusProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreff().then((value) {
      showCategoryAPI = showCategoryApi();
    });
    CommonFuncs.showToast("select_onboardingcategories_view\nSelectCategories");
  }

  SharedPreferences? preff;
  Future getPreff() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }

  int totalCategory = 0;

  List selectedCategory = [];
  String selectedJoin = '';

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return LoadingOverlay(
      isLoading: _status.getStatus == Status.LOADING,
      child: Scaffold(
        body: Container(
          height: MySize.screenHeight,
          width: MySize.screenWidth,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              paddingComp(logoComp(
                  height: MySize.size50, width: MySize.screenWidth * 0.6)),
              SizedBox(
                height: MySize.scaleFactorHeight * 20,
              ),
              TextWidget(
                text: "Select Categories".tr(),
                fontSize: MySize.size20,
                fontWeight: FontWeight.w500,
                fontFamily: AppConst.primaryFont,
                fontColor: AppColors.secondaryColor,
              ),
              SizedBox(
                height: MySize.scaleFactorHeight * 10,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: "You have selected ".tr(), style: _style()),
                TextSpan(
                    text: "$tapedCount",
                    style: _style(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold)),
                TextSpan(text: " out of ".tr(), style: _style()),
                TextSpan(
                    text: "$totalCategory",
                    style: _style(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold)),
              ])),
              SizedBox(
                height: MySize.scaleFactorHeight * 20,
              ),
              CheckboxListTile(
                  checkColor: AppColors.primaryColor,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: TextWidget(
                      text: "Select All".tr(),
                      fontColor: AppColors.whiteColor,
                      fontSize: MySize.size18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  fillColor:
                      const MaterialStatePropertyAll(AppColors.whiteColor),
                  value: check,
                  onChanged: (value) {
                    print("check changed to: $value");

                    check = value!;
                    selectedCategory = [];
                    selectedJoin = '';
                    isSelectAll = !isSelectAll;
                    isSelectAll ? tapedCount = totalCategory : tapedCount = 0;

                    apiData.forEach((element) {
                      element.isSelect = isSelectAll;
                      if (isSelectAll) {
                        selectedCategory.add(element.id);
                        selectedJoin = selectedCategory.join(',');
                      } else {
                        selectedCategory.remove(element.id);
                      }
                      //   print("added cat: ${element.id}");
                      setState(() {});
                    });

                    setState(() {});
                  }),
              paddingComp(
                const Divider(
                  color: AppColors.secondaryColor,
                  height: 0,
                ),
              ),
              const Spacer(),
              FutureBuilder<ShowCatModel?>(
                  future: showCategoryAPI,
                  builder: (context, AsyncSnapshot<ShowCatModel?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show loading indicator while waiting for data
                      return const CircularProgressIndicator(
                        color: AppColors.whiteColor,
                      );
                    } else if (snapshot.hasError || snapshot.data == null) {
                      // Show error message when there's an error or data is null
                      return Center(
                        child: TextWidget(
                          text: "Categories not available".tr(),
                          fontSize: MySize.size20,
                          fontFamily: AppConst.primaryFont,
                          fontColor: AppColors.secondaryColor,
                        ),
                      );
                    } else {
                      var categoryModel = snapshot.data;
                      if (categoryModel != null) {
                        List<Category> categories = categoryModel.products;

                        return CarouselSlider.builder(
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
                            totalCategory = categories.length;
                            apiData = categories;
                            final category = apiData[index];
                            final item = apiData[index];
                            int selectedCount =
                                apiData.where((item) => item.isSelect).length;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // if(check)
                                    //   {
                                    //     check = !check;
                                    //     isSelectAll = !isSelectAll;
                                    //   }

                                    item.isSelect = !item.isSelect;
                                    item.isSelect
                                        ? tapedCount = selectedCount + 1
                                        : tapedCount = selectedCount - 1;

                                    item.isSelect
                                        ? selectedCategory.add(category.id)
                                        : selectedCategory.remove(category.id);

                                    selectedJoin = item.isSelect
                                        ? selectedCategory.join(',')
                                        : '0';

                                    // if(tapedCount == totalCategory)
                                    // {
                                    //   check = true;
                                    //   isSelectAll = true;
                                    // }

                                    setState(() {});
                                  },
                                  child: Opacity(
                                    opacity: item.isSelect ? 0.9 : 1,
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            MySize.size12),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: SvgPicture.asset(
                                          "assets/svg/backCard.svg",
                                          height: MySize.screenHeight * 0.7,
                                          width: MySize.screenWidth,
                                          colorFilter: const ColorFilter.mode(
                                              Colors.red, BlendMode.srcIn),
                                          semanticsLabel: 'A red up arrow'),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // if(check)
                                    // {
                                    //   check = !check;
                                    //   isSelectAll = !isSelectAll;
                                    // }

                                    item.isSelect = !item.isSelect;
                                    item.isSelect
                                        ? tapedCount = selectedCount + 1
                                        : tapedCount = selectedCount - 1;

                                    item.isSelect
                                        ? selectedCategory.add(category.id)
                                        : selectedCategory.remove(category.id);

                                    selectedJoin = item.isSelect
                                        ? selectedCategory.join(',')
                                        : '0';

                                    // if(tapedCount == totalCategory)
                                    //   {
                                    //     check = true;
                                    //     isSelectAll = true;
                                    //   }

                                    setState(() {});
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          AppUrls.imageUrl +
                                              category.productImage,
                                          width: MySize.screenWidth,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return const Icon(Icons.error);
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: MySize.scaleFactorHeight * 10,
                                      ),
                                      SizedBox(
                                        width: MySize.scaleFactorWidth * 150,
                                        child: TextWidget(
                                          text: category.name,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          fontSize: MySize.size20,
                                          fontWeight: FontWeight.w700,
                                          fontColor: item.isSelect
                                              ? AppColors.secondaryColor
                                              : AppColors.blueColor,
                                          fontFamily: AppConst.primaryFont,
                                        ),
                                      ),
                                      SizedBox(
                                        height: MySize.scaleFactorHeight * 8,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                          itemCount: categories.length,
                        );
                      }
                    }
                    return const SizedBox();
                  }),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: MySize.size20),
                  child: ButtonWidget(
                      onTap: () {
                        if (tapedCount != 0) {
                          print(selectedJoin);

                          showAdaptiveDialog(
                              context: context,
                              builder: (index) => Dialog(
                                    insetPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            MySize.scaleFactorWidth * 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Container(
                                        height: MySize.scaleFactorHeight * 250,
                                        width: MySize.screenWidth,
                                        padding: EdgeInsets.all(MySize.size20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
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
                                            // SizedBox(
                                            //   height: MySize.scaleFactorHeight * 10,
                                            // ),
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
                                                  "$selected $tapedCount $outof $totalCategory $categories",
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              fontSize: MySize.size20,
                                              fontFamily: AppConst.primaryFont,
                                              fontColor: AppColors.purpleColor,
                                            ),

                                            Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    height: MySize
                                                            .scaleFactorHeight *
                                                        40,
                                                    child: ButtonWidget(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        text: "Add more".tr()),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      MySize.scaleFactorWidth *
                                                          12,
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: MySize
                                                            .scaleFactorHeight *
                                                        40,
                                                    child: ButtonWidget(
                                                        onTap: () {
                                                          setCategoriesSelected(
                                                              true);
                                                          Navigator.pop(
                                                              context);
                                                          selectCategoryAPI()
                                                              .then((value) {
                                                            Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const BottomBarView(),
                                                                    ));
                                                          });
                                                        },
                                                        text:
                                                            "Okay to go".tr()),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                  ));
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomBarView(),
                              ));
                        }
                      },
                      text: "Let's Go".tr()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _style(
          {double fontSize = 14,
          FontWeight fontWeight = FontWeight.w500,
          Color color = AppColors.whiteColor}) =>
      TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
}
