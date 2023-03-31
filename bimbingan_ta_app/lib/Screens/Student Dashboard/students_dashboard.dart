// ignore_for_file: non_constant_identifier_names

import 'package:bimbingan_ta_app/Screens/Edit%20Profile/student_edit_profile.dart';
import 'package:bimbingan_ta_app/Screens/Guidance/add_guidance.dart';
import 'package:bimbingan_ta_app/Screens/Introduction%20Screen/introduction_screen.dart';
import 'package:bimbingan_ta_app/Screens/Login%20Screen/student_login.dart';
import 'package:bimbingan_ta_app/Screens/Student%20Dashboard/Student%20Dashboard%20Component/student_activity_list.dart';
import 'package:bimbingan_ta_app/Screens/Student%20Dashboard/Student%20Dashboard%20Component/student_container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/ep.dart';
import 'package:iconify_flutter/icons/fluent_mdl2.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentsDashboard extends StatefulWidget {
  const StudentsDashboard({Key? key}) : super(key: key);

  @override
  State<StudentsDashboard> createState() => _StudentsDashboardState();
}

class _StudentsDashboardState extends State<StudentsDashboard> {
  String name = '';
  String student_id = '';
  String kode_dosen1 = '';
  String kode_dosen2 = '';
  String judul = '';

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name')!;
      student_id = preferences.getString('student_id')!;
    });
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
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

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double bodyHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    double bodyWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFFF4F4F4),
        child: ListView(
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
                student_id,
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
                        builder: (context) => const StudentsDashboard()));
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
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddGuidance()));
              },
              leading: const Iconify(AntDesign.file_add_outlined),
              title: Text(
                "Tambah Bimbingan",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentEditProfile()));
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
            SizedBox(
              height: bodyHeight * 0.4,
            ),
            Padding(
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
                        builder: (cotnext) => const StudentEditProfile()));
              })
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          width: bodyWidth,
          padding: EdgeInsets.symmetric(
              horizontal: bodyWidth * 0.05, vertical: bodyHeight * 0.03),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(bottom: bodyHeight * 0.05),
              child: const StudentContainer(),
            ),
            const StudentActivityList()
          ]),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE31C21),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddGuidance()));
        },
        child: const Iconify(
          FluentMdl2.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
