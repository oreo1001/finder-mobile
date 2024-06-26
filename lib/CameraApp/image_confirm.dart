import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mlapi_flutter/CameraApp/sub_appbar.dart';
import 'package:mlapi_flutter/Controller/my_cam_controller.dart';

class ImageConfirm extends StatefulWidget {
  const ImageConfirm({super.key});

  @override
  State<ImageConfirm> createState() => _ImageConfirmState();
}

class _ImageConfirmState extends State<ImageConfirm> {
  late Rx<XFile?> pickedImage;
  MyCamController myCamController = Get.find();

  @override
  void initState() {
    super.initState();
    pickedImage = myCamController.pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppBar(),
        body:Column(
      children: [
        Text('dd'),
        _buildPhotoArea()
      ],
    ));
  }

  Widget _buildPhotoArea() {
    return pickedImage.value != null
        ? Container(
      width: 300,
      height: 300,
      child: (kIsWeb)
          ? Image.network(pickedImage.value!.path)
          : Image.file(File(pickedImage.value!.path)), //가져온 이미지를 화면에 띄워주는 코드
    )
        : Container(
      width: 300,
      height: 300,
      child: Image.network(
          "https://images.unsplash.com/photo-1460088033389-a14158fa866d?q=80&w=640&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
      color: Colors.grey,
    );
  }
}