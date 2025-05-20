// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vedalaya_app/views/app_navigation/navigation_screen.dart';
// // import 'package:vedalaya_app/view/learning_screen/learning_screen.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  GetMaterialApp(
//         debugShowCheckedModeBanner: false,

//           title: 'Vedalaya App',
//       home: AppNavigationScreen()
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vedalaya_app/views/app_navigation/navigation_screen.dart';
void main() async {
  runApp(const VedalayaApp());
}

class VedalayaApp extends StatelessWidget {
  const VedalayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vedalaya App',
      theme: ThemeData(
        // Add your app-wide theme here if needed
        primarySwatch: Colors.purple,
      ),
      home: const AppNavigationScreen(),
    );
  }
}