import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/features/requests/providers/request_provider.dart';
import 'package:attendence_school_erp/core/models/request.dart';
import 'package:attendence_school_erp/core/enums/enums.dart';
import 'package:attendence_school_erp/features/auth/providers/auth_provider.dart';
import 'package:attendence_school_erp/features/requests/widgets/request_timeline.dart';
import 'package:intl/intl.dart';

class RequestsScreen extends ConsumerStatefulWidget {
  const RequestsScreen({super.key});

  @override
  ConsumerState<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends ConsumerState<RequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRequests();
    });
  }

  void _loadRequests() {
    final profile = ref.read(currentUserProfileProvider).value;
    if (profile != null) {
      ref
          .read(requestsProvider.notifier)
          .loadRequests(profile.id, profile.role);
    }
  }

  void _showCreateRequestDialog() {
    final contentController = TextEditingController();
    RequestCategory selectedCategory = RequestCategory.material;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('طلب جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<RequestCategory>(
              value: selectedCategory,
              decoration: const InputDecoration(labelText: 'الفئة'),
              items: const [
                DropdownMenuItem(
                  value: RequestCategory.material,
                  child: Text('مواد'),
                ),
                DropdownMenuItem(
                  value: RequestCategory.maintenance,
                  child: Text('صيانة'),
                ),
                DropdownMenuItem(
                  value: RequestCategory.pedagogical,
                  child: Text('تربوي'),
                ),
                DropdownMenuItem(
                  value: RequestCategory.admin,
                  child: Text('إداري'),
                ),
              ],
              onChanged: (value) {
                if (value != null) selectedCategory = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'المحتوى',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final profile = ref.read(currentUserProfileProvider).value;
              if (profile == null) return;

              ref
                  .read(requestsProvider.notifier)
                  .createRequest(
                    requesterId: profile.id,
                    category: selectedCategory,
                    content: contentController.text,
                  );
              Navigator.pop(context);
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requestsState = ref.watch(requestsProvider);
    final profile = ref.watch(currentUserProfileProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلبات والتقارير'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRequests),
        ],
      ),
      floatingActionButton:
          profile?.role == UserRole.teacher ||
              profile?.role == UserRole.head_teacher
          ? FloatingActionButton.extended(
              onPressed: _showCreateRequestDialog,
              icon: const Icon(Icons.add),
              label: const Text('طلب جديد'),
            )
          : null,
      body: requestsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : requestsState.error != null
          ? Center(
              child: Text(
                'خطأ: ${requestsState.error}',
                style: const TextStyle(color: Colors.red),
              ),
            )
          : Column(
              children: [
                if (profile?.role == UserRole.economist)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.task_alt, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'مهامي المسندة (${requestsState.requests.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: requestsState.requests.isEmpty
                      ? const Center(child: Text('لا توجد طلبات'))
                      : ListView.builder(
                          itemCount: requestsState.requests.length,
                          itemBuilder: (context, index) {
                            final request = requestsState.requests[index];
                            return _RequestCard(request: request);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _RequestCard extends ConsumerWidget {
  final Request request;

  const _RequestCard({required this.request});

  String _getCategoryLabel(RequestCategory category) {
    switch (category) {
      case RequestCategory.material:
        return 'مواد';
      case RequestCategory.maintenance:
        return 'صيانة';
      case RequestCategory.pedagogical:
        return 'تربوي';
      case RequestCategory.admin:
        return 'إداري';
    }
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.sent:
        return Colors.blue;
      case RequestStatus.seen:
        return Colors.orange;
      case RequestStatus.forwarded:
        return Colors.purple;
      case RequestStatus.completed:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(request.status).withOpacity(0.1),
          child: Icon(Icons.assignment, color: _getStatusColor(request.status)),
        ),
        title: Text(
          _getCategoryLabel(request.category),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          request.content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'المحتوى:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(request.content, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),

                const Text(
                  'تتبع الطلب:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                RequestTimeline(request: request),

                const SizedBox(height: 16),
                _buildRoleActions(context, ref),

                if (request.status == RequestStatus.rejected &&
                    request.rejectionReason != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'سبب الرفض:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(request.rejectionReason!),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleActions(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    if (profile == null) return const SizedBox.shrink();

    if (profile.role == UserRole.director) {
      if (request.status == RequestStatus.sent) {
        return Row(
          children: [
            ElevatedButton(
              onPressed: () =>
                  ref.read(requestsProvider.notifier).markAsSeen(request.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('تمييز كمشاهد'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => _showForwardModal(context, ref),
              child: const Text('توجيه الطلب'),
            ),
          ],
        );
      } else if (request.status == RequestStatus.seen) {
        return OutlinedButton(
          onPressed: () => _showForwardModal(context, ref),
          child: const Text('توجيه الطلب'),
        );
      }
    }

    if (profile.id == request.assignedTo &&
        request.status == RequestStatus.forwarded) {
      return ElevatedButton.icon(
        onPressed: () =>
            ref.read(requestsProvider.notifier).completeRequest(request.id),
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('تم الإنجاز'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showForwardModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'توجيه الطلب إلى:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _StaffListTile(
              title: 'السيد المقتصد',
              subtitle: 'مصلحة الحسابات والوسائل',
              onTap: () {
                ref
                    .read(requestsProvider.notifier)
                    .forwardRequest(
                      requestId: request.id,
                      assignedToId: 'economist_id',
                    );
                Navigator.pop(context);
              },
            ),
            _StaffListTile(
              title: 'المراقب العام',
              subtitle: 'مصلحة التلميذ',
              onTap: () {
                ref
                    .read(requestsProvider.notifier)
                    .forwardRequest(
                      requestId: request.id,
                      assignedToId: 'supervisor_id',
                    );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _StaffListTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFE2E8F0),
        child: Icon(Icons.person, color: Color(0xFF64748B)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
