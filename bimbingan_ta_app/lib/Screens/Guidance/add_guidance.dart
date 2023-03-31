// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:bimbingan_ta_app/Model/student_model.dart';
import 'package:bimbingan_ta_app/Screens/Student%20Dashboard/students_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/akar_icons.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddGuidance extends StatefulWidget {
  const AddGuidance({Key? key}) : super(key: key);

  @override
  State<AddGuidance> createState() => _AddGuidanceState();
}

class _AddGuidanceState extends State<AddGuidance> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController tanggalBimbinganController = TextEditingController();
  TextEditingController catatanController = TextEditingController();
  TextEditingController toDoController = TextEditingController();

  int? namaPembimbing;
  List<Advisor> listPembimbing = [];

  Future<List<Advisor>> getLecturer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var student_id = pref.get("student_id");

    var response = await http
        .get(Uri.parse('http://10.0.2.2:1337/api/students/$student_id'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      listPembimbing.clear();
      StudentModel studentModel = StudentModel.fromJson(data);
      for (Map<String, dynamic> i in data['advisors']) {
        if (studentModel.student_id == student_id) {
          Advisor advisor = Advisor.fromJson(i);
          listPembimbing.add(advisor);
        }
      }

      return listPembimbing;
    } else {
      throw Exception("Failed to Load Data");
    }
  }

  @override
  void initState() {
    super.initState();
    getLecturer();
  }

  addGuidance() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getInt("id");
    var body = json.encode({
      "data": {
        "note": catatanController.text,
        "to_do": toDoController.text,
        "student": id,
        "lecturer": namaPembimbing,
        "date": tanggalBimbinganController.text
      }
    });
    var response = await http.post(
        Uri.parse('http://10.0.2.2:1337/api/guidance-progresses'),
        body: body,
        headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Tambah Bimbingan Sukses",
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
        title: "Tambah Bimbingan Gagal",
        desc: "Silahkan Periksa Lagi Data yang di Inputkan",
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
          width: bodyWidth,
          padding: EdgeInsets.symmetric(
              horizontal: bodyWidth * 0.1, vertical: bodyHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tambah Bimbingan",
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
                "Lengkapi Data Bimbingan di Bawah Ini",
                style: GoogleFonts.poppins(
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.black)),
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
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2017),
                            lastDate: DateTime(2150));
                        if (pickedDate != null) {
                          String formatDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);

                          setState(() {
                            tanggalBimbinganController.text = formatDate;
                          });
                        }
                      },
                      controller: tanggalBimbinganController,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      decoration: InputDecoration(
                          labelText: 'Masukkan Tanggal Bimbingan',
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
                            ? 'Tanggal Bimbingan tidak boleh kosong'
                            : null;
                      },
                    ),
                    SizedBox(
                      height: bodyHeight * 0.02,
                    ),
                    DropdownButtonFormField(
                      menuMaxHeight: 150,
                      value: namaPembimbing,
                      isExpanded: false,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      icon: const Iconify(
                        AkarIcons.chevron_down,
                        color: Color(0xFFE31C21),
                      ),
                      decoration: InputDecoration(
                          labelText: "Nama Pembimbing",
                          labelStyle: const TextStyle(color: Color(0xFFE31C21)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFFE31C21), width: 2))),
                      items: listPembimbing
                          .map((item) => DropdownMenuItem(
                                child: Text(item.name),
                                value: item.id,
                              ))
                          .toList(),
                      onChanged: (int? value) {
                        setState(() {
                          namaPembimbing = value;
                        });
                      },
                      onSaved: (int? value) {
                        setState(() {
                          namaPembimbing = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Nama Pembimbing tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: bodyHeight * 0.02,
                    ),
                    TextFormField(
                      maxLines: 3,
                      controller: catatanController,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      decoration: InputDecoration(
                          labelText: 'Masukkan Catatan',
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
                    ),
                    SizedBox(
                      height: bodyHeight * 0.02,
                    ),
                    TextFormField(
                      maxLines: 3,
                      controller: toDoController,
                      style: const TextStyle(color: Color(0xFFE31C21)),
                      decoration: InputDecoration(
                          labelText: 'Masukkan To Do List',
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
                              addGuidance();
                            }
                          },
                          child: Center(
                            child: Text(
                              "Tambah",
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
