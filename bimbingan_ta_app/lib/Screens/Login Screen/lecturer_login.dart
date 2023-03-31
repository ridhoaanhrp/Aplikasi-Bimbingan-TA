import 'dart:convert';

import 'package:bimbingan_ta_app/Screens/Lecturer%20Dashboard/lecturer_dashboard.dart';
import 'package:bimbingan_ta_app/Screens/Register%20Screen/lecturer_register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturerLogin extends StatefulWidget {
  const LecturerLogin({Key? key}) : super(key: key);

  @override
  State<LecturerLogin> createState() => _LoginDosenState();
}

class _LoginDosenState extends State<LecturerLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController kodeDosenController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    var response = await http
        .post(Uri.parse('http://10.0.2.2:1337/api/lecturers/login'), body: {
      "identifier": kodeDosenController.text,
      "password": passwordController.text
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("lecturer_code", data['lecturer_code']);
      await preferences.setInt("id", data['id']);
      await preferences.setString("name", data['name']);
      await preferences.setString("lecturer_id", data['lecturer_id']);
      await preferences.setBool("isLogin", true);

      Alert(
        context: context,
        type: AlertType.success,
        title: "Login Sukses",
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
        title: "Login Gagal",
        desc: "Kode Dosen atau Password mungkin salah",
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
          padding: EdgeInsets.symmetric(
              horizontal: bodyWidth * 0.1, vertical: bodyHeight * 0.1),
          height: bodyHeight,
          width: bodyWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "picture/logoTelU.png",
                scale: 10,
              ),
              Text(
                "LOGIN",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              Text(
                "Masukkan Kode Dosen dan Password Anda",
                style: GoogleFonts.poppins(
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.black)),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: kodeDosenController,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      decoration: InputDecoration(
                          labelText: 'Masukkan Kode Dosen Anda',
                          labelStyle: const TextStyle(color: Color(0xFFE31C21)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2))),
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Kode Dosen tidak boleh kosong'
                            : null;
                      },
                    ),
                    SizedBox(
                      height: bodyHeight * 0.04,
                    ),
                    TextFormField(
                      controller: passwordController,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Masukkan Password Anda',
                          labelStyle: const TextStyle(color: Color(0xFFE31C21)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2)),
                          focusedBorder: OutlineInputBorder(
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
                      width: bodyWidth * 0.9,
                      height: bodyHeight * 0.07,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: const Color(0xFFE31C21)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login();
                            }
                          },
                          child: Center(
                            child: Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LecturerRegister()));
                      }),
                      child: Text.rich(TextSpan(
                          text: "Belum punya akun? Daftar ",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 14, color: Colors.black)),
                          children: [
                            TextSpan(
                                text: "disini",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 14, color: Color(0xFF0082FB)),
                                ))
                          ])),
                    )
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
