import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/enums.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required UserRole role,
    required String fullName,
    String? phone,
    String? email,
    DateTime? createdAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
