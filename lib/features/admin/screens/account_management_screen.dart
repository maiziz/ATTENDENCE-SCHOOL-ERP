import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/core/enums/enums.dart';

class AccountManagementScreen extends ConsumerStatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  ConsumerState<AccountManagementScreen> createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState
    extends ConsumerState<AccountManagementScreen> {
  void _showCreateAccountDialog() {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    UserRole selectedRole = UserRole.teacher;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('حساب جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<UserRole>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'الدور',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: UserRole.director,
                      child: Text('المدير'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.general_supervisor,
                      child: Text('المراقب العام'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.field_supervisor,
                      child: Text('المشرف التربوي'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.head_teacher,
                      child: Text('مسؤول القسم'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.teacher,
                      child: Text('أستاذ'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.economist,
                      child: Text('المقتصد'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedRole = value);
                    }
                  },
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
              onPressed: () {
                // Create account
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إنشاء الحساب')),
                );
                Navigator.pop(context);
              },
              child: const Text('إنشاء'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الحسابات')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateAccountDialog,
        icon: const Icon(Icons.person_add),
        label: const Text('حساب جديد'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Demo data
        itemBuilder: (context, index) {
          return _AccountCard(
            name: 'سارة بن يوسف',
            email: 'teacher@school.dz',
            phone: '+213555456789',
            role: UserRole.teacher,
            isActive: index != 2,
          );
        },
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final bool isActive;

  const _AccountCard({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
  });

  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.director:
        return 'المدير';
      case UserRole.general_supervisor:
        return 'المراقب العام';
      case UserRole.field_supervisor:
        return 'المشرف التربوي';
      case UserRole.head_teacher:
        return 'مسؤول القسم';
      case UserRole.teacher:
        return 'أستاذ';
      case UserRole.economist:
        return 'المقتصد';
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.director:
        return Colors.purple;
      case UserRole.general_supervisor:
        return Colors.blue;
      case UserRole.field_supervisor:
        return Colors.teal;
      case UserRole.head_teacher:
        return Colors.indigo;
      case UserRole.teacher:
        return Colors.green;
      case UserRole.economist:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(role),
          child: Text(name[0], style: const TextStyle(color: Colors.white)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(email),
            Text(phone),
            const SizedBox(height: 4),
            Chip(
              label: Text(_getRoleLabel(role)),
              backgroundColor: _getRoleColor(role).withOpacity(0.2),
              labelStyle: TextStyle(color: _getRoleColor(role), fontSize: 12),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                    isActive ? Icons.block : Icons.check_circle,
                    color: isActive ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(isActive ? 'تعطيل' : 'تفعيل'),
                ],
              ),
            ),
            const PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.lock_reset, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('إعادة تعيين كلمة المرور'),
                ],
              ),
            ),
            const PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('حذف'),
                ],
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
