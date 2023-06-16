
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNvigationBar extends StatelessWidget {

  final int currentIndex;

  const CustomBottomNvigationBar({
    super.key, 
    required this.currentIndex
  });

  void onItemTapped( BuildContext context, int index ) {
    // context.go
    switch( index ) {
      case 0:
        context.go('/home/0');
      break;

      case 1:
        context.go('/home/1');
      break;

      case 2:
        context.go('/home/2');
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: ( value ) => onItemTapped( context, value ),
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