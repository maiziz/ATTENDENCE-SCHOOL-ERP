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
import 'package:attendence_school_erp/features/attendance/screens/lesson_log_screen.dart';

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
          } else if ((profile.role == UserRole.general_supervisor ||
                  profile.role == UserRole.field_supervisor) &&
              dashState.supervisorStats == null) {
            Future.microtask(
              () => ref.read(dashboardProvider.notifier).loadSupervisorStats(),
            );
          } else if (profile.role == UserRole.economist &&
              dashState.economistStats == null) {
            Future.microtask(
              () => ref.read(dashboardProvider.notifier).loadEconomistStats(),
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
    } else if (role == UserRole.general_supervisor ||
        role == UserRole.field_supervisor) {
      return _SupervisorStatsWidgets(stats: state.supervisorStats);
    } else if (role == UserRole.economist) {
      return _EconomistStatsWidgets(stats: state.economistStats);
    } else if (role == UserRole.teacher || role == UserRole.head_teacher) {
      return _TeacherWeeklySchedule(schedule: state.weeklySchedule);
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
        commonItems.addAll([
          DashboardMenuItem(
            title: 'الغيابات (طلاب)',
            icon: Icons.event_busy_rounded,
            color: const Color(0xFFEF4444),
          ),
          DashboardMenuItem(
            title: 'تصاريح الدخول',
            icon: Icons.badge_rounded,
            color: const Color(0xFF3B82F6),
          ),
          DashboardMenuItem(
            title: 'الملاحظات والسلوك',
            icon: Icons.psychology_rounded,
            color: const Color(0xFFF59E0B),
          ),
          DashboardMenuItem(
            title: 'الطلبات والتبليغات',
            icon: Icons.assignment_rounded,
            color: const Color(0xFF10B981),
          ),
        ]);
        break;
      case UserRole.field_supervisor:
        commonItems.addAll([
          DashboardMenuItem(
            title: 'رصد السلوك',
            icon: Icons.add_comment_rounded,
            color: const Color(0xFFF59E0B),
          ),
          DashboardMenuItem(
            title: 'تصاريح الدخول',
            icon: Icons.badge_rounded,
            color: const Color(0xFF3B82F6),
          ),
          DashboardMenuItem(
            title: 'الطلبات',
            icon: Icons.assignment_rounded,
            color: const Color(0xFF3B82F6),
          ),
        ]);
        break;
      case UserRole.teacher:
      case UserRole.head_teacher:
        commonItems.addAll([
          DashboardMenuItem(
            title: 'تسجيل الغياب',
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
            title: 'دفتر النصوص',
            icon: Icons.menu_book_rounded,
            color: const Color(0xFF8B5CF6),
          ),
          DashboardMenuItem(
            title: 'طلباتي',
            icon: Icons.assignment_rounded,
            color: const Color(0xFF3B82F6),
          ),
        ]);
        break;
      case UserRole.economist:
        commonItems.addAll([
          DashboardMenuItem(
            title: 'إدارة الطلبات',
            icon: Icons.inventory_2_rounded,
            color: const Color(0xFF10B981),
          ),
          DashboardMenuItem(
            title: 'الصيانة والمرافق',
            icon: Icons.build_rounded,
            color: const Color(0xFFEF4444),
          ),
          DashboardMenuItem(
            title: 'الميزانية (تجريبي)',
            icon: Icons.account_balance_wallet_rounded,
            color: const Color(0xFFF59E0B),
          ),
          DashboardMenuItem(
            title: 'الغيابات',
            icon: Icons.event_busy_rounded,
            color: const Color(0xFF3B82F6),
          ),
        ]);
        break;
    }

    return commonItems
        .map(
          (item) => _DashboardCard(
            item: item,
            onTap: () {
              // Map icons/titles to screens
              if (item.title.contains('الغياب'))
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
              if (item.title.contains('السلوك') ||
                  item.title.contains('الملاحظات'))
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
              if (item.title.contains('النصوص'))
                // For Cahier de Texte from menu, we might need a generic or session-picker screen
                // For now, push a placeholder if no session_id is active
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LessonLogScreen(
                      sessionId: 'menu',
                      className: 'N/A',
                      subject: 'N/A',
                    ),
                  ),
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
  final DirectorStats? stats;
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

class _SupervisorStatsWidgets extends StatelessWidget {
  final SupervisorStats? stats;
  const _SupervisorStatsWidgets({this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats == null) return const Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نظرة عامة (المراقبين)',
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
                label: 'غيابات اليوم',
                value: '${stats!.totalAbsencesToday}',
                icon: Icons.group_off_rounded,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'تصاريح نشطة',
                value: '${stats!.activeEntryPasses}',
                icon: Icons.confirmation_number_rounded,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'تقارير سلوك',
                value: '${stats!.behavioralIncidents}',
                icon: Icons.report_problem_rounded,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EconomistStatsWidgets extends StatelessWidget {
  final EconomistStats? stats;
  const _EconomistStatsWidgets({this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats == null) return const Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إدارة الموارد (المقتصد)',
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
                label: 'طلبات مواد',
                value: '${stats!.pendingMaterialRequests}',
                icon: Icons.inventory_rounded,
                color: Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'صيانة جارية',
                value: '${stats!.ongoingMaintenance}',
                icon: Icons.handyman_rounded,
                color: Colors.brown,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'استهلاك الميزانية',
                value: '${stats!.budgetUtilization.toStringAsFixed(0)}%',
                icon: Icons.account_balance_rounded,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TeacherWeeklySchedule extends StatefulWidget {
  final List<ScheduleItem> schedule;
  const _TeacherWeeklySchedule({required this.schedule});

  @override
  State<_TeacherWeeklySchedule> createState() => _TeacherWeeklyScheduleState();
}

class _TeacherWeeklyScheduleState extends State<_TeacherWeeklySchedule>
    with SingleTickerProviderStateMixin {
  int selectedDay = DateTime.now().weekday; // 1 = Mon ... 7 = Sun
  // Convert to 0-indexed Sat-Thu or Sun-Thu based on project needs.
  // Assuming 0=Sat, 1=Sun, 2=Mon, 3=Tue, 4=Wed, 5=Thu
  late int activeDayIndex;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Map DateTime.weekday to 0-indexed Algerian week (Sun=1, Mon=2, etc)
    // Here we'll just use 0-4 for Sun-Thu for simplicity in mock
    activeDayIndex = (DateTime.now().weekday % 7);
    selectedDay = activeDayIndex;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dayNames = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];
    final daySchedule = widget.schedule
        .where((s) => s.dayIndex == selectedDay)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'جدول التوقيت الأسبوعي',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        // Day Picker
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(dayNames.length, (index) {
              final isSelected = selectedDay == index;
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ChoiceChip(
                  label: Text(dayNames[index]),
                  selected: isSelected,
                  onSelected: (val) => setState(() => selectedDay = index),
                  selectedColor: const Color(0xFF3B82F6),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        if (daySchedule.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('لا توجد حصص في هذا اليوم'),
            ),
          )
        else
          ...daySchedule.map(
            (item) => _ScheduleItemCard(
              item: item,
              isActive: _isItemActive(item),
              animation: _pulseController,
            ),
          ),
      ],
    );
  }

  bool _isItemActive(ScheduleItem item) {
    if (item.dayIndex != activeDayIndex) return false;
    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return currentTime.compareTo(item.startTime) >= 0 &&
        currentTime.compareTo(item.endTime) <= 0;
  }
}

class _ScheduleItemCard extends StatelessWidget {
  final ScheduleItem item;
  final bool isActive;
  final Animation<double> animation;

  const _ScheduleItemCard({
    required this.item,
    required this.isActive,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? Colors.blue.withOpacity(0.5 + 0.5 * animation.value)
                  : Colors.transparent,
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 10 * animation.value,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      item.startTime,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Icon(
                      Icons.arrow_downward,
                      size: 12,
                      color: Colors.grey,
                    ),
                    Text(
                      item.endTime,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                const VerticalDivider(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'القسم: ${item.className}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${item.subject} | قاعة ${item.room}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isActive)
                  const Icon(Icons.lock_outline, color: Colors.grey, size: 20)
                else
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AttendanceScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('تسجيل الغياب'),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LessonLogScreen(
                                sessionId: item.id,
                                className: item.className,
                                subject: item.subject,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_note, size: 18),
                        label: const Text(
                          'دفتر النصوص',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
