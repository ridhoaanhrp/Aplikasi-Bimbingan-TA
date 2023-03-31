class ProgressModel {
  ProgressModel({
    required this.id,
    required this.studentId,
    required this.lecturerId,
    required this.lecturerCode,
    required this.progressNoteId,
    required this.progressValueId,
    required this.progressModelAbstract,
    required this.chapterOne,
    required this.chapterTwo,
    required this.chapterThree,
    required this.reference,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String studentId;
  String lecturerId;
  String lecturerCode;
  int progressNoteId;
  int progressValueId;
  Progress progressModelAbstract;
  Progress chapterOne;
  Progress chapterTwo;
  Progress chapterThree;
  Progress reference;
  int total;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProgressModel.fromJson(Map<String, dynamic> json) => ProgressModel(
        id: json["id"],
        studentId: json["student_id"],
        lecturerId: json["lecturer_id"],
        lecturerCode: json["lecturer_code"],
        progressNoteId: json["progress_note_id"],
        progressValueId: json["progress_value_id"],
        progressModelAbstract: Progress.fromJson(json["abstract"]),
        chapterOne: Progress.fromJson(json["chapter_one"]),
        chapterTwo: Progress.fromJson(json["chapter_two"]),
        chapterThree: Progress.fromJson(json["chapter_three"]),
        reference: Progress.fromJson(json["reference"]),
        total: json["total"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "lecturer_id": lecturerId,
        "lecturer_code": lecturerCode,
        "progress_note_id": progressNoteId,
        "progress_value_id": progressValueId,
        "abstract": progressModelAbstract.toJson(),
        "chapter_one": chapterOne.toJson(),
        "chapter_two": chapterTwo.toJson(),
        "chapter_three": chapterThree.toJson(),
        "reference": reference.toJson(),
        "total": total,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Progress {
  Progress({
    required this.value,
    required this.note,
  });

  int? value;
  dynamic note;

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
        value: json["value"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "note": note,
      };
}
