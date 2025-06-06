import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:techhackportal/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models.dart';
import 'dart:convert';
import 'dart:async';

class ProgramSearchPage extends StatefulWidget {
  @override
  _ProgramSearchPageState createState() => _ProgramSearchPageState();
}

class _ProgramSearchPageState extends State<ProgramSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedInstitutionId;

  List<Program> programs = [];
  List<Course> courses = [];
  List<Institution> institutions = [];

  // Separate states for institution tab
  Program? institutionTabProgram;
  Institution? institutionTabInstitution;
  List<Course> institutionTabCourses = [];

  // Separate states for program tab
  Program? programTabProgram;
  Institution? programTabInstitution;
  List<Course> programTabCourses = [];
  List<Institution> programTabInstitutions = [];

  List<Program> institutionTabPrograms = [];
Map<int, List<Course>> institutionTabProgramCourses = {};
Map<int, List<AcademicUnit>> institutionTabCourseUnits = {};
Map<int, List<AcademicUnit>> programTabCourseUnits = {};
List<AcademicUnit> units = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
  final programRes = await http.get(Uri.parse(PROGRAMS));
  final courseRes = await http.get(Uri.parse(COURSES));
  final institutionRes = await http.get(Uri.parse(INSTITUTIONS));
  final unitRes = await http.get(Uri.parse(UNITS)); // Your API endpoint for units

  if (programRes.statusCode == 200 &&
      courseRes.statusCode == 200 &&
      institutionRes.statusCode == 200 &&
      unitRes.statusCode == 200) {
    setState(() {
      programs = (jsonDecode(programRes.body) as List)
          .map((e) => Program.fromJson(e))
          .toList();
      courses = (jsonDecode(courseRes.body) as List)
          .map((e) => Course.fromJson(e))
          .toList();
      institutions = (jsonDecode(institutionRes.body) as List)
          .map((e) => Institution.fromJson(e))
          .toList();
      units = (jsonDecode(unitRes.body) as List)
          .map((e) => AcademicUnit.fromJson(e))
          .toList();
    });
  } else {
    print('Failed to load data');
  }
}

void _searchByInstitution() {
  if (selectedInstitutionId != null) {
    final institutionIdInt = int.parse(selectedInstitutionId!);

    final programsForInstitution = programs.where((p) {
      final hasCourses = courses.any((c) => c.programId == p.id);
      return p.institutionId == institutionIdInt && hasCourses;
    }).toList();

    // Build a map: program.id -> list of courses
    final programCoursesMap = <int, List<Course>>{};
    final courseUnitsMap = <int, List<AcademicUnit>>{};

    for (var program in programsForInstitution) {
      final linkedCourses =
          courses.where((c) => c.programId == program.id).toList();
      programCoursesMap[program.id] = linkedCourses;

      // For each course, find units
      for (var course in linkedCourses) {
        final linkedUnits =
            units.where((u) => u.courseId == course.id).toList();
        courseUnitsMap[course.id] = linkedUnits;
      }
    }

    final institution =
        institutions.firstWhere((inst) => inst.id == institutionIdInt);

    setState(() {
      institutionTabPrograms = programsForInstitution;
      institutionTabProgramCourses = programCoursesMap;
      institutionTabInstitution = institution;
      institutionTabCourseUnits = courseUnitsMap;
    });
  }
}



void _searchByProgram(String query) {
  final filteredPrograms = programs.where((p) {
    final hasCourses = courses.any((c) => c.programId == p.id);
    final matchesQuery =
        p.name.toLowerCase().contains(query.toLowerCase());
    return hasCourses && matchesQuery;
  }).toList();

  if (filteredPrograms.isNotEmpty) {
    final program = filteredPrograms.first;

    // Find all institutions offering this program by name
    final institutionsOfferingProgram = institutions.where((inst) {
      return programs.any((p) =>
          p.institutionId == inst.id &&
          p.name.toLowerCase() == program.name.toLowerCase());
    }).toList();

    final programCourses =
        courses.where((c) => c.programId == program.id).toList();

    // For each course, find academic units
    final courseUnitsMap = <int, List<AcademicUnit>>{};
    for (var course in programCourses) {
      final linkedUnits =
          units.where((u) => u.courseId == course.id).toList();
      courseUnitsMap[course.id] = linkedUnits;
    }

    setState(() {
      programTabProgram = program;
      programTabInstitutions = institutionsOfferingProgram;
      programTabCourses = programCourses;
      programTabCourseUnits = courseUnitsMap;
    });
  } else {
    setState(() {
      programTabProgram = null;
      programTabInstitutions = [];
      programTabCourses = [];
      programTabCourseUnits = {};
    });
  }
}




  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

Widget _buildInstitutionTab() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Select Institution',
            border: OutlineInputBorder(),
          ),
          value: selectedInstitutionId,
          items: institutions
              .map((inst) => DropdownMenuItem(
                    value: inst.id.toString(),
                    child: Text(inst.name),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedInstitutionId = value;
              institutionTabPrograms = [];
              institutionTabInstitution = null;
              institutionTabProgramCourses = {};
            });
          },
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _searchByInstitution,
          child: Text('Search'),
        ),
        SizedBox(height: 20),
        institutionTabPrograms.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: institutionTabPrograms.length,
                  itemBuilder: (context, index) {
                    final program = institutionTabPrograms[index];
                    final programCourses =
                        institutionTabProgramCourses[program.id] ?? [];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              program.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Duration: ${program.durationYears} years',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Divider(),
                            Text(
                              'Courses:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
ListView.separated(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: programCourses.length,
  separatorBuilder: (_, __) => Divider(height: 1),
  itemBuilder: (context, courseIndex) {
    final course = programCourses[courseIndex];
    final linkedUnits =
        institutionTabCourseUnits[course.id] ?? [];

    return ExpansionTile(
      leading: Icon(Icons.book),
      title: Text(course.title),
      subtitle: Text('Semester ${course.semester}'),
      children: linkedUnits.map((unit) {
        return ListTile(
          title: Text('${unit.code} - ${unit.name}'),
          subtitle: Text(unit.description),
        );
      }).toList(),
    );
  },
),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : Text(
                'No programs found for this institution.',
                style: TextStyle(color: Colors.grey[600]),
              ),
      ],
    ),
  );
}


Widget _buildProgramTab() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return programs
                .map((p) => p.name)
                .where((name) => name
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()))
                .toList();
          },
          fieldViewBuilder:
              (context, controller, focusNode, onEditingComplete) {
            _searchController.text = controller.text;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Search Program',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchByProgram(controller.text),
                ),
              ),
              onEditingComplete: onEditingComplete,
            );
          },
          onSelected: (String selection) {
            _searchController.text = selection;
            _searchByProgram(selection);
          },
        ),
        SizedBox(height: 20),
        programTabProgram != null
            ? Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          programTabProgram!.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Duration: ${programTabProgram!.durationYears} years',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Divider(),
                        Text(
                          'Institutions offering this program:',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal),
                        ),
                        ...programTabInstitutions.map((inst) => InkWell(
                              onTap: () => _launchURL(inst.website),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  inst.name,
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            )),
                        Divider(),
                        Text(
                          'Courses:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: programTabCourses.length,
                            separatorBuilder: (_, __) => Divider(height: 1),
                            itemBuilder: (context, index) {
                              final course = programTabCourses[index];
                              final linkedUnits =
                                  programTabCourseUnits[course.id] ?? [];

                              return ExpansionTile(
                                leading: Icon(Icons.book),
                                title: Text(course.title),
                                subtitle:
                                    Text('Semester ${course.semester}'),
                                children: linkedUnits.map((unit) {
                                  return ListTile(
                                    title: Text(
                                        '${unit.code} - ${unit.name}'),
                                    subtitle: Text(unit.description),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Text(
                'Search for a program to see details.',
                style: TextStyle(color: Colors.grey[600]),
              ),
      ],
    ),
  );
}


  Widget _buildResultCard(Program? program, List<Institution> institutionsList,
    List<Course> coursesList) {
  return program != null
      ? Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.name,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Duration: ${program.durationYears} years',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  Text(
                    'Institutions offering this program:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal),
                  ),
                  ...institutionsList.map((inst) => InkWell(
                        onTap: () => _launchURL(inst.website),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            inst.name,
                            style: TextStyle(
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      )),
                  Divider(),
                  Text(
                    'Courses:',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: coursesList.length,
                      separatorBuilder: (_, __) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final course = coursesList[index];
                        return ListTile(
                          leading: Icon(Icons.book),
                          title: Text(course.title),
                          subtitle: Text('Semester ${course.semester}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      : Text(
          'No results to show.',
          style: TextStyle(color: Colors.grey[600]),
        );
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async {
      // Returning false disables the back button
      return false;
    },child:DefaultTabController(
      length: 2,
      
      child: Scaffold(
        appBar: AppBar(
          title: Text('Program Search'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'By Institution'),
              Tab(text: 'By Program'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildInstitutionTab(),
            _buildProgramTab(),
          ],
        ),
      ),
    ));
  }
}
