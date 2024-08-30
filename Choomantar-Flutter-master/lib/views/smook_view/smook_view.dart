import 'package:chumanter/res/utils/CommonFuncs.dart';

import '../../configs/imports/import_helper.dart';
import '../quize_view/quiz_view_for_entertainment.dart';
import '../quize_view/quiz_view_for_financial.dart';
import '../quize_view/quiz_view_for_health_profile.dart';
import '../quize_view/quiz_view_for_shopping_profile.dart';
import '../quize_view/quiz_view_for_technology.dart';

class SmookView extends StatefulWidget {
  final int index;
  bool? viewMode;

  SmookView(this.index, {super.key, this.viewMode});

  @override
  State<SmookView> createState() => _SmookViewState();
}

class _SmookViewState extends State<SmookView> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(AppConst.animationScreen8)
      ..initialize().then((_) {
        setState(() {
          _videoController.play();
        });
     //   _videoController.setLooping(true);
      });

    // Check the value of the index and navigate accordingly
    Future.delayed(const Duration(seconds: 4), () {
      if (widget.index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizeViewGeneralProfile(viewMode: widget.viewMode)), // Replace with your existing page
        );
      } else if(widget.index==1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizeViewHealthProfile(viewMode: widget.viewMode,)), // Replace with the page for other indices
        );
      }
      else if(widget.index==2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizeViewShoppingProfile(viewMode: widget.viewMode,)), // Replace with the page for other indices
        );
      }
      else if(widget.index==3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizeViewEntertainment(viewMode: widget.viewMode,)), // Replace with the page for other indices
        );
      }
      else if(widget.index==4) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizeViewTechnology(viewMode: widget.viewMode,)), // Replace with the page for other indices
        );
      }
      else if(widget.index==5) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizeViewFinancial(viewMode: widget.viewMode,)), // Replace with the page for other indices
        );
      }
    });

    CommonFuncs.showToast("smook_view\nSmookView");
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController.value.size.width,
            height: _videoController.value.size.height,
            child: VideoPlayer(_videoController),
          ),
        ),
      ),
    );
  }
}

