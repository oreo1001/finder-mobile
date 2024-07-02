import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../theme.dart';

Dialog tipDialog(){
  List<String> textList = ['너무 가까운 사진', '여러 개의 식물', '너무 먼 사진', '흐릿한 사진'];
  return Dialog(
    child: Container(
      padding: EdgeInsets.all(15.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('촬영 팁',style: textTheme().bodyMedium?.copyWith(
              fontSize: 18.sp,color: Colors.teal.shade800)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 20.h),
            height: 200.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.sp),
              child: GridTile(
                child: Image.asset(
                  'assets/images/tip0.jpg',
                  fit: BoxFit.cover,
                ),
                footer: GridTileBar(
                  backgroundColor: Colors.black54,
                  title: Text(
                    '정상적인 사진',
                    style: textTheme().bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 10.w),
            height: 250.h,
            child: GridView.builder(
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius:
                    BorderRadius.circular(15.sp),
                    child: GridTile(
                      child: Image.asset(
                        'assets/images/tip${index + 1}.jpg',
                        fit: BoxFit.cover,
                      ),
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(
                          textList[index],
                          style: textTheme()
                              .bodyMedium
                              ?.copyWith(
                              fontSize: 12.sp,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 15.h,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(30.w, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.sp),
                ),
                backgroundColor: Colors.teal.shade300,
                // 버튼 배경색
                foregroundColor: Colors.white, // 텍스트 색상
              ),
              onPressed: () {
                Get.back();
              },
              child: Text('닫기'))
        ],
      ),
    ),
  );
}