// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'school_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SchoolClass _$SchoolClassFromJson(Map<String, dynamic> json) {
  return _SchoolClass.fromJson(json);
}

/// @nodoc
mixin _$SchoolClass {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get gradeLevel => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SchoolClass to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchoolClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchoolClassCopyWith<SchoolClass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchoolClassCopyWith<$Res> {
  factory $SchoolClassCopyWith(
    SchoolClass value,
    $Res Function(SchoolClass) then,
  ) = _$SchoolClassCopyWithImpl<$Res, SchoolClass>;
  @useResult
  $Res call({String id, String name, int gradeLevel, DateTime? createdAt});
}

/// @nodoc
class _$SchoolClassCopyWithImpl<$Res, $Val extends SchoolClass>
    implements $SchoolClassCopyWith<$Res> {
  _$SchoolClassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchoolClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? gradeLevel = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            gradeLevel: null == gradeLevel
                ? _value.gradeLevel
                : gradeLevel // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$SchoolClassImplCopyWith<$Res>
    implements $SchoolClassCopyWith<$Res> {
  factory _$$SchoolClassImplCopyWith(
    _$SchoolClassImpl value,
    $Res Function(_$SchoolClassImpl) then,
  ) = __$$SchoolClassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, int gradeLevel, DateTime? createdAt});
}

/// @nodoc
class __$$SchoolClassImplCopyWithImpl<$Res>
    extends _$SchoolClassCopyWithImpl<$Res, _$SchoolClassImpl>
    implements _$$SchoolClassImplCopyWith<$Res> {
  __$$SchoolClassImplCopyWithImpl(
    _$SchoolClassImpl _value,
    $Res Function(_$SchoolClassImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SchoolClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? gradeLevel = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$SchoolClassImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        gradeLevel: null == gradeLevel
            ? _value.gradeLevel
            : gradeLevel // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$SchoolClassImpl implements _SchoolClass {
  const _$SchoolClassImpl({
    required this.id,
    required this.name,
    required this.gradeLevel,
    this.createdAt,
  });

  factory _$SchoolClassImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchoolClassImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int gradeLevel;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SchoolClass(id: $id, name: $name, gradeLevel: $gradeLevel, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchoolClassImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, gradeLevel, createdAt);

  /// Create a copy of SchoolClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchoolClassImplCopyWith<_$SchoolClassImpl> get copyWith =>
      __$$SchoolClassImplCopyWithImpl<_$SchoolClassImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchoolClassImplToJson(this);
  }
}

abstract class _SchoolClass implements SchoolClass {
  const factory _SchoolClass({
    required final String id,
    required final String name,
    required final int gradeLevel,
    final DateTime? createdAt,
  }) = _$SchoolClassImpl;

  factory _SchoolClass.fromJson(Map<String, dynamic> json) =
      _$SchoolClassImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get gradeLevel;
  @override
  DateTime? get createdAt;

  /// Create a copy of SchoolClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchoolClassImplCopyWith<_$SchoolClassImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
