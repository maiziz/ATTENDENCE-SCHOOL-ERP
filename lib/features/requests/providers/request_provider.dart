import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendence_school_erp/main.dart';
import 'package:attendence_school_erp/core/models/request.dart';
import 'package:attendence_school_erp/core/enums/enums.dart';

// Request State
class RequestsState {
  final List<Request> requests;
  final bool isLoading;
  final String? error;

  RequestsState({required this.requests, this.isLoading = false, this.error});

  RequestsState copyWith({
    List<Request>? requests,
    bool? isLoading,
    String? error,
  }) {
    return RequestsState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Request Notifier
class RequestNotifier extends StateNotifier<RequestsState> {
  RequestNotifier() : super(RequestsState(requests: []));

  // Load requests (role-based)
  Future<void> loadRequests(String userId, UserRole userRole) async {
    state = state.copyWith(isLoading: true);

    try {
      List<dynamic> data;

      if (userRole == UserRole.director) {
        // Director sees all
        data = await supabase.from('requests').select();
      } else if (userRole == UserRole.economist) {
        // Economist sees assigned
        data = await supabase
            .from('requests')
            .select()
            .eq('assigned_to', userId);
      } else {
        // Teachers see their own
        data = await supabase
            .from('requests')
            .select()
            .eq('requester_id', userId);
      }

      final requests = data.map((json) => Request.fromJson(json)).toList();

      state = state.copyWith(requests: requests, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Create Request (Teacher)
  Future<void> createRequest({
    required String requesterId,
    required RequestCategory category,
    required String content,
  }) async {
    try {
      await supabase.from('requests').insert({
        'requester_id': requesterId,
        'category': category.name,
        'content': content,
        'status': RequestStatus.sent.name,
      });

      // Reload
      await loadRequests(requesterId, UserRole.teacher);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Mark as Seen (Director)
  Future<void> markAsSeen(String requestId) async {
    try {
      await supabase
          .from('requests')
          .update({
            'status': RequestStatus.seen.name,
            'seen_at': DateTime.now().toIso8601String(),
          })
          .eq('id', requestId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Forward Request (Director)
  Future<void> forwardRequest({
    required String requestId,
    required String assignedToId,
  }) async {
    try {
      await supabase
          .from('requests')
          .update({
            'status': RequestStatus.forwarded.name,
            'assigned_to': assignedToId,
            'forwarded_at': DateTime.now().toIso8601String(),
          })
          .eq('id', requestId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Complete Request (Economist/Assignee)
  Future<void> completeRequest(String requestId) async {
    try {
      await supabase
          .from('requests')
          .update({
            'status': RequestStatus.completed.name,
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', requestId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Reject Request (Director)
  Future<void> rejectRequest({
    required String requestId,
    required String reason,
  }) async {
    try {
      await supabase
          .from('requests')
          .update({
            'status': RequestStatus.rejected.name,
            'rejection_reason': reason,
          })
          .eq('id', requestId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final requestsProvider = StateNotifierProvider<RequestNotifier, RequestsState>(
  (ref) => RequestNotifier(),
);
