import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/core/models/school_class.dart';
import 'package:attendence_school_erp/main.dart';
import 'package:attendence_school_erp/core/models/attendance.dart';
import 'package:attendence_school_erp/core/models/student.dart';
import 'package:attendence_school_erp/core/enums/enums.dart';

// Attendance State for a specific session
class AttendanceState {
  final List<AttendanceRecord> records;
  final bool isLoading;
  final String? error;

  AttendanceState({required this.records, this.isLoading = false, this.error});

  AttendanceState copyWith({
    List<AttendanceRecord>? records,
    bool? isLoading,
    String? error,
  }) {
    return AttendanceState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Combined record with student info
class AttendanceRecord {
  final Student student;
  final Attendance? attendance; // Current session attendance
  final Attendance? previousSessionAttendance; // Context from previous session

  AttendanceRecord({
    required this.student,
    this.attendance,
    this.previousSessionAttendance,
  });

  // Relay Logic (Context Awareness)
  AttendanceBadge getBadge() {
    // 1. Blue Badge: Authorized Entry (Highest priority for returnees)
    if (attendance?.authorizationStatus == AuthStatus.authorized_entry) {
      return AttendanceBadge.blueAuthorized;
    }

    // 2. Red Badge: Previous Absence Warning
    // If student was absent in previous session and hasn't been marked yet or is marked absent again
    if (previousSessionAttendance?.status == AttendanceStatus.absent) {
      // If we already marked them present, showing green is fine,
      // but the red badge is a "state" from the relay.
      // Let's follow the user's logic: Red badge means "was absent earlier".
      if (attendance?.status != AttendanceStatus.present) {
        return AttendanceBadge.redPreviousAbsence;
      }
    }

    // 3. Orange Badge: Potential Escape
    // Was present in previous session but marked absent in current one
    if (previousSessionAttendance?.status == AttendanceStatus.present &&
        attendance?.status == AttendanceStatus.absent) {
      return AttendanceBadge.orangePotentialEscape;
    }

    // 4. Regular Present
    if (attendance?.status == AttendanceStatus.present) {
      return AttendanceBadge.greenPresent;
    }

    return AttendanceBadge.none;
  }
}

enum AttendanceBadge {
  redPreviousAbsence, // غياب سابق - تنبيه للأستاذ
  blueAuthorized, // مسموح بالدخول - إذن من المراقب
  orangePotentialEscape, // هروب محتمل - كان حاضراً وغاب الآن
  greenPresent, // حاضر
  none, // تلميذ عادي
}

// Attendance Provider
class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier() : super(AttendanceState(records: []));

  Future<List<SchoolClass>> loadClasses() async {
    try {
      final data = await supabase.from('classes').select().order('name');
      return (data as List).map((json) => SchoolClass.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> loadAttendance({
    required String classId,
    required DateTime date,
    required String sessionTime,
  }) async {
    if (classId.isEmpty || classId == 'demo-class-id') {
      state = state.copyWith(records: [], isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Fetch students
      final studentsData = await supabase
          .from('students')
          .select()
          .eq('class_id', classId);

      final students = (studentsData as List)
          .map((json) => Student.fromJson(json))
          .toList();

      if (students.isEmpty) {
        state = state.copyWith(records: [], isLoading: false);
        return;
      }

      // Fetch current session attendance
      final dateStr = date.toIso8601String().split('T')[0];
      final currentAttendanceData = await supabase
          .from('attendance')
          .select()
          .eq('date', dateStr)
          .eq('session_time', sessionTime);

      final currentAttendanceMap = <String, Attendance>{};
      for (var json in currentAttendanceData as List) {
        final att = Attendance.fromJson(json);
        currentAttendanceMap[att.studentId] = att;
      }

      // Fetch previous session attendance
      final previousSessionTime = _getPreviousSessionTime(sessionTime);
      final previousAttendanceData = await supabase
          .from('attendance')
          .select()
          .eq('date', dateStr)
          .eq('session_time', previousSessionTime);

      final previousAttendanceMap = <String, Attendance>{};
      for (var json in previousAttendanceData as List) {
        final att = Attendance.fromJson(json);
        previousAttendanceMap[att.studentId] = att;
      }

      // Combine data
      final records = students.map((student) {
        return AttendanceRecord(
          student: student,
          attendance: currentAttendanceMap[student.id],
          previousSessionAttendance: previousAttendanceMap[student.id],
        );
      }).toList();

      state = state.copyWith(records: records, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> markAttendance({
    required String studentId,
    required String teacherId,
    required DateTime date,
    required String sessionTime,
    required AttendanceStatus status,
    required String classId,
  }) async {
    // 1. Optimistic Update
    final oldRecords = [...state.records];
    final newRecords = oldRecords.map((r) {
      if (r.student.id == studentId) {
        return AttendanceRecord(
          student: r.student,
          attendance:
              (r.attendance ??
                      Attendance(
                        id: '',
                        studentId: studentId,
                        teacherId: teacherId,
                        date: date,
                        sessionTime: sessionTime,
                        status: status,
                        authorizationStatus: AuthStatus.none,
                      ))
                  .copyWith(status: status),
          previousSessionAttendance: r.previousSessionAttendance,
        );
      }
      return r;
    }).toList();

    state = state.copyWith(records: newRecords);

    try {
      final dateStr = date.toIso8601String().split('T')[0];

      final existing = await supabase
          .from('attendance')
          .select('id')
          .eq('student_id', studentId)
          .eq('date', dateStr)
          .eq('session_time', sessionTime)
          .maybeSingle();

      if (existing != null) {
        await supabase
            .from('attendance')
            .update({
              'status': status.name,
              'teacher_id': teacherId,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existing['id']);
      } else {
        await supabase.from('attendance').insert({
          'student_id': studentId,
          'teacher_id': teacherId,
          'date': dateStr,
          'session_time': sessionTime,
          'status': status.name,
        });
      }
    } catch (e) {
      // Rollback on error
      state = state.copyWith(records: oldRecords, error: e.toString());
    }
  }

  Future<void> markAllPresent({
    required String teacherId,
    required DateTime date,
    required String sessionTime,
    required String classId,
  }) async {
    final oldRecords = [...state.records];
    final dateStr = date.toIso8601String().split('T')[0];

    // 1. Optimistic Update
    final newRecords = oldRecords.map((r) {
      return AttendanceRecord(
        student: r.student,
        attendance:
            (r.attendance ??
                    Attendance(
                      id: '',
                      studentId: r.student.id,
                      teacherId: teacherId,
                      date: date,
                      sessionTime: sessionTime,
                      status: AttendanceStatus.present,
                      authorizationStatus: AuthStatus.none,
                    ))
                .copyWith(status: AttendanceStatus.present),
        previousSessionAttendance: r.previousSessionAttendance,
      );
    }).toList();

    state = state.copyWith(records: newRecords);

    try {
      // Prepare batch upsert data
      final upsertData = oldRecords.map((r) {
        return {
          'student_id': r.student.id,
          'teacher_id': teacherId,
          'date': dateStr,
          'session_time': sessionTime,
          'status': AttendanceStatus.present.name,
          'updated_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      await supabase
          .from('attendance')
          .upsert(upsertData, onConflict: 'student_id,date,session_time');
    } catch (e) {
      state = state.copyWith(records: oldRecords, error: e.toString());
    }
  }

  String _getPreviousSessionTime(String currentSession) {
    // Simple logic: if current is 09:00:00, previous is 08:00:00
    // In production, this would be more sophisticated
    final hour = int.parse(currentSession.split(':')[0]);
    if (hour > 0) {
      return '${(hour - 1).toString().padLeft(2, '0')}:00:00';
    }
    return '08:00:00';
  }
}

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>(
      (ref) => AttendanceNotifier(),
    );
