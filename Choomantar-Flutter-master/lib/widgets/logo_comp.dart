import 'package:chumanter/configs/imports/import_helper.dart';

Widget logoComp({double width = 300, double height = 60}) => Padding(
      padding: EdgeInsets.only(top: MySize.size20),
      child: Center(
        child: Image.asset(
          AppConst.logo,
          height: height,
          width: width,
          fit: BoxFit.fill,
        ),
      ),
    );
