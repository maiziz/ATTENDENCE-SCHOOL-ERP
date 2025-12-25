import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/features/entry_pass/providers/entry_pass_provider.dart';
import 'package:attendence_school_erp/features/auth/providers/auth_provider.dart';
import 'package:attendence_school_erp/core/models/student.dart';

class EntryPassScreen extends ConsumerStatefulWidget {
  const EntryPassScreen({super.key});

  @override
  ConsumerState<EntryPassScreen> createState() => _EntryPassScreenState();
}

class _EntryPassScreenState extends ConsumerState<EntryPassScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  void _showIssueDialog(Student student) {
    final reasonController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedSession = '08:00:00';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('تصريح دخول لـ: ${student.fullName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedSession,
                decoration: const InputDecoration(
                  labelText: 'الحصة',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: '08:00:00', child: Text('08:00')),
                  DropdownMenuItem(value: '09:00:00', child: Text('09:00')),
                  DropdownMenuItem(value: '10:00:00', child: Text('10:00')),
                  DropdownMenuItem(value: '11:00:00', child: Text('11:00')),
                  DropdownMenuItem(value: '13:00:00', child: Text('13:00')),
                  DropdownMenuItem(value: '14:00:00', child: Text('14:00')),
                  DropdownMenuItem(value: '15:00:00', child: Text('15:00')),
                ],
                onChanged: (v) => setState(() => selectedSession = v!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'السبب (اختياري)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                final supervisor = ref.read(currentUserProfileProvider).value;
                if (supervisor == null) return;

                await ref
                    .read(entryPassProvider.notifier)
                    .issueEntryPass(
                      studentId: student.id,
                      supervisorId: supervisor.id,
                      date: selectedDate,
                      sessionTime: selectedSession,
                      reason: reasonController.text,
                    );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إنشاء التصريح بنجاح')),
                  );
                }
              },
              child: const Text('تأكيد'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(entryPassProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('تصاريح الدخول الرقمنية')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'ابحث عن تلميذ...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) =>
                    ref.read(entryPassProvider.notifier).searchStudents(val),
              ),
            ),
          ),

          if (state.isLoading) const Center(child: CircularProgressIndicator()),

          if (state.searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.searchResults.length,
                itemBuilder: (context, index) {
                  final student = state.searchResults[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Text(
                          student.fullName[0],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      title: Text(
                        student.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('اضغط لمنح تصريح دخول'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showIssueDialog(student),
                    ),
                  );
                },
              ),
            )
          else if (_searchCtrl.text.isNotEmpty && !state.isLoading)
            const Expanded(child: Center(child: Text('لا توجد نتائج')))
          else
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.badge_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'ابحث عن تلميذ لمنحه تصريح دخول',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
