// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ObservationImpl _$$ObservationImplFromJson(Map<String, dynamic> json) =>
    _$ObservationImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      authorId: json['author_id'] as String,
      type: $enumDecode(_$ObservationTypeEnumMap, json['type']),
      visibility: $enumDecode(
        _$ObservationVisibilityEnumMap,
        json['visibility'],
      ),
      content: json['content'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ObservationImplToJson(_$ObservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'author_id': instance.authorId,
      'type': _$ObservationTypeEnumMap[instance.type]!,
      'visibility': _$ObservationVisibilityEnumMap[instance.visibility]!,
      'content': instance.content,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$ObservationTypeEnumMap = {
  ObservationType.behavioral: 'behavioral',
  ObservationType.academic: 'academic',
  ObservationType.social: 'social',
};

const _$ObservationVisibilityEnumMap = {
  ObservationVisibility.public: 'public',
  ObservationVisibility.restricted: 'restricted',
};
