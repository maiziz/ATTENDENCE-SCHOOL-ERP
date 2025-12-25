import 'package:freezed_annotation/freezed_annotation.dart';

part 'grade.freezed.dart';
part 'grade.g.dart';

@freezed
class Grade with _$Grade {
  const factory Grade({
    required String id,
    required String studentId,
    required String teacherId,
    required String subject,
    double? evaluation,
    double? fard,
    double? exam,
    String? teacherObservation,
    DateTime? createdAt,
  }) = _Grade;

  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);
}
