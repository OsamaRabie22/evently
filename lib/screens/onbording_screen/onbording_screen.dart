import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../auth/login_screen.dart';
import '../introduction_screens/onboarding_pages_screen.dart';

class OnbordingScreen extends StatelessWidget {
  static const String routeName = "OnbordingScreen";

  const OnbordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    final bool isEn = context.locale == Locale('en', 'US');
    final theme = Theme.of(context); // Get the current theme (light or dark)
    final Color primaryColor = theme.colorScheme.primary;
    final Color onPrimaryColor = theme.colorScheme.onPrimary;
    final Color secondaryColor = theme.colorScheme.secondary;
    final Color onError = theme.colorScheme.onError;
    final Color onTertiary = theme.colorScheme.onTertiary;

    final bool isDark =
        theme.brightness == Brightness.dark; // Check if dark theme is applied

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          !isDark
              ? "assets/images/Logo.png"
              : "assets/images/dark/Logo-dark.png",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Image.asset(
              !isDark
                  ? "assets/images/creative_w.png"
                  : "assets/images/dark/creative.png",
              width: double.infinity,
            ),
            SizedBox(height: 24),
            Text(
              "onboardingTitel".tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "onboardingSubTitel".tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: secondaryColor,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "onboardingLanguage".tr(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: primaryColor,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          context.setLocale(Locale('en', 'US'));
                        },
                        child: language_button(
                          "onboardingEnglish".tr(),
                          context,
                          isEn,
                          primaryColor,
                          onPrimaryColor,
                          onError,
                          onTertiary,
                        ),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          context.setLocale(Locale('ar', 'EG'));
                        },
                        child: language_button(
                          "onboardingArabic".tr(),
                          context,
                          !isEn,
                          primaryColor,
                          onPrimaryColor,
                          onError,
                          onTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "onboardingTheme".tr(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: primaryColor,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          provider.changeTheme(ThemeMode.light);
                        },
                        child: theme_button(
                          "sun",
                          !isDark,
                          primaryColor,
                          onPrimaryColor,
                        ),
                      ),
                      // Sun button for light theme
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          provider.changeTheme(ThemeMode.dark);
                        },
                        child: theme_button(
                          "moon",
                          isDark,
                          primaryColor,
                          onPrimaryColor,
                        ),
                      ),
                      // Moon button for dark theme
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, OnboardingPagesScreen.routeName);
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: primaryColor,
                ),
                child: Center(
                  child: Text(
                    "onboardingStart".tr(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: onError,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget language_button(
    String language,
    BuildContext context,
    bool isSelected,
    Color primaryColor,
    Color onPrimaryColor,
    Color onError,
    Color onTertiary,
  ) {
    return Container(
      width: 83,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? primaryColor
            : onPrimaryColor, // Change background color based on selection
      ),
      child: Center(
        child: Text(
          "$language",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isSelected
                ? onError
                : onTertiary, // Change text color based on selection
          ),
        ),
      ),
    );
  }

  Widget theme_button(
    String imageName,
    bool isSelected,
    Color primaryColor,
    Color onPrimaryColor,
  ) {
    return Container(
      width: 56,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? primaryColor
            : onPrimaryColor, // Select color based on theme
      ),
      child: Center(child: Image.asset("assets/images/$imageName.png")),
    );
  }
}
