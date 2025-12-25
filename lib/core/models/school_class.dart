import 'package:freezed_annotation/freezed_annotation.dart';

part 'school_class.freezed.dart';
part 'school_class.g.dart';

@freezed
class SchoolClass with _$SchoolClass {
  const factory SchoolClass({
    required String id,
    required String name,
    required int gradeLevel,
    DateTime? createdAt,
  }) = _SchoolClass;

  factory SchoolClass.fromJson(Map<String, dynamic> json) =>
      _$SchoolClassFromJson(json);
}
