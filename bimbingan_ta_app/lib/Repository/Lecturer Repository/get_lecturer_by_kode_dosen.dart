import 'dart:convert';

import 'package:bimbingan_ta_app/Model/lecturer_model.dart';
import 'package:http/http.dart' as http;

class GetLecturerByKodeDosen {
  List<LecturerModel> lecturerList = [];

  Future<List<LecturerModel>> getLecturerByKodeDosen() async {
    lecturerList.clear();
    final response =
        await http.get(Uri.parse('https://10.0.2.2:1337/api/lecturers'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> item in data) {
        LecturerModel lecturer = LecturerModel.fromJson(item);
        lecturerList.add(lecturer);
      }
      return lecturerList;
    } else {
      return [];
    }
  }
}
