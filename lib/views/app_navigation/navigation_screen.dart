// import 'package:flutter/material.dart';

// class AppNavigationScreen extends StatefulWidget {
//   const AppNavigationScreen({super.key});

//   @override
//   State<AppNavigationScreen> createState() => _AppNavigationScreenState();
// }

// class _AppNavigationScreenState extends State<AppNavigationScreen> {
//    int _selectedIndex = 0;
//     final PageController _pageController =
//       PageController(); // Page controller to manage PageView

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index; // Update the selected index
//     });
//     _pageController.jumpToPage(index); // Jump to the selected page
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//     body:   PageView(
//         physics: const NeverScrollableScrollPhysics(),
//         pageSnapping: false,
//         controller: _pageController, // Connect the PageController
//         onPageChanged: (index) {
//           setState(() {
//             _selectedIndex = index; // Update the selected index
//           });
//         },
//         children: [
//           // First Screen
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class AppNavigationScreen extends StatefulWidget {
//   const AppNavigationScreen({super.key});

//   @override
//   State<AppNavigationScreen> createState() => _AppNavigationScreenState();
// }

// class _AppNavigationScreenState extends State<AppNavigationScreen> {
//   int _selectedIndex = 1; // Default selected is Learning
//   final PageController _pageController = PageController(initialPage: 1);

//   void _onItemTapped(int index) {
//     _pageController.jumpToPage(index);
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         physics: NeverScrollableScrollPhysics(),
//         children: const [
//           Center(child: Text("Home", style: TextStyle(fontSize: 24))),
//           Center(child: Text("Learning", style: TextStyle(fontSize: 24))),
//           Center(child: Text("Profile", style: TextStyle(fontSize: 24))),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.purple,
//         unselectedItemColor: Colors.purple.shade200,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.menu_book),
//             label: 'Learning',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';

// class AppNavigationScreen extends StatefulWidget {
//   const AppNavigationScreen({super.key});

//   @override
//   State<AppNavigationScreen> createState() => _AppNavigationScreenState();
// }

// class _AppNavigationScreenState extends State<AppNavigationScreen> {
//   int _selectedIndex = 1; // default selected = Learning
//   final PageController _pageController = PageController(initialPage: 1);

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     _pageController.jumpToPage(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: const [
//           Center(child: Text("Home", style: TextStyle(fontSize: 24))),
//           Center(child: Text("Learning", style: TextStyle(fontSize: 24))),
//           Center(child: Text("Profile", style: TextStyle(fontSize: 24))),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         color: Colors.white,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             buildNavItem(icon: Icons.home, label: "Home", index: 0),
//             buildNavItem(
//                 icon: Icons.menu_book,
//                 label: "Learning",
//                 index: 1,
//                 isCenter: true),
//             buildNavItem(icon: Icons.person, label: "Profile", index: 2),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildNavItem({
//     required IconData icon,
//     required String label,
//     required int index,
//     bool isCenter = false,
//   }) {
//     bool isSelected = _selectedIndex == index;

//     return GestureDetector(
//       onTap: () => _onItemTapped(index),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: isSelected
//             ? BoxDecoration(
//                 color: AppConstants.purpleColorShade,
//                 borderRadius: BorderRadius.circular(12),
//               )
//             : null,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: AppConstants.purpleColor,
//               size: 24,
//             ),
//             Text(
//               label,
//               style: TextStyle(
//                 color: AppConstants.purpleColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AppNavigationScreen extends StatefulWidget {
//   const AppNavigationScreen({super.key});

//   @override
//   State<AppNavigationScreen> createState() => _AppNavigationScreenState();
// }

// class _AppNavigationScreenState extends State<AppNavigationScreen> {
//   int _selectedIndex = 1; // default selected = Learning
//   final PageController _pageController = PageController(initialPage: 1);

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     _pageController.jumpToPage(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: const [
//           Center(child: Text("Home", style: TextStyle(fontSize: 24))),
//           Center(child: Text("Learning", style: TextStyle(fontSize: 24))),
//           Center(child: Text("Profile", style: TextStyle(fontSize: 24))),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.symmetric(vertical: 7),
//         color: Colors.white,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             buildNavItem(
//                 svgPath: "assets/icons/majesticons_home.svg",
//                 label: "Home",
//                 index: 0),
//             buildNavItem(
//                 svgPath: "assets/icons/Vector (2).svg",
//                 label: "Learning",
//                 index: 1),
//             buildNavItem(
//                 svgPath: "assets/icons/Vector (3).svg",
//                 label: "Profile",
//                 index: 2),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildNavItem({
//     required String svgPath,
//     required String label,
//     required int index,
//   }) {
//     bool isSelected = _selectedIndex == index;

//     return GestureDetector(
//       onTap: () => _onItemTapped(index),
//       child: Container(
//         width: 80, // FIXED WIDTH so all items have same container size
//         padding: const EdgeInsets.symmetric(vertical: 7),
//         decoration: isSelected
//             ? BoxDecoration(
//                 color: AppConstants.purpleColorShade,
//                 borderRadius: BorderRadius.circular(16),
//               )
//             : null,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               width: 20,
//               height: 20,
//               child: SvgPicture.asset(
//                 svgPath,
//                 color: AppConstants.purpleColor,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Text(
//               label,
//               style: isSelected
//                   ? GoogleFonts.poppins(
//                       color: AppConstants.purpleColor,
//                       fontWeight: FontWeight.bold,
//                     )
//                   : GoogleFonts.poppins(
//                       color: AppConstants.purpleColor,
//                       fontWeight: FontWeight.w500,
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:vedalaya_app/views/learning/learning_screen.dart'; // make sure this path is correct

// class AppNavigationScreen extends StatefulWidget {
//   const AppNavigationScreen({super.key});

//   @override
//   State<AppNavigationScreen> createState() => _AppNavigationScreenState();
// }

// class _AppNavigationScreenState extends State<AppNavigationScreen> {
//   int _selectedIndex = 1; // Default selected = Learning
//   final PageController _pageController = PageController(initialPage: 1);

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     _pageController.jumpToPage(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: const [
//           Center(child: Text("Home", style: TextStyle(fontSize: 22))),
//           LearningScreen(),
//           Center(child: Text("Profile", style: TextStyle(fontSize: 22))),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.symmetric(vertical: 4.5),
//         color: Color.fromRGBO(240, 240, 240, 1),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             buildNavItem(
//               svgPath: "assets/icons/majesticons_home.svg",
//               label: "Home",
//               index: 0,
//             ),
//             buildNavItem(
//               svgPath: "assets/icons/Vector (2).svg",
//               label: "Learning",
//               index: 1,
//             ),
//             buildNavItem(
//               svgPath: "assets/icons/Vector (3).svg",
//               label: "Profile",
//               index: 2,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildNavItem({
//     required String svgPath,
//     required String label,
//     required int index,
//   }) {
//     bool isSelected = _selectedIndex == index;

//     return SizedBox(
//       width: 85,
//       height: 55,
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(15),
//           onTap: () => _onItemTapped(index),
//           child: Container(
//             decoration: isSelected
//                 ? BoxDecoration(
//                     color: AppConstants.purpleColorShade,
//                     borderRadius: BorderRadius.circular(15),
//                   )
//                 : null,
//             padding: const EdgeInsets.symmetric(vertical: 7),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: SvgPicture.asset(
//                     svgPath,
//                     color: AppConstants.purpleColor,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 Text(
//                   label,
//                   style: isSelected
//                       ? GoogleFonts.poppins(
//                           color: AppConstants.purpleColor,
//                           fontWeight: FontWeight.bold,
//                         )
//                       : GoogleFonts.poppins(
//                           color: AppConstants.purpleColor,
//                           fontWeight: FontWeight.w500,
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vedalaya_app/core/themes/app_constants.dart';
import 'package:vedalaya_app/views/learning/learning_screen.dart';
import 'package:vedalaya_app/views/learning/widgets/mylearning_screen/mylearning_screen.dart';

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({super.key});

  @override
  State<AppNavigationScreen> createState() => _AppNavigationScreenState();
}

class _AppNavigationScreenState extends State<AppNavigationScreen> {
  int _selectedIndex = 1; // Default selected = Learning
  final PageController _pageController = PageController(initialPage: 1);

  // List of screens for navigation
  static const List<Widget> _screens = [
    // Center(child: Text("Home", style: TextStyle(fontSize: 22))),
    MylearningScreen(),
    LearningScreen(),
    Center(child: Text("Profile", style: TextStyle(fontSize: 22))),
  ];

  // Navigation items data
  static const List<Map<String, dynamic>> _navItems = [
    {
      "svgPath": "assets/icons/majesticons_home.svg",
      "label": "Home",
    },
    {
      "svgPath": "assets/icons/Vector (2).svg",
      "label": "Learning",
    },
    {
      "svgPath": "assets/icons/Vector (3).svg",
      "label": "Profile",
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.5),
      color: const Color.fromRGBO(240, 240, 240, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _navItems.length,
          (index) => _buildNavItem(
            svgPath: _navItems[index]["svgPath"],
            label: _navItems[index]["label"],
            index: index,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String svgPath,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return SizedBox(
      width: 85,
      height: 55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _onItemTapped(index),
          child: Container(
            decoration: isSelected
                ? BoxDecoration(
                    color: AppConstants.purpleColorShade,
                    borderRadius: BorderRadius.circular(15),
                  )
                : null,
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(
                    svgPath,
                    color: AppConstants.purpleColor,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: AppConstants.purpleColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
