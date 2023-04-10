import 'package:flutter/material.dart';
import 'package:tanum/pages/Login.dart';
import 'package:tanum/utils/routes.dart';
import 'utils/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: APP_THEME,
      ),
      routes: Routes.getRoutes(context),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      showSemanticsDebugger: false,
    );
  }
}
