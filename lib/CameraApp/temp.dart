import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mlapi_flutter/CameraApp/appbar.dart';
import 'package:mlapi_flutter/Controller/my_cam_controller.dart';
import 'package:mlapi_flutter/main.dart';
import 'package:unicons/unicons.dart';

import 'custom_circle.dart';
import 'custom_viewfinder.dart';

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  MyCamController myCamController = Get.find();
  XFile? imageFile;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  @override
  void initState() {
    super.initState();
    List<CameraDescription> test = myCamController.myCameras;
    controller = CameraController(test[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 600.h, // 원하는 높이로 설정하세요.
                child: CameraPreview(controller),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CameraAppBar()
              ),
              Positioned(
                top: 180.h, // CustomPaint를 배치할 y 좌표
                left: (MediaQuery.of(context).size.width - 300.w) / 2, // 화면의 가운데에 위치
                child: CustomPaint(
                  size: Size(300.w, 300.h), // 원하는 크기
                  painter: ViewfinderPainter(),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){}, child: Text('사진첩')),
                  CustomPaint(
                    size: Size(80.w,80.h), // 원하는 크기 설정
                    painter: CircleWithBorderPainter(),
                  ),
                  TextButton(onPressed: (){}, child: Text('촬영 팁')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}