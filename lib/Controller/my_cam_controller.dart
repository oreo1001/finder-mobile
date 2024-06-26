import 'package:camera/camera.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MyCamController extends GetxController {
  List<CameraDescription> myCameras = <CameraDescription>[];

  MyCamController(this.myCameras);
}