import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mlapi_flutter/Controller/my_cam_controller.dart';
import 'package:http/http.dart' as http;
import 'package:mlapi_flutter/Detect/component/box_painter.dart';
import 'package:mlapi_flutter/Detect/loading_screen.dart';
import 'package:mlapi_flutter/Detect/parsing_function.dart';
import 'package:mlapi_flutter/theme.dart';
import 'package:unicons/unicons.dart';

class DetectPage extends StatefulWidget {
  const DetectPage({super.key});

  @override
  State<DetectPage> createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  late Rx<XFile?> pickedImage;
  MyCamController myCamController = Get.find();
  String outputText='';
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
    dataMap.value =  getMapFromParsedData(parsedData).obs;
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
    String label = '';
    double resultScore = 0;
    return Scaffold(
      body: Obx(() {
        if (dataMap.isEmpty) {
          return Column(
            children: [
              CustomLinearProgress(),
              Image.asset('assets/images/plant-search.png',width:140.w, height:200.h),
            ],
          );
        } else {
          for (int i = 0; i < dataMap['labels'].length; i++) {
            if (!dataMap['labels'][i].contains('Healthy')) {
              double score = dataMap['scores'][i];
              resultScore = (score*1000).roundToDouble()/10;  //소숫점 첫째 자리까지 반올림
              label = dataMap['labels'][i];
            }
          }
          return Column(
            children: [
              Stack(
                children: [
                  imageBytes == null
                      ? Text('이미지를 선택하세요')
                      : AspectRatio(
                    aspectRatio: imageWidth! / imageHeight!,
                    child: Image.memory(imageBytes!),
                  ),
                  imageBytes == null
                      ? Container()
                      : AspectRatio(
                    aspectRatio: imageWidth! / imageHeight!,
                    child: CustomPaint(
                      painter: MyBoxPainter(
                        dataMap: dataMap,
                        originalWidth: imageWidth!,
                        originalHeight: imageHeight!,
                      ),
                    ),
                  ),
                ],
              ),
              Text('해당 식물은 $resultScore%의 확률로 \n $label 병에 걸렸습니다.'),
              SizedBox(height: 100.h,),
              Row(children: [
                IconButton(onPressed: (){
                    Get.offNamed('/cam');
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape:const CircleBorder(),
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w)
                  ),
                  icon: Icon(
                  UniconsLine.camera,
                  size: 35.sp,
                  color: Colors.black,
                ),)
              ]),
              Text(dataMap.toString()),
            ],
          );
        }
      }),
    );
  }
}