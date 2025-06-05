import 'package:flutter/material.dart';

class RecentCompetenciesList extends StatelessWidget {
  final List<dynamic> competencies;

  const RecentCompetenciesList({super.key, required this.competencies});

  @override
  Widget build(BuildContext context) {
    // Only show top 5 recent competencies for brevity
    final recentComps = competencies.take(5).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Competencies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...recentComps.map((comp) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${comp['competencyName']?? 'NA'} (${comp['achievementLevel']?? 'NA'})'),
              subtitle: Text('Assessed by: ${comp['assessedBy']?? 'NA'} on ${comp['assessmentDate']?? 'NA'}'),
              leading: const Icon(Icons.check_circle_outline, color: Colors.teal),
            )),
          ],
        ),
      ),
    );
  }
}
