import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/enums.dart';

part 'observation.freezed.dart';
part 'observation.g.dart';

@freezed
class Observation with _$Observation {
  const factory Observation({
    required String id,
    required String studentId,
    required String authorId,
    required ObservationType type,
    required ObservationVisibility visibility,
    required String content,
    DateTime? createdAt,
  }) = _Observation;

  factory Observation.fromJson(Map<String, dynamic> json) =>
      _$ObservationFromJson(json);
}
