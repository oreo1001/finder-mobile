import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../theme.dart';
import 'custom_card2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                //위에 곡선
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal.shade200,
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.sp),
                    ),
                  ),
                  width: double.infinity,
                  height: 130.h,
                  child: Column(
                    children: [
                      SizedBox(height: 60.h),
                      Text('Saltware Object Detection',
                          style: textTheme()
                              .bodyLarge
                              ?.copyWith(fontSize: 20.sp, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Container(
                //밑에 곡선
                color: Colors.teal.shade200,
                height: 80.h,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50.sp),
                      ),
                    ),
                    width: double.infinity,
                    child: Text('')),
              ),
              GestureDetector(
                  onTap: () {
                    Get.toNamed('/realTime');
                  },
                  child: CustomCard(
                    title: '병충해 실시간 탐지',
                    imagePath: 'assets/images/observing-cat.jpg',
                    myColor: Colors.blue.shade200,
                  )),
              SizedBox(
                height: 50.h,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/cam');
                },
                child: CustomCard(
                    title: '이미지로 병충해 탐지',
                    imagePath: 'assets/images/camera.jpg',
                    myColor: Colors.lightGreen),
              ),
            ],
          ),
        ));
  }
}
