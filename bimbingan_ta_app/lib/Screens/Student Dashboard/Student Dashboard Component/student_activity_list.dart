// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:bimbingan_ta_app/Model/guidance_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentActivityList extends StatefulWidget {
  const StudentActivityList({Key? key}) : super(key: key);

  @override
  State<StudentActivityList> createState() => _StudentActivityListState();
}

class _StudentActivityListState extends State<StudentActivityList> {
  List<GuidanceModel> listGuidance = [];

  Future<List<GuidanceModel>> getGuidance() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var student_id = pref.get("student_id");

    var response = await http.get(
        Uri.parse('http://10.0.2.2:1337/api/guidance-progresses/$student_id'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      listGuidance.clear();
      for (Map<String, dynamic> item in data) {
        GuidanceModel guidance = GuidanceModel.fromJson(item);
        if (guidance.student.student_id == student_id.toString()) {
          listGuidance.add(guidance);
        }
      }
      return listGuidance;
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    getGuidance();
  }

  @override
  Widget build(BuildContext context) {
    double bodyHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    double bodyWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getGuidance(),
        builder: (context, AsyncSnapshot<List<GuidanceModel>> snapshot) {
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
                    final DateFormat formatter = DateFormat("dd-MMMM-yyyy");
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
                                borderRadius: BorderRadius.circular(10)),
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
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Text(
                                    snapshot.data![index].note,
                                    maxLines: 10,
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal)),
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
                                borderRadius: BorderRadius.circular(10)),
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
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  children: [
                                    Text(
                                      "To Do",
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Text(
                                      snapshot.data![index].to_do,
                                      maxLines: 10,
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal)),
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
        });

    //
  }
}
