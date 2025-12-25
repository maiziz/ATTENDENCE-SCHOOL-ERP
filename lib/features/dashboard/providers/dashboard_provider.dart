import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/main.dart';

// Dashboard Stats Model
class DashboardStats {
  final double attendancePercentage;
  final int absentStaffCount;
  final int pendingRequestsCount;

  DashboardStats({
    required this.attendancePercentage,
    required this.absentStaffCount,
    required this.pendingRequestsCount,
  });
}

// Active Session Model
class ActiveSession {
  final String className;
  final String room;
  final String subject;
  final bool isNow; // true for "Now", false for "Next"

  ActiveSession({
    required this.className,
    required this.room,
    required this.subject,
    this.isNow = true,
  });
}

class DashboardState {
  final DashboardStats? directorStats;
  final ActiveSession? teacherSession;
  final bool isLoading;

  DashboardState({
    this.directorStats,
    this.teacherSession,
    this.isLoading = false,
  });

  DashboardState copyWith({
    DashboardStats? directorStats,
    ActiveSession? teacherSession,
    bool? isLoading,
  }) {
    return DashboardState(
      directorStats: directorStats ?? this.directorStats,
      teacherSession: teacherSession ?? this.teacherSession,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState());

  Future<void> loadDirectorStats() async {
    state = state.copyWith(isLoading: true);
    try {
      // 1. Calculate Attendance % for today
      final dateStr = DateTime.now().toIso8601String().split('T')[0];
      final attendanceData = await supabase
          .from('attendance')
          .select('status')
          .eq('date', dateStr);
      final attendanceList = attendanceData as List;

      double percentage = 0;
      if (attendanceList.isNotEmpty) {
        final presentCount = attendanceList
            .where((a) => a['status'] == 'present')
            .length;
        percentage = (presentCount / attendanceList.length) * 100;
      } else {
        percentage = 92.5; // Demo fallback
      }

      // 2. Absent Staff (Mock for demo if no staff_attendance table exists yet)
      final absentStaff = 3;

      // 3. Pending Requests
      final requestsData = await supabase
          .from('requests')
          .select('id')
          .eq('status', 'sent');
      final requestsCount = (requestsData as List).length;

      state = state.copyWith(
        directorStats: DashboardStats(
          attendancePercentage: percentage,
          absentStaffCount: absentStaff,
          pendingRequestsCount: requestsCount,
        ),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadTeacherSession(String teacherId) async {
    state = state.copyWith(isLoading: true);
    try {
      // In a real app, query 'sessions' table based on current time
      // For demo, we return a fixed "Active Session"
      state = state.copyWith(
        teacherSession: ActiveSession(
          className: '4م1',
          room: '12',
          subject: 'الرياضيات',
          isNow: true,
        ),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
      return DashboardNotifier();
    });
