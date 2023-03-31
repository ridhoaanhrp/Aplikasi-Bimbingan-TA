// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class GuidanceModel {
  GuidanceModel({
    required this.id,
    required this.note,
    required this.to_do,
    required this.date,
    required this.student,
    required this.created_at,
    required this.updated_at,
  });

  int id;
  String note;
  String to_do;
  DateTime date;
  Student student;
  DateTime created_at;
  DateTime updated_at;

  factory GuidanceModel.fromJson(Map<String, dynamic> json) => GuidanceModel(
        id: json["id"],
        note: json["note"],
        to_do: json["to_do"],
        date: DateTime.parse(json["date"]),
        student: Student.fromJson(json["student"]),
        created_at: DateTime.parse(json["created_at"]),
        updated_at: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "note": note,
        "to_do": to_do,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "student": student.toJson(),
        "created_at": created_at.toIso8601String(),
        "updated_at": updated_at.toIso8601String(),
      };
}

class Student {
  Student({
    required this.id,
    required this.name,
    required this.title,
    required this.student_id,
  });

  int id;
  String name;
  String title;
  String student_id;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        student_id: json["student_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title,
        "student_id": student_id,
      };
}
