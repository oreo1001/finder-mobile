import 'package:camera/camera.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MyCamController extends GetxController {
  List<CameraDescription> myCameras = <CameraDescription>[];
  var pickedImage = Rx<XFile?>(null);

  MyCamController(this.myCameras);
}