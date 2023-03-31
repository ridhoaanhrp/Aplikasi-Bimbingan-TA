// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
// To parse this JSON data, do
//
//     final lecturerModel = lecturerModelFromJson(jsonString);

import 'dart:convert';

LecturerModel lecturerModelFromJson(String str) =>
    LecturerModel.fromJson(json.decode(str));

String lecturerModelToJson(LecturerModel data) => json.encode(data.toJson());

class LecturerModel {
  LecturerModel(
      {required this.id,
      required this.lecturer_id,
      required this.lecturer_code,
      required this.name,
      required this.created_at,
      required this.updated_at,
      required this.students});

  int id;
  String lecturer_id;
  String lecturer_code;
  String name;
  DateTime created_at;
  DateTime updated_at;
  List<Student> students;

  factory LecturerModel.fromJson(Map<String, dynamic> json) => LecturerModel(
        id: json["id"],
        lecturer_id: json["lecturer_id"],
        lecturer_code: json["lecturer_code"],
        name: json["name"],
        created_at: DateTime.parse(json["created_at"]),
        updated_at: DateTime.parse(json["updated_at"]),
        students: List<Student>.from(
            json["students"].map((x) => Student.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lecturer_id": lecturer_id,
        "lecturer_code": lecturer_code,
        "name": name,
        "created_at": created_at.toIso8601String(),
        "updated_at": updated_at.toIso8601String(),
        "students": List<dynamic>.from(students.map((x) => x.toJson())),
      };
}

class Student {
  Student(
      {required this.id,
      required this.name,
      required this.student_id,
      required this.title,
      this.advisors,
      this.total_score});

  int id;
  String name;
  String student_id;
  String title;
  List<String>? advisors;
  int? total_score;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        name: json["name"],
        student_id: json["student_id"],
        title: json["title"],
        advisors: List<String>.from(json["advisors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "student_id": student_id,
        "title": title,
        "advisors": List<dynamic>.from(advisors!.map((x) => x)),
      };
}



// import 'dart:convert';

// import 'package:bimbingan_ta_app/Model/student_model.dart';

// class LecturerModel {
//   final int id;
//   final String lecturer_id;
//   final String name;
//   final String lecturer_code;
//   final DateTime? created_at;
//   final DateTime? updated_at;
//   List<StudentModel> students;
//   LecturerModel({
//     required this.id,
//     required this.lecturer_id,
//     required this.name,
//     required this.lecturer_code,
//     this.created_at,
//     this.updated_at,
//     required this.students,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'lecturer_id': lecturer_id,
//       'name': name,
//       'lecturer_code': lecturer_code,
//       'created_at': created_at?.millisecondsSinceEpoch,
//       'updated_at': updated_at?.millisecondsSinceEpoch,
//       'students': students.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory LecturerModel.fromMap(Map<String, dynamic> map) {
//     return LecturerModel(
//       id: map['id'] as int,
//       lecturer_id: map['lecturer_id'] as String,
//       name: map['name'] as String,
//       lecturer_code: map['lecturer_code'] as String,
//       created_at: map['created_at'] != null
//           ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
//           : null,
//       updated_at: map['updated_at'] != null
//           ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
//           : null,
//       students: List<StudentModel>.from(
//         (map['students'] as List<int>).map<StudentModel>(
//           (x) => StudentModel.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory LecturerModel.fromJson(String source) =>
//       LecturerModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }

// class Students {
//   final int id;
//   final String name;
//   final String student_id;
//   final String title;
//   Students({
//     required this.id,
//     required this.name,
//     required this.student_id,
//     required this.title,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//       'student_id': student_id,
//       'title': title,
//     };
//   }

//   factory Students.fromMap(Map<String, dynamic> map) {
//     return Students(
//       id: map['id'] as int,
//       name: map['name'] as String,
//       student_id: map['student_id'] as String,
//       title: map['title'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Students.fromJson(String source) =>
//       Students.fromMap(json.decode(source) as Map<String, dynamic>);
// }
