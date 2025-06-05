import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:techhackportal/config.dart';

class StudentSchoolHistoryPage extends StatefulWidget {

  final String studentid;
    final Map<String, dynamic> data;

    final Map<String, dynamic> fullName;
    final List schoolHistory;

  const StudentSchoolHistoryPage({super.key,  required this.studentid, required this.data, required this.fullName, required this.schoolHistory});

  @override
  State<StudentSchoolHistoryPage> createState() => _StudentSchoolHistoryPageState();
}

class _StudentSchoolHistoryPageState extends State<StudentSchoolHistoryPage> {
  bool showError = false;
  bool _isLoading = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
 

    // ignore: deprecated_member_use
    return WillPopScope(
    onWillPop: () async {
      // Returning false disables the back button
      return false;
    },child:Scaffold(
      appBar: AppBar(
        title: const Text('Student School History'),
      ),
      body: 
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student basic info
            Text(
              'Student: ${widget.fullName['firstName']} ${widget.fullName['middleName']} ${widget.fullName['lastName']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('UPI: ${widget.data['upi']}'),
            Text('Gender: ${widget.data['gender']}'),
            const SizedBox(height: 16),

            // School history
            ...widget.schoolHistory.map((school) {
              final competencies = school['competencies'] as List<dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  title: Text(
                    school['schoolName'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Status: ${school['currentStatus']}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Admission No: ${school['admissionNumber']} | Enrolled: ${school['enrollmentDate']}'),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Competencies:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...competencies.map((comp) {
                      return ListTile(
                        title: Text(comp['competencyName']),
                        subtitle: Text(
                            '${comp['description']}\nLevel: ${comp['achievementLevel']} | Grade: ${comp['gradeLevel']} | Assessed by: ${comp['assessedBy']}'),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    ));
  }

}
