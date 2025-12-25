// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Grade _$GradeFromJson(Map<String, dynamic> json) {
  return _Grade.fromJson(json);
}

/// @nodoc
mixin _$Grade {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get teacherId => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  double? get evaluation => throw _privateConstructorUsedError;
  double? get fard => throw _privateConstructorUsedError;
  double? get exam => throw _privateConstructorUsedError;
  String? get teacherObservation => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Grade to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Grade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GradeCopyWith<Grade> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GradeCopyWith<$Res> {
  factory $GradeCopyWith(Grade value, $Res Function(Grade) then) =
      _$GradeCopyWithImpl<$Res, Grade>;
  @useResult
  $Res call({
    String id,
    String studentId,
    String teacherId,
    String subject,
    double? evaluation,
    double? fard,
    double? exam,
    String? teacherObservation,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$GradeCopyWithImpl<$Res, $Val extends Grade>
    implements $GradeCopyWith<$Res> {
  _$GradeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Grade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? teacherId = null,
    Object? subject = null,
    Object? evaluation = freezed,
    Object? fard = freezed,
    Object? exam = freezed,
    Object? teacherObservation = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            teacherId: null == teacherId
                ? _value.teacherId
                : teacherId // ignore: cast_nullable_to_non_nullable
                      as String,
            subject: null == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String,
            evaluation: freezed == evaluation
                ? _value.evaluation
                : evaluation // ignore: cast_nullable_to_non_nullable
                      as double?,
            fard: freezed == fard
                ? _value.fard
                : fard // ignore: cast_nullable_to_non_nullable
                      as double?,
            exam: freezed == exam
                ? _value.exam
                : exam // ignore: cast_nullable_to_non_nullable
                      as double?,
            teacherObservation: freezed == teacherObservation
                ? _value.teacherObservation
                : teacherObservation // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GradeImplCopyWith<$Res> implements $GradeCopyWith<$Res> {
  factory _$$GradeImplCopyWith(
    _$GradeImpl value,
    $Res Function(_$GradeImpl) then,
  ) = __$$GradeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentId,
    String teacherId,
    String subject,
    double? evaluation,
    double? fard,
    double? exam,
    String? teacherObservation,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$GradeImplCopyWithImpl<$Res>
    extends _$GradeCopyWithImpl<$Res, _$GradeImpl>
    implements _$$GradeImplCopyWith<$Res> {
  __$$GradeImplCopyWithImpl(
    _$GradeImpl _value,
    $Res Function(_$GradeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Grade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? teacherId = null,
    Object? subject = null,
    Object? evaluation = freezed,
    Object? fard = freezed,
    Object? exam = freezed,
    Object? teacherObservation = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$GradeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        teacherId: null == teacherId
            ? _value.teacherId
            : teacherId // ignore: cast_nullable_to_non_nullable
                  as String,
        subject: null == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String,
        evaluation: freezed == evaluation
            ? _value.evaluation
            : evaluation // ignore: cast_nullable_to_non_nullable
                  as double?,
        fard: freezed == fard
            ? _value.fard
            : fard // ignore: cast_nullable_to_non_nullable
                  as double?,
        exam: freezed == exam
            ? _value.exam
            : exam // ignore: cast_nullable_to_non_nullable
                  as double?,
        teacherObservation: freezed == teacherObservation
            ? _value.teacherObservation
            : teacherObservation // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GradeImpl implements _Grade {
  const _$GradeImpl({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.subject,
    this.evaluation,
    this.fard,
    this.exam,
    this.teacherObservation,
    this.createdAt,
  });

  factory _$GradeImpl.fromJson(Map<String, dynamic> json) =>
      _$$GradeImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final String teacherId;
  @override
  final String subject;
  @override
  final double? evaluation;
  @override
  final double? fard;
  @override
  final double? exam;
  @override
  final String? teacherObservation;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Grade(id: $id, studentId: $studentId, teacherId: $teacherId, subject: $subject, evaluation: $evaluation, fard: $fard, exam: $exam, teacherObservation: $teacherObservation, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GradeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.teacherId, teacherId) ||
                other.teacherId == teacherId) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.evaluation, evaluation) ||
                other.evaluation == evaluation) &&
            (identical(other.fard, fard) || other.fard == fard) &&
            (identical(other.exam, exam) || other.exam == exam) &&
            (identical(other.teacherObservation, teacherObservation) ||
                other.teacherObservation == teacherObservation) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentId,
    teacherId,
    subject,
    evaluation,
    fard,
    exam,
    teacherObservation,
    createdAt,
  );

  /// Create a copy of Grade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GradeImplCopyWith<_$GradeImpl> get copyWith =>
      __$$GradeImplCopyWithImpl<_$GradeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GradeImplToJson(this);
  }
}

abstract class _Grade implements Grade {
  const factory _Grade({
    required final String id,
    required final String studentId,
    required final String teacherId,
    required final String subject,
    final double? evaluation,
    final double? fard,
    final double? exam,
    final String? teacherObservation,
    final DateTime? createdAt,
  }) = _$GradeImpl;

  factory _Grade.fromJson(Map<String, dynamic> json) = _$GradeImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  String get teacherId;
  @override
  String get subject;
  @override
  double? get evaluation;
  @override
  double? get fard;
  @override
  double? get exam;
  @override
  String? get teacherObservation;
  @override
  DateTime? get createdAt;

  /// Create a copy of Grade
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GradeImplCopyWith<_$GradeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
