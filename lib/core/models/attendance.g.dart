// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceImpl _$$AttendanceImplFromJson(Map<String, dynamic> json) =>
    _$AttendanceImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      teacherId: json['teacher_id'] as String,
      date: DateTime.parse(json['date'] as String),
      sessionTime: json['session_time'] as String,
      status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
      authorizationStatus: $enumDecode(
        _$AuthStatusEnumMap,
        json['authorization_status'],
      ),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AttendanceImplToJson(
  _$AttendanceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'student_id': instance.studentId,
  'teacher_id': instance.teacherId,
  'date': instance.date.toIso8601String(),
  'session_time': instance.sessionTime,
  'status': _$AttendanceStatusEnumMap[instance.status]!,
  'authorization_status': _$AuthStatusEnumMap[instance.authorizationStatus]!,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.pending: 'pending',
  AttendanceStatus.present: 'present',
  AttendanceStatus.absent: 'absent',
  AttendanceStatus.late: 'late',
};

const _$AuthStatusEnumMap = {
  AuthStatus.none: 'none',
  AuthStatus.authorized_entry: 'authorized_entry',
  AuthStatus.justified: 'justified',
  AuthStatus.unjustified: 'unjustified',
};
