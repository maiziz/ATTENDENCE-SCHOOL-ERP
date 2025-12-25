import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/main.dart';

class LessonLogScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String className;
  final String subject;

  const LessonLogScreen({
    super.key,
    required this.sessionId,
    required this.className,
    required this.subject,
  });

  @override
  ConsumerState<LessonLogScreen> createState() => _LessonLogScreenState();
}

class _LessonLogScreenState extends ConsumerState<LessonLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _objectivesCtrl = TextEditingController();
  final _homeworkCtrl = TextEditingController();
  bool _isSaving = false;

  Future<void> _saveLog() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      await supabase.from('lesson_logs').upsert({
        'session_id': widget.sessionId,
        'title': _titleCtrl.text,
        'objectives': _objectivesCtrl.text,
        'homework': _homeworkCtrl.text,
        'date': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ دفتر النصوص بنجاح')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في الحفظ: $e')));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _copyPrevious() async {
    // Logic: Look for the most recent log of the same subject in a parallel class
    // For demo, we'll just mock it or search for same subject
    try {
      final data = await supabase
          .from('lesson_logs')
          .select('title, objectives, homework')
          // .eq('subject', widget.subject) // if subject was stored
          .order('date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data != null) {
        setState(() {
          _titleCtrl.text = data['title'] ?? '';
          _objectivesCtrl.text = data['objectives'] ?? '';
          _homeworkCtrl.text = data['homework'] ?? '';
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('تم نسخ محتوى آخر حصة')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لا توجد دروس سابقة لنسخها')),
          );
        }
      }
    } catch (e) {
      // Error handled silently for demo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دفتر النصوص (Cahier de Texte)'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'عنوان الدرس',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'يرجى إدخال العنوان' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _objectivesCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'الأهداف والمحتوى المعرفي',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _homeworkCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'الواجب المنزلي',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveLog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'حفظ محتوى الحصة',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _copyPrevious,
        label: const Text('نسخ من حصة سابقة'),
        icon: const Icon(Icons.copy_rounded),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'القسم: ${widget.className}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('المادة: ${widget.subject}'),
            ],
          ),
        ],
      ),
    );
  }
}
