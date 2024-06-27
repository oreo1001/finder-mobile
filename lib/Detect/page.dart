import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mlapi_flutter/Controller/my_cam_controller.dart';

class DetectPage extends StatefulWidget {
  const DetectPage({super.key});

  @override
  State<DetectPage> createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> with WidgetsBindingObserver {
  MyCamController myCamController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Text(''));
  }
}