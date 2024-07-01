import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../theme.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color myColor;

  const CustomCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.myColor

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            height: 220.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight:  Radius.circular(10.sp),
                  bottomRight: Radius.circular(10.sp),
                ),
              boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300.withOpacity(0.2),
                    spreadRadius: 2.sp,
                    blurRadius: 1.sp,
                    offset: const Offset(0, 1),
                  ),
                ],
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height:30.h),
                      Container(
                        padding: EdgeInsets.fromLTRB(25.w,0,0,10.h),
                        color: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.sp),
                          child: Image.asset(imagePath,width:100.w,height:100.h),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(title, style:textTheme()
                            .bodyLarge
                            ?.copyWith(fontSize: 24.sp, color: myColor)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Icon(Icons.arrow_forward_ios,color: Colors.grey.shade600,),
                  )
                ],
              ),
            )),
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: Container(
            width: 10.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80.sp),
                topLeft: Radius.circular(80.sp),
              ),
              color: myColor,
            ),
            child: Container(),
          ),
        ),
      ],
    );
  }
}