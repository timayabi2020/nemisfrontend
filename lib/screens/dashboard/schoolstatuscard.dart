import 'package:flutter/material.dart';

class SchoolStatusCard extends StatelessWidget {
  final Map<String, dynamic> schoolData;

  const SchoolStatusCard({super.key, required this.schoolData});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Current School', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Row(children: [
              const Icon(Icons.school, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text('${schoolData['schoolName'] ?? 'NA'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.confirmation_number, color: Colors.blue),
              const SizedBox(width: 8),
              Text('Admission No: ${schoolData['admissionNumber']?? 'NA'}'),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.date_range, color: Colors.blue),
              const SizedBox(width: 8),
              Text('Enrolled: ${schoolData['enrollmentDate']?? 'NA'}'),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.info, color: Colors.blue),
              const SizedBox(width: 8),
              Text('Status: ${schoolData['currentStatus']?? 'NA'}'),
            ]),
          ],
        ),
      ),
    );
  }
}
