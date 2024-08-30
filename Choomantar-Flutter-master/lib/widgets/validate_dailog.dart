
import 'package:easy_localization/easy_localization.dart';

import '../configs/imports/import_helper.dart';

Widget validationDialog(BuildContext context,
        {Widget? title,
        bool isTitle = false,
        String btnText = "Ok",
        String icon = AppConst.closeIcon,
        required String oprText,
        required Function ontap}) =>
    Dialog(

      insetPadding:
          EdgeInsets.symmetric(horizontal: MySize.scaleFactorWidth * 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySize.size16),
      ),
      child: Container(
          height: isTitle
              ? MySize.scaleFactorHeight * 270
              : MySize.scaleFactorHeight * 230,
          width: MySize.screenWidth,
          padding: EdgeInsets.all(MySize.size20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MySize.size16),
            image: const DecorationImage(
              image: AssetImage(AppConst.eyeBg),
              fit: BoxFit.scaleDown,
              scale: 0.5
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isTitle ? title! : const SizedBox(),
              isTitle
                  ? SizedBox(
                      height: MySize.scaleFactorHeight * 20,
                    )
                  : const SizedBox(),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    icon,
                    height: MySize.size50,
                    width: MySize.size50,
                  )),
              SizedBox(
                height: MySize.scaleFactorHeight * 10,
              ),
              TextWidget(
                text: oprText,
                textAlign: TextAlign.center,
                maxLines: 2,
                fontSize: MySize.size14,
                fontFamily: AppConst.primaryFont,
                fontColor: AppColors.purpleColor,
              ),
              SizedBox(
                height: MySize.scaleFactorHeight * 20,
              ),
              SizedBox(
                width: MySize.scaleFactorWidth * 120,
                height: MySize.scaleFactorHeight * 40,
                child: ButtonWidget(
                    onTap: () {
                      ontap();
                    },
                    text: btnText.tr()),
              )
            ],
          )),
    );
