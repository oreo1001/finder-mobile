import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlapi_flutter/CameraApp/component/tip_dialog.dart';
import 'package:mlapi_flutter/Controller/my_cam_controller.dart';
import 'package:mlapi_flutter/main.dart';
import 'package:unicons/unicons.dart';

import '../theme.dart';
import 'component/custom_circle.dart';
import 'component/custom_viewfinder.dart';
import 'component/main_appbar.dart';

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> with WidgetsBindingObserver {
  MyCamController myCamController = Get.find();
  List<CameraDescription> myCams = [];
  late CameraController controller;

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  int _pointers = 0;
  late CameraDescription currentDescription;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      setState(() {
        myCamController.pickedImage = XFile(pickedFile.path).obs;
      });
      Get.toNamed('/imageConfirm');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    myCams = myCamController.myCameras;
    print(myCams);
    if (myCams.isNotEmpty) {
      currentDescription = myCams[0]; // back
      _initializeCameraController(currentDescription);
    } else {
      print('No cameras available');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = controller;
    if (!cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void switchCameraDirection() {
    if (currentDescription.lensDirection == CameraLensDirection.back) {
      currentDescription = myCams[1];
      _initializeCameraController(currentDescription);
    } else {
      currentDescription = myCams[0];
      _initializeCameraController(currentDescription);
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (controller.value.hasError) {
        print('Camera error: ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
      _minAvailableZoom = await controller.getMinZoomLevel();
      _maxAvailableZoom = await controller.getMaxZoomLevel();
      if (mounted) {
        setState(() {});
      }
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
        default:
          showInSnackBar(e.toString());
          break;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
              _cameraPreviewWidget(),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CameraAppBar(() {
                    switchCameraDirection();
                  })),
              Positioned(
                top: 180.h,
                left: (MediaQuery.of(context).size.width - 300.w) /
                    2,
                child: IgnorePointer(
                  child: CustomPaint(
                    size: Size(300.w, 300.h),
                    painter: ViewfinderPainter(),
                  ),
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
                    onTap: () {
                      takePicture();
                    },
                    child: CustomPaint(
                      size: Size(80.w, 80.h),
                      painter: CircleWithBorderPainter(),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.dialog(tipDialog());
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(UniconsLine.comment_exclamation, size: 25.sp, color: Colors.teal.shade300,),
                          Text('촬영 팁',
                              style: textTheme()
                                  .bodyMedium!
                                  .copyWith(color: Colors.teal.shade300, fontSize: 14.sp)),
                        ],
                      )),
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
          child: Text("사진첩",
              style: textTheme()
                  .bodyMedium!
                  .copyWith(color: Colors.teal.shade300)),
        ),
      ],
    );
  }

  Widget _cameraPreviewWidget() {
    if (!controller.value.isInitialized) {
      return const Text(
        'waiting for camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
        ),
      );
    }
    return Listener(
      onPointerDown: (_) => _pointers++,
      onPointerUp: (_) => _pointers--,
      child: SizedBox(
        height: 600.h,
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

  Future takePicture() async {
    final CameraController cameraController = controller;
    if (!cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    if (cameraController.value.isTakingPicture) {
      showInSnackBar("사진을 찍는 중 입니다.");
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
    if (_pointers != 2) {
      return;
    }
    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller.setZoomLevel(_currentScale);
  }
}
