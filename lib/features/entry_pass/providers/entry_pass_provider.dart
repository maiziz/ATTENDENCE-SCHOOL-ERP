import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/main.dart';
import 'package:attendence_school_erp/core/models/student.dart';
import 'package:attendence_school_erp/core/models/attendance.dart';
import 'package:attendence_school_erp/core/enums/enums.dart';

class EntryPassState {
  final List<Student> searchResults;
  final List<Attendance> activePasses;
  final bool isLoading;
  final String? error;

  EntryPassState({
    this.searchResults = const [],
    this.activePasses = const [],
    this.isLoading = false,
    this.error,
  });

  EntryPassState copyWith({
    List<Student>? searchResults,
    List<Attendance>? activePasses,
    bool? isLoading,
    String? error,
  }) {
    return EntryPassState(
      searchResults: searchResults ?? this.searchResults,
      activePasses: activePasses ?? this.activePasses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class EntryPassNotifier extends StateNotifier<EntryPassState> {
  EntryPassNotifier() : super(EntryPassState());

  Future<void> searchStudents(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResults: []);
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final data = await supabase
          .from('students')
          .select()
          .ilike('full_name', '%$query%')
          .limit(10);

      final students = (data as List)
          .map((json) => Student.fromJson(json))
          .toList();
      state = state.copyWith(searchResults: students, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> issueEntryPass({
    required String studentId,
    required String supervisorId,
    required DateTime date,
    required String sessionTime,
    String? reason,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final dateStr = date.toIso8601String().split('T')[0];

      // Check if attendance record exists for this student/session
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
              'authorization_status': AuthStatus.authorized_entry.name,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existing['id']);
      } else {
        await supabase.from('attendance').insert({
          'student_id': studentId,
          'teacher_id':
              supervisorId, // Using supervisor as the one who authorized
          'date': dateStr,
          'session_time': sessionTime,
          'status': AttendanceStatus.pending.name,
          'authorization_status': AuthStatus.authorized_entry.name,
        });
      }

      // Reload relevant data if needed
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadActivePasses() async {
    state = state.copyWith(isLoading: true);
    try {
      final todayStr = DateTime.now().toIso8601String().split('T')[0];
      final data = await supabase
          .from('attendance')
          .select('*, students(*)')
          .eq('date', todayStr)
          .eq('authorization_status', AuthStatus.authorized_entry.name);

      // This is a bit more complex because of nested joins
      // For now, we'll just mock the result or handle the list
      // In a real app, we'd have a proper model for this view
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final entryPassProvider =
    StateNotifierProvider<EntryPassNotifier, EntryPassState>((ref) {
      return EntryPassNotifier();
    });
