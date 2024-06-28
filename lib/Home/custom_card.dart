import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String buttonText;
  final VoidCallback onPressed;

  const CustomCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300.withOpacity(0.2),
              spreadRadius: 2.sp,
              blurRadius: 1.sp,
              offset: const Offset(0, 1),
            ),
          ]),
      width: 330.w,
      height: 300.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Text(
              title,
              style: textTheme()
                  .displayMedium
                  ?.copyWith(fontSize: 20.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.sp),
              child: Image.asset(imagePath),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                side: BorderSide(color: Colors.black, width: 1.5.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.sp),
                ),
              ),
              child: Text(
                buttonText,
                style: textTheme()
                    .displayMedium
                    ?.copyWith(fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}