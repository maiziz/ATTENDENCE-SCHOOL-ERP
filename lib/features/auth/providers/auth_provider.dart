import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:attendence_school_erp/main.dart';
import 'package:attendence_school_erp/core/models/profile.dart';

// Auth State Provider
final authStateProvider = StreamProvider<Session?>((ref) {
  return supabase.auth.onAuthStateChange.map((event) => event.session);
});

// Current User Profile Provider
final currentUserProfileProvider = FutureProvider<Profile?>((ref) async {
  final session = supabase.auth.currentSession;
  if (session == null) return null;

  try {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', session.user.id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Profile.fromJson(response);
  } catch (e) {
    return null;
  }
});

// Auth Service
class AuthService {
  Future<void> signIn(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}

final authServiceProvider = Provider((ref) => AuthService());
