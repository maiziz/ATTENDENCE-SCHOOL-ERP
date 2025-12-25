import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/features/grading/providers/grading_provider.dart';
import 'package:attendence_school_erp/features/observations/providers/observation_provider.dart';
import 'package:attendence_school_erp/features/auth/providers/auth_provider.dart';
import 'package:attendence_school_erp/core/models/school_class.dart';

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
                // Header Filters
                Container(
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
                                (c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name),
                                ),
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
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
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
                ),

                if (!isFocusMode)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'التلميذ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'تقييم',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'فرض',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'اختبار',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                Expanded(
                  child: gradingState.isLoading && gradingState.records.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : isFocusMode
                      ? _buildFocusView(gradingState)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: gradingState.records.length,
                          itemBuilder: (context, index) {
                            final record = gradingState.records[index];
                            return _GradingRow(
                              record: record,
                              subject: selectedSubject,
                              onSave: (eval, fard, exam, obs) =>
                                  _saveGrade(record, eval, fard, exam, obs),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
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

class _GradingRow extends StatefulWidget {
  final GradingRecord record;
  final String subject;
  final Function(double?, double?, double?, String?) onSave;

  const _GradingRow({
    required this.record,
    required this.subject,
    required this.onSave,
  });

  @override
  State<_GradingRow> createState() => _GradingRowState();
}

class _GradingRowState extends State<_GradingRow> {
  late TextEditingController _evalCtrl;
  late TextEditingController _fardCtrl;
  late TextEditingController _examCtrl;

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
  }

  @override
  void didUpdateWidget(_GradingRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.record.grade != oldWidget.record.grade) {
      if (!_evalCtrl.selection.isValid)
        _evalCtrl.text = widget.record.grade?.evaluation?.toString() ?? '';
      if (!_fardCtrl.selection.isValid)
        _fardCtrl.text = widget.record.grade?.fard?.toString() ?? '';
      if (!_examCtrl.selection.isValid)
        _examCtrl.text = widget.record.grade?.exam?.toString() ?? '';
    }
  }

  void _triggerSave() {
    final eval = double.tryParse(_evalCtrl.text);
    final fard = double.tryParse(_fardCtrl.text);
    final exam = double.tryParse(_examCtrl.text);
    widget.onSave(eval, fard, exam, null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              widget.record.student.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: _CompactInput(controller: _evalCtrl, onBlur: _triggerSave),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactInput(controller: _fardCtrl, onBlur: _triggerSave),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactInput(controller: _examCtrl, onBlur: _triggerSave),
          ),
          IconButton(
            icon: Icon(
              widget.record.grade?.teacherObservation != null
                  ? Icons.chat
                  : Icons.chat_bubble_outline,
              size: 20,
              color: Colors.blue,
            ),
            onPressed: () => _showObservationSheet(context),
          ),
        ],
      ),
    );
  }

  void _showObservationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ObservationSheet(
        studentName: widget.record.student.fullName,
        initialObservation: widget.record.grade?.teacherObservation,
        onSave: (obs) => widget.onSave(
          double.tryParse(_evalCtrl.text),
          double.tryParse(_fardCtrl.text),
          double.tryParse(_examCtrl.text),
          obs,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _evalCtrl.dispose();
    _fardCtrl.dispose();
    _examCtrl.dispose();
    super.dispose();
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.blue.shade50,
                child: Text(
                  widget.record.student.fullName[0],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
              const Divider(),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'ملاحظات مقترحة:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              _ObservationChips(
                onSelected: (val) {
                  setState(() => _obsCtrl.text = val);
                  _save();
                },
                average: _calculateAverage(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _obsCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'اكتب ملاحظة مخصصة...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                onChanged: (_) => _save(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateAverage() {
    final e = double.tryParse(_evalCtrl.text) ?? 0;
    final f = double.tryParse(_fardCtrl.text) ?? 0;
    final x = double.tryParse(_examCtrl.text) ?? 0;
    return (e + f + x * 2) / 4;
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
      onFocusChange: (hasFocus) {
        if (!hasFocus) onBlur();
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
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
    List<String> suggestions = [];
    if (average < 10) {
      suggestions = ['نتائج مقلقة', 'نقص في التركيز', 'يجب بذل مجهود مضاعف'];
    } else if (average < 14) {
      suggestions = ['نتائج حسنة واصل', 'تلميذ مشارك', 'يمكنك التحسن أكثر'];
    } else {
      suggestions = ['نتائج ممتازة', 'تلميذ مجتهد ومنضبط', 'أهنئك على مجهودك'];
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: suggestions
          .map(
            (s) => ActionChip(
              label: Text(s, style: const TextStyle(fontSize: 11)),
              onPressed: () => onSelected(s),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          )
          .toList(),
    );
  }
}

class _CompactInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onBlur;
  const _CompactInput({required this.controller, required this.onBlur});
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) onBlur();
      },
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
    );
  }
}

class _ObservationSheet extends StatefulWidget {
  final String studentName;
  final String? initialObservation;
  final Function(String) onSave;
  const _ObservationSheet({
    required this.studentName,
    this.initialObservation,
    required this.onSave,
  });
  @override
  State<_ObservationSheet> createState() => _ObservationSheetState();
}

class _ObservationSheetState extends State<_ObservationSheet> {
  late TextEditingController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialObservation);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملاحظة لـ: ${widget.studentName}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'اكتب ملاحظتك هنا...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(_ctrl.text);
                Navigator.pop(context);
              },
              child: const Text('حفظ الملاحظة'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
