import 'package:collection/collection.dart';
import 'package:ellelife/core/navigation/navigation_utils.dart';
import 'package:ellelife/core/navigation/route_names.dart';
import 'package:ellelife/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key, required this.state, required this.child});

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final activeIndex = NavigationUtils.activeIndex(state);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: mainColor,
        items: NavigationUtils.icons.mapIndexed((index, item) {
          return BottomNavigationBarItem(
            icon: Icon(activeIndex == index ? item.$2 : item.$1),
            label: item.$3,
          );
        }).toList(),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.home);
            case 1:
              context.go(RouteNames.createPost);
            case 2:
              context.go(RouteNames.search);
            case 3:
              context.go(RouteNames.profile);
          }
        },
      ),
    );
  }
}
