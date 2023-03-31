// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:bimbingan_ta_app/Model/guidance_model.dart';
import 'package:bimbingan_ta_app/Model/progress_model.dart';
import 'package:bimbingan_ta_app/Model/student_model.dart';
import 'package:bimbingan_ta_app/Screens/Introduction%20Screen/introduction_screen.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Guidance%20Menu/Lecturer%20Guidance%20Component/guidance_screen_appBar.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Guidance%20Menu/Lecturer%20Guidance%20Component/guidance_screen_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LecturerGuidanceMenu extends StatefulWidget {
  final String student_id;
  const LecturerGuidanceMenu({
    Key? key,
    required this.student_id,
  }) : super(key: key);

  @override
  State<LecturerGuidanceMenu> createState() => _LecturerGuidanceMenuState();
}

class _LecturerGuidanceMenuState extends State<LecturerGuidanceMenu> {
  String name = '';
  String lecturer_id = '';
  int? id_progress;
  List<GuidanceModel> listGuidance = [];
  List<ProgressModel> listProgress = [];
  List<ProgressModel> specificList = [];

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

  Future<List<GuidanceModel>> getStudentGuidance() async {
    var id_student = widget.student_id;
    var response = await http.get(
        Uri.parse('http://10.0.2.2:1337/api/guidance-progresses/$id_student'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      listGuidance.clear();
      for (Map<String, dynamic> item in data) {
        GuidanceModel guidance = GuidanceModel.fromJson(item);
        if (guidance.student.student_id == id_student.toString()) {
          listGuidance.add(guidance);
        }
      }
      return listGuidance;
    } else {
      return [];
    }
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
    getStudentGuidance();
    getStudentProgress();
  }

  @override
  Widget build(BuildContext context) {
    double bodyHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    double bodyWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: drawer(context, bodyHeight, bodyWidth, name, lecturer_id, logOut),
      appBar: appBar(context),
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
            FutureBuilder(
                future: getStudentGuidance(),
                builder:
                    (context, AsyncSnapshot<List<GuidanceModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return Container(
                      width: bodyWidth * 0.9,
                      height: bodyHeight * 0.7,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final DateFormat formatter =
                                DateFormat("dd-MMMM-yyyy");
                            final String formatted =
                                formatter.format(snapshot.data![index].date);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatted,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  height: bodyHeight * 0.04,
                                ),
                                Card(
                                  elevation: 0,
                                  child: Container(
                                    width: bodyWidth * 0.9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: bodyWidth * 0.03),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFD9E2EE),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: ExpansionTile(
                                        expandedAlignment: Alignment.topLeft,
                                        expandedCrossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        leading: const Iconify(
                                          AntDesign.file_text_outline,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                        title: Text(
                                          "Pembahasan",
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        children: [
                                          Text(
                                            "Pembahasan",
                                            style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Text(
                                            snapshot.data![index].note,
                                            maxLines: 10,
                                            style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                          SizedBox(
                                            height: bodyHeight * 0.02,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: bodyHeight * 0.01,
                                ),
                                Card(
                                  elevation: 0,
                                  child: Container(
                                    width: bodyWidth * 0.9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: bodyWidth * 0.03),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFD9E2EE),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: ExpansionTile(
                                          expandedAlignment: Alignment.topLeft,
                                          expandedCrossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          leading: const Iconify(
                                            Bi.list_check,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                          title: Text(
                                            "To Do",
                                            style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          children: [
                                            Text(
                                              "To Do",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Text(
                                              snapshot.data![index].to_do,
                                              maxLines: 10,
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                            SizedBox(
                                              height: bodyHeight * 0.02,
                                            )
                                          ]),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: bodyHeight * 0.02,
                                ),
                              ],
                            );
                          }),
                    );
                  }
                  return Center(
                    child: Text(
                      "Belum Ada Bimbingan",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  );
                })
          ]),
        ),
      )),
    );
  }
}
