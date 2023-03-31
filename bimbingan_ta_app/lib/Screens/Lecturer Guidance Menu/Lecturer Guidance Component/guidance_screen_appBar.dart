// ignore_for_file: file_names

import 'package:bimbingan_ta_app/Screens/Edit%20Profile/lecturer_edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ep.dart';

PreferredSizeWidget appBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 80,
    backgroundColor: const Color(0xFFE31C21),
    centerTitle: true,
    title: Text(
      "Bimbingan",
      style: GoogleFonts.poppins(
          textStyle: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                    builder: (cotnext) => const LecturerEditProfile()));
          })
    ],
  );
}
