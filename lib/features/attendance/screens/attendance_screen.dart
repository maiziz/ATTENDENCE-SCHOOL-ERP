import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/features/attendance/providers/attendance_provider.dart';
import 'package:attendence_school_erp/core/enums/enums.dart';
import 'package:attendence_school_erp/core/models/school_class.dart';
import 'package:attendence_school_erp/features/auth/providers/auth_provider.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedSession = '09:00:00';
  List<SchoolClass> classes = [];
  String? selectedClassId;
  bool isLoadingClasses = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final loadedClasses = await ref
        .read(attendanceProvider.notifier)
        .loadClasses();
    if (mounted) {
      setState(() {
        classes = loadedClasses;
        if (classes.isNotEmpty) {
          selectedClassId = classes.first.id;
        }
        isLoadingClasses = false;
      });
      _loadAttendance();
    }
  }

  void _loadAttendance() {
    if (selectedClassId == null) return;
    ref
        .read(attendanceProvider.notifier)
        .loadAttendance(
          classId: selectedClassId!,
          date: selectedDate,
          sessionTime: selectedSession,
        );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceState = ref.watch(attendanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الحضور'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAttendance,
          ),
        ],
      ),
      body: isLoadingClasses
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Premium Filter Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              value: selectedClassId,
                              decoration: InputDecoration(
                                labelText: 'القسم',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              items: classes.map((c) {
                                return DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => selectedClassId = value);
                                  _loadAttendance();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              value: selectedSession,
                              decoration: InputDecoration(
                                labelText: 'الحصة',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: '08:00:00',
                                  child: Text('08:00'),
                                ),
                                DropdownMenuItem(
                                  value: '09:00:00',
                                  child: Text('09:00'),
                                ),
                                DropdownMenuItem(
                                  value: '10:00:00',
                                  child: Text('10:00'),
                                ),
                                DropdownMenuItem(
                                  value: '11:00:00',
                                  child: Text('11:00'),
                                ),
                                DropdownMenuItem(
                                  value: '13:00:00',
                                  child: Text('13:00'),
                                ),
                                DropdownMenuItem(
                                  value: '14:00:00',
                                  child: Text('14:00'),
                                ),
                                DropdownMenuItem(
                                  value: '15:00:00',
                                  child: Text('15:00'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => selectedSession = value);
                                  _loadAttendance();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Date Picker
                          InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (date != null) {
                                setState(() => selectedDate = date);
                                _loadAttendance();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Bulk Action Button
                          ElevatedButton.icon(
                            onPressed: () async {
                              final profile = ref
                                  .read(currentUserProfileProvider)
                                  .value;
                              if (profile == null || selectedClassId == null)
                                return;

                              await ref
                                  .read(attendanceProvider.notifier)
                                  .markAllPresent(
                                    teacherId: profile.id,
                                    date: selectedDate,
                                    sessionTime: selectedSession,
                                    classId: selectedClassId!,
                                  );

                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم تسجيل الجميع كحضور'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.done_all),
                            label: const Text('حضور الجميع'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Student List
                Expanded(
                  child:
                      attendanceState.isLoading &&
                          attendanceState.records.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : attendanceState.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text('خطأ: ${attendanceState.error}'),
                              TextButton(
                                onPressed: _loadAttendance,
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: attendanceState.records.length,
                          itemBuilder: (context, index) {
                            final record = attendanceState.records[index];
                            return _StudentAttendanceCard(
                              record: record,
                              onMarkAttendance: (status) async {
                                final profile = ref
                                    .read(currentUserProfileProvider)
                                    .value;
                                if (profile == null) return;

                                // Preventive Warning Logic (Relay System)
                                if (status == AttendanceStatus.present &&
                                    record.getBadge() ==
                                        AttendanceBadge.redPreviousAbsence) {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('تنبيه دخول'),
                                      content: Text(
                                        'تنبيه: التلميذ(ة) ${record.student.fullName} كان غائباً في الحصة السابقة. هل أحضر مبرراً أو إذن دخول؟',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('إلغاء'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                          ),
                                          child: const Text('نعم، مسموح له'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm != true) return;
                                }

                                await ref
                                    .read(attendanceProvider.notifier)
                                    .markAttendance(
                                      studentId: record.student.id,
                                      teacherId: profile.id,
                                      date: selectedDate,
                                      sessionTime: selectedSession,
                                      status: status,
                                      classId: selectedClassId!,
                                    );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _StudentAttendanceCard extends StatelessWidget {
  final AttendanceRecord record;
  final Function(AttendanceStatus) onMarkAttendance;

  const _StudentAttendanceCard({
    required this.record,
    required this.onMarkAttendance,
  });

  @override
  Widget build(BuildContext context) {
    final currentStatus = record.attendance?.status;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Student Info
            CircleAvatar(
              radius: 24,
              backgroundColor: _getBadgeColor().withOpacity(0.1),
              child: Text(
                record.student.fullName[0],
                style: TextStyle(
                  color: _getBadgeColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.student.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _getBadgeLabel(),
                    style: TextStyle(color: _getBadgeColor(), fontSize: 13),
                  ),
                ],
              ),
            ),

            // Quick Actions Row
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionButton(
                    icon: Icons.check_circle_rounded,
                    color: Colors.green,
                    isSelected: currentStatus == AttendanceStatus.present,
                    onTap: () => onMarkAttendance(AttendanceStatus.present),
                    tooltip: 'حاضر',
                  ),
                  _ActionButton(
                    icon: Icons.access_time_filled_rounded,
                    color: Colors.orange,
                    isSelected: currentStatus == AttendanceStatus.late,
                    onTap: () => onMarkAttendance(AttendanceStatus.late),
                    tooltip: 'متأخر',
                  ),
                  _ActionButton(
                    icon: Icons.cancel_rounded,
                    color: Colors.red,
                    isSelected: currentStatus == AttendanceStatus.absent,
                    onTap: () => onMarkAttendance(AttendanceStatus.absent),
                    tooltip: 'غائب',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBadgeColor() {
    switch (record.getBadge()) {
      case AttendanceBadge.redPreviousAbsence:
        return Colors.red;
      case AttendanceBadge.blueAuthorized:
        return Colors.blue;
      case AttendanceBadge.orangePotentialEscape:
        return Colors.orange;
      case AttendanceBadge.greenPresent:
        return Colors.green;
      case AttendanceBadge.none:
        return Colors.grey;
    }
  }

  String _getBadgeLabel() {
    switch (record.getBadge()) {
      case AttendanceBadge.redPreviousAbsence:
        return 'غياب سابق';
      case AttendanceBadge.blueAuthorized:
        return 'مسموح بالدخول';
      case AttendanceBadge.orangePotentialEscape:
        return 'هروب محتمل';
      case AttendanceBadge.greenPresent:
        return 'حاضر';
      case AttendanceBadge.none:
        return '';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected ? color : Colors.grey.shade400,
            size: 28,
          ),
        ),
      ),
    );
  }
}
