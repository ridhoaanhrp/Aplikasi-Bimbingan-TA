// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:bimbingan_ta_app/Model/progress_model.dart';
import 'package:bimbingan_ta_app/Model/student_model.dart';
import 'package:bimbingan_ta_app/Screens/Introduction%20Screen/introduction_screen.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Progress%20Menu/Lecturer%20Progress%20Menu%20Component/abstrak_list_tile.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Progress%20Menu/Lecturer%20Progress%20Menu%20Component/bab1_list_tile.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Progress%20Menu/Lecturer%20Progress%20Menu%20Component/bab2_list_tile.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Progress%20Menu/Lecturer%20Progress%20Menu%20Component/bab3_list_tile.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Progress%20Menu/Lecturer%20Progress%20Menu%20Component/daftar_pustaka_list_tile.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Progress%20Menu/Lecturer%20Progress%20Menu%20Component/lecturer_progress_appBar.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Progress%20Menu/Lecturer%20Progress%20Menu%20Component/lecturer_progress_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login Screen/lecturer_login.dart';

class LecturerProgressMenu extends StatefulWidget {
  final String student_id;
  final int id;
  const LecturerProgressMenu({
    Key? key,
    required this.student_id,
    required this.id,
  }) : super(key: key);

  @override
  State<LecturerProgressMenu> createState() => _LecturerProgressMenuState();
}

class _LecturerProgressMenuState extends State<LecturerProgressMenu> {
  TextEditingController abstrakController = TextEditingController();
  TextEditingController catatanAbstrakkController = TextEditingController();
  TextEditingController bab1Controller = TextEditingController();
  TextEditingController catatanBab1Controller = TextEditingController();
  TextEditingController bab2Controller = TextEditingController();
  TextEditingController catatanBab2Controller = TextEditingController();
  TextEditingController bab3Controller = TextEditingController();
  TextEditingController catatanBab3Controller = TextEditingController();
  TextEditingController daftarPustakaController = TextEditingController();
  TextEditingController catatanDaftarPustakaController =
      TextEditingController();
  String name = '';
  String lecturer_id = '';
  int? id_progress;
  List<ProgressModel> listProgress = [];
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

  Future<StudentModel> getStudentInformation() async {
    var id_student = widget.student_id;
    var response = await http
        .get(Uri.parse('http://10.0.2.2:1337/api/students/$id_student'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return StudentModel.fromJson(data);
    } else {
      throw Exception("Failed to Load Data");
    }
  }

  Future<ProgressModel> getStudentProgress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var lecturer_code = preferences.get("lecturer_code");
    var responseForGetId =
        await http.get(Uri.parse('http://10.0.2.2:1337/api/progresses'));
    var data = jsonDecode(responseForGetId.body);
    for (Map<String, dynamic> item in data) {
      ProgressModel progress = ProgressModel.fromJson(item);
      listProgress.add(progress);
    }
    var dataId = listProgress
        .where((element) =>
            element.studentId == widget.student_id &&
            element.lecturerCode == lecturer_code)
        .toList();
    dataId.forEach((element) {
      if (element.studentId == widget.student_id &&
          element.lecturerCode == lecturer_code) {
        id_progress = element.id;
      }
    });
    var response = await http
        .get(Uri.parse('http://10.0.2.2:1337/api/progresses/$id_progress'));
    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(json);
      return ProgressModel.fromJson(json);
    } else {
      throw Exception("Failed to Load Data");
    }
  }

  @override
  void initState() {
    getPref();

    super.initState();
    getStudentInformation();
    getStudentProgress();
  }

  @override
  Widget build(BuildContext context) {
    double bodyHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    double bodyWidth = MediaQuery.of(context).size.width;

    print("id progress sebelum scaffol: $id_progress");
    return Scaffold(
      drawer: progressDrawer(
          context, bodyHeight, bodyWidth, name, lecturer_id, logOut),
      appBar: progressAppBar(context),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          width: bodyWidth,
          padding: EdgeInsets.symmetric(
              horizontal: bodyWidth * 0.05, vertical: bodyHeight * 0.03),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(bottom: bodyHeight * 0.05),
              child: FutureBuilder<StudentModel>(
                  future: getStudentInformation(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("id progress: $id_progress");
                      return Container(
                        width: bodyWidth * 0.9,
                        height: bodyHeight * 0.2,
                        padding: EdgeInsets.symmetric(
                            horizontal: bodyWidth * 0.03,
                            vertical: bodyHeight * 0.01),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 7,
                                  color: Color.fromARGB(255, 221, 110, 113),
                                  blurStyle: BlurStyle.solid)
                            ]),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Informasi Bimbingan",
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    height: bodyHeight * 0.01,
                                  ),
                                  Text(
                                    snapshot.data!.student_id,
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  Text(
                                    snapshot.data!.name,
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    snapshot.data!.title,
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: bodyHeight * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      for (var item in snapshot.data!.advisors)
                                        Card(
                                          elevation: 0,
                                          child: Container(
                                            width: bodyWidth * 0.2,
                                            height: bodyHeight * 0.04,
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFE31C21),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                                child: Text(
                                              item.lecturer_code,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            )),
                                          ),
                                        )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: FutureBuilder<ProgressModel>(
                                    future: getStudentProgress(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.connectionState ==
                                              ConnectionState.done) {
                                        print(snapshot.data!.total);
                                        print("Id nya ${snapshot.data!.id}");
                                        return Center(
                                          child: CircularPercentIndicator(
                                            radius: 60,
                                            lineWidth: 15,
                                            percent: snapshot.data!.total / 100,
                                            center: Text(
                                              "${snapshot.data!.total}%",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                            progressColor:
                                                const Color(0xFFE31C21),
                                          ),
                                        );
                                      } else if (!snapshot.hasData) {
                                        return Center(
                                          child: CircularPercentIndicator(
                                            radius: 60,
                                            lineWidth: 15,
                                            percent: 0.0,
                                            center: Text(
                                              "0%",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                            progressColor:
                                                const Color(0xFFE31C21),
                                          ),
                                        );
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }))
                          ],
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Center(
                      child: Text(
                        "Data Tidak Ada",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    );
                  }),
            ),
            FutureBuilder<ProgressModel>(
                future: getStudentProgress(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    print("Id progress note: ${snapshot.data!.progressNoteId}");
                    var abstrakValue =
                        snapshot.data!.progressModelAbstract.value;
                    var bab1Value = snapshot.data!.chapterOne.value;
                    var bab2Value = snapshot.data!.chapterTwo.value;
                    var bab3Value = snapshot.data!.chapterThree.value;
                    var daftarPustakaValue = snapshot.data!.reference.value;

                    return Column(
                      children: [
                        // AbstrakListTile(),

                        abstrakListTile(
                            context,
                            bodyWidth,
                            bodyHeight,
                            abstrakController,
                            catatanAbstrakkController,
                            snapshot.data!.progressModelAbstract.note ?? '-',
                            (abstrakValue != null) ? abstrakValue : 0),
                        bab1ListTile(
                            context,
                            bodyWidth,
                            bodyHeight,
                            bab1Controller,
                            catatanBab1Controller,
                            snapshot.data!.chapterOne.note ?? "-",
                            (bab1Value != null) ? bab1Value : 0),
                        bab2ListTile(
                            context,
                            bodyWidth,
                            bodyHeight,
                            bab2Controller,
                            catatanBab2Controller,
                            snapshot.data!.chapterTwo.note ?? "-",
                            (bab2Value != null) ? bab2Value : 0),
                        bab3ListTile(
                            context,
                            bodyWidth,
                            bodyHeight,
                            bab3Controller,
                            catatanBab3Controller,
                            snapshot.data!.chapterThree.note ?? "-",
                            (bab3Value != null) ? bab3Value : 0),
                        daftarPustakaListTile(
                            context,
                            bodyWidth,
                            bodyHeight,
                            daftarPustakaController,
                            catatanDaftarPustakaController,
                            snapshot.data!.reference.note ?? "-",
                            (daftarPustakaValue != null)
                                ? daftarPustakaValue
                                : 0),
                        SizedBox(
                          height: bodyHeight * 0.03,
                        ),
                        Container(
                          width: bodyWidth * 0.9,
                          height: bodyHeight * 0.07,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: const Color(0xFFE31C21)),
                              onPressed: () async {
                                print(
                                    "id progress value: ${snapshot.data!.progressValueId}");
                                print(
                                    "id progress note: ${snapshot.data!.progressNoteId}");
                                print("id progress : ${snapshot.data!.id}");
                                var body = json.encode({
                                  "data": {
                                    "progress_value": {
                                      "id": snapshot.data!.progressValueId,
                                      "abstract":
                                          (abstrakController.text.isEmpty)
                                              ? snapshot.data!
                                                  .progressModelAbstract.value
                                              : int.tryParse(
                                                  abstrakController.text),
                                      "chapter_one": (bab1Controller
                                              .text.isEmpty)
                                          ? snapshot.data!.chapterOne.value
                                          : int.tryParse(bab1Controller.text),
                                      "chapter_two": (bab2Controller
                                              .text.isEmpty)
                                          ? snapshot.data!.chapterTwo.value
                                          : int.tryParse(bab2Controller.text),
                                      "chapter_three": (bab3Controller
                                              .text.isEmpty)
                                          ? snapshot.data!.chapterThree.value
                                          : int.tryParse(bab3Controller.text),
                                      "reference":
                                          (daftarPustakaController.text.isEmpty)
                                              ? snapshot.data!.reference.value
                                              : int.tryParse(
                                                  daftarPustakaController.text)
                                    },
                                    "progress_note": {
                                      "id": snapshot.data!.progressNoteId,
                                      "abstract": (catatanAbstrakkController
                                              .text.isEmpty)
                                          ? snapshot
                                              .data!.progressModelAbstract.note
                                          : catatanAbstrakkController.text,
                                      "chapter_one":
                                          (catatanBab1Controller.text.isEmpty)
                                              ? snapshot.data!.chapterOne.note
                                              : catatanBab1Controller.text,
                                      "chapter_two":
                                          (catatanBab2Controller.text.isEmpty)
                                              ? snapshot.data!.chapterTwo.note
                                              : catatanBab2Controller.text,
                                      "chapter_three":
                                          (catatanBab3Controller.text.isEmpty)
                                              ? snapshot.data!.chapterThree.note
                                              : catatanBab3Controller.text,
                                      "reference":
                                          (catatanDaftarPustakaController
                                                  .text.isEmpty)
                                              ? snapshot.data!.reference.note
                                              : catatanDaftarPustakaController
                                                  .text
                                    }
                                  }
                                });
                                var response = await http.put(
                                    Uri.parse(
                                        'http://10.0.2.2:1337/api/progresses/$id_progress'),
                                    body: body,
                                    headers: {
                                      'Content-type': 'application/json'
                                    });

                                if (response.statusCode == 200) {
                                  var data = jsonDecode(response.body);
                                  print(response.body);

                                  setState(() {
                                    getStudentInformation();
                                    getStudentProgress();
                                  });
                                } else {
                                  print(response.body);
                                }
                              },
                              child: Center(
                                child: Text(
                                  "Simpan",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )),
                        ),
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                })
          ]),
        ),
      )),
    );
  }
}
