import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Controller/my_cam_controller.dart';
import '../theme.dart';

class CustomLinearProgress extends StatefulWidget {
  const CustomLinearProgress({super.key});

  @override
  _CustomLinearProgressState createState() => _CustomLinearProgressState();
}

class _CustomLinearProgressState extends State<CustomLinearProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progress;
  MyCamController myCamController = Get.find();
  late Rx<XFile?> pickedImage;
  final double fixedHeight = 250.h;

  @override
  void initState() {
    pickedImage = myCamController.pickedImage;
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _progress = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    // 애니메이션 시작
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildPhotoArea() {
    return pickedImage.value != null
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: fixedHeight,
            child: ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: 1.0,
                child: Transform.scale(
                  scale:2.0,
                  child: (kIsWeb)
                      ? Image.network(pickedImage.value!.path)
                      : Image.file(File(pickedImage.value!.path)),
                ),
              ),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    double progressBarWidth = MediaQuery.of(context).size.width - 50;

    return Column(
      children: [
        Stack(
          children: [
            _buildPhotoArea(),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return ClipRRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: _animationController.value,
                    child: Container(
                      color: Colors.grey.withOpacity(0.2),
                      width: MediaQuery.of(context).size.width,
                      height: fixedHeight,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 80.h),
        Text('분석 중...',
            style: textTheme()
                .bodyMedium
                ?.copyWith(fontSize: 20.sp, color: Colors.teal.shade500)),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 30.w),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                decoration: BoxDecoration(
                  color: Colors.teal.shade300,
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.sp),
                  child: LinearProgressIndicator(
                    value: _progress.value,
                    minHeight: 15.h,
                    backgroundColor: Colors.white,
                    color: Colors.teal.shade300,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10.h,
              left: progressBarWidth * _progress.value - 10.w, // 수정된 부분
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.sp),
                child: Container(
                  width: 50.w,
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(_progress.value * 100).toInt()}%',
                        style: TextStyle(
                            color: Colors.teal.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
