import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'Camera/page.dart';

void main() {
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
        localizationsDelegates: const [
          // GlobalMaterialLocalizations.delegate,
          // GlobalWidgetsLocalizations.delegate,
          // GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko'),
          Locale('en'),
        ],
        locale: const Locale('ko'),
        title: 'WonMo Calendar',
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
          GetPage(name: '/camera', page: () => CameraPage())
        ],
        home: CameraPage(),
      ),
    );
  }
}
