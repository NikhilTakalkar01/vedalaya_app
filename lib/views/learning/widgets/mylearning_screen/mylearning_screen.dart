import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vedalaya_app/views/learning/learning_screen.dart';

class MylearningScreen extends StatefulWidget {
  const MylearningScreen({super.key});

  @override
  State<MylearningScreen> createState() => _MylearningScreenState();
}

int index = 5;

class _MylearningScreenState extends State<MylearningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 25,
            )),
        title: Text(
          "My Learning",
          style: GoogleFonts.poppins(
              color: Color.fromRGBO(101, 101, 101, 1),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: Get.height * 0.03),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _star("assets/icons/star1.png", "The Seeker", "Achieved"),
                  _star(
                      "assets/icons/star1.png", "The Listener", "Unlock in 5"),
                  _star("assets/icons/star1.png", "The Sage", "Unlock in 5"),
                  _star("assets/icons/star1.png", "First Flame", "Unlock in 5"),
                  _star("assets/icons/star1.png", "First Flame", "Unlock in 5"),
                  _star("assets/icons/star1.png", "First Flame", "Unlock in 5"),
                  _star("assets/icons/star1.png", "First Flame", "Unlock in 5"),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: Get.width * 0.05,
                right: Get.width * 0.05,
                top: Get.height * 0.03),
            child: Column(
              children: [
                Text("My Courses",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w800)),
                SizedBox(
                  height: Get.height * 0.02,
                )
              ],
            ),
          ),
          Divider(
            height: Get.height * 0.001,
            color: Colors.black,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: index,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    _card(index),
                    Divider(
                      height: Get.height * 0.001,
                      color: Colors.black,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _star(String icon, String name, String achievement) {
    return Padding(
      padding:
          EdgeInsets.only(left: Get.width * 0.025, right: Get.width * 0.04),
      child: Column(
        children: [
          Image.asset(
            icon,
          ),
          SizedBox(
            height: Get.height * 0.005,
          ),
          Text(name,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(
            height: Get.height * 0.001,
          ),
          Text(
            achievement,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.green),
          )
        ],
      ),
    );
  }

  Widget _card(int index) {
    return Padding(
      padding: EdgeInsets.only(
        left: Get.width * 0.025,
        right: Get.width * 0.03,
        top: Get.width * 0.02,
        bottom: Get.width * 0.02,
      ),
      child: Row(
        children: [
          Container(
            height: Get.height * 0.07,
            width: Get.width * 0.28,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: Colors.black)),
            child: Image.asset(
              "assets/icons/hanumanji.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: Get.width * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hanuman Chalisa",
                style: GoogleFonts.poppins(
                    color: Color.fromRGBO(30, 30, 30, 1),
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "(2/9 Lessons Completed)",
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Color.fromRGBO(30, 30, 30, 0.5),
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(
            width: Get.width * 0.03,
          ),
          SizedBox(
            height: Get.height * 0.036,
            width: Get.width * 0.24,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // padding: EdgeInsets.only(left: 20, right: 20),

                  backgroundColor: (index == 0 || index == 1)
                      ? Color.fromRGBO(213, 213, 213, 0.35)
                      : Color.fromRGBO(74, 0, 179, 1),
                  // backgroundColor: AppConstants.purpleColor,
                  shadowColor: (index == 0 || index == 1)
                      ? Color.fromRGBO(74, 0, 179, 1)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  (index == 0 || index == 1)
                      ? Get.to(LearningScreen())
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please Complete Above lessons',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red[400],
                          ),
                        );

                  setState(() {});
                },
                child: Center(
                  child: Text(
                    (index == 0 || index == 1) ? "Resume" : "Start",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
