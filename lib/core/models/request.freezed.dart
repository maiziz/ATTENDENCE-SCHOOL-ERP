// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Request _$RequestFromJson(Map<String, dynamic> json) {
  return _Request.fromJson(json);
}

/// @nodoc
mixin _$Request {
  String get id => throw _privateConstructorUsedError;
  String get requesterId => throw _privateConstructorUsedError;
  RequestCategory get category => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  RequestStatus get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get seenAt => throw _privateConstructorUsedError;
  DateTime? get forwardedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;

  /// Serializes this Request to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestCopyWith<Request> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestCopyWith<$Res> {
  factory $RequestCopyWith(Request value, $Res Function(Request) then) =
      _$RequestCopyWithImpl<$Res, Request>;
  @useResult
  $Res call({
    String id,
    String requesterId,
    RequestCategory category,
    String content,
    RequestStatus status,
    DateTime? createdAt,
    DateTime? seenAt,
    DateTime? forwardedAt,
    DateTime? completedAt,
    String? assignedTo,
    String? rejectionReason,
  });
}

/// @nodoc
class _$RequestCopyWithImpl<$Res, $Val extends Request>
    implements $RequestCopyWith<$Res> {
  _$RequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? category = null,
    Object? content = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? seenAt = freezed,
    Object? forwardedAt = freezed,
    Object? completedAt = freezed,
    Object? assignedTo = freezed,
    Object? rejectionReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            requesterId: null == requesterId
                ? _value.requesterId
                : requesterId // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as RequestCategory,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RequestStatus,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            seenAt: freezed == seenAt
                ? _value.seenAt
                : seenAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            forwardedAt: freezed == forwardedAt
                ? _value.forwardedAt
                : forwardedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            assignedTo: freezed == assignedTo
                ? _value.assignedTo
                : assignedTo // ignore: cast_nullable_to_non_nullable
                      as String?,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RequestImplCopyWith<$Res> implements $RequestCopyWith<$Res> {
  factory _$$RequestImplCopyWith(
    _$RequestImpl value,
    $Res Function(_$RequestImpl) then,
  ) = __$$RequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String requesterId,
    RequestCategory category,
    String content,
    RequestStatus status,
    DateTime? createdAt,
    DateTime? seenAt,
    DateTime? forwardedAt,
    DateTime? completedAt,
    String? assignedTo,
    String? rejectionReason,
  });
}

/// @nodoc
class __$$RequestImplCopyWithImpl<$Res>
    extends _$RequestCopyWithImpl<$Res, _$RequestImpl>
    implements _$$RequestImplCopyWith<$Res> {
  __$$RequestImplCopyWithImpl(
    _$RequestImpl _value,
    $Res Function(_$RequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? category = null,
    Object? content = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? seenAt = freezed,
    Object? forwardedAt = freezed,
    Object? completedAt = freezed,
    Object? assignedTo = freezed,
    Object? rejectionReason = freezed,
  }) {
    return _then(
      _$RequestImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        requesterId: null == requesterId
            ? _value.requesterId
            : requesterId // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as RequestCategory,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RequestStatus,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        seenAt: freezed == seenAt
            ? _value.seenAt
            : seenAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        forwardedAt: freezed == forwardedAt
            ? _value.forwardedAt
            : forwardedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        assignedTo: freezed == assignedTo
            ? _value.assignedTo
            : assignedTo // ignore: cast_nullable_to_non_nullable
                  as String?,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestImpl implements _Request {
  const _$RequestImpl({
    required this.id,
    required this.requesterId,
    required this.category,
    required this.content,
    required this.status,
    this.createdAt,
    this.seenAt,
    this.forwardedAt,
    this.completedAt,
    this.assignedTo,
    this.rejectionReason,
  });

  factory _$RequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestImplFromJson(json);

  @override
  final String id;
  @override
  final String requesterId;
  @override
  final RequestCategory category;
  @override
  final String content;
  @override
  final RequestStatus status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? seenAt;
  @override
  final DateTime? forwardedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? assignedTo;
  @override
  final String? rejectionReason;

  @override
  String toString() {
    return 'Request(id: $id, requesterId: $requesterId, category: $category, content: $content, status: $status, createdAt: $createdAt, seenAt: $seenAt, forwardedAt: $forwardedAt, completedAt: $completedAt, assignedTo: $assignedTo, rejectionReason: $rejectionReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.seenAt, seenAt) || other.seenAt == seenAt) &&
            (identical(other.forwardedAt, forwardedAt) ||
                other.forwardedAt == forwardedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    requesterId,
    category,
    content,
    status,
    createdAt,
    seenAt,
    forwardedAt,
    completedAt,
    assignedTo,
    rejectionReason,
  );

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestImplCopyWith<_$RequestImpl> get copyWith =>
      __$$RequestImplCopyWithImpl<_$RequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestImplToJson(this);
  }
}

abstract class _Request implements Request {
  const factory _Request({
    required final String id,
    required final String requesterId,
    required final RequestCategory category,
    required final String content,
    required final RequestStatus status,
    final DateTime? createdAt,
    final DateTime? seenAt,
    final DateTime? forwardedAt,
    final DateTime? completedAt,
    final String? assignedTo,
    final String? rejectionReason,
  }) = _$RequestImpl;

  factory _Request.fromJson(Map<String, dynamic> json) = _$RequestImpl.fromJson;

  @override
  String get id;
  @override
  String get requesterId;
  @override
  RequestCategory get category;
  @override
  String get content;
  @override
  RequestStatus get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get seenAt;
  @override
  DateTime? get forwardedAt;
  @override
  DateTime? get completedAt;
  @override
  String? get assignedTo;
  @override
  String? get rejectionReason;

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestImplCopyWith<_$RequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
