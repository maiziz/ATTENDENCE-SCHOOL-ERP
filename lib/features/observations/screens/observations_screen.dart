import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/core/enums/enums.dart';
import 'package:attendence_school_erp/features/observations/providers/observation_provider.dart';
import 'package:attendence_school_erp/features/auth/providers/auth_provider.dart';
import 'package:attendence_school_erp/core/models/student.dart';
import 'package:attendence_school_erp/core/models/school_class.dart';

class ObservationsScreen extends ConsumerStatefulWidget {
  const ObservationsScreen({super.key});

  @override
  ConsumerState<ObservationsScreen> createState() => _ObservationsScreenState();
}

class _ObservationsScreenState extends ConsumerState<ObservationsScreen> {
  ObservationType filterType = ObservationType.behavioral;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(observationProvider.notifier).loadObservations();
    });
  }

  void _showCreateObservationDialog() async {
    final contentController = TextEditingController();
    ObservationType selectedType = ObservationType.behavioral;
    ObservationVisibility selectedVisibility = ObservationVisibility.public;
    String? selectedStudentId;
    String? selectedClassId;
    List<Student> students = [];
    List<SchoolClass> classes = await ref
        .read(observationProvider.notifier)
        .loadAllClasses();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('ملاحظة جديدة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Class Selector
                DropdownButtonFormField<String>(
                  value: selectedClassId,
                  decoration: const InputDecoration(
                    labelText: 'القسم (اختياري للفلترة)',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('الكل')),
                    ...classes.map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ),
                  ],
                  onChanged: (value) async {
                    List<Student> filteredStudents;
                    if (value == null) {
                      filteredStudents = await ref
                          .read(observationProvider.notifier)
                          .loadAllStudents();
                    } else {
                      filteredStudents = await ref
                          .read(observationProvider.notifier)
                          .loadStudentsByClass(value);
                    }
                    setDialogState(() {
                      selectedClassId = value;
                      students = filteredStudents;
                      selectedStudentId = null;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Student Selector
                DropdownButtonFormField<String>(
                  value: selectedStudentId,
                  decoration: const InputDecoration(
                    labelText: 'التلميذ',
                    border: OutlineInputBorder(),
                  ),
                  items: students
                      .map(
                        (s) => DropdownMenuItem(
                          value: s.id,
                          child: Text(s.fullName),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedStudentId = value);
                  },
                ),
                const SizedBox(height: 16),

                // Type Selector
                DropdownButtonFormField<ObservationType>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'النوع',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: ObservationType.behavioral,
                      child: Text('سلوكية'),
                    ),
                    DropdownMenuItem(
                      value: ObservationType.academic,
                      child: Text('أكاديمية'),
                    ),
                    DropdownMenuItem(
                      value: ObservationType.social,
                      child: Text('اجتماعية'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null)
                      setDialogState(() => selectedType = value);
                  },
                ),
                const SizedBox(height: 16),

                // Visibility Selector
                DropdownButtonFormField<ObservationVisibility>(
                  value: selectedVisibility,
                  decoration: const InputDecoration(
                    labelText: 'الظهور',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: ObservationVisibility.public,
                      child: Text('عامة (يراها الجميع)'),
                    ),
                    DropdownMenuItem(
                      value: ObservationVisibility.restricted,
                      child: Text('محدودة (المدير والمراقب فقط)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null)
                      setDialogState(() => selectedVisibility = value);
                  },
                ),
                const SizedBox(height: 16),

                // Content
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'المحتوى',
                    border: OutlineInputBorder(),
                    hintText: 'اكتب الملاحظة هنا...',
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: selectedStudentId == null
                  ? null
                  : () {
                      final profile = ref
                          .read(currentUserProfileProvider)
                          .value;
                      if (profile == null) return;

                      ref
                          .read(observationProvider.notifier)
                          .createObservation(
                            studentId: selectedStudentId!,
                            authorId: profile.id,
                            type: selectedType,
                            visibility: selectedVisibility,
                            content: contentController.text,
                          );
                      Navigator.pop(context);
                    },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(observationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملاحظات'),
        actions: [
          PopupMenuButton<ObservationType>(
            icon: const Icon(Icons.filter_list),
            onSelected: (type) {
              setState(() => filterType = type);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ObservationType.behavioral,
                child: Text('سلوكية'),
              ),
              const PopupMenuItem(
                value: ObservationType.academic,
                child: Text('أكاديمية'),
              ),
              const PopupMenuItem(
                value: ObservationType.social,
                child: Text('اجتماعية'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateObservationDialog,
        icon: const Icon(Icons.add),
        label: const Text('ملاحظة جديدة'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: Text('خطأ: ${state.error}'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.observations.length,
              itemBuilder: (context, index) {
                final obs = state.observations[index];
                return _ObservationCard(
                  studentName: obs.student.fullName,
                  type: obs.observation.type,
                  visibility: obs.observation.visibility,
                  content: obs.observation.content,
                  authorName: obs.authorName,
                  date: obs.observation.createdAt ?? DateTime.now(),
                );
              },
            ),
    );
  }
}

class _ObservationCard extends StatelessWidget {
  final String studentName;
  final ObservationType type;
  final ObservationVisibility visibility;
  final String content;
  final String authorName;
  final DateTime date;

  const _ObservationCard({
    required this.studentName,
    required this.type,
    required this.visibility,
    required this.content,
    required this.authorName,
    required this.date,
  });

  String _getTypeLabel(ObservationType type) {
    switch (type) {
      case ObservationType.behavioral:
        return 'سلوكية';
      case ObservationType.academic:
        return 'أكاديمية';
      case ObservationType.social:
        return 'اجتماعية';
    }
  }

  Color _getTypeColor(ObservationType type) {
    switch (type) {
      case ObservationType.behavioral:
        return Colors.blue;
      case ObservationType.academic:
        return Colors.green;
      case ObservationType.social:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getTypeColor(type),
                  child: Text(
                    studentName[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Chip(
                            label: Text(_getTypeLabel(type)),
                            backgroundColor: _getTypeColor(
                              type,
                            ).withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: _getTypeColor(type),
                              fontSize: 12,
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 8),
                          if (visibility == ObservationVisibility.restricted)
                            const Icon(
                              Icons.lock,
                              size: 16,
                              color: Colors.grey,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Content
            Text(content, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 12),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'بواسطة: $authorName',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
