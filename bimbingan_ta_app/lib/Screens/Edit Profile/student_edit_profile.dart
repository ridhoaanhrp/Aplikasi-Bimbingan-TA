// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:bimbingan_ta_app/Screens/Student%20Dashboard/students_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentEditProfile extends StatefulWidget {
  const StudentEditProfile({Key? key}) : super(key: key);

  @override
  State<StudentEditProfile> createState() => _StudentEditProfileState();
}

class _StudentEditProfileState extends State<StudentEditProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namaController = TextEditingController();
  TextEditingController judulController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String name = '';
  String student_id = '';

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name')!;
      student_id = preferences.getString('student_id')!;
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
      "data": {
        "name": namaController.text,
        "title": judulController.text,
        "password": passwordController.text
      }
    });
    var response = await http.put(
        Uri.parse('http://10.0.2.2:1337/api/students/$id'),
        body: body,
        headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      await preferences.setString("name", data['data']['attributes']['name']);
      await preferences.setString("title", data['data']['attributes']['title']);

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
                        builder: (context) => const StudentsDashboard()),
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
                          hintText: student_id,
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
                          hintText: name,
                          hintStyle: const TextStyle(color: Color(0xFFE31C21)),
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
                      controller: judulController,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText: "Masukkan Judul Anda",
                          hintStyle: const TextStyle(color: Color(0xFFE31C21)),
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
                            ? 'Judul tidak boleh kosong'
                            : null;
                      },
                    ),
                    SizedBox(
                      height: bodyHeight * 0.02,
                    ),
                    TextFormField(
                      controller: passwordController,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      obscureText: true,
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
                      height: bodyHeight * 0.04,
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
