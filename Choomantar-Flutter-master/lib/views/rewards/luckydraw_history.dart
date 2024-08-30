import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:showcaseview/showcaseview.dart';

class LuckydrawHistory extends StatefulWidget {
  const LuckydrawHistory({super.key});

  @override
  State<LuckydrawHistory> createState() => _LuckydrawHistoryState();
}

class _LuckydrawHistoryState extends State<LuckydrawHistory> {
  @override
  late Future<List<Map<String, dynamic>>> historyData;

  String imagePath = '';
  String baseurl = 'https://dreammerchants.tech/ajax/';
  int activeStep = 2;
  bool showOnce = true;
  final GlobalKey one = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadUserImage();
    historyData = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(AppUrls.luckydrawHistory), body: {
        "id": prefs!.get('uid').toString(),
      });

      var dataa = jsonDecode(response.body);
      var filterdata = dataa[2];

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter(
            "200",
            AppUrls.luckydrawHistory,
            "POST",
            "id: ${prefs!.get('uid').toString()}",
            filterdata,
            "rewards_history");

        return [filterdata as Map<String, dynamic>];
      } else {
        CommonFuncs.apiHitPrinter(
            response.statusCode.toString(),
            AppUrls.luckydrawHistory,
            "POST",
            "id: ${prefs!.get('uid').toString()}",
            dataa,
            "rewards_history");

        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }

  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath =
          prefs.getString('user_image').toString(); // Load the image path
    });
  }

  SharedPreferences? preff;

  Future getPreff() async {
    preff = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        padding: EdgeInsets.only(
          left: MySize.size20,
          right: MySize.size20,
          top: MySize.size20,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConst.bgPrimary),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MySize.scaleFactorHeight * 56,
              child: Row(
                children: [
                  backBtn(context),
                  // Builder(
                  //   builder: (context) => GestureDetector(
                  //     onTap: () => Scaffold.of(context).openDrawer(),
                  //     child: const Icon(
                  //       CupertinoIcons.line_horizontal_3_decrease,
                  //       color: AppColors.whiteColor,
                  //     ),
                  //   ),
                  // ),
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
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imagePath,
                        width: MySize.size20 * 2,
                        height: MySize.size20 * 2,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Image.asset('assets/images/hi4.png'),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/hi4.png'),
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              height: MySize.scaleFactorHeight * 20,
            ),

            TextWidget(
              text: "Lucky Draw History".tr(),
              maxLines: 2,
              textAlign: TextAlign.center,
              fontSize: MySize.size20,
              fontWeight: FontWeight.w400,
              fontFamily: AppConst.primaryFont,
              fontColor: AppColors.primaryColor,
            ),

            SizedBox(
              height: MySize.scaleFactorHeight * 25,
            ),

            ShowCaseWidget(
              builder: Builder(builder: (context) {
                if (showOnce) {
                  Future.delayed(const Duration(seconds: 2), () {
                    ShowCaseWidget.of(context).startShowCase([one]);

                    setState(() {
                      showOnce = false;
                    });
                  }).then((value) {
                    Future.delayed(const Duration(seconds: 4), () {
                      ShowCaseWidget.of(context).dismiss();
                    });
                  });
                }

                return Expanded(
                  child: FutureBuilder(
                    future: historyData,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.urduBtn)));
                      } else {
                        List<Map<String, dynamic>> historyDataa = snapshot.data;

                        if (historyDataa == null || historyDataa.isEmpty) {
                          return Center(
                              child: TextWidget(
                            text: "No reward history found!",
                            fontWeight: FontWeight.w700,
                          ));
                        } else {
                          return ListView.separated(
                            itemCount: historyDataa.length,
                            separatorBuilder:
                                (BuildContext context, int index) => SizedBox(
                              height: MySize.scaleFactorHeight * 15,
                            ),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                final survey = historyDataa[index];
                                return Showcase(
                                  key: one,
                                  targetPadding: const EdgeInsets.only(
                                      top: 40, bottom: -40),
                                  description: 'Swipe left to delete',
                                  child: Dismissible(
                                    resizeDuration:
                                        const Duration(milliseconds: 5),
                                    key: Key(survey['inventoryid'].toString()),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      // Remove the item from the data source.
                                      setState(() {
                                        historyDataa.removeAt(index);
                                      });

                                      // // Then show a snackbar.
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(SnackBar(content: Text('$item dismissed')));
                                    },
                                    background: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MySize.size17,
                                          vertical: MySize.size17),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(
                                            MySize.size16),
                                      ),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MySize.size17,
                                          vertical: MySize.size17),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            MySize.size16),
                                        image: const DecorationImage(
                                          image: AssetImage(AppConst.eyeBg),
                                          fit: BoxFit.scaleDown,
                                          scale: 0.7,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black),
                                                  right: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black),
                                                  left: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black),
                                                  bottom: BorderSide(
                                                      width: 0,
                                                      color: Colors.black)),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5.0),
                                                topRight: Radius.circular(5.0),
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(
                                                left: 5.0,
                                                top: 4.0,
                                                bottom: 4.0),
                                            child: Row(
                                              children: [
                                                TextWidget(
                                                  text: 'Account Title:',
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily:
                                                      AppConst.primaryFont,
                                                  fontColor:
                                                      AppColors.purpleColor,
                                                ),
                                                SizedBox(
                                                  width: MySize.size5,
                                                ),
                                                Expanded(
                                                  child: TextWidget(
                                                    text:
                                                        survey['inventoryname'],
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start,
                                                    fontSize: MySize.size16,
                                                    fontFamily:
                                                        AppConst.primaryFont,
                                                    fontColor:
                                                        AppColors.urduBtn,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                left: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(
                                                left: 5.0,
                                                top: 4.0,
                                                bottom: 4.0),
                                            child: Row(
                                              children: [
                                                TextWidget(
                                                  text: 'Inventory Image:',
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily:
                                                      AppConst.primaryFont,
                                                  fontColor:
                                                      AppColors.purpleColor,
                                                ),
                                                SizedBox(
                                                  width: MySize.size16,
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width:
                                                            80, // Set the desired width
                                                        height:
                                                            60, // Set the desired height
                                                        child: Image.network(
                                                          baseurl +
                                                              survey[
                                                                  'inventoryimage'], // URL of the image
                                                          fit: BoxFit
                                                              .cover, // Ensure the image covers the container while maintaining aspect ratio
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high, // High-quality image rendering
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 8.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                left: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(
                                                left: 5.0,
                                                top: 4.0,
                                                bottom: 4.0),
                                            child: Row(
                                              children: [
                                                TextWidget(
                                                  text: 'Person Name:',
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily:
                                                      AppConst.primaryFont,
                                                  fontColor:
                                                      AppColors.purpleColor,
                                                ),
                                                SizedBox(
                                                  width: MySize.size5,
                                                ),
                                                Expanded(
                                                  child: TextWidget(
                                                    textAlign: TextAlign.start,
                                                    text: survey['name'],
                                                    fontSize: MySize.size16,
                                                    fontFamily:
                                                        AppConst.primaryFont,
                                                    fontColor:
                                                        AppColors.urduBtn,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                left: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(
                                                left: 5.0,
                                                top: 4.0,
                                                bottom: 4.0),
                                            child: Row(
                                              children: [
                                                TextWidget(
                                                  text: 'Points Redeemed:',
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily:
                                                      AppConst.primaryFont,
                                                  fontColor:
                                                      AppColors.purpleColor,
                                                ),
                                                SizedBox(
                                                  width: MySize.size5,
                                                ),
                                                TextWidget(
                                                  text: survey['points']
                                                          .toString() +
                                                      " pts",
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily:
                                                      AppConst.primaryFont,
                                                  fontColor: AppColors.urduBtn,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                left: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(
                                                left: 5.0,
                                                top: 4.0,
                                                bottom: 4.0),
                                            child: Row(
                                              children: [
                                                TextWidget(
                                                  text: 'Inventory Name:',
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily:
                                                      AppConst.primaryFont,
                                                  fontColor:
                                                      AppColors.purpleColor,
                                                ),
                                                SizedBox(
                                                  width: MySize.size5,
                                                ),
                                                TextWidget(
                                                  text: survey['inventoryname'],
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily:
                                                      AppConst.primaryFont,
                                                  fontColor: AppColors.urduBtn,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black),
                                                  right: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black),
                                                  left: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black),
                                                  bottom: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black),
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(5.0),
                                                  bottomRight:
                                                      Radius.circular(5.0),
                                                )),
                                            padding: const EdgeInsets.only(
                                                left: 5.0,
                                                top: 4.0,
                                                bottom: 4.0),
                                            child: Row(
                                              children: [
                                                TextWidget(
                                                  text: 'Date:',
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily:
                                                      AppConst.primaryFont,
                                                  fontColor:
                                                      AppColors.purpleColor,
                                                ),
                                                SizedBox(
                                                  width: MySize.size5,
                                                ),
                                                TextWidget(
                                                  text: survey['posted_at'],
                                                  maxLines: 2,
                                                  fontSize: MySize.size16,
                                                  fontFamily:
                                                      AppConst.primaryFont,
                                                  fontColor: AppColors.urduBtn,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Transform.translate(
                                            offset: const Offset(0, 14),
                                            child: EasyStepper(
                                                padding: EdgeInsets.zero,
                                                enableStepTapping: false,
                                                finishedStepTextColor:
                                                    Colors.black,
                                                stepRadius: 20,
                                                lineStyle: const LineStyle(
                                                  lineLength: 50,
                                                ),
                                                finishedStepBackgroundColor:
                                                    AppColors.primaryColor,
                                                activeStep: survey['status'] ==
                                                        'Not Paid'
                                                    ? 2
                                                    : 3,
                                                steps: const [
                                                  EasyStep(
                                                    icon: Icon(Icons.done),
                                                    title: "Applied",
                                                  ),
                                                  EasyStep(
                                                    icon: Icon(Icons.pending),
                                                    title: "Pending",
                                                  ),
                                                  // EasyStep(
                                                  //   icon: Icon(
                                                  //       Icons.monetization_on),
                                                  //   title: "Approved",
                                                  // ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                final survey = historyDataa[index];
                                return Dismissible(
                                  resizeDuration:
                                      const Duration(milliseconds: 5),
                                  key: Key(survey['inventoryid']),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    // Remove the item from the data source.
                                    setState(() {
                                      historyDataa.removeAt(index);
                                    });

                                    // // Then show a snackbar.
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(SnackBar(content: Text('$item dismissed')));
                                  },
                                  background: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: MySize.size17,
                                        vertical: MySize.size17),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.circular(MySize.size16),
                                    ),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: MySize.size17,
                                        vertical: MySize.size17),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(MySize.size16),
                                      image: const DecorationImage(
                                        image: AssetImage(AppConst.eyeBg),
                                        fit: BoxFit.scaleDown,
                                        scale: 0.7,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                left: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    width: 0,
                                                    color: Colors.black)),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5.0),
                                              topRight: Radius.circular(5.0),
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 5.0, top: 4.0, bottom: 4.0),
                                          child: Row(
                                            children: [
                                              TextWidget(
                                                text: 'Account Title:',
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily:
                                                    AppConst.primaryFont,
                                                fontColor:
                                                    AppColors.purpleColor,
                                              ),
                                              SizedBox(
                                                width: MySize.size5,
                                              ),
                                              Expanded(
                                                child: TextWidget(
                                                  text: 'Lucky Draw History',
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                  fontSize: MySize.size16,
                                                  fontFamily:
                                                      AppConst.primaryFont,
                                                  fontColor: AppColors.urduBtn,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                              right: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                              left: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 5.0, top: 4.0, bottom: 4.0),
                                          child: Row(
                                            children: [
                                              TextWidget(
                                                text: 'Inventory Image:',
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily:
                                                    AppConst.primaryFont,
                                                fontColor:
                                                    AppColors.purpleColor,
                                              ),
                                              SizedBox(
                                                width: MySize.size5,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:
                                                          50, // Set the desired width
                                                      height:
                                                          50, // Set the desired height
                                                      child: Image.network(
                                                        survey[baseurl +
                                                            'inventoryimage'], // URL of the image
                                                        fit: BoxFit
                                                            .cover, // Ensure the image covers the container while maintaining aspect ratio
                                                        filterQuality: FilterQuality
                                                            .high, // High-quality image rendering
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                              right: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                              left: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 5.0, top: 4.0, bottom: 4.0),
                                          child: Row(
                                            children: [
                                              TextWidget(
                                                text: 'Person Name:',
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily:
                                                    AppConst.primaryFont,
                                                fontColor:
                                                    AppColors.purpleColor,
                                              ),
                                              SizedBox(
                                                width: MySize.size5,
                                              ),
                                              Expanded(
                                                child: TextWidget(
                                                  textAlign: TextAlign.start,
                                                  text: survey['name'],
                                                  fontSize: MySize.size16,
                                                  fontFamily:
                                                      AppConst.primaryFont,
                                                  fontColor: AppColors.urduBtn,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                              right: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                              left: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 5.0, top: 4.0, bottom: 4.0),
                                          child: Row(
                                            children: [
                                              TextWidget(
                                                text: 'Points Redeemed:',
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily:
                                                    AppConst.primaryFont,
                                                fontColor:
                                                    AppColors.purpleColor,
                                              ),
                                              SizedBox(
                                                width: MySize.size5,
                                              ),
                                              TextWidget(
                                                text: survey['points']
                                                        .toString() +
                                                    " pts",
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily:
                                                    AppConst.primaryFont,
                                                fontColor: AppColors.urduBtn,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                              right: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                              left: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 5.0, top: 4.0, bottom: 4.0),
                                          child: Row(
                                            children: [
                                              TextWidget(
                                                text: 'Inventory Name:',
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily:
                                                    AppConst.primaryFont,
                                                fontColor:
                                                    AppColors.purpleColor,
                                              ),
                                              SizedBox(
                                                width: MySize.size5,
                                              ),
                                              TextWidget(
                                                text: survey['inventoryname'],
                                                maxLines: 2,
                                                fontSize: MySize.size16,
                                                fontFamily:
                                                    AppConst.primaryFont,
                                                fontColor: AppColors.urduBtn,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                left: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black),
                                              ),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(5.0),
                                                bottomRight:
                                                    Radius.circular(5.0),
                                              )),
                                        ),
                                        Transform.translate(
                                          offset: const Offset(0, 14),
                                          child: EasyStepper(
                                              padding: EdgeInsets.zero,
                                              enableStepTapping: false,
                                              finishedStepTextColor:
                                                  Colors.black,
                                              stepRadius: 20,
                                              lineStyle: const LineStyle(
                                                lineLength: 50,
                                              ),
                                              finishedStepBackgroundColor:
                                                  AppColors.primaryColor,
                                              activeStep:
                                                  survey['status'] == 'Not Paid'
                                                      ? 2
                                                      : 3,
                                              steps: const [
                                                EasyStep(
                                                  icon: Icon(Icons.done),
                                                  title: "Applied",
                                                ),
                                                EasyStep(
                                                  icon: Icon(Icons.pending),
                                                  title: "Pending",
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }
                      }
                    },
                  ),
                );
              }),
            ),

            const SizedBox(
              height: 10.0,
            ),
            // Expanded(child:
            // Center(child: TextWidget(text: "Completed Surveys View", fontSize: 16, fontWeight: FontWeight.w800,)))
          ],
        ),
      ),
    );
  }
}
