import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:camera/camera.dart';
import 'package:mlapi_flutter/CameraApp/image_confirm.dart';
import 'package:mlapi_flutter/CameraApp/page.dart';
import 'package:mlapi_flutter/CameraApp/test.dart';
import 'package:mlapi_flutter/Detect/component/ex.dart';
import 'package:mlapi_flutter/Detect/page.dart';
import 'Controller/my_cam_controller.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  Get.put(MyCamController(_cameras));
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(395.0, 785.0),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        locale: const Locale('ko'),
        title: 'Pinder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            hoverColor: const Color(0xFFACCCFF),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: WidgetStateProperty.all(true),
              thickness: WidgetStateProperty.all(10),
              thumbColor: WidgetStateProperty.all(Colors.amber),
              radius: const Radius.circular(10),
            )),
        getPages: [
          GetPage(name: '/cam', page: () => CameraApp()),
          GetPage(name: '/test',page:()=> CameraExampleHome()),
          GetPage(name: '/imageConfirm',page:() => ImageConfirm()),
          GetPage(name: '/detect', page:()=>DetectPage()),
          GetPage(name: '/ex',page:()=>Example())
        ],
        home: CameraApp(),
      ),
    );
  }
}
