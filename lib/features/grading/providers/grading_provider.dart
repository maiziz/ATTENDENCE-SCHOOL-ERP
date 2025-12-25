import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/main.dart';
import 'package:attendence_school_erp/core/models/grade.dart';

import 'package:attendence_school_erp/core/models/student.dart';

class GradingRecord {
  final Student student;
  final Grade? grade;

  GradingRecord({required this.student, this.grade});

  GradingRecord copyWith({Grade? grade}) {
    return GradingRecord(student: student, grade: grade ?? this.grade);
  }
}

class GradingState {
  final List<GradingRecord> records;
  final bool isLoading;
  final String? error;

  GradingState({required this.records, this.isLoading = false, this.error});

  GradingState copyWith({
    List<GradingRecord>? records,
    bool? isLoading,
    String? error,
  }) {
    return GradingState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class GradingNotifier extends StateNotifier<GradingState> {
  GradingNotifier() : super(GradingState(records: []));

  Future<void> loadClassGrades({
    required String classId,
    required String subject,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // 1. Fetch all students in the class
      final studentsData = await supabase
          .from('students')
          .select()
          .eq('class_id', classId)
          .order('full_name');

      final students = (studentsData as List)
          .map((json) => Student.fromJson(json))
          .toList();

      // 2. Fetch existing grades for this subject and these students
      final gradesData = await supabase
          .from('grades')
          .select()
          .eq('subject', subject)
          .inFilter('student_id', students.map((s) => s.id).toList());

      final grades = (gradesData as List)
          .map((json) => Grade.fromJson(json))
          .toList();

      // 3. Map students to records
      final records = students.map((s) {
        final grade = grades.where((g) => g.studentId == s.id).firstOrNull;
        return GradingRecord(student: s, grade: grade);
      }).toList();

      state = state.copyWith(records: records, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> saveGrade({
    required String studentId,
    required String teacherId,
    required String subject,
    double? evaluation,
    double? fard,
    double? exam,
    String? observation,
  }) async {
    // 1. Optimistic Update
    final oldRecords = [...state.records];
    final newRecords = oldRecords.map((r) {
      if (r.student.id == studentId) {
        final currentGrade =
            r.grade ??
            Grade(
              id: '',
              studentId: studentId,
              teacherId: teacherId,
              subject: subject,
              createdAt: DateTime.now(),
            );
        return r.copyWith(
          grade: currentGrade.copyWith(
            evaluation: evaluation ?? currentGrade.evaluation,
            fard: fard ?? currentGrade.fard,
            exam: exam ?? currentGrade.exam,
            teacherObservation: observation ?? currentGrade.teacherObservation,
          ),
        );
      }
      return r;
    }).toList();

    state = state.copyWith(records: newRecords);

    try {
      final existing = await supabase
          .from('grades')
          .select('id')
          .eq('student_id', studentId)
          .eq('subject', subject)
          .maybeSingle();

      final data = {
        'student_id': studentId,
        'teacher_id': teacherId,
        'subject': subject,
        if (evaluation != null) 'evaluation': evaluation,
        if (fard != null) 'fard': fard,
        if (exam != null) 'exam': exam,
        if (observation != null) 'teacher_observation': observation,
      };

      if (existing != null) {
        await supabase.from('grades').update(data).eq('id', existing['id']);
      } else {
        await supabase.from('grades').insert(data);
      }
    } catch (e) {
      state = state.copyWith(records: oldRecords, error: e.toString());
    }
  }

  Future<void> loadStudentGrades(String studentId) async {
    // Keeping this for compatibility if needed, but updated to use records
    state = state.copyWith(isLoading: true, error: null);
    try {
      final studentData = await supabase
          .from('students')
          .select()
          .eq('id', studentId)
          .single();
      final student = Student.fromJson(studentData);

      final data = await supabase
          .from('grades')
          .select()
          .eq('student_id', studentId)
          .order('created_at', ascending: false);

      final grades = (data as List)
          .map((json) => Grade.fromJson(json))
          .toList();

      final records = grades
          .map((g) => GradingRecord(student: student, grade: g))
          .toList();
      state = state.copyWith(records: records, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final gradingProvider = StateNotifierProvider<GradingNotifier, GradingState>((
  ref,
) {
  return GradingNotifier();
});
