import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/main.dart';

// Active Session Model
class ActiveSession {
  final String className;
  final String room;
  final String subject;
  final bool isNow;

  ActiveSession({
    required this.className,
    required this.room,
    required this.subject,
    this.isNow = true,
  });
}

// Dashboard Stats for Director
class DirectorStats {
  final double attendancePercentage;
  final int absentStaffCount;
  final int pendingRequestsCount;

  DirectorStats({
    required this.attendancePercentage,
    required this.absentStaffCount,
    required this.pendingRequestsCount,
  });
}

// Stats for Supervisors
class SupervisorStats {
  final int totalAbsencesToday;
  final int activeEntryPasses;
  final int behavioralIncidents;

  SupervisorStats({
    required this.totalAbsencesToday,
    required this.activeEntryPasses,
    required this.behavioralIncidents,
  });
}

// Stats for Economist
class EconomistStats {
  final int pendingMaterialRequests;
  final int ongoingMaintenance;
  final double budgetUtilization;

  EconomistStats({
    required this.pendingMaterialRequests,
    required this.ongoingMaintenance,
    required this.budgetUtilization,
  });
}

// Schedule Item Model
class ScheduleItem {
  final String id;
  final int
  dayIndex; // 0 = Sat, 1 = Sun, etc (Algerian weekend is Fri/Sat, usually Sun-Thu)
  final String startTime;
  final String endTime;
  final String className;
  final String subject;
  final String room;

  ScheduleItem({
    required this.id,
    required this.dayIndex,
    required this.startTime,
    required this.endTime,
    required this.className,
    required this.subject,
    required this.room,
  });
}

class DashboardState {
  final DirectorStats? directorStats;
  final SupervisorStats? supervisorStats;
  final EconomistStats? economistStats;
  final ActiveSession? teacherSession;
  final List<ScheduleItem> weeklySchedule;
  final bool isLoading;

  DashboardState({
    this.directorStats,
    this.supervisorStats,
    this.economistStats,
    this.teacherSession,
    this.weeklySchedule = const [],
    this.isLoading = false,
  });

  DashboardState copyWith({
    DirectorStats? directorStats,
    SupervisorStats? supervisorStats,
    EconomistStats? economistStats,
    ActiveSession? teacherSession,
    List<ScheduleItem>? weeklySchedule,
    bool? isLoading,
  }) {
    return DashboardState(
      directorStats: directorStats ?? this.directorStats,
      supervisorStats: supervisorStats ?? this.supervisorStats,
      economistStats: economistStats ?? this.economistStats,
      teacherSession: teacherSession ?? this.teacherSession,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
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
        directorStats: DirectorStats(
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

  Future<void> loadSupervisorStats() async {
    state = state.copyWith(isLoading: true);
    try {
      // Mock for demo
      state = state.copyWith(
        supervisorStats: SupervisorStats(
          totalAbsencesToday: 42,
          activeEntryPasses: 8,
          behavioralIncidents: 3,
        ),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadEconomistStats() async {
    state = state.copyWith(isLoading: true);
    try {
      // Mock for demo
      state = state.copyWith(
        economistStats: EconomistStats(
          pendingMaterialRequests: 5,
          ongoingMaintenance: 2,
          budgetUtilization: 65.0,
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
      // Mock weekly schedule
      final mockSchedule = [
        ScheduleItem(
          id: '1',
          dayIndex: 0,
          startTime: '08:00',
          endTime: '09:00',
          className: '4م1',
          subject: 'رياضيات',
          room: '12',
        ),
        ScheduleItem(
          id: '2',
          dayIndex: 0,
          startTime: '09:00',
          endTime: '10:00',
          className: '2م3',
          subject: 'رياضيات',
          room: '05',
        ),
        ScheduleItem(
          id: '3',
          dayIndex: 1,
          startTime: '10:00',
          endTime: '11:00',
          className: '4م1',
          subject: 'رياضيات',
          room: '12',
        ),
        ScheduleItem(
          id: '4',
          dayIndex: 2,
          startTime: '14:00',
          endTime: '15:00',
          className: '1م4',
          subject: 'رياضيات',
          room: '08',
        ),
      ];

      state = state.copyWith(
        teacherSession: ActiveSession(
          className: '4م1',
          room: '12',
          subject: 'الرياضيات',
          isNow: true,
        ),
        weeklySchedule: mockSchedule,
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
