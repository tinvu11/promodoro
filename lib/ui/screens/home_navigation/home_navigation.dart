import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:promodoro/core/Theme/app_colors.dart';
import '../../commons/widgets/background.dart';

class HomeNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const HomeNavigation({super.key, required this.navigationShell});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  void _onTap(int index) {
    widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // Tắt màu loang khi nhấn vào
          highlightColor: Colors.transparent, // Tắt màu highlight khi vừa chạm vào
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: widget.navigationShell.currentIndex,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: AppColors.textSecondary,
          onTap: _onTap,
          items: [
            const BottomNavigationBarItem(icon: const Icon(Icons.timer), label: "Timer"),
            const BottomNavigationBarItem(icon: const Icon(Icons.stacked_bar_chart_rounded), label: "Static"),
            const BottomNavigationBarItem(icon: const Icon(Icons.settings), label: "Setting"),
          ],
        ),
      ),
      body: Stack(
        children: [
          const RepaintBoundary(
            child: Background(image: 'assets/images/trees.jpg', sigmaX: 0, sigmaY: 0, darkAlpha: 0.35),
          ),
          widget.navigationShell,
        ],
      ),
    );
  }
}
