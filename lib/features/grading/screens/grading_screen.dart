import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/features/grading/providers/grading_provider.dart';
import 'package:attendence_school_erp/features/observations/providers/observation_provider.dart';
import 'package:attendence_school_erp/features/auth/providers/auth_provider.dart';
import 'package:attendence_school_erp/core/models/school_class.dart';
import 'package:pluto_grid/pluto_grid.dart';

class GradingScreen extends ConsumerStatefulWidget {
  const GradingScreen({super.key});

  @override
  ConsumerState<GradingScreen> createState() => _GradingScreenState();
}

class _GradingScreenState extends ConsumerState<GradingScreen> {
  String? selectedClassId;
  String selectedSubject = 'اللغة العربية';
  List<SchoolClass> classes = [];
  bool isLoadingClasses = true;
  bool isFocusMode = false;
  int focusedIndex = 0;

  final List<String> subjects = [
    'اللغة العربية',
    'الرياضيات',
    'اللغة الفرنسية',
    'اللغة الإنجليزية',
    'العلوم الطبيعية',
    'الفيزياء',
    'التاريخ والجغرافيا',
    'التربية الإسلامية',
  ];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    final loadedClasses = await ref
        .read(observationProvider.notifier)
        .loadAllClasses();
    if (mounted) {
      setState(() {
        classes = loadedClasses;
        if (classes.isNotEmpty) {
          selectedClassId = classes.first.id;
          _loadGrades();
        }
        isLoadingClasses = false;
      });
    }
  }

  void _loadGrades() {
    if (selectedClassId == null) return;
    ref
        .read(gradingProvider.notifier)
        .loadClassGrades(classId: selectedClassId!, subject: selectedSubject);
  }

  void _saveGrade(
    GradingRecord record,
    double? eval,
    double? fard,
    double? exam,
    String? obs,
  ) {
    final profile = ref.read(currentUserProfileProvider).value;
    if (profile == null) return;
    ref
        .read(gradingProvider.notifier)
        .saveGrade(
          studentId: record.student.id,
          teacherId: profile.id,
          subject: selectedSubject,
          evaluation: eval,
          fard: fard,
          exam: exam,
          observation: obs,
        );
  }

  @override
  Widget build(BuildContext context) {
    final gradingState = ref.watch(gradingProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('رصد العلامات'),
        actions: [
          IconButton(
            icon: Icon(
              isFocusMode ? Icons.view_list : Icons.filter_center_focus,
            ),
            onPressed: () => setState(() => isFocusMode = !isFocusMode),
            tooltip: isFocusMode ? 'عرض القائمة' : 'وضع التركيز',
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadGrades),
        ],
      ),
      body: isLoadingClasses
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeaderFilters(),
                Expanded(
                  child: gradingState.isLoading && gradingState.records.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : isFocusMode
                      ? _buildFocusView(gradingState)
                      : _buildGridView(gradingState),
                ),
              ],
            ),
    );
  }

  Widget _buildHeaderFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedClassId,
              decoration: InputDecoration(
                labelText: 'القسم',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: classes
                  .map(
                    (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() => selectedClassId = val);
                _loadGrades();
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedSubject,
              decoration: InputDecoration(
                labelText: 'المادة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: subjects
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => selectedSubject = val);
                  _loadGrades();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(GradingState state) {
    if (state.records.isEmpty)
      return const Center(child: Text('لا توجد بيانات'));

    final columns = [
      PlutoColumn(
        title: 'التلميذ',
        field: 'student_name',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 250,
        enableEditingMode: false,
      ),
      PlutoColumn(
        title: 'تقييم',
        field: 'evaluation',
        type: PlutoColumnType.number(format: '#.##'),
        width: 100,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'فرض',
        field: 'fard',
        type: PlutoColumnType.number(format: '#.##'),
        width: 100,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'اختبار',
        field: 'exam',
        type: PlutoColumnType.number(format: '#.##'),
        width: 100,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'ملاحظة',
        field: 'id',
        type: PlutoColumnType.text(),
        width: 80,
        enableEditingMode: false,
        renderer: (rendererContext) {
          final studentId = rendererContext.cell.value as String;
          final record = state.records.firstWhere(
            (r) => r.student.id == studentId,
          );
          return IconButton(
            icon: Icon(
              record.grade?.teacherObservation != null
                  ? Icons.chat
                  : Icons.chat_bubble_outline,
              size: 20,
              color: Colors.blue,
            ),
            onPressed: () => _showObservationModal(record),
          );
        },
      ),
    ];

    final rows = state.records.map((record) {
      return PlutoRow(
        cells: {
          'student_name': PlutoCell(value: record.student.fullName),
          'evaluation': PlutoCell(value: record.grade?.evaluation ?? 0),
          'fard': PlutoCell(value: record.grade?.fard ?? 0),
          'exam': PlutoCell(value: record.grade?.exam ?? 0),
          'id': PlutoCell(value: record.student.id),
        },
      );
    }).toList();

    return PlutoGrid(
      columns: columns,
      rows: rows,
      onChanged: (event) {
        final studentId = event.row.cells['id']!.value as String;
        final record = state.records.firstWhere(
          (r) => r.student.id == studentId,
        );
        _saveGrade(
          record,
          event.row.cells['evaluation']!.value?.toDouble(),
          event.row.cells['fard']!.value?.toDouble(),
          event.row.cells['exam']!.value?.toDouble(),
          record.grade?.teacherObservation,
        );
      },
      configuration: const PlutoGridConfiguration(
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveDown,
      ),
    );
  }

  void _showObservationModal(GradingRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ملاحظة لـ: ${record.student.fullName}'),
        content: _ObservationModalContent(
          initialText: record.grade?.teacherObservation ?? '',
          onSave: (obs) {
            _saveGrade(
              record,
              record.grade?.evaluation,
              record.grade?.fard,
              record.grade?.exam,
              obs,
            );
            Navigator.pop(context);
          },
          average:
              (record.grade?.evaluation ??
                  0 +
                      (record.grade?.fard ?? 0) +
                      ((record.grade?.exam ?? 0) * 2)) /
              4,
        ),
      ),
    );
  }

  Widget _buildFocusView(GradingState state) {
    if (state.records.isEmpty)
      return const Center(child: Text('لا يوجد تلاميذ'));
    if (focusedIndex >= state.records.length) focusedIndex = 0;

    final record = state.records[focusedIndex];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: focusedIndex > 0
                    ? () => setState(() => focusedIndex--)
                    : null,
              ),
              Text(
                'تلميذ ${focusedIndex + 1} من ${state.records.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: focusedIndex < state.records.length - 1
                    ? () => setState(() => focusedIndex++)
                    : null,
              ),
            ],
          ),
        ),
        _FocusGradingCard(
          record: record,
          subject: selectedSubject,
          onSave: (eval, fard, exam, obs) =>
              _saveGrade(record, eval, fard, exam, obs),
        ),
      ],
    );
  }
}

class _ObservationModalContent extends StatefulWidget {
  final String initialText;
  final Function(String) onSave;
  final double average;

  const _ObservationModalContent({
    required this.initialText,
    required this.onSave,
    required this.average,
  });

  @override
  State<_ObservationModalContent> createState() =>
      _ObservationModalContentState();
}

class _ObservationModalContentState extends State<_ObservationModalContent> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ObservationChips(
          onSelected: (val) => setState(() => _ctrl.text = val),
          average: widget.average,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _ctrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'الملاحظة',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => widget.onSave(_ctrl.text),
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}

// Reuse existing components or update them
class _FocusGradingCard extends StatefulWidget {
  final GradingRecord record;
  final String subject;
  final Function(double?, double?, double?, String?) onSave;

  const _FocusGradingCard({
    required this.record,
    required this.subject,
    required this.onSave,
  });

  @override
  State<_FocusGradingCard> createState() => _FocusGradingCardState();
}

class _FocusGradingCardState extends State<_FocusGradingCard> {
  late TextEditingController _evalCtrl;
  late TextEditingController _fardCtrl;
  late TextEditingController _examCtrl;
  late TextEditingController _obsCtrl;

  @override
  void initState() {
    super.initState();
    _evalCtrl = TextEditingController(
      text: widget.record.grade?.evaluation?.toString() ?? '',
    );
    _fardCtrl = TextEditingController(
      text: widget.record.grade?.fard?.toString() ?? '',
    );
    _examCtrl = TextEditingController(
      text: widget.record.grade?.exam?.toString() ?? '',
    );
    _obsCtrl = TextEditingController(
      text: widget.record.grade?.teacherObservation ?? '',
    );
  }

  @override
  void didUpdateWidget(_FocusGradingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.record != oldWidget.record) {
      _evalCtrl.text = widget.record.grade?.evaluation?.toString() ?? '';
      _fardCtrl.text = widget.record.grade?.fard?.toString() ?? '';
      _examCtrl.text = widget.record.grade?.exam?.toString() ?? '';
      _obsCtrl.text = widget.record.grade?.teacherObservation ?? '';
    }
  }

  void _save() {
    widget.onSave(
      double.tryParse(_evalCtrl.text),
      double.tryParse(_fardCtrl.text),
      double.tryParse(_examCtrl.text),
      _obsCtrl.text.isEmpty ? null : _obsCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                widget.record.student.fullName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _LargeFocusInput(
                      label: 'تقييم',
                      controller: _evalCtrl,
                      onBlur: _save,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LargeFocusInput(
                      label: 'فرض',
                      controller: _fardCtrl,
                      onBlur: _save,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LargeFocusInput(
                      label: 'اختبار',
                      controller: _examCtrl,
                      onBlur: _save,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _ObservationChips(
                onSelected: (val) {
                  setState(() => _obsCtrl.text = val);
                  _save();
                },
                average: (double.tryParse(_evalCtrl.text) ?? 10), // simplified
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _obsCtrl,
                maxLines: 2,
                onChanged: (_) => _save(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LargeFocusInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onBlur;
  const _LargeFocusInput({
    required this.label,
    required this.controller,
    required this.onBlur,
  });
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) {
        if (!f) onBlur();
      },
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _ObservationChips extends StatelessWidget {
  final Function(String) onSelected;
  final double average;
  const _ObservationChips({required this.onSelected, required this.average});
  @override
  Widget build(BuildContext context) {
    List<String> suggestions = average < 10
        ? ['نتائج مقلقة', 'نقص تركيز']
        : ['ممتاز واصل', 'تلميذ مجتهد'];
    return Wrap(
      spacing: 6,
      children: suggestions
          .map(
            (s) => ActionChip(label: Text(s), onPressed: () => onSelected(s)),
          )
          .toList(),
    );
  }
}
