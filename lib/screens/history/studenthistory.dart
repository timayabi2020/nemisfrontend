import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:techhackportal/config.dart';

class StudentSchoolHistoryPage extends StatefulWidget {

  final String studentid;

  const StudentSchoolHistoryPage({super.key,  required this.studentid});

  @override
  State<StudentSchoolHistoryPage> createState() => _StudentSchoolHistoryPageState();
}

class _StudentSchoolHistoryPageState extends State<StudentSchoolHistoryPage> {
  bool showError = false;
  bool _isLoading = false;
  Map<String, dynamic> data = {

  };

    var fullName = {};
    List schoolHistory =[];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchStudentDetailsByUPI();
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color:Color(0xFF006600) ,))
          : showError
              ? const Center(child: Text('Error fetching student data'))
              : data.isEmpty
                  ? const Center(child: Text('No data available'))
                  :
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student basic info
            Text(
              'Student: ${fullName['firstName']} ${fullName['middleName']} ${fullName['lastName']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('UPI: ${data['upi']}'),
            Text('Gender: ${data['gender']}'),
            const SizedBox(height: 16),

            // School history
            ...schoolHistory.map((school) {
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
   Future<void> _fetchStudentDetailsByUPI() async {

  

    setState(() {
      _isLoading = true;
      showError = false;
    });

    final url =
        "$NEMIS_URI/${widget.studentid}";

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
          )
          .timeout(const Duration(seconds: 40));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded != null) {
          setState(() {

            _isLoading = false;
            data = decoded;
            fullName = data['fullName'];
            schoolHistory = data['schoolHistory'] as List<dynamic>;
  
          });
        } else {
          setState(() {
            showError = true;
            _isLoading = false;

          });
        }
      } else {
        setState(() {
          _isLoading = false;
          showError = true;

        });
      }
    } catch (e) {
      setState(() {
        showError = true;
        _isLoading = false;

      });
    }
  }
}
