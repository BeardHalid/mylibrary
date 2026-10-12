import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mylibrary/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        context.go(AppRoutes.homeScreen);
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animation.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final scale = Tween<double>(
              begin: 0.7,
              end: 1.12,
            ).transform(_animation.value);
            final depth = Tween<double>(
              begin: 0,
              end: 180,
            ).transform(_animation.value);

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, -0.001)
                ..translate(0.0, 0.0, depth),
              child: Transform.scale(scale: scale, child: child),
            );
          },
          child: const SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 132,
                  color: Color(0xFF284B63),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFE07A5F),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.wifi_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
