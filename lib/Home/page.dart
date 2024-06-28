import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../theme.dart';
import 'custom_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCard(title: '실시간 탐지', imagePath: 'assets/images/병해충1.png', buttonText: '실시간 탐지 바로 가기', onPressed: () { Get.toNamed('/cam'); }),

              TextButton(
                  onPressed: () {},
                  child: Text('실시간 탐지',
                      style: textTheme().bodyMedium!.copyWith(
                          color: Colors.teal.shade300, fontSize: 20.sp))),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 80.h),
                child: TextButton(
                    onPressed: () {
                      Get.toNamed('/cam');
                    },
                    child: Text('이미지로 검색',
                        style: textTheme().bodyMedium!.copyWith(
                            color: Colors.teal.shade300, fontSize: 20.sp))),
              ),
              TextButton(
                  onPressed: () {},
                  child: Text('temp',
                      style: textTheme().bodyMedium!.copyWith(
                          color: Colors.teal.shade300, fontSize: 20.sp))),
            ],
          ),
        ));
  }
}

Container myCard(String title,String imagePath, String buttonText,VoidCallback pushButton){
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
            padding: EdgeInsets.symmetric(
                horizontal: 20.w, vertical: 20.h),
            child: Text(title,
                style: textTheme()
                    .displayMedium
                    ?.copyWith(fontSize: 20.sp)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.sp),
                child: Image.asset('assets/images/병해충1.png')),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: TextButton(
                onPressed: pushButton,
                style: TextButton.styleFrom(
                  side: BorderSide(
                      color: Colors.black, width: 1.5.w),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(8.sp), // 둥근 사각형 테두리
                  ),
                ),
                child: Text(buttonText, style: textTheme()
                    .displayMedium
                    ?.copyWith(fontSize: 14.sp))),
          )
        ],
      ));
}