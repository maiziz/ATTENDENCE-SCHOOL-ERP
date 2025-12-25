// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GradeImpl _$$GradeImplFromJson(Map<String, dynamic> json) => _$GradeImpl(
  id: json['id'] as String,
  studentId: json['student_id'] as String,
  teacherId: json['teacher_id'] as String,
  subject: json['subject'] as String,
  evaluation: (json['evaluation'] as num?)?.toDouble(),
  fard: (json['fard'] as num?)?.toDouble(),
  exam: (json['exam'] as num?)?.toDouble(),
  teacherObservation: json['teacher_observation'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$GradeImplToJson(_$GradeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'teacher_id': instance.teacherId,
      'subject': instance.subject,
      'evaluation': instance.evaluation,
      'fard': instance.fard,
      'exam': instance.exam,
      'teacher_observation': instance.teacherObservation,
      'created_at': instance.createdAt?.toIso8601String(),
    };
