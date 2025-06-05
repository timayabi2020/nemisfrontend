import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key, required String studentid, required refreshtoken, required token});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  bool _isSidebarVisible = false;
  final Duration _sidebarAnimationDuration = Duration(milliseconds: 300);

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/programs');
        break;
      case 1:
        Navigator.pushNamed(context, '/analytics');
        break;
      case 2:
        Navigator.pushNamed(context, '/settings');
        break;
    }
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
              Navigator.pushReplacementNamed(context, '/login');
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
                              child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: isHovered ? Colors.green.shade700 : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.school, color: Colors.white),
                                      selectedTileColor: Colors.black45,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      title: const Text('Programs', style: TextStyle(color: Colors.white)),
                                      selected: _selectedIndex == 0,
                                      onTap: () => _onDestinationSelected(0),
                                    ),
                                  )
                                
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
                                  leading: const Icon(Icons.insights, color: Colors.white),
                                  selectedTileColor: Colors.black45,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  title: const Text('Analytics', style: TextStyle(color: Colors.white)),
                                  selected: _selectedIndex == 1,
                                  onTap: () => _onDestinationSelected(1),
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
                                  leading: const Icon(Icons.settings, color: Colors.white),
                                  selectedTileColor: Colors.black45,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  title: const Text('Settings', style: TextStyle(color: Colors.white)),
                                  selected: _selectedIndex == 2,
                                  onTap: () => _onDestinationSelected(2),
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Welcome to the Student Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Use the sidebar to navigate through the dashboard.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
