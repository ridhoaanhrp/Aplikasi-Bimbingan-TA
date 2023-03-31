// ignore_for_file: unused_import, non_constant_identifier_names

import 'dart:convert';

import 'package:bimbingan_ta_app/Screens/Lecturer%20Dashboard/lecturer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LecturerEditProfile extends StatefulWidget {
  const LecturerEditProfile({Key? key}) : super(key: key);

  @override
  State<LecturerEditProfile> createState() => _LecturerEditProfileState();
}

class _LecturerEditProfileState extends State<LecturerEditProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namaController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String name = '';
  String lecturer_id = '';
  String lecturer_code = '';

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name')!;
      lecturer_id = preferences.getString('lecturer_id')!;
      lecturer_code = preferences.getString('lecturer_code')!;
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  editProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getInt('id');
    var body = json.encode({
      "data": {"name": namaController.text, "password": passwordController.text}
    });
    var response = await http.put(
        Uri.parse('http://10.0.2.2:1337/api/lecturers/$id'),
        body: body,
        headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      await preferences.setString("name", data['data']['attributes']['name']);

      Alert(
        context: context,
        type: AlertType.success,
        title: "Edit Profil Sukses",
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
                "Okay",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w800),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LecturerDashboard()),
                    (route) => false);
              })
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        style: const AlertStyle(
            descStyle: TextStyle(fontSize: 13, fontFamily: "Montserrat"),
            titleStyle: TextStyle(
                fontSize: 23,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w800)),
        title: "Edit Profil Gagal",
        desc: "Data yang anda input mungkin tidak tepat",
        buttons: [
          DialogButton(
              color: const Color(0xFFE31C21),
              child: const Text(
                "Kembali",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: "Montserrat"),
              ),
              onPressed: () => Navigator.pop(context))
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    double bodyHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double bodyWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: bodyHeight,
          width: bodyWidth,
          padding: EdgeInsets.symmetric(
              horizontal: bodyWidth * 0.1, vertical: bodyHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Profil",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              SizedBox(
                height: bodyHeight * 0.05,
              ),
              Text(
                "Silahkan Masukkan Data yang Ingin di Edit",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
              ),
              SizedBox(
                height: bodyHeight * 0.08,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          hintText: lecturer_id,
                          hintStyle: const TextStyle(color: Color(0xFFE31C21)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2))),
                    ),
                    SizedBox(
                      height: bodyHeight * 0.02,
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          hintText: lecturer_code,
                          hintStyle: const TextStyle(color: Color(0xFFE31C21)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2))),
                    ),
                    SizedBox(
                      height: bodyHeight * 0.02,
                    ),
                    TextFormField(
                      controller: namaController,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      decoration: InputDecoration(
                          labelText: 'Masukkan Nama Anda',
                          labelStyle: const TextStyle(color: Color(0xFFE31C21)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2))),
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Nama tidak boleh kosong'
                            : null;
                      },
                    ),
                    SizedBox(
                      height: bodyHeight * 0.02,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      decoration: InputDecoration(
                          labelText: 'Masukkan Password Anda',
                          labelStyle: const TextStyle(color: Color(0xFFE31C21)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2))),
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Password tidak boleh kosong'
                            : null;
                      },
                    ),
                    SizedBox(
                      height: bodyHeight * 0.07,
                    ),
                    Container(
                      width: bodyWidth * 0.8,
                      height: bodyHeight * 0.07,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: const Color(0xFFE31C21)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              editProfile();
                            }
                          },
                          child: Center(
                            child: Text(
                              "Edit",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: bodyHeight * 0.02,
                    ),
                    Container(
                      width: bodyWidth * 0.8,
                      height: bodyHeight * 0.07,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: const Color(0xFFE31C21)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
