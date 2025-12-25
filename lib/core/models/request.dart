import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/enums.dart';

part 'request.freezed.dart';
part 'request.g.dart';

@freezed
class Request with _$Request {
  const factory Request({
    required String id,
    required String requesterId,
    required RequestCategory category,
    required String content,
    required RequestStatus status,
    DateTime? createdAt,
    DateTime? seenAt,
    DateTime? forwardedAt,
    DateTime? completedAt,
    String? assignedTo,
    String? rejectionReason,
  }) = _Request;

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);
}
