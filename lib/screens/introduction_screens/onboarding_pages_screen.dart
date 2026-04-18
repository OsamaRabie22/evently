import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/onboarding_page_model.dart';
import '../auth/login_screen.dart';

class OnboardingPagesScreen extends StatefulWidget {
  static const String routeName = "OnboardingPagesScreen";

  const OnboardingPagesScreen({super.key});

  @override
  State<OnboardingPagesScreen> createState() => _OnboardingPagesScreenState();
}

class _OnboardingPagesScreenState extends State<OnboardingPagesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageModel> _pages = [
    OnboardingPageModel(
      imagePath: "assets/images/hot-trending.png",
      darkImagePath: "assets/images/dark/hot-trending (1).png",
      titleKey: "titleKey1",
      descriptionKey: "descriptionKey1",
    ),
    OnboardingPageModel(
      imagePath: "assets/images/being-creative.png",
      darkImagePath: "assets/images/dark/being-creative (2).png",
      titleKey: "titleKey2",
      descriptionKey: "descriptionKey2",
    ),
    OnboardingPageModel(
      imagePath: "assets/images/being-creative (1).png",
      darkImagePath: "assets/images/dark/being-creative (3).png",
      titleKey: "titleKey3",
      descriptionKey: "descriptionKey3",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isLastPage => _currentPage == _pages.length - 1;

  bool get _isFirstPage => _currentPage == 0;

  void _onNextTap() {
    if (_isLastPage) {
      Navigator.pushNamed(context, LoginScreen.routeName);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color primaryColor = theme.colorScheme.primary;
    final Color onPrimaryColor = theme.colorScheme.onPrimary;
    final Color onError = theme.colorScheme.onError;
    final Color secondaryColor = theme.colorScheme.secondary;
    final Color onTertiary = theme.colorScheme.onTertiary;
    final Color inversePrimary = theme.colorScheme.inversePrimary;

    return Scaffold(
      // ── بدل AppBar هنعمل Stack عشان نتحكم في كل حاجة ────────────────────
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Top Bar ────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // السهم: بيظهر بس من الـ page التانية
                  _isFirstPage
                      ? const SizedBox(
                          width: 40,
                        ) // placeholder عشان الـ skip ميتحركش
                      : InkWell(
                          onTap: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: onPrimaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: onTertiary,
                              size: 18,
                            ),
                          ),
                        ),

                  // Logo في النص
                  Image.asset(
                    isDark
                        ? "assets/images/dark/Logo-dark.png"
                        : "assets/images/Logo.png",
                    height: 36,
                  ),

                  // Skip بيختفي في آخر page
                  _isLastPage
                      ? const SizedBox(width: 60) // placeholder
                      : InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: onPrimaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "skip".tr(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: onTertiary,
                              ),
                            ),
                          ),
                        ),
                ],
              ),

              const SizedBox(height: 16),

              // ── PageView ──────────────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          isDark ? page.darkImagePath : page.imagePath,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          page.titleKey.tr(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          page.descriptionKey.tr(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // ── Dots Indicator ────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentPage == index
                          ? primaryColor
                          : inversePrimary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Next / Get Started Button ─────────────────────────────────
              InkWell(
                onTap: _onNextTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      _isLastPage ? "getStarted".tr() : "next".tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: onError,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
