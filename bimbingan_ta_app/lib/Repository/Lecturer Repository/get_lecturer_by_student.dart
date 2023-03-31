import 'package:bimbingan_ta_app/Model/student_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetLecturerByStudent {
  List<StudentModel> lecturerList = [];

  Future<List<StudentModel>> getLecturerByNim() async {
    lecturerList.clear();
    final response = await http.get(Uri.parse('https://10.0.2.2:1337/api/m'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> item in data) {
        StudentModel student = StudentModel.fromJson(item);
        lecturerList.add(student);
      }
      return lecturerList;
    } else {
      return [];
    }
  }
}
