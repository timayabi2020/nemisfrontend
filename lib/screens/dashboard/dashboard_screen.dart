import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/students');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/programs');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/analytics');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/settings');
                  break;
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Students'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.school),
                label: Text('Programs'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.insights),
                label: Text('Analytics'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _DashboardCard(
                    icon: Icons.person,
                    title: 'Manage Students',
                    onTap: () => Navigator.pushNamed(context, '/students'),
                  ),
                  _DashboardCard(
                    icon: Icons.school,
                    title: 'Manage Programs',
                    onTap: () => Navigator.pushNamed(context, '/programs'),
                  ),
                  _DashboardCard(
                    icon: Icons.insights,
                    title: 'Analytics',
                    onTap: () => Navigator.pushNamed(context, '/analytics'),
                  ),
                  _DashboardCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () => Navigator.pushNamed(context, '/settings'),
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

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DashboardCard({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
