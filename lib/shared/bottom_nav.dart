import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        print("index : $index");
      });
    }

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.dumbbell,
            size: 20,
          ),
          label: 'Topics',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.bolt,
            size: 20,
          ),
          label: 'Kettlebell Workouts',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.circleUser,
            size: 20,
          ),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: (int idx) {
        switch (idx) {
          case 0:
            Navigator.pushNamed(context, '/main_workout_home');
            _onItemTapped(idx);
            break;
          case 1:
            _onItemTapped(idx);
            Navigator.pushNamed(context, '/kettlebellworkouts');
            _onItemTapped(idx);
            break;
          case 2:
            Navigator.pushNamed(context, '/profile');
            _onItemTapped(idx);
            break;
        }
      },
    );
  }
}
