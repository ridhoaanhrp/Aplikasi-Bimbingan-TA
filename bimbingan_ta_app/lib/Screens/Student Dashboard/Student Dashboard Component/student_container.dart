// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:bimbingan_ta_app/Model/progress_model.dart';
import 'package:bimbingan_ta_app/Model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentContainer extends StatefulWidget {
  const StudentContainer({Key? key}) : super(key: key);

  @override
  State<StudentContainer> createState() => _StudentContainerState();
}

class _StudentContainerState extends State<StudentContainer> {
  List<StudentModel> studentList = [];
  List<ProgressModel> listProgress = [];
  List<ProgressModel> listProgressByNim = [];
  int? id_progress;
  double? total_average;

  Future<StudentModel> getStudent() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var student_id = pref.get("student_id");
    var response = await http
        .get(Uri.parse('http://10.0.2.2:1337/api/students/$student_id'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(data);
      return StudentModel.fromJson(data);
    } else {
      throw Exception("Failed to Load Data");
    }
  }

  Future<List<ProgressModel>> getProgress() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var student_id = pref.get("student_id");

    var responseToGetProgressId =
        await http.get(Uri.parse('https://10.0.2.2:1337/api/progresses'));
    var dataProgress = jsonDecode(responseToGetProgressId.body);

    if (responseToGetProgressId.statusCode == 200) {
      for (Map<String, dynamic> item in dataProgress) {
        ProgressModel progress = ProgressModel.fromJson(item);
        listProgress.add(progress);
      }
      var getProgressByNim = listProgress
          .where((element) => element.studentId == student_id)
          .toList();
      listProgressByNim.addAll(getProgressByNim);
      print(listProgressByNim.length);
      return listProgressByNim;
    } else {
      return [];
    }
  }

  Future<double> averageTotal() async {
    List<ProgressModel> list = await getProgress();
    double totalAverage = list
            .map((e) => e.total)
            .toList()
            .reduce((value, element) => value + element) /
        list.length;
    print(totalAverage);
    return totalAverage;
  }

  @override
  void initState() {
    super.initState();
    getStudent();
    getProgress();
  }

  @override
  Widget build(BuildContext context) {
    double bodyHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    double bodyWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<StudentModel>(
      future: getStudent(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: bodyWidth * 0.9,
            height: bodyHeight * 0.2,
            padding: EdgeInsets.symmetric(
                horizontal: bodyWidth * 0.03, vertical: bodyHeight * 0.01),
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
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text(
                                  item.lecturer_code,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal)),
                                )),
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: FutureBuilder<double>(
                        future: averageTotal(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            print(snapshot.data!);
                            return Center(
                              child: CircularPercentIndicator(
                                radius: 60,
                                lineWidth: 15,
                                percent: snapshot.data! / 100,
                                center: Text(
                                  "${snapshot.data!}%",
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600)),
                                ),
                                progressColor: const Color(0xFFE31C21),
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
                                          fontWeight: FontWeight.w600)),
                                ),
                                progressColor: const Color(0xFFE31C21),
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
        } else if (snapshot.connectionState == ConnectionState.waiting) {
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
      },
    );
  }
}
