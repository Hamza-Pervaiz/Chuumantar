import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'custom_payment_container.dart';


class ChoosePaymenType extends StatefulWidget {
  final Function(String) onYesPressed;
  const ChoosePaymenType({super.key, required this.onYesPressed});

  @override
  State<ChoosePaymenType> createState() => _ChoosePaymenTypeState();
}

class _ChoosePaymenTypeState extends State<ChoosePaymenType> {
  String? selectedPaymentType;
 // PageController pageController = PageController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFuncs.showToast("selectplaymenttype\nChoosePaymenType");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: MySize.size10),
        Text(
          'Choose Payment Method'.tr(),
          style: TextStyle(
            fontFamily: AppConst.primaryFont,
            fontWeight: FontWeight.w900,
            color: AppColors.secondaryColor,
            fontSize: MySize.size22,
          ),
        ),
        GestureDetector(
          onTap: (){
            selectedPaymentType ='Easy Paisa';
            widget.onYesPressed(selectedPaymentType! );},
          child:  ReusablePaymentContainer(
            text: 'Easy Paisa'.tr(),
            image: 'assets/images/Easypaisa_Icon_Vector-removebg.png',
          ),
        ),
        GestureDetector(
          onTap: (){
            selectedPaymentType ='Jazz Cash';
            widget.onYesPressed(selectedPaymentType! );
          },
          child: ReusablePaymentContainer(
            text: 'Jazz Cash'.tr(),
            image: 'assets/images/Jazz_cash_logo_vector-removebg-preview.png',
          ),
        ),
        GestureDetector(
          onTap: (){
            selectedPaymentType ='Sada Pay';
            widget.onYesPressed(selectedPaymentType! );
          },
          child: ReusablePaymentContainer(
              text: 'Sada Pay'.tr(),
              image: 'assets/images/SadaPay_Logo_Vector-removebg-preview.png',
              ),
        ),
      ],
    );
  }
}

