// ignore_for_file: non_constant_identifier_names

import 'package:bimbingan_ta_app/Screens/Edit%20Profile/lecturer_edit_profile.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Dashboard/lecturer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/fluent_mdl2.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';

Widget progressDrawer(BuildContext context, double bodyHeight, double bodyWidth,
    String name, String lecturer_id, dynamic Function() logOut) {
  return Drawer(
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
  );
}
