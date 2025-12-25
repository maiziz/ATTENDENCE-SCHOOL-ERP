import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/features/auth/providers/auth_provider.dart';
import 'package:attendence_school_erp/core/enums/enums.dart';
import 'package:attendence_school_erp/features/attendance/screens/attendance_screen.dart';
import 'package:attendence_school_erp/features/requests/screens/requests_screen.dart';
import 'package:attendence_school_erp/features/grading/screens/grading_screen.dart';
import 'package:attendence_school_erp/features/admin/screens/account_management_screen.dart';
import 'package:attendence_school_erp/features/observations/screens/observations_screen.dart';
import 'package:attendence_school_erp/features/dashboard/providers/dashboard_provider.dart';
import 'package:attendence_school_erp/features/entry_pass/screens/entry_pass_screen.dart';
import 'package:attendence_school_erp/features/council/screens/council_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final dashState = ref.watch(dashboardProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const Scaffold(
            body: Center(child: Text('لم يتم العثور على الملف الشخصي')),
          );
        }

        // Trigger data loading if not already loading
        if (!dashState.isLoading) {
          if (profile.role == UserRole.director &&
              dashState.directorStats == null) {
            Future.microtask(
              () => ref.read(dashboardProvider.notifier).loadDirectorStats(),
            );
          } else if ((profile.role == UserRole.teacher ||
                  profile.role == UserRole.head_teacher) &&
              dashState.teacherSession == null) {
            Future.microtask(
              () => ref
                  .read(dashboardProvider.notifier)
                  .loadTeacherSession(profile.id),
            );
          }
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: CustomScrollView(
            slivers: [
              // Premium Header
              SliverToBoxAdapter(
                child: Container(
                  height: 280,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1E293B), Color(0xFF334155)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative elements
                      Positioned(
                        right: -50,
                        top: -50,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'مرحباً بك،',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        profile.fullName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        await ref
                                            .read(authServiceProvider)
                                            .signOut();
                                        if (context.mounted)
                                          Navigator.of(
                                            context,
                                          ).pushReplacementNamed('/login');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.blueAccent.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  _getRoleTitle(profile.role),
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Role-Specific Content Sliver
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                sliver: SliverToBoxAdapter(
                  child: _buildRoleSpecificContent(
                    profile.role,
                    dashState,
                    context,
                  ),
                ),
              ),

              // Menu Grid
              SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildListDelegate(
                    _buildMenuItems(context, profile.role),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('خطأ: $error'))),
    );
  }

  Widget _buildRoleSpecificContent(
    UserRole role,
    DashboardState state,
    BuildContext context,
  ) {
    if (role == UserRole.director) {
      return _DirectorStatsWidgets(stats: state.directorStats);
    } else if (role == UserRole.teacher || role == UserRole.head_teacher) {
      return _TeacherActiveSessionCard(session: state.teacherSession);
    }
    return const SizedBox.shrink();
  }

  String _getRoleTitle(UserRole role) {
    switch (role) {
      case UserRole.director:
        return 'مدير المؤسسة';
      case UserRole.general_supervisor:
        return 'مراقب عام';
      case UserRole.field_supervisor:
        return 'مراقب ساحة';
      case UserRole.head_teacher:
        return 'أستاذ منسق';
      case UserRole.teacher:
        return 'أستاذ';
      case UserRole.economist:
        return 'مقتصد';
    }
  }

  List<Widget> _buildMenuItems(BuildContext context, UserRole role) {
    final commonItems = <DashboardMenuItem>[];

    switch (role) {
      case UserRole.director:
        commonItems.addAll([
          DashboardMenuItem(
            title: 'الطلبات',
            icon: Icons.assignment_rounded,
            color: const Color(0xFF3B82F6),
          ),
          DashboardMenuItem(
            title: 'الغيابات',
            icon: Icons.event_busy_rounded,
            color: const Color(0xFFEF4444),
          ),
          DashboardMenuItem(
            title: 'الحسابات',
            icon: Icons.people_alt_rounded,
            color: const Color(0xFF10B981),
          ),
          DashboardMenuItem(
            title: 'الإحصائيات',
            icon: Icons.analytics_rounded,
            color: const Color(0xFF8B5CF6),
          ),
          DashboardMenuItem(
            title: 'مجلس القسم',
            icon: Icons.groups_rounded,
            color: const Color(0xFF6366F1),
          ),
        ]);
        break;
      case UserRole.general_supervisor:
      case UserRole.field_supervisor:
        commonItems.addAll([
          DashboardMenuItem(
            title: 'الغيابات',
            icon: Icons.event_busy_rounded,
            color: const Color(0xFFEF4444),
          ),
          DashboardMenuItem(
            title: 'تصاريح الدخول',
            icon: Icons.badge_rounded,
            color: const Color(0xFF3B82F6),
          ),
          DashboardMenuItem(
            title: 'الطلبات',
            icon: Icons.assignment_rounded,
            color: const Color(0xFF10B981),
          ),
        ]);
        break;
      case UserRole.teacher:
      case UserRole.head_teacher:
        commonItems.addAll([
          DashboardMenuItem(
            title: 'الغيابات',
            icon: Icons.event_busy_rounded,
            color: const Color(0xFFEF4444),
          ),
          DashboardMenuItem(
            title: 'رصد العلامات',
            icon: Icons.grade_rounded,
            color: const Color(0xFF10B981),
          ),
          DashboardMenuItem(
            title: 'مجلس القسم',
            icon: Icons.groups_rounded,
            color: const Color(0xFF6366F1),
          ),
          DashboardMenuItem(
            title: 'الطلبات',
            icon: Icons.assignment_rounded,
            color: const Color(0xFF3B82F6),
          ),
        ]);
        break;
      // Add other roles as needed...
      default:
        commonItems.addAll([
          DashboardMenuItem(
            title: 'الغيابات',
            icon: Icons.event_busy_rounded,
            color: const Color(0xFFEF4444),
          ),
          DashboardMenuItem(
            title: 'الطلبات',
            icon: Icons.assignment_rounded,
            color: const Color(0xFF3B82F6),
          ),
        ]);
    }

    return commonItems
        .map(
          (item) => _DashboardCard(
            item: item,
            onTap: () {
              // Map icons/titles to screens
              if (item.title.contains('الغيابات'))
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AttendanceScreen()),
                );
              if (item.title.contains('العلامات'))
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GradingScreen()),
                );
              if (item.title.contains('الطلبات'))
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RequestsScreen()),
                );
              if (item.title.contains('الحسابات'))
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AccountManagementScreen(),
                  ),
                );
              if (item.title.contains('الملاحظات'))
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ObservationsScreen()),
                );
              if (item.title.contains('تصاريح'))
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EntryPassScreen()),
                );
              if (item.title.contains('مجلس'))
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CouncilScreen()),
                );
            },
          ),
        )
        .toList();
  }
}

class DashboardMenuItem {
  final String title;
  final IconData icon;
  final Color color;

  DashboardMenuItem({
    required this.title,
    required this.icon,
    required this.color,
  });
}

class _DashboardCard extends StatelessWidget {
  final DashboardMenuItem item;
  final VoidCallback onTap;

  const _DashboardCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, size: 32, color: item.color),
                ),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DirectorStatsWidgets extends StatelessWidget {
  final DashboardStats? stats;
  const _DirectorStatsWidgets({this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats == null) return const Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إحصائيات حية',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'نسبة الحضور',
                value: '${stats!.attendancePercentage.toStringAsFixed(1)}%',
                icon: Icons.pie_chart_rounded,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'طاقم غائب',
                value: '${stats!.absentStaffCount}',
                icon: Icons.person_off_rounded,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'طلبات معلقة',
                value: '${stats!.pendingRequestsCount}',
                icon: Icons.pending_actions_rounded,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class _TeacherActiveSessionCard extends StatelessWidget {
  final ActiveSession? session;
  const _TeacherActiveSessionCard({this.session});

  @override
  Widget build(BuildContext context) {
    if (session == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timer_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'حصتك الآن',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'القسم: ${session!.className}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'المادة: ${session!.subject} | القاعة: ${session!.room}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to Attendance or Start Session
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AttendanceScreen()),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('بدء الحصة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
