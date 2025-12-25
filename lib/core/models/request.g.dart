// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestImpl _$$RequestImplFromJson(Map<String, dynamic> json) =>
    _$RequestImpl(
      id: json['id'] as String,
      requesterId: json['requester_id'] as String,
      category: $enumDecode(_$RequestCategoryEnumMap, json['category']),
      content: json['content'] as String,
      status: $enumDecode(_$RequestStatusEnumMap, json['status']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      seenAt: json['seen_at'] == null
          ? null
          : DateTime.parse(json['seen_at'] as String),
      forwardedAt: json['forwarded_at'] == null
          ? null
          : DateTime.parse(json['forwarded_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      assignedTo: json['assigned_to'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
    );

Map<String, dynamic> _$$RequestImplToJson(_$RequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requester_id': instance.requesterId,
      'category': _$RequestCategoryEnumMap[instance.category]!,
      'content': instance.content,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt?.toIso8601String(),
      'seen_at': instance.seenAt?.toIso8601String(),
      'forwarded_at': instance.forwardedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'assigned_to': instance.assignedTo,
      'rejection_reason': instance.rejectionReason,
    };

const _$RequestCategoryEnumMap = {
  RequestCategory.material: 'material',
  RequestCategory.maintenance: 'maintenance',
  RequestCategory.pedagogical: 'pedagogical',
  RequestCategory.admin: 'admin',
};

const _$RequestStatusEnumMap = {
  RequestStatus.sent: 'sent',
  RequestStatus.seen: 'seen',
  RequestStatus.forwarded: 'forwarded',
  RequestStatus.completed: 'completed',
  RequestStatus.rejected: 'rejected',
};
