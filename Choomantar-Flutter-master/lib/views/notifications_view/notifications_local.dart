import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../models/inappnotifications_model.dart';
import 'api_class_notifcation.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final ApiService _apiService = ApiService();
  ProgressDialog? progressDialog;
  late Future<List<NotificationModel>> notifics;
  bool notificationsEnabled = false;
  String buttonText = "";
  int notiLength = 0;
  String imagePath = '';
  bool showOnce = true;

  final GlobalKey oneone = GlobalKey();

  Future<void> removeNotifications() async {
    progressDialog!.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('uid') ?? '';
    var response = await http.post(
      Uri.parse(AppUrls.removeInAppNotifications),
      body: {"userId": userId},
    );
    progressDialog!.hide();
    var dataa = jsonDecode(response.body);

    if (response.statusCode == 200) {
      CommonFuncs.apiHitPrinter("200", AppUrls.removeInAppNotifications, "POST",
          "userId: $userId", dataa, "notifications_local");
      if (kDebugMode) {
        print(jsonDecode(response.body));
      }
    } else {
      CommonFuncs.apiHitPrinter(
          response.statusCode.toString(),
          AppUrls.removeInAppNotifications,
          "POST",
          "userId: $userId",
          dataa,
          "notifications_local");
      if (kDebugMode) {
        print(jsonDecode(response.body));
      }
    }

    notifics = _apiService.fetchNotifications();
    setState(() {
      notiLength = 0;
    });
  }

  Future<void> toggleNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool currentlyEnabled = prefs.getBool('notificationsEnabled') ?? true;
    if (kDebugMode) {
      print(currentlyEnabled);
    }
    await prefs.setBool('notificationsEnabled', !currentlyEnabled);
    setState(() {});
  }

  // Future<void> updateNotifications() async {
  //   try {
  //     // Fetch notifications
  //     List<NotificationModel> notifications =
  //         await _apiService.fetchNotifications();

  //     // Reverse the list
  //     List<NotificationModel> reversedNotifications =
  //         notifications.reversed.toList();

  //     // Update the notifics variable
  //     notifics = Future.value(reversedNotifications);

  //     // Optionally, you can print the reversed list for debugging
  //     if (kDebugMode) {
  //       print('Reversed Notifications: $reversedNotifications');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error updating notifications: $e');
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getNotifEnabled();
    _loadUserImage();
    notifics = _apiService.fetchNotifications();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // add your code here.
    });
  }

  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath =
          prefs.getString('user_image').toString(); // Load the image path
    });
  }

  Future<void> getNotifEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled =
          prefs.getBool('notificationsEnabled') ?? false; // Load the image path
      if (kDebugMode) {
        print("isnotienabled: $notificationsEnabled");
      }
      buttonText = notificationsEnabled
          ? 'Stop seeing notifications'
          : 'Enable notifications';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MySize.screenHeight,
        width: MySize.screenWidth,
        padding: EdgeInsets.all(MySize.size16),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConst.bgPrimary), fit: BoxFit.fill)),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
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
              text: "Notifications".tr(),
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
                    ShowCaseWidget.of(context).startShowCase([oneone]);

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
                    future: notifics,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No notifications available',
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 20)));
                      } else {
                        List<NotificationModel> notis = snapshot.data!;

                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            notiLength = notis.length;
                            // Remove the item from the data source
                          });
                          // Optionally, you can show a snackbar or perform any other action here
                        });

                        return ListView.separated(
                          itemCount: notis.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                            height: MySize.scaleFactorHeight * 8,
                          ),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              NotificationModel notification = notis[index];
                              return Showcase(
                                key: oneone,
                                targetPadding:
                                    const EdgeInsets.only(top: 40, bottom: -40),
                                description: 'Swipe left to delete',
                                child: Dismissible(
                                  key: Key(notification.id),
                                  resizeDuration:
                                      const Duration(milliseconds: 5),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    setState(() {
                                      notis.removeAt(index);
                                    });
                                  },
                                  background: Container(
                                    height: MySize.size68,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: MySize.size15),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.circular(MySize.size10),
                                    ),
                                  ),
                                  child: Container(
                                      height: MySize.size68,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MySize.size15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            MySize.size10),
                                        image: const DecorationImage(
                                          image: AssetImage(AppConst.eyeBg),
                                          fit: BoxFit.scaleDown,
                                          scale: 0.7,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.notifications_active,
                                            color: AppColors.blueColor,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(
                                              notification.message,
                                              textScaleFactor: 1.0,
                                              maxLines: 3,
                                              style: TextStyle(
                                                color: AppColors.urduBtn,
                                                fontFamily:
                                                    AppConst.primaryFont,
                                                fontSize: MySize.size16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            } else {
                              NotificationModel notification = notis[index];
                              return Dismissible(
                                key: Key(notification.id),
                                resizeDuration: const Duration(milliseconds: 5),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  setState(() {
                                    notis.removeAt(index);
                                  });
                                },
                                background: Container(
                                  height: MySize.size68,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MySize.size15),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.circular(MySize.size10),
                                  ),
                                ),
                                child: Container(
                                    height: MySize.size68,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: MySize.size15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(MySize.size10),
                                      image: const DecorationImage(
                                        image: AssetImage(AppConst.eyeBg),
                                        fit: BoxFit.scaleDown,
                                        scale: 0.7,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.notifications_active,
                                          color: AppColors.blueColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            notification.message,
                                            textScaleFactor: 1.0,
                                            maxLines: 3,
                                            style: TextStyle(
                                              color: AppColors.urduBtn,
                                              fontFamily: AppConst.primaryFont,
                                              fontSize: MySize.size16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                );
              }),
            ),
            if (notiLength > 0)
              ElevatedButton(
                onPressed: () {
                  progressDialog = ProgressDialog(context,
                      type: ProgressDialogType.normal, isDismissible: false);
                  progressDialog?.style(
                    textAlign: TextAlign.center,
                    message: 'Deleting Notifications...',
                    elevation: 10,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    messageTextStyle: const TextStyle(
                      color: AppColors.purpleColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                  removeNotifications();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Remove Notifications',
                    style: TextStyle(color: AppColors.blackColor)),
              ),
          ],
        ),
      ),
    );
  }
}
