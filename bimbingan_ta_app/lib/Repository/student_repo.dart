import 'dart:convert';

import 'package:bimbingan_ta_app/Model/student_model.dart';
import 'package:http/http.dart' as http;

class StudentRepo {
  List<StudentModel> studentList = [];

  // Future<List<StudentModel>> getStudent(String student_id) async {
  //   studentList.clear();
  //   var response = await http
  //       .get(Uri.parse('https://bimbingan-proposal-ta.herokuapp.com/api/m'));
  //   var data = jsonDecode(response.body.toString());

  //   if (response.statusCode == 200) {
  //     for (Map<String, dynamic> item in data) {
  //       StudentModel studentModel = StudentModel.fromJson(item);
  //       if (studentModel.student_id == nim) {
  //         studentList.clear();
  //         studentList.add(studentModel);
  //       }
  //     }
  //     return studentList;
  //   } else {
  //     throw Exception("failed to load data");
  //   }
  // }
}
