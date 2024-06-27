import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:unicons/unicons.dart';

class CameraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CameraAppBar(this.onCameraButtonPressed,{super.key});
  final VoidCallback onCameraButtonPressed;

  @override
  Size get preferredSize => Size.fromHeight(70.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.fromLTRB(0, 40.h, 0, 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.close, size: 25.sp, color:Colors.white)),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: (){
                Get.toNamed('/test');
              },
              icon: Icon(
                UniconsLine.auto_flash,
                size: 25.sp,
                color: Colors.white,
              ),),
            IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: onCameraButtonPressed,
                icon: Icon(
                  UniconsLine.camera_change,
                  size: 25.sp,
                  color: Colors.white,
                ),),
          ],
        ),
      ),
    );
  }
}