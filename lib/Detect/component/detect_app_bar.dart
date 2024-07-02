import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:unicons/unicons.dart';

class DetectAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DetectAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(50.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: (){Get.offNamed('/home');},
                icon: Icon(Icons.home_outlined, size: 30.sp, color:Colors.black)),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: (){Get.offNamed('/cam');},
              icon: Icon(
                UniconsLine.camera,
                size: 30.sp,
                color: Colors.black,
              ),),
          ],
        ),
      ),
    );
  }
}