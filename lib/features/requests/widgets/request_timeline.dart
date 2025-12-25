import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:attendence_school_erp/core/models/request.dart';
import 'package:attendence_school_erp/core/enums/enums.dart';
import 'package:intl/intl.dart';

class RequestTimeline extends StatelessWidget {
  final Request request;

  const RequestTimeline({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final steps = _buildSteps();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: FixedTimeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          color: const Color(0xFF94A3B8),
          indicatorTheme: const IndicatorThemeData(position: 0, size: 20),
          connectorTheme: const ConnectorThemeData(thickness: 2.5),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemCount: steps.length,
          contentsBuilder: (context, index) {
            final step = steps[index];
            return Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: step.isCompleted
                          ? const Color(0xFF1E293B)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                  if (step.date != null)
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(step.date!),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  if (step.note != null)
                    Text(
                      step.note!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueAccent,
                      ),
                    ),
                ],
              ),
            );
          },
          indicatorBuilder: (context, index) {
            final step = steps[index];
            if (step.isCompleted) {
              return const DotIndicator(
                color: Color(0xFF3B82F6),
                child: Icon(Icons.check, color: Colors.white, size: 12),
              );
            }
            return const OutlinedDotIndicator(
              color: Color(0xFF94A3B8),
              backgroundColor: Colors.white,
            );
          },
          connectorBuilder: (context, index, type) {
            return SolidLineConnector(
              color: steps[index].isCompleted
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFFE2E8F0),
            );
          },
        ),
      ),
    );
  }

  List<_TimelineStep> _buildSteps() {
    return [
      _TimelineStep(
        title: 'تم إرسال الطلب',
        date: request.createdAt,
        isCompleted: true,
      ),
      _TimelineStep(
        title: 'شوهد من طرف المدير',
        date: request.seenAt,
        isCompleted:
            request.seenAt != null ||
            request.forwardedAt != null ||
            request.completedAt != null,
      ),
      _TimelineStep(
        title: 'تم التوجيه للمصلحة المعنية',
        date: request.forwardedAt,
        isCompleted: request.forwardedAt != null || request.completedAt != null,
        note: request.assignedTo != null ? 'إلى: ${request.assignedTo}' : null,
      ),
      _TimelineStep(
        title: 'تمت المعالجة والانتهاء',
        date: request.completedAt,
        isCompleted: request.status == RequestStatus.completed,
      ),
    ];
  }
}

class _TimelineStep {
  final String title;
  final DateTime? date;
  final bool isCompleted;
  final String? note;

  _TimelineStep({
    required this.title,
    this.date,
    required this.isCompleted,
    this.note,
  });
}
