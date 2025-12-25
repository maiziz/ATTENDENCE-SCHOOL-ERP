// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchoolClassImpl _$$SchoolClassImplFromJson(Map<String, dynamic> json) =>
    _$SchoolClassImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      gradeLevel: (json['grade_level'] as num).toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$SchoolClassImplToJson(_$SchoolClassImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'grade_level': instance.gradeLevel,
      'created_at': instance.createdAt?.toIso8601String(),
    };
