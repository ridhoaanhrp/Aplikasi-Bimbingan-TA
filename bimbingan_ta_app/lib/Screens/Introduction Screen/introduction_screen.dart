// ignore_for_file: unused_import

import 'package:bimbingan_ta_app/Screens/Lecturer%20Dashboard/lecturer_dashboard.dart';
import 'package:bimbingan_ta_app/Screens/Login%20Screen/lecturer_login.dart';
import 'package:bimbingan_ta_app/Screens/Login%20Screen/student_login.dart';
import 'package:bimbingan_ta_app/Screens/Student%20Dashboard/students_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double bodyHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double bodyWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: bodyWidth * 0.1),
        width: bodyWidth,
        height: bodyHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "picture/logoTelU.png",
              scale: 10,
            ),
            SizedBox(
              height: bodyHeight * 0.07,
            ),
            Text(
              "Bimbingan Proposal TA",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            SizedBox(
              height: bodyHeight * 0.1,
            ),
            Container(
              width: bodyWidth * 0.9,
              height: bodyHeight * 0.07,
              decoration: BoxDecoration(
                  color: const Color(0xFFE31C21),
                  borderRadius: BorderRadius.circular(10)),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFE31C21),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const StudentLogin())));
                  },
                  child: Center(
                    child: Text(
                      "Mahasiswa",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  )),
            ),
            SizedBox(
              height: bodyHeight * 0.05,
            ),
            Container(
              width: bodyWidth * 0.9,
              height: bodyHeight * 0.07,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      primary: const Color(0xFFE31C21)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const LecturerLogin())));
                  },
                  child: Center(
                    child: Text(
                      "Dosen",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
