
import 'package:flutter/material.dart';

class CustomBottomNvigationBar extends StatelessWidget {
  const CustomBottomNvigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // elevation = top spacer
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon( Icons.home_max),
          label: 'Home'
        ),

        BottomNavigationBarItem(
          icon: Icon( Icons.label_outline_rounded),
          label: 'Categories'
        ),

        BottomNavigationBarItem(
          icon: Icon( Icons.favorite_border_outlined),
          label: 'Favorites'
        )
      ],
    );
  }
}