// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
// To parse this JSON data, do
//
//     final studentModel = studentModelFromJson(jsonString);

import 'dart:convert';

StudentModel studentModelFromJson(String str) =>
    StudentModel.fromJson(json.decode(str));

String studentModelToJson(StudentModel data) => json.encode(data.toJson());

class StudentModel {
  StudentModel({
    required this.id,
    required this.name,
    required this.student_id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.advisors,
  });

  int id;
  String name;
  String student_id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  List<Advisor> advisors;

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        id: json["id"],
        name: json["name"],
        student_id: json["student_id"],
        title: json["title"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        advisors: List<Advisor>.from(
            json["advisors"].map((x) => Advisor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "student_id": student_id,
        "title": title,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "advisors": List<dynamic>.from(advisors.map((x) => x.toJson())),
      };
}

class Advisor {
  Advisor({
    required this.id,
    required this.lecturer_id,
    required this.lecturer_code,
    required this.name,
  });

  int id;
  String lecturer_id;
  String lecturer_code;
  String name;

  factory Advisor.fromJson(Map<String, dynamic> json) => Advisor(
        id: json["id"],
        lecturer_id: json["lecturer_id"],
        lecturer_code: json["lecturer_code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lecturer_id": lecturer_id,
        "lecturer_code": lecturer_code,
        "name": name,
      };
}



// import 'dart:convert';

// import 'package:bimbingan_ta_app/Model/lecturer_model.dart';

// class StudentModel {
//   final int id;
//   final String name;
//   final String title;
//   final String student_id;
//   List<LecturerModel> advisors;
//   final DateTime created_at;
//   final DateTime updated_at;

//   StudentModel({
//     required this.id,
//     required this.name,
//     required this.student_id,
//     required this.title,
//     required this.created_at,
//     required this.updated_at,
//     required this.advisors,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//       'title': title,
//       'student_id': student_id,
//       'advisors': advisors.map((x) => x.toMap()).toList(),
//       'created_at': created_at.millisecondsSinceEpoch,
//       'updated_at': updated_at.millisecondsSinceEpoch,
//     };
//   }

//   factory StudentModel.fromMap(Map<String, dynamic> map) {
//     return StudentModel(
//       id: map['id'] as int,
//       name: map['name'] as String,
//       title: map['title'] as String,
//       student_id: map['student_id'] as String,
//       advisors: List<LecturerModel>.from(
//         (map['advisors'] as List<int>).map<LecturerModel>(
//           (x) => LecturerModel.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//       created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
//       updated_at: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory StudentModel.fromJson(String source) =>
//       StudentModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }

// class Advisors {
//   final int id;
//   final String lecturer_id;
//   final String lecturer_code;
//   final String name;
//   Advisors({
//     required this.id,
//     required this.lecturer_id,
//     required this.lecturer_code,
//     required this.name,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'lecturer_id': lecturer_id,
//       'lecturer_code': lecturer_code,
//       'name': name,
//     };
//   }

//   factory Advisors.fromMap(Map<String, dynamic> map) {
//     return Advisors(
//       id: map['id'] as int,
//       lecturer_id: map['lecturer_id'] as String,
//       lecturer_code: map['lecturer_code'] as String,
//       name: map['name'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Advisors.fromJson(String source) =>
//       Advisors.fromMap(json.decode(source) as Map<String, dynamic>);
// }

// class StudentModel {
//   final int id;
//   final String kode_dosen1;
//   final String judul;
//   final String kode_dosen2;
//   final String nama;
//   final String nim;
//   final String created_at;
//   final String updated_at;

//   StudentModel({
//     required this.id,
//     required this.kode_dosen1,
//     required this.kode_dosen2,
//     required this.judul,
//     required this.nama,
//     required this.nim,
//     required this.created_at,
//     required this.updated_at,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'kode_dosen1': kode_dosen1,
//       'kode_dosen2': kode_dosen2,
//       'judul': judul,
//       'nama': nama,
//       'nim': nim,
//       'created_at': created_at,
//       'updated_at': updated_at,
//     };
//   }

//   factory StudentModel.fromMap(Map<String, dynamic> map) {
//     return StudentModel(
//       id: map['id'] as int,
//       kode_dosen1: map['kode_dosen1'] as String,
//       kode_dosen2: map['kode_dosen2'] as String,
//       judul: map['judul'] as String,
//       nama: map['nama'] as String,
//       nim: map['nim'] as String,
//       created_at: map['created_at'] as String,
//       updated_at: map['updated_at'] as String,
//     );
//   }

//   factory StudentModel.fromJson(Map<String, dynamic> json) {
//     var data = StudentModel(
//         id: json["id"],
//         kode_dosen1: json["kode_dosen1"],
//         kode_dosen2: json["kode_dosen2"],
//         judul: json["judul"],
//         nama: json["nama"],
//         nim: json["nim"],
//         created_at: json["created_at"],
//         updated_at: json["updated_at"]);
//     return data;
//   }
// }
