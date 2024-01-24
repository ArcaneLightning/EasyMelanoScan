import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.house,
            size: 20,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.file,
            size: 20,
          ),
          label: 'Storage',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.camera,
            size: 20,
          ),
          label: 'Upload',
        ),
      ],
      fixedColor: Colors.deepPurple[200],
      onTap: (int idx) {
        switch (idx) {
          case 0:
            // do nothing
            break;
          case 1:
            Navigator.pushNamed(context, '/storage');
            break;
          case 2:
            Navigator.pushNamed(context, '/upload');
            break;
        }
      },
    );
  }
}