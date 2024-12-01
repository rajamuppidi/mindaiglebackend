import 'package:flutter/material.dart';
import 'package:mindaigle/features/dashboard/views/dashboard_page.dart';
import 'package:mindaigle/features/connections/views/connections_page.dart';
import 'package:mindaigle/features/profile/views/profile_page.dart';
import 'package:mindaigle/common/widgets/app_bar.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    DashboardPage(),
    const ConnectionsPage(
        showAppBar: false), // Disable AppBar for ConnectionsPage
    const ProfilePage(showAppBar: false), // Disable AppBar for ProfilePage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print("Selected Index: $_selectedIndex"); // Debug print
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print("NavBar Widget Rendered"); // Debug print
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Mindaigle'),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: theme.colorScheme.secondary,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true, // Ensure unselected labels are visible
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Connections',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
