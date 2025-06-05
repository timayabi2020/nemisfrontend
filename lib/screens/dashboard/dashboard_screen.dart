import 'package:flutter/material.dart';
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
  Widget _selectedWidget = const Center(
    child: Text(
      'Welcome to the Student Dashboard',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    ),
  );
  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;

      // 2️⃣ Update the selected widget based on the index
      switch (index) {
        case 0:
          _selectedWidget = Center(
             child: Text(
      'Welcome to the Student Dashboard',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    ),
          );
          break;
        case 1:
          _selectedWidget = Center(
            child: StudentSchoolHistoryPage(studentid:widget.studentid),
          );
          break;

      }
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
                Navigator.pushNamed(context, '/profile');
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
                                  //contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                  leading: const Icon(Icons.dashboard, color: Colors.white),
                                  selectedTileColor: Colors.black45,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
                                  selected: _selectedIndex == 0,
                                  onTap: () => _onDestinationSelected(0),
                                ),
                                
                              ),
                            );
                          }),


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
                                  //contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                  leading: const Icon(Icons.history_edu, color: Colors.white),
                                  selectedTileColor: Colors.black45,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  title: const Text('History', style: TextStyle(color: Colors.white)),
                                  selected: _selectedIndex == 1,
                                  onTap: () => _onDestinationSelected(1),
                                ),
                                
                              ),
                            );
                          }),

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
            
          
          Expanded(
           
             child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedWidget,
            ),
          ),
        ],
      ),
    );
  }
}
