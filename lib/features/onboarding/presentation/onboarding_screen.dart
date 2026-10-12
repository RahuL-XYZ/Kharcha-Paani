import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/routing/route_names.dart';

class OnboardingSlide {
  final String imagePath;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color titleColor;
  final Color textColor;

  const OnboardingSlide({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.backgroundColor,
    this.titleColor = const Color(0xFF1A1A1A),
    this.textColor = const Color(0xFF404040),
  });
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      imagePath: 'assets/onboarding_images/ob_1.png',
      title: 'We will\ntake care',
      description: 'of tickets, transfers and a cool place to stay with effortless bill splitting',
      backgroundColor: Color(0xFFF5C431), // Vibrant Warm Yellow
    ),
    OnboardingSlide(
      imagePath: 'assets/onboarding_images/ob_2.png',
      title: 'Relax\n& enjoy',
      description: 'Sunbathe, swim, eat and drink deliciously without worrying about balances',
      backgroundColor: Color(0xFF56D7D8), // Vibrant Mint Cyan
    ),
    OnboardingSlide(
      imagePath: 'assets/onboarding_images/ob_3.png',
      title: 'Flexible\npayment',
      description: 'Credit card and transfer, cryptocurrency, or instant cash settlements',
      backgroundColor: Color(0xFFF5B5C3), // Soft Rose Pink
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      await ref.read(routerNotifierProvider).refreshOnboardingStatus();
      if (mounted) {
        context.go(RouteNames.login);
      }
    }
  }

  void _onNextTap() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSlide = _slides[_currentPage];

    return Scaffold(
      backgroundColor: currentSlide.backgroundColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        color: currentSlide.backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar (Logo & Skip)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Skip Button
                    GestureDetector(
                      onTap: _completeOnboarding,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Skip',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF262626),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Image Area
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 16,
                            ),
                            child: Center(
                              child: AnimatedScale(
                                scale: _currentPage == index ? 1.0 : 0.85,
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOutBack,
                                child: Image.asset(
                                  slide.imagePath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Text Area
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slide.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  height: 1.05,
                                  letterSpacing: -1.0,
                                  color: slide.titleColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                slide.description,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                  color: slide.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),
              ),

              // Bottom Control Bar (Badge + Dots + Next Button)
              Padding(
                padding: const EdgeInsets.only(
                  left: 28,
                  right: 28,
                  bottom: 24,
                  top: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 58),

                    // Page Indicator Dots
                    Row(
                      children: List.generate(
                        _slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFF1A1A1A)
                                : Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // Next Button (White Rounded Square with translucent outer ring)
                    GestureDetector(
                      onTap: _onNextTap,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            _currentPage == _slides.length - 1
                                ? Icons.check_rounded
                                : Icons.chevron_right_rounded,
                            color: const Color(0xFF1A1A1A),
                            size: 30,
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
      ),
    );
  }
}
