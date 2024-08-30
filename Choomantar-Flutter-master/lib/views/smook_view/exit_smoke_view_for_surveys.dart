import 'package:chumanter/res/utils/CommonFuncs.dart';

import '../../configs/imports/import_helper.dart';

class ExitSmokeViewForSurvey extends StatefulWidget {


  const ExitSmokeViewForSurvey( {super.key});

  @override
  State<ExitSmokeViewForSurvey> createState() => _ExitSmokeViewState();
}

class _ExitSmokeViewState extends State<ExitSmokeViewForSurvey> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset(AppConst.animationScreen9)
      ..initialize().then((_) {
        setState(() {
          _videoController.play();

        });
        //  _videoController.setLooping(true);
      });

    CommonFuncs.showToast("smoke_view_for_surveys\nExitSmokeViewForSurvey");

  //  _videoController.addListener(videoListener);


    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void videoListener() {
    if (_videoController.value.position >= _videoController.value.duration) {
      Navigator.pop(context);
    }
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