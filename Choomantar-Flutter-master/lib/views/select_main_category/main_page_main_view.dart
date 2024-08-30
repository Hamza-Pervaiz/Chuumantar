import 'package:cached_network_image/cached_network_image.dart';
import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:chumanter/views/select_main_category/unselect_onboardingcategories_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'select_onboardingcategories_view.dart';


class SelectUnselectCatgeoriesView extends StatefulWidget {
  const SelectUnselectCatgeoriesView({super.key});

  @override
  State<SelectUnselectCatgeoriesView> createState() => _SelectUnselectCatgeoriesViewState();
}

class _SelectUnselectCatgeoriesViewState extends State<SelectUnselectCatgeoriesView> {
  String imagePath = "";

  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('user_image').toString(); // Load the image path
    });
  }
  List<TextfieldModel> categories = [
    TextfieldModel(
      name: "Add more categories".tr(),
      image: "assets/images/icons8-select-96.png",
    ),
    TextfieldModel(
      name: "Edit categories".tr(),
      image: "assets/images/closeIcon.png",
    ),
  ];

  @override
  void initState() {
    _loadUserImage();
    CommonFuncs.showToast("main_page_main_view\nSelectUnselectCatgeoriesView");
    super.initState();

  }

  PageController pageController =PageController();
  @override
  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MySize.scaleFactorHeight * 56,
              child: Row(
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsView())),
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
                    child: ClipOval(
                      child: CachedNetworkImage(
                        width: MySize.size20*2,
                        height: MySize.size20*2,
                        imageUrl: imagePath,
                        placeholder: (context, url) => Image.asset('assets/images/hi4.png',  fit: BoxFit.cover,),
                        errorWidget: (context, url, error) =>  Image.asset('assets/images/hi4.png', fit: BoxFit.cover,),

                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: MySize.scaleFactorHeight*100),
Text( 'Manage Categories'.tr(),style: const TextStyle(color: AppColors.secondaryColor,fontWeight: FontWeight.w600, fontSize: 24,fontFamily:AppConst.primaryFont),),
            SizedBox(height: MySize.scaleFactorHeight*50),
            for (var category in categories)
              Container(
                margin: EdgeInsets.symmetric(vertical: MySize.size12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white, // Border color
                    width: 2.0,

                  ),
                  borderRadius: BorderRadius.circular(MySize.size8),
                ),
                child: GestureDetector(
                  onTap: (){
                    if (kDebugMode) {
                      print(category.name);
                    }
                    if(category.name =='Add more categories'.tr())
                      {
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder: (_, __, ___) => SelectCategories(),
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
                       Navigator.push(context,MaterialPageRoute(builder: (context)=>const SelectCategories()));
                      }
                    else{

                      // Navigator.push(
                      //   context,
                      //   PageRouteBuilder(
                      //     pageBuilder: (_, __, ___) => UnselectCategories(),
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

                     Navigator.push(context,MaterialPageRoute(builder: (context)=> const UnselectCategories()));

                    }
                  },
                  child: ListTile(
                    leading: Image.asset(category.image, width: 50, height: 35),
                    title: Center(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: MySize.size18,
                          fontFamily: AppConst.primaryFont,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,),
                      ),
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
class TextfieldModel {
  final String name;
  final String image;
  bool isSelect;

  TextfieldModel(
      {required this.image,
        required this.name,
        this.isSelect = false});
}