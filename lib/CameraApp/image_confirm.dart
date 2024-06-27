import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlapi_flutter/Controller/my_cam_controller.dart';
import 'package:unicons/unicons.dart';

import '../theme.dart';

class ImageConfirm extends StatefulWidget {
  const ImageConfirm({super.key});

  @override
  State<ImageConfirm> createState() => _ImageConfirmState();
}

class _ImageConfirmState extends State<ImageConfirm> {
  late Rx<XFile?> pickedImage;
  MyCamController myCamController = Get.find();
  String outputText='';
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  @override
  void initState() {
    super.initState();
  }
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
        myCamController.pickedImage = XFile(pickedFile.path).obs;
        setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    pickedImage = myCamController.pickedImage;
    return Scaffold(
      body: Column(
        children: [
          _buildPhotoArea(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w,0,50.w,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _imageButton(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: (){Get.toNamed('/detect');},
                    icon: Icon(
                      UniconsLine.check_circle,
                      size: 100.sp,
                      color: Colors.teal.shade300,
                    ),),
                  TextButton(onPressed: (){}, child: Text('촬영 팁',style:textTheme().bodyMedium!.copyWith(color:Colors.teal.shade300))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoArea() {
    return pickedImage.value != null
        ? SizedBox(
      width: 600.w,
      height: 600.h,
      child: (kIsWeb)
          ? Image.network(pickedImage.value!.path)
          : Image.file(File(pickedImage.value!.path)), //가져온 이미지를 화면에 띄워주는 코드
    )
        : Container();
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
          child: Text("다시 선택하기",style:textTheme().bodyMedium!.copyWith(color:Colors.teal.shade300)),
        ),
      ],
    );
  }
}