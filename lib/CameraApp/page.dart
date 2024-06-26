import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlapi_flutter/CameraApp/main_appbar.dart';
import 'package:mlapi_flutter/Controller/my_cam_controller.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import '../theme.dart';
import 'custom_circle.dart';
import 'custom_viewfinder.dart';

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> with WidgetsBindingObserver {
  MyCamController myCamController = Get.find();
  late CameraController controller;
  List<CameraDescription> myCams = [];

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  int _pointers = 0;

  late Rx<XFile?> pickedImage;
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      setState(() {
        pickedImage = XFile(pickedFile.path).obs;
        myCamController.pickedImage = XFile(pickedFile.path).obs;
      });
      Get.toNamed('/imageConfirm');
    }
  }


  @override
  void initState() {
    super.initState();
    pickedImage = myCamController.pickedImage;
    WidgetsBinding.instance.addObserver(this);
    myCams = myCamController.myCameras;
    _initializeCameraController(myCams);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (controller == null || !controller!.value.isInitialized) {
  //     return;
  //   }
  //
  //   if (state == AppLifecycleState.inactive) {
  //     controller.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     _initializeCameraController(myCams);
  //   }
  // }

  void _showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
  void _initializeCameraController(List<CameraDescription> myCams) {
    controller = CameraController(myCams.first, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (controller.value.hasError) {
        _showInSnackBar(
            'Camera error ${controller.value.errorDescription}');
      }
    });
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.getMaxZoomLevel().then((double value) => _maxAvailableZoom = value);
      controller.getMinZoomLevel().then((double value) => _minAvailableZoom = value);
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            _showInSnackBar('You have denied camera access.');
            break;
          case 'CameraAccessDeniedWithoutPrompt':
            _showInSnackBar('Please go to Settings app to enable camera access.');
            break;
          case 'CameraAccessRestricted':
            _showInSnackBar('Camera access is restricted.');
            break;
          case 'AudioAccessDenied':
            _showInSnackBar('You have denied audio access.');
            break;
          case 'AudioAccessDeniedWithoutPrompt':
            _showInSnackBar('Please go to Settings app to enable audio access.');
            break;
          case 'AudioAccessRestricted':
            _showInSnackBar('Audio access is restricted.');
            break;
          default:
            _showInSnackBar(e.toString());
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    // controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
              _cameraPreviewWidget(),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CameraAppBar()
              ),
              Positioned(
                top: 180.h,
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
                  _imageButton(),
                  GestureDetector(
                    onTap:(){takePicture(controller);},
                    child: CustomPaint(
                      size: Size(80.w,80.h),
                      painter: CircleWithBorderPainter(),
                    ),
                  ),
                  TextButton(onPressed: (){}, child: Text('촬영 팁',style:textTheme().bodyMedium!.copyWith(color:Colors.teal.shade300))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          style: TextButton.styleFrom(
            side: BorderSide(color: Colors.teal.shade300, width: 1.5.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17.sp), // 둥근 사각형 테두리
            ),
          ),
          child: Text("사진첩",style:textTheme().bodyMedium!.copyWith(color:Colors.teal.shade300)),
        ),
      ],
    );
  }
  Widget _cameraPreviewWidget() {     //zoomin 기능 시도
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: SizedBox(
          height:600.h,
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(
              controller,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onScaleStart: _handleScaleStart,
                      onScaleUpdate: _handleScaleUpdate,
                      onTapDown: (TapDownDetails details) =>
                          onViewFinderTap(details, constraints),
                    );
                  }),
            ),
          ),
        ),
      );
  }
  Future takePicture(CameraController cameraController) async {
    if (cameraController == null || !cameraController.value.isInitialized) {
      _showInSnackBar('Error: select a camera first.');
      return null;
    }
    if (cameraController.value.isTakingPicture) {
      _showInSnackBar("사진을 찍는 중 입니다.");
    }
    final XFile file = await cameraController.takePicture();
    myCamController.pickedImage = file.obs;
    Get.toNamed('/imageConfirm');
  }
  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller.setFocusPoint(offset);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }
    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }
}

