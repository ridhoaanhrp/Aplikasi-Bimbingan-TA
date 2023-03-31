import 'dart:convert';

import 'package:bimbingan_ta_app/Model/guidance_model.dart';
import 'package:http/http.dart' as http;

class GuidanceRepo {
  List<GuidanceModel> listGuidance = [];

  Future<List<GuidanceModel>> getGuidance(String student_id) async {
    var response = await http
        .get(Uri.parse('https://10.0.2.2:1337/api/guidance-progresses'));
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
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
}
