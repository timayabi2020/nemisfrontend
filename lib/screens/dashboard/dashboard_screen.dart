import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:techhackportal/config.dart';
import 'package:techhackportal/screens/dashboard/competecnycahrt.dart';
import 'package:techhackportal/screens/dashboard/recentcompetency.dart';
import 'package:techhackportal/screens/dashboard/schoolstatuscard.dart';
import 'package:techhackportal/screens/dashboard/studentprofilecard.dart';
import 'package:techhackportal/screens/history/studenthistory.dart';
import 'package:techhackportal/screens/login/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  final String studentid;
  final String refreshtoken;
  final String token;
  const AdminDashboard({super.key,  required this.studentid, required this.refreshtoken, required this.token});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  bool _isSidebarVisible = false;
  final Duration _sidebarAnimationDuration = Duration(milliseconds: 300);
    bool showError = false;
  bool _isLoading = false;
  Map<String, dynamic> data = {

  };

    Map<String, dynamic> fullName = {};
    List schoolHistory =[];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchStudentDetailsByUPI();

  }

 Widget _buildDashboardContent() {
    switch (_selectedIndex) {
      case 0: // Programs
        if (_isLoading) {
          // While data is loading
          return const Center(child: CircularProgressIndicator(color: Color(0xFF006600)));
        } else if (data.isEmpty || data['schoolHistory'] == null) {
          // If data didn't load properly
          return const Center(child: Text('No data available.'));
        } else {
          // Data is ready
          final school = data['schoolHistory'][0];
          final competencies = school['competencies'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompetencyPieChart(competencies: competencies),
                RecentCompetenciesList(competencies: competencies),
                //StudentProfileCard(studentData: data),
                //SchoolStatusCard(schoolData: school),
              ],
            ),
          );
        }
      case 1: // Analytics
        return StudentSchoolHistoryPage(
          studentid: widget.studentid,
          data: data,
          fullName: fullName,
          schoolHistory: schoolHistory,
        );
      case 2: // Settings
        return const Center(child: Text('Settings Page'));
      case 3: // History
        return const Center(child: Text('History Page'));
      default:
        return const Center(child: Text('Dashboard'));
    }
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
                        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen()
            ),
          );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => setState(() => _isSidebarVisible = !_isSidebarVisible),
        ),
        title: const Text('Dashboard', style: TextStyle(color: Colors.black)),
        actions: [
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF006600),
              child: Icon(Icons.person, color: Colors.white),
            ),
            onSelected: (value) {
              if (value == 'Profile') {
                _showProfile(context);
              } else if (value == 'Logout') {
                _confirmLogout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'Profile',
                child: StatefulBuilder(
                  builder: (context, setInnerState) {
                    bool isHovered = false;
                    return MouseRegion(
                      onEnter: (_) => setInnerState(() => isHovered = true),
                      onExit: (_) => setInnerState(() => isHovered = false),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isHovered ? Colors.grey.shade200 : Colors.transparent,
                        ),
                        child: Text('Profile', style: TextStyle(color: Colors.black)),
                      ),
                    );
                  },
                ),
              ),
              PopupMenuItem<String>(
                value: 'Logout',
                child: StatefulBuilder(
                  builder: (context, setInnerState) {
                    bool isHovered = false;
                    return MouseRegion(
                      onEnter: (_) => setInnerState(() => isHovered = true),
                      onExit: (_) => setInnerState(() => isHovered = false),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isHovered ? Colors.grey.shade200 : Colors.transparent,
                        ),
                        child: Text('Logout', style: TextStyle(color: Colors.black)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: _sidebarAnimationDuration,
            width: (!isMobile && _isSidebarVisible) ? 260 : 0,
            color: const Color(0xFF006600),
            child: ClipRect(
              child: AnimatedOpacity(
                opacity: (!isMobile && _isSidebarVisible) ? 1.0 : 0.0,
                duration: _sidebarAnimationDuration,
                child: (!isMobile && _isSidebarVisible)
                    ? ListView(
                        padding: const EdgeInsets.only(top: 20),
                        children: [
                            _buildSidebarTile('Dashboard', Icons.dashboard, 0),
                            _buildSidebarTile('Academic History', Icons.history_edu, 1),


                          const Divider(color: Colors.white70),
                          StatefulBuilder(
                            
                            builder: (context, setHoverState) {
                              bool isHovered = false;
                              return MouseRegion(
                              onEnter: (_) => setHoverState(() => isHovered = true),
                              onExit: (_) => setHoverState(() => isHovered = false),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isHovered ? Colors.green.shade700 : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.logout, color: Colors.white),
                                    title: const Text('Logout', style: TextStyle(color: Colors.white)),
                                    onTap: _confirmLogout,
                                  ),
                                ),
                              );
                            }),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ),
              ),
              Expanded(child: _buildDashboardContent()),
            
          
          // Expanded(
           
          //    child: _isLoading
          //       ? Center(
          //           child: CircularProgressIndicator(),
          //         )
          //       : showError
          //           ? Center(
          //               child: Text(
          //                 'Error fetching data. Please try again later.',
          //                 style: TextStyle(color: Colors.red, fontSize: 18),
          //               ),
          //             )
          //           : 
          //    AnimatedSwitcher(
          //     duration: const Duration(milliseconds: 300),
          //     switchInCurve: Curves.easeIn,

          //     child: _selectedWidget,
          //   ),
          // ),
        ],
      ),
    );
  }
   Widget _buildSidebarTile(String title, IconData icon, int index) {
    return StatefulBuilder(
      builder: (context, setHoverState) {
        bool isHovered = false;
        return MouseRegion(
          onEnter: (_) => setHoverState(() => isHovered = true),
          onExit: (_) => setHoverState(() => isHovered = false),
          child: Container(
            decoration: BoxDecoration(
              color: isHovered ? Colors.green.shade700 : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Icon(icon, color: Colors.white),
              title: Text(title, style: const TextStyle(color: Colors.white)),
              selected: _selectedIndex == index,
              onTap: () => _onDestinationSelected(index),
            ),
          ),
        );
      },
    );
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
   void _showProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        //title: Text("My profile"),
        content:StudentProfileCard(studentData: data),
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
}
