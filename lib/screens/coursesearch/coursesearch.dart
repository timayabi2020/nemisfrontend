import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:techhackportal/config.dart';
import 'package:techhackportal/screens/login/login_screen.dart';

class CourseSearchPage extends StatefulWidget {
  final String refreshtoken;
  final String token;
  const CourseSearchPage({
    super.key,
    required this.refreshtoken,
    required this.token,
  });

  @override
  _CourseSearchPageState createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _registrationSearchController = TextEditingController();

  late TabController _tabController;

  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> programs = [];
  List<Map<String, dynamic>> institutions = [];
  List<Map<String, dynamic>> units = [];

  List<Map<String, dynamic>> registrations = [];
  List<Map<String, dynamic>> filteredRegistrations = [];

  Map<String, dynamic>? selectedCourse;
  Map<String, dynamic>? selectedProgram;
  Map<String, dynamic>? selectedInstitution;
  List<Map<String, dynamic>> selectedUnits = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
    _fetchRegistrations();
  }

  Future<void> _fetchData() async {
    final courseRes = await http.get(Uri.parse(COURSES));
    final programRes = await http.get(Uri.parse(PROGRAMS));
    final institutionRes = await http.get(Uri.parse(INSTITUTIONS));
    final unitRes = await http.get(Uri.parse(UNITS));

    if (courseRes.statusCode == 200 &&
        programRes.statusCode == 200 &&
        institutionRes.statusCode == 200 &&
        unitRes.statusCode == 200) {
      setState(() {
        courses = List<Map<String, dynamic>>.from(jsonDecode(courseRes.body));
        programs = List<Map<String, dynamic>>.from(jsonDecode(programRes.body));
        institutions = List<Map<String, dynamic>>.from(jsonDecode(institutionRes.body));
        units = List<Map<String, dynamic>>.from(jsonDecode(unitRes.body));
      });
    } else {
      print('Failed to load data.');
    }
  }

  Future<void> _fetchRegistrations() async {
    final res = await http.get(
      Uri.parse(EXAMS_REGISTRATION),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (res.statusCode == 200) {
      setState(() {
        registrations = List<Map<String, dynamic>>.from(jsonDecode(res.body));
        filteredRegistrations = registrations;
      });
    } else {
      print('Failed to load registrations.');
    }
  }

  void _searchCourse(String courseTitle) {
    final course = courses.firstWhere(
      (c) => c['title'].toLowerCase() == courseTitle.toLowerCase(),
      orElse: () => {},
    );

    if (course.isNotEmpty) {
      final program = programs.firstWhere(
        (p) => p['id'] == course['program'],
        orElse: () => {},
      );

      if (program.isNotEmpty) {
        final institution = institutions.firstWhere(
          (i) => i['id'] == program['institution'],
          orElse: () => {},
        );

        if (institution.isNotEmpty) {
          final courseUnits =
              units.where((u) => u['course'] == course['id']).toList();

          setState(() {
            selectedCourse = course;
            selectedProgram = program;
            selectedInstitution = institution;
            selectedUnits = courseUnits;
          });
          return;
        }
      }
    }

    setState(() {
      selectedCourse = null;
      selectedProgram = null;
      selectedInstitution = null;
      selectedUnits = [];
    });
  }

  Future<void> _registerCourse() async {
    if (selectedCourse == null) return;

    final payload = {
      "course_code": selectedCourse!['id'].toString(),
      "course_title": selectedCourse!['title'],
      "semester": selectedCourse!['semester'].toString(),
      "year": DateTime.now().year,
      "is_verified": true,
    };

    final response = await http.post(
      Uri.parse(EXAMS_REGISTRATION),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      _showSuccessDialog("Exam registered successfully", "Registration Success");
      _fetchRegistrations(); // refresh registrations
    } else if (response.statusCode == 401) {
      _sessionExpiredDialog('Your session has expired. Please log in again.', 'Session Expired');
    } else {
      _showSuccessDialog("Failed to register exam", "Registration Error");
    }
  }

  void _sessionExpiredDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  _showSuccessDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _filterRegistrations(String query) {
    setState(() {
      filteredRegistrations = registrations.where((reg) =>
          reg['course_title'].toLowerCase().contains(query.toLowerCase()) ||
          reg['semester'].toString().toLowerCase().contains(query.toLowerCase()) ||
          reg['registered_on'].toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
        appBar: AppBar(
          title: Text('Course Search & Exam Registration'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Search & Register'),
              Tab(text: 'My Registrations'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Search & Registration Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return courses
                          .where((c) => c['title']
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()))
                          .map((c) => c['title'] as String)
                          .toList();
                    },
                    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                      _searchController.text = controller.text;
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Search for a course',
                          border: OutlineInputBorder(),
                        ),
                        onEditingComplete: onEditingComplete,
                      );
                    },
                    onSelected: (String selection) {
                      _searchController.text = selection;
                      _searchCourse(selection);
                    },
                  ),
                  SizedBox(height: 16),
                  selectedCourse != null
                      ? Expanded(
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListView(
                                children: [
                                  Text('Course: ${selectedCourse!['title']}',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text('Course Code: ${selectedCourse!['id']}'),
                                  Text('Semester: ${selectedCourse!['semester']}'),
                                  SizedBox(height: 8),
                                  Text('Program: ${selectedProgram!['name']}'),
                                  Text('Institution: ${selectedInstitution!['name']}'),
                                  SizedBox(height: 8),
                                  Text('Units:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ...selectedUnits.map((unit) => ListTile(
                                        title: Text(unit['name']),
                                        subtitle: Text(unit['description']),
                                      )),
                                  SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.send, color: Colors.white),
                                    label: Text('Register exam for this course',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: _registerCourse,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF006600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Text('Search for a course to view details!',
                          style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            // My Registrations Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _registrationSearchController,
                    decoration: InputDecoration(
                      labelText: 'Search registrations...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterRegistrations,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Course Title')),
                          DataColumn(label: Text('Semester')),
                          DataColumn(label: Text('Registered On')),
                        ],
                        rows: filteredRegistrations.map((reg) {
                          return DataRow(cells: [
                            DataCell(Text(reg['course_title'] ?? '')),
                            DataCell(Text(reg['semester'].toString())),
                            DataCell(Text(reg['registered_on'].split('T')[0])),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
