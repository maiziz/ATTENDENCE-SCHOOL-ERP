import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:attendence_school_erp/features/grading/providers/grading_provider.dart';
import 'package:attendence_school_erp/core/models/student.dart';

class CouncilScreen extends ConsumerStatefulWidget {
  const CouncilScreen({super.key});

  @override
  ConsumerState<CouncilScreen> createState() => _CouncilScreenState();
}

class _CouncilScreenState extends ConsumerState<CouncilScreen> {
  int? selectedStudentIndex;

  @override
  Widget build(BuildContext context) {
    final gradingState = ref.watch(gradingProvider);
    final isTablet = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(title: const Text('مجلس القسم - تحليل النتائج')),
      body: gradingState.records.isEmpty
          ? const Center(child: Text('يرجى اختيار قسم من شاشة العلامات أولاً'))
          : Row(
              children: [
                // Left Panel: Student List (Always visible if tablet, else conditional)
                if (isTablet || selectedStudentIndex == null)
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: ListView.separated(
                        itemCount: gradingState.records.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final record = gradingState.records[index];
                          final isSelected = selectedStudentIndex == index;
                          return ListTile(
                            selected: isSelected,
                            selectedTileColor: Colors.blue.withOpacity(0.05),
                            title: Text(
                              record.student.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'المجموع: ${_calculateTotal(record)}/60',
                            ),
                            trailing: _buildEvolutionIcon(record),
                            onTap: () =>
                                setState(() => selectedStudentIndex = index),
                          );
                        },
                      ),
                    ),
                  ),

                // Right Panel: Detail Analysis
                if (isTablet || selectedStudentIndex != null)
                  Expanded(
                    flex: 2,
                    child: selectedStudentIndex == null
                        ? const Center(child: Text('اختر تلميذاً لبدء التحليل'))
                        : _buildDetailPanel(
                            gradingState.records[selectedStudentIndex!],
                          ),
                  ),
              ],
            ),
    );
  }

  double _calculateTotal(GradingRecord record) {
    if (record.grade == null) return 0;
    return (record.grade!.evaluation ?? 0) +
        (record.grade!.fard ?? 0) +
        (record.grade!.exam ?? 0);
  }

  Widget _buildEvolutionIcon(GradingRecord record) {
    // Mocking evolution for now
    final isImproving = record.student.fullName.length % 2 == 0;
    return Icon(
      isImproving ? Icons.arrow_upward : Icons.arrow_downward,
      color: isImproving ? Colors.green : Colors.red,
      size: 16,
    );
  }

  Widget _buildDetailPanel(GradingRecord record) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  record.student.fullName[0],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.student.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'تلميذ في السنة الثانية متوسط',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              _buildDecisionBadge(record),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'مخطط الكفاءات (Kiviat Diagram)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(height: 300, child: _buildRadarChart(record)),
          const SizedBox(height: 40),
          const Text(
            'توصيات مجلس القسم:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildRecommendationRow(
                  Icons.trending_up,
                  'التلميذ يظهر تحسناً مستمراً في المواد العلمية.',
                ),
                const SizedBox(height: 12),
                _buildRecommendationRow(
                  Icons.warning_amber,
                  'يُنصح بتكثيف المراجعة في اللغات الأجنبية.',
                ),
                const SizedBox(height: 12),
                _buildRecommendationRow(
                  Icons.check_circle,
                  'السلوك العام: منضبط ومشارك.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarChart(GradingRecord record) {
    // Mocking radar data based on grades
    final eval = (record.grade?.evaluation ?? 10).toDouble();
    final fard = (record.grade?.fard ?? 12).toDouble();
    final exam = (record.grade?.exam ?? 8).toDouble();

    return RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            fillColor: Colors.blue.withOpacity(0.2),
            borderColor: Colors.blue,
            entryRadius: 3,
            dataEntries: [
              RadarEntry(value: eval),
              RadarEntry(value: fard),
              RadarEntry(value: exam),
              RadarEntry(value: (eval + fard) / 2),
              RadarEntry(value: (fard + exam) / 2),
            ],
          ),
        ],
        radarBackgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        radarBorderData: const BorderSide(color: Colors.grey, width: 0.5),
        titlePositionPercentageOffset: 0.2,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 12),
        getTitle: (index, angle) {
          switch (index) {
            case 0:
              return const RadarChartTitle(text: 'التقييم المستمر');
            case 1:
              return const RadarChartTitle(text: 'الفروض');
            case 2:
              return const RadarChartTitle(text: 'الاختبارات');
            case 3:
              return const RadarChartTitle(text: 'المواظبة');
            case 4:
              return const RadarChartTitle(text: 'المشاركة');
            default:
              return const RadarChartTitle(text: '');
          }
        },
      ),
    );
  }

  Widget _buildDecisionBadge(GradingRecord record) {
    final average = _calculateTotal(record) / 3;
    final isPassing = average >= 10;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isPassing ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isPassing ? Colors.green : Colors.red),
      ),
      child: Text(
        isPassing ? 'ينتقل' : 'توجيه',
        style: TextStyle(
          color: isPassing ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecommendationRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
