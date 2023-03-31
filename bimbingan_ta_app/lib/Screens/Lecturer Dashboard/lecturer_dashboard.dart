// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:bimbingan_ta_app/Model/lecturer_model.dart';
import 'package:bimbingan_ta_app/Screens/Edit%20Profile/lecturer_edit_profile.dart';
import 'package:bimbingan_ta_app/Screens/Introduction%20Screen/introduction_screen.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Dashboard/Lecturer%20Dashboard%20Component/student_list.dart';
import 'package:bimbingan_ta_app/Screens/Login%20Screen/lecturer_login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/ep.dart';
import 'package:iconify_flutter/icons/fluent_mdl2.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LecturerDashboard extends StatefulWidget {
  const LecturerDashboard({Key? key}) : super(key: key);

  @override
  State<LecturerDashboard> createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard> {
  String name = '';
  String lecturer_id = '';

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name')!;
      lecturer_id = preferences.getString('lecturer_id')!;
    });
  }

  logOut() async {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Konfirmasi Logout",
      desc: "Anda Yakin Ingin Logout?",
      style: const AlertStyle(
        descStyle: TextStyle(
            fontSize: 13,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w800),
      ),
      buttons: [
        DialogButton(
            color: const Color(0xFFE31C21),
            child: const Text(
              "Ya",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w800),
            ),
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const IntroductionScreen()),
                  (route) => false);
            }),
        DialogButton(
            color: const Color(0xFFE31C21),
            child: const Text(
              "Tidak",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w800),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    ).show();
  }

  Future<LecturerModel> getListOfStudent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var lecturer_code = preferences.get("lecturer_code");
    var response = await http
        .get(Uri.parse('http://10.0.2.2:1337/api/lecturers/$lecturer_code'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LecturerModel.fromJson(data);
    } else {
      throw Exception("Failed to Load Data");
    }
  }

  @override
  void initState() {
    getPref();
    super.initState();
    getListOfStudent();
  }

  @override
  Widget build(BuildContext context) {
    double bodyHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    double bodyWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        backgroundColor: const Color(0xFFF4F4F4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
                padding: EdgeInsets.symmetric(horizontal: bodyWidth * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Iconify(
                        Bi.x,
                        size: 40,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          "picture/logoTelU.png",
                          scale: 20,
                        ),
                        Text(
                          "Aplikasi Bimbingan TA",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        )
                      ],
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: bodyWidth * 0.04),
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: bodyWidth * 0.04),
              child: Text(
                lecturer_id,
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ),
            SizedBox(
              height: bodyHeight * 0.04,
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LecturerDashboard()));
              },
              leading: const Iconify(IconParkOutline.all_application),
              title: Text(
                "Dashboard",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ),
            Expanded(
              flex: 3,
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LecturerEditProfile()));
                },
                leading: const Iconify(FluentMdl2.settings),
                title: Text(
                  "Edit Profil",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ),
            ),
            SizedBox(
              height: bodyHeight * 0.2,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: bodyWidth * 0.04),
                child: Container(
                  width: bodyWidth * 0.7,
                  height: bodyHeight * 0.07,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE31C21),
                      borderRadius: BorderRadius.circular(10)),
                  child: ElevatedButton(
                      onPressed: () {
                        logOut();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFE31C21),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Center(
                        child: Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFFE31C21),
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        actions: [
          IconButton(
              icon: const Iconify(
                Ep.setting,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LecturerEditProfile()));
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: getListOfStudent,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            width: bodyWidth,
            height: bodyHeight,
            padding: EdgeInsets.symmetric(
                horizontal: bodyWidth * 0.05, vertical: bodyHeight * 0.03),
            child: const StudentList(),
          ),
        )),
      ),
    );
  }
}
