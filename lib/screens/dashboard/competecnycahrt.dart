import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CompetencyPieChart extends StatelessWidget {
  final List<dynamic> competencies;

  const CompetencyPieChart({super.key, required this.competencies});

  @override
  Widget build(BuildContext context) {
    // Count occurrences
    final Map<String, int> achievementCounts = {};
    for (var comp in competencies) {
      final level = comp['achievementLevel'];
      achievementCounts[level] = (achievementCounts[level] ?? 0) + 1;
    }

    final List<PieChartSectionData> sections = achievementCounts.entries.map((entry) {
      return PieChartSectionData(
        title: entry.key,
        value: entry.value.toDouble(),
        color: _getColorForLevel(entry.key),
        radius: 60,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Achievement Levels Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForLevel(String level) {
    switch (level) {
      case 'Proficient':
        return Colors.green;
      case 'Developing':
        return Colors.orange;
      case 'Emerging':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
