import 'dart:convert';

import 'package:bimbingan_ta_app/Model/lecturer_model.dart';
import 'package:bimbingan_ta_app/Model/progress_model.dart';
import 'package:bimbingan_ta_app/Repository/Lecturer%20Repository/get_lecturer_by_kode_dosen.dart';
import 'package:bimbingan_ta_app/Screens/Student%20Dashboard/students_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/akar_icons.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentRegister extends StatefulWidget {
  const StudentRegister({Key? key}) : super(key: key);

  @override
  State<StudentRegister> createState() => _RegisterMahasiswaState();
}

class _RegisterMahasiswaState extends State<StudentRegister> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController judulController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int? pembimbing1;
  int? pembimbing2;
  bool isPembimbing2 = false;
  List<LecturerModel> listPembimbing1 = [];
  List<LecturerModel> listPembimbing2 = [];

  GetLecturerByKodeDosen repoKodeDosen = GetLecturerByKodeDosen();

  Future<List<LecturerModel>> getKodeDosen1() async {
    listPembimbing1.clear();
    listPembimbing1 = await repoKodeDosen.getLecturerByKodeDosen();
    return listPembimbing1;
  }

  @override
  void initState() {
    super.initState();
    getKodeDosen1();
  }

  signUp() async {
    List<int> advisors = [];

    // if pembimbing == true  ==> true
    // if pembimbing != false ==> true

    if (isPembimbing2) {
      advisors = [pembimbing1!, pembimbing2!];
    } else {
      advisors = [pembimbing1!];
    }

    var body = json.encode({
      "data": {
        "student_id": nimController.text,
        "name": namaController.text,
        "title": judulController.text,
        "advisors": advisors,
        "password": passwordController.text
      }
    });

    var response = await http.post(
      Uri.parse('http://10.0.2.2:1337/api/students'),
      body: body,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("name", data['data']['attributes']['name']);
      await preferences.setInt("id", data['data']['id']);
      await preferences.setString(
          "student_id", data['data']['attributes']['student_id']);

      var bodyProgress1 = json.encode({
        "data": {"student": preferences.getInt("id"), "lecturer": pembimbing1}
      });

      var bodyProgress2 = json.encode({
        "data": {"student": preferences.getInt("id"), "lecturer": pembimbing2}
      });

      var addProgress1 = await http.post(
          Uri.parse('http://10.0.2.2:1337/api/progresses'),
          body: bodyProgress1,
          headers: {'Content-type': 'application/json'});

      if (isPembimbing2) {
        var addProgress2 = await http.post(
            Uri.parse('http://10.0.2.2:1337/api/progresses'),
            body: bodyProgress2,
            headers: {'Content-type': 'application/json'});
        var progressDefault2 = jsonDecode(addProgress2.body);
        print(progressDefault2);
      }
      var progressDefault1 = jsonDecode(addProgress1.body);

      print(progressDefault1);

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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          // height: bodyHeight,
          width: bodyWidth,
          padding: EdgeInsets.symmetric(
              horizontal: bodyWidth * 0.1, vertical: bodyHeight * 0.05),
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
                height: bodyHeight * 0.02,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nimController,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      decoration: InputDecoration(
                          labelText: 'Masukkan NIM Anda',
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
                        return value!.isEmpty ? 'NIM tidak boleh kosong' : null;
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
                      controller: judulController,
                      maxLines: 4,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      decoration: InputDecoration(
                          labelText: 'Masukkan Judul Proposal Anda',
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
                            ? 'Judul Proposal tidak boleh kosong'
                            : null;
                      },
                    ),
                    SizedBox(
                      height: bodyHeight * 0.02,
                    ),
                    DropdownButtonFormField(
                      menuMaxHeight: 150,
                      value: pembimbing1,
                      isExpanded: false,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      icon: const Iconify(
                        AkarIcons.chevron_down,
                        color: Color(0xFFE31C21),
                      ),
                      decoration: InputDecoration(
                          labelText: "Calon Pembimbing 1",
                          labelStyle: const TextStyle(color: Color(0xFFE31C21)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2))),
                      items: listPembimbing1
                          .map((item) => DropdownMenuItem(
                                child: Text(item.name),
                                value: item.id,
                              ))
                          .toList(),
                      onChanged: (int? value) {
                        setState(() {
                          pembimbing1 = value;
                          listPembimbing2 = listPembimbing1
                              .where((element) => element.id != value)
                              .toList();
                        });
                      },
                      onSaved: (int? value) {
                        setState(() {
                          pembimbing1 = value;
                          listPembimbing2 = listPembimbing1
                              .where((element) => element.id != value)
                              .toList();
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Calon Pembimbing 1 tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: bodyHeight * 0.02,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<int>(
                        menuMaxHeight: 150,
                        value: pembimbing2,
                        isExpanded: true,
                        style: const TextStyle(color: Color(0xFFE31C21)),
                        icon: const Iconify(
                          AkarIcons.chevron_down,
                          color: Color(0xFFE31C21),
                        ),
                        decoration: InputDecoration(
                            labelText: "Calon Pembimbing 2",
                            labelStyle:
                                const TextStyle(color: Color(0xFFE31C21)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE31C21), width: 2))),
                        items: listPembimbing2
                            .map((item) => DropdownMenuItem(
                                  child: Text(item.name),
                                  value: item.id,
                                ))
                            .toList(),
                        onChanged: (int? value) {
                          setState(() {
                            pembimbing2 = value;
                            isPembimbing2 = true;
                          });
                        },
                        onSaved: (int? value) {
                          setState(() {
                            pembimbing2 = value;
                            isPembimbing2 = true;
                          });
                          // Null check operator used on a null value
                        },
                      ),
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
                            } else if (pembimbing1 == pembimbing2) {
                              final snackBar = SnackBar(
                                content: Text(
                                  "Pembimbing 1 dan 2 Tidak Boleh Sama",
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
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
