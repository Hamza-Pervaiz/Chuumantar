import 'package:chumanter/configs/imports/import_helper.dart';

Widget backBtn(BuildContext context) => GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(MySize.size4),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(MySize.size8)),
        child: Icon(
          Icons.keyboard_backspace,
          size: MySize.size30,
          color: AppColors.secondaryColor,
        ),
      ),
    );
