// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert';

import 'package:bimbingan_ta_app/Model/guidance_model.dart';
import 'package:bimbingan_ta_app/Model/lecturer_model.dart';
import 'package:bimbingan_ta_app/Model/progress_model.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Guidance%20Menu/lecturer_guidance_menu.dart';
import 'package:bimbingan_ta_app/Screens/Lecturer%20Progress%20Menu/lecturer_progress_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<ProgressModel> listProgress = [];
  List<ProgressModel> specificList = [];

  Future<LecturerModel> getListOfStudent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var progressList = await getStudentProgress();

    var lecturer_code = preferences.get("lecturer_code");
    var response = await http
        .get(Uri.parse('http://10.0.2.2:1337/api/lecturers/$lecturer_code'));
    var data = jsonDecode(response.body);

    var object = LecturerModel.fromJson(data);

    for (var element in object.students) {
      var progress = progressList.firstWhere((item) =>
          item.studentId == element.student_id &&
          item.lecturerId == object.lecturer_id);

      element.total_score = progress.total;
    }

    if (response.statusCode == 200) {
      return LecturerModel.fromJson(data);
    } else {
      throw Exception("Failed to Load Data");
    }
  }

  Future<List<ProgressModel>> getStudentProgress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var lecturer_code = preferences.get("lecturer_code");
    var response =
        await http.get(Uri.parse('https://10.0.2.2:1337/api/progresses'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      listProgress.clear();
      specificList.clear();
      for (Map<String, dynamic> item in data) {
        ProgressModel progress = ProgressModel.fromJson(item);
        listProgress.add(progress);
      }
      var listData = listProgress
          .where((element) => element.lecturerCode == lecturer_code)
          .toList();
      specificList.addAll(listData);
      for (var element in specificList) {
        print("Total: ${element.total}");
      }
      return specificList;
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    getStudentProgress();
    getListOfStudent();
  }

  @override
  Widget build(BuildContext context) {
    double bodyHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    double bodyWidth = MediaQuery.of(context).size.width;

    return Container(
      width: bodyWidth,
      child: FutureBuilder<LecturerModel>(
          future: getListOfStudent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.students.length,
                itemBuilder: (context, index) {
                  var id = snapshot.data!.students[index].id;
                  var total = snapshot.data!.students[index].total_score;
                  print(total);
                  var percent;
                  if (total != null) {
                    print("succed");
                    percent = total as int;
                  } else {
                    print("failed");
                    percent = 0 as int;
                  }
                  return Card(
                    elevation: 0,
                    child: Container(
                      width: bodyWidth * 0.9,
                      height: bodyHeight * 0.24,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                                      snapshot.data!.students[index].student_id,
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                    Text(
                                      snapshot.data!.students[index].name,
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      snapshot.data!.students[index].title,
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
                                        for (var item in snapshot
                                            .data!.students[index].advisors!)
                                          Card(
                                            elevation: 0,
                                            child: Container(
                                              width: bodyWidth * 0.2,
                                              height: bodyHeight * 0.04,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      width: 2,
                                                      color: const Color(
                                                          0xFFE31C21)),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                  child: Text(
                                                item,
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFFE31C21),
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              )),
                                            ),
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: bodyWidth * 0.25,
                                  height: bodyHeight * 0.035,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFFE31C21),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3))),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LecturerGuidanceMenu(
                                                    student_id: snapshot
                                                        .data!
                                                        .students[index]
                                                        .student_id,
                                                  )));
                                    },
                                    child: Center(
                                        child: Text(
                                      "Bimbingan",
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: bodyWidth * 0.01,
                              ),
                              Expanded(
                                child: Container(
                                  width: bodyWidth * 0.25,
                                  height: bodyHeight * 0.035,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFFE31C21),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3))),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LecturerProgressMenu(
                                                      student_id: snapshot
                                                          .data!
                                                          .students[index]
                                                          .student_id,
                                                      id: snapshot
                                                          .data!
                                                          .students[index]
                                                          .id)));
                                    },
                                    child: Center(
                                        child: Text(
                                      "Progress",
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasData) {
              return Center(
                child: Text(
                  "Belum Ada Mahasiswa yang di Bimbing",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
