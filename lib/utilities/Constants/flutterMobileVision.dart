import 'package:bcard/utilities/Classes/profileClass.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class ScanCard {
  static Future<void> init() async {
    await FlutterMobileVision.start();
  }

  static Future<List<String>> startScan() async {
    List<OcrText> texts = await FlutterMobileVision.read(
      autoFocus: true,
      camera: FlutterMobileVision.CAMERA_BACK,
      waitTap: true,
    );
    return texts.map<String>((text) => text.value).toList();
  }
}
