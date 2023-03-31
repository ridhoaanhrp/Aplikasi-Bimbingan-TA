import 'dart:convert';

import 'package:bimbingan_ta_app/Screens/Lecturer%20Dashboard/lecturer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturerRegister extends StatefulWidget {
  const LecturerRegister({Key? key}) : super(key: key);

  @override
  State<LecturerRegister> createState() => _RegisterDosenState();
}

class _RegisterDosenState extends State<LecturerRegister> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nipController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController kodeDosenController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signUp() async {
    var body = json.encode({
      "data": {
        "lecturer_id": nipController.text,
        "lecturer_code": kodeDosenController.text,
        "name": namaController.text,
        "password": passwordController.text
      }
    });
    var response = await http.post(
        Uri.parse('http://10.0.2.2:1337/api/lecturers'),
        body: body,
        headers: {'Content-type': 'application/json'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(
          "lecturer_code", data['data']['attributes']['lecturer_code']);
      await preferences.setInt("id", data['data']['id']);
      await preferences.setString("name", data['data']['attributes']['name']);
      await preferences.setString(
          "lecturer_id", data['data']['attributes']['lecturer_id']);
      await preferences.setBool("isLogin", true);
      Alert(
        context: context,
        type: AlertType.success,
        title: "Registrasi Sukses",
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
        title: "Registrasi Gagal",
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
              horizontal: bodyWidth * 0.1, vertical: bodyHeight * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Registrasi",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              SizedBox(
                height: bodyHeight * 0.03,
              ),
              Text(
                "Lengkapi Data Diri Anda di Bawah Ini",
                style: GoogleFonts.poppins(
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.black)),
              ),
              SizedBox(
                height: bodyHeight * 0.12,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nipController,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      decoration: InputDecoration(
                          labelText: 'Masukkan NIP Anda',
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
                        return value!.isEmpty ? 'NIP tidak boleh kosong' : null;
                      },
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
                            ? 'Nama tidak boleh kosong'
                            : null;
                      },
                    ),
                    SizedBox(
                      height: bodyHeight * 0.02,
                    ),
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
                      height: bodyHeight * 0.02,
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
                      width: bodyWidth * 0.8,
                      height: bodyHeight * 0.07,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: const Color(0xFFE31C21)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signUp();
                            }
                          },
                          child: Center(
                            child: Text(
                              "Register",
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
