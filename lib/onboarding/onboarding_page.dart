import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/home/home_page.dart';

class OnboardingPage extends StatefulWidget {
  static const String viewedKey = 'onboarding_viewed';

  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  Timer? _splashTimer;
  int _currentPage = 0;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _saveOnboardingViewed();

    _splashTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  Future<void> _saveOnboardingViewed() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(OnboardingPage.viewedKey, true);
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const _SplashView();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F9),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 58,
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _openHomePage,
                  child: const Text(
                    'Пропустить',
                    style: TextStyle(
                      color: Color(0xFF9B99A8),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFD5D3DC)),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: const [
                  _WelcomeSlide(),
                  _TasksSlide(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _currentPage == 1
                          ? TextButton.icon(
                              onPressed: _previousPage,
                              icon: const Icon(
                                Icons.chevron_left,
                                color: Color(0xFF9B99A8),
                              ),
                              label: const Text(
                                'Назад',
                                style: TextStyle(
                                  color: Color(0xFF9B99A8),
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : const SizedBox(height: 48),
                    ),
                  ),
                  Row(
                    children: [
                      _PageDot(isActive: _currentPage == 0),
                      const SizedBox(width: 8),
                      _PageDot(isActive: _currentPage == 1),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1297F3),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(102, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Далее',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _nextPage() {
    if (_currentPage == 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _openHomePage();
    }
  }

  void _openHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MyHomePage(title: 'Мои задачи'),
      ),
    );
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4F3F9),
      body: Center(
        child: _TodoLogo(size: 94),
      ),
    );
  }
}

class _WelcomeSlide extends StatelessWidget {
  const _WelcomeSlide();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(28, 28, 28, 0),
      child: Column(
        children: [
          _TodoLogo(size: 76),
          SizedBox(height: 10),
          Text(
            'Todolist',
            style: TextStyle(
              color: Colors.black,
              fontSize: 34,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 28),
          Text(
            'Добро пожаловать!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Организуйте свою жизнь\nс Todolist — приложение для\nуправления задачами',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF7C7984),
              fontSize: 17,
              height: 1.35,
            ),
          ),
          Expanded(
            child: Center(
              child: _ChecklistIllustration(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TasksSlide extends StatelessWidget {
  const _TasksSlide();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(28, 14, 28, 0),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: _CalendarIllustration(),
            ),
          ),
          Text(
            'Все задачи\nв одном месте',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              height: 1.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Добавляйте, упорядочивайте\nи управляйте задачами на день,\nнеделю и месяц',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF7C7984),
              fontSize: 17,
              height: 1.4,
            ),
          ),
          Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }
}

class _TodoLogo extends StatelessWidget {
  final double size;

  const _TodoLogo({required this.size});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFF2D28),
        borderRadius: BorderRadius.circular(size * 0.14),
      ),
      child: Icon(
        Icons.playlist_add_check_rounded,
        color: Colors.white,
        size: size * 0.68,
      ),
    );
  }
}

class _ChecklistIllustration extends StatelessWidget {
  const _ChecklistIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 22,
            bottom: 22,
            child: Transform.rotate(
              angle: 0.08,
              child: Container(
                width: 152,
                height: 116,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _TaskLine(color: Color(0xFFFF2D28), width: 75),
                    _TaskLine(color: Color(0xFF8F5DA8), width: 88),
                    _TaskLine(color: Color(0xFF5D985B), width: 65),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 30,
            bottom: 25,
            child: Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: const Color(0xFFFF2D28),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 54),
            ),
          ),
          const Positioned(
            left: 66,
            top: 12,
            child: Icon(Icons.star_rounded, color: Color(0xFFFFD33D), size: 48),
          ),
          const Positioned(
            right: 25,
            top: 42,
            child: Icon(Icons.star_rounded, color: Color(0xFFFFD33D), size: 38),
          ),
          const Positioned(
            right: 80,
            top: 8,
            child: Icon(Icons.auto_awesome, color: Color(0xFF69B6F3), size: 30),
          ),
        ],
      ),
    );
  }
}

class _CalendarIllustration extends StatelessWidget {
  const _CalendarIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 275,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 12,
            child: Container(
              width: 150,
              height: 135,
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1C000000),
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _TaskLine(color: Color(0xFFFF2D28), width: 70),
                  _TaskLine(color: Color(0xFFFF2D28), width: 84),
                  _TaskLine(color: Color(0xFF34A853), width: 62),
                ],
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 58,
            child: Transform.rotate(
              angle: 0.08,
              child: Container(
                width: 96,
                height: 106,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF2D28),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Icon(
                        Icons.checklist_rounded,
                        color: Color(0xFF34A853),
                        size: 55,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 12,
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: const Color(0xFFFF2D28),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 50),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskLine extends StatelessWidget {
  final Color color;
  final double width;

  const _TaskLine({required this.color, required this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check, color: color, size: 18),
        const SizedBox(width: 8),
        Container(
          width: width,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFFD7D6DB),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF1297F3)
            : const Color(0xFF57546A),
        shape: BoxShape.circle,
      ),
    );
  }
}