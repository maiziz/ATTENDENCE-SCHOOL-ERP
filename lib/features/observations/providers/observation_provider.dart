import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/main.dart';
import 'package:attendence_school_erp/core/models/observation.dart';
import 'package:attendence_school_erp/core/models/student.dart';
import 'package:attendence_school_erp/core/models/school_class.dart';
import 'package:attendence_school_erp/core/enums/enums.dart';

class ObservationState {
  final List<ObservationWithDetails> observations;
  final bool isLoading;
  final String? error;

  ObservationState({
    required this.observations,
    this.isLoading = false,
    this.error,
  });

  ObservationState copyWith({
    List<ObservationWithDetails>? observations,
    bool? isLoading,
    String? error,
  }) {
    return ObservationState(
      observations: observations ?? this.observations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ObservationWithDetails {
  final Observation observation;
  final Student student;
  final String authorName;

  ObservationWithDetails({
    required this.observation,
    required this.student,
    required this.authorName,
  });
}

class ObservationNotifier extends StateNotifier<ObservationState> {
  ObservationNotifier() : super(ObservationState(observations: []));

  Future<void> loadObservations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await supabase
          .from('observations')
          .select('*, students(*), profiles(full_name)')
          .order('created_at', ascending: false);

      final observations = (data as List).map((json) {
        return ObservationWithDetails(
          observation: Observation.fromJson(json),
          student: Student.fromJson(json['students']),
          authorName: json['profiles']['full_name'],
        );
      }).toList();

      state = state.copyWith(observations: observations, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createObservation({
    required String studentId,
    required String authorId,
    required ObservationType type,
    required ObservationVisibility visibility,
    required String content,
  }) async {
    try {
      await supabase.from('observations').insert({
        'student_id': studentId,
        'author_id': authorId,
        'type': type.name,
        'visibility': visibility.name,
        'content': content,
      });

      await loadObservations();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<List<Student>> loadAllStudents() async {
    try {
      final data = await supabase.from('students').select().order('full_name');
      return (data as List).map((json) => Student.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<SchoolClass>> loadAllClasses() async {
    try {
      final data = await supabase.from('classes').select().order('name');
      return (data as List).map((json) => SchoolClass.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Student>> loadStudentsByClass(String classId) async {
    try {
      final data = await supabase
          .from('students')
          .select()
          .eq('class_id', classId)
          .order('full_name');
      return (data as List).map((json) => Student.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}

final observationProvider =
    StateNotifierProvider<ObservationNotifier, ObservationState>((ref) {
      return ObservationNotifier();
    });
