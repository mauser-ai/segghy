import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Barra di navigazione inferiore condivisa dalle schermate "hub" del
/// gioco (capitoli, indizi, mappa, personaggi), per passare rapidamente da
/// una sezione investigativa all'altra senza tornare al menu principale.
class GameNavBar extends StatelessWidget {
  final int currentIndex;

  const GameNavBar({super.key, required this.currentIndex});

  static const _routes = ['/chapters', '/inventory', '/map', '/characters'];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        context.go(_routes[index]);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          label: 'Capitoli',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Indizi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'Mappa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_outlined),
          label: 'Personaggi',
        ),
      ],
    );
  }
}
