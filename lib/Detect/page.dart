import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mlapi_flutter/Controller/my_cam_controller.dart';
import 'package:http/http.dart' as http;
import 'package:mlapi_flutter/Detect/component/box_painter.dart';
import 'package:mlapi_flutter/Detect/loading_screen.dart';
import 'package:mlapi_flutter/Detect/parsing_function.dart';

import '../theme.dart';
import 'component/detect_app_bar.dart';

class DetectPage extends StatefulWidget {
  const DetectPage({super.key});

  @override
  State<DetectPage> createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  late Rx<XFile?> pickedImage;
  MyCamController myCamController = Get.find();
  String outputText = '';
  RxMap<String, dynamic> dataMap = RxMap<String, dynamic>();

  Uint8List? imageBytes;
  int? imageHeight;
  int? imageWidth;

  @override
  void initState() {
    super.initState();
    pickedImage = myCamController.pickedImage;
    getImageAndDetect(pickedImage.value);
  }

  Future<void> detect(String byteString, width, height) async {
    String endpoint =
        'https://aavl48ony0.execute-api.ap-northeast-2.amazonaws.com/Prod/detect';
    final detections = await http.post(
      Uri.parse(endpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'image': byteString,
        'width': width.toString(),
        'height': height.toString()
      }),
    );
    var parsedData = jsonDecode(detections.body);
    dataMap.value = getMapFromParsedData(parsedData).obs;
    print(dataMap);
  }

  Future<void> getImageAndDetect(XFile? pickedFile) async {
    if (pickedFile != null) {
      try {
        Uint8List bytes = await pickedFile.readAsBytes();
        final decodedImage = await decodeImageFromList(bytes);
        final height = decodedImage.height; // Image height
        final width = decodedImage.width; // Image width

        String base64String = base64.encode(bytes);
        setState(() {
          imageBytes = bytes;
          imageHeight = height;
          imageWidth = width;
        });
        await detect(base64String, width, height);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (dataMap.isEmpty) {
          return Column(
            children: [
              const CustomLinearProgress(),
              Image.asset('assets/images/plant-search.png',
                  width: 140.w, height: 200.h),
            ],
          );
        } else if (dataMap.containsKey('error')) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DetectAppBar(),
                imageAndBoxWidget(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('해당 사진에서 정보를 읽어올 수 없습니다.',
                        style: textTheme().bodyMedium?.copyWith(
                            fontSize: 18.sp, color: Colors.teal.shade500)),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              ],
            ),
          );
        } else {
          return detectResult();
        }
      }),
    );
  }

 Container imageAndBoxWidget() {
    print(imageWidth);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: AspectRatio(
        aspectRatio: imageWidth!/imageHeight!,
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageBytes == null ? Text('이미지를 선택하세요') : Image.memory(imageBytes!),
            dataMap.containsKey('error') || imageBytes == null
                ? Container()
                : CustomPaint(
                    painter: MyBoxPainter(
                      dataMap: dataMap,
                      originalWidth: imageWidth!,
                      originalHeight: imageHeight!,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView detectResult() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const DetectAppBar(),
          imageAndBoxWidget(),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            // 스크롤 비활성화
            shrinkWrap: true,
            // 내용에 맞게 크기 조절
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            itemCount: dataMap['boxes'].length,
            itemBuilder: (context, index) {
              List<double> box = dataMap['boxes'][index];
              double score =
                  dataMap['scores'].isNotEmpty ? dataMap['scores'][index] : 0.0;
              String label =
                  dataMap['labels'].isNotEmpty ? dataMap['labels'][index] : '';
              String roundedScore = (score * 100).toStringAsFixed(1);
              return Card(
                color: Colors.teal.shade300,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '개체 레이블: $label',
                        style: textTheme()
                            .bodyMedium
                            ?.copyWith(fontSize: 14.sp, color: Colors.white),
                      ),
                      SizedBox(height: 8.h),
                      Text('확률: $roundedScore%',
                          style: textTheme()
                              .bodyMedium
                              ?.copyWith(fontSize: 14.sp, color: Colors.white)),
                      SizedBox(height: 8.h),
                      Text(
                          '바운딩 박스 좌표: [${box[0]}, ${box[1]}, ${box[2]}, ${box[3]}]',
                          style: textTheme()
                              .bodyMedium
                              ?.copyWith(fontSize: 14.sp, color: Colors.white)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
