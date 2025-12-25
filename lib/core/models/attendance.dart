import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/enums.dart';

part 'attendance.freezed.dart';
part 'attendance.g.dart';

@freezed
class Attendance with _$Attendance {
  const factory Attendance({
    required String id,
    required String studentId,
    required String teacherId,
    required DateTime date,
    required String sessionTime, // Time as string (e.g., "08:00:00")
    required AttendanceStatus status,
    required AuthStatus authorizationStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Attendance;

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);
}
