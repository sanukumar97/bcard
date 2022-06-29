import 'package:bcard/screens/LoginSignup/register1.dart';
import 'package:bcard/utilities/Constants/randomConstants.dart';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  
  void _onDonePress() {
    Navigator.pop(context);
    AppConfig.firstInstallDone = true;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistrationPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      backgroundColorAllSlides: Colors.white,
      renderNextBtn: _nextButton,
      renderPrevBtn: _prevButton,
      renderSkipBtn: _skipButton,
      renderDoneBtn: _doneButton,
      onDonePress: _onDonePress,
      slides: List<Slide>.generate(
        4,
        (i) => Slide(
          backgroundImage: "assets/images/intro/intro${i + 1}.jpg",
          backgroundImageFit: BoxFit.fill,
          backgroundOpacity: 0.0,
        ),
      ),
    );
  }

  Widget get _nextButton => Text(
        "NEXT",
        style: myTs(color: color1),
      );
  Widget get _prevButton => Text(
        "PREV",
        style: myTs(color: color1),
      );
  Widget get _skipButton => Text(
        "SKIP",
        style: myTs(color: color1),
      );
  Widget get _doneButton => Text(
        "DONE",
        style: myTs(color: color1),
      );
}
