import 'package:easy_localization/easy_localization.dart';
import 'package:evently_1/providers/theme_provider.dart';
import 'package:evently_1/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  // ← StatefulWidget عشان اللغة
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // ── StreamBuilder عشان يستنى الـ user يتحمل من Firebase ──────────
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              final displayName = user?.displayName ?? '';
              final email = user?.email ?? '';
              final photoURL = user?.photoURL;

              return Column(
                children: [
                  // ── Avatar ───────────────────────────────────────────────
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    backgroundImage: photoURL != null
                        ? NetworkImage(photoURL)
                        : null,
                    child: photoURL == null
                        ? Text(
                            _getInitials(displayName),
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // ── Name ─────────────────────────────────────────────────
                  Text(
                    displayName.isNotEmpty ? displayName : 'user'.tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ── Email ─────────────────────────────────────────────────
                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          // ── Dark Mode ─────────────────────────────────────────────────────
          _SettingCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'darkMode'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Switch(
                  value: themeProvider.currentTheme == ThemeMode.dark,
                  onChanged: (val) => themeProvider.toggleTheme(),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Language ──────────────────────────────────────────────────────
          _SettingCard(
            onTap: () => _showLanguageDialog(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'onboardingLanguage'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Logout ────────────────────────────────────────────────────────
          _SettingCard(
            onTap: () => _confirmLogout(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'logout'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.logout, color: Colors.red, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        // ← StatefulBuilder عشان الـ dialog يتحدث
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'onboardingLanguage'.tr(),
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'onboardingEnglish'.tr(),
                    style: GoogleFonts.poppins(),
                  ),
                  leading: Radio<String>(
                    value: 'en',
                    groupValue: context.locale.languageCode,
                    onChanged: (val) async {
                      await context.setLocale(const Locale('en', 'US'));
                      if (context.mounted) {
                        setDialogState(() {}); // ← يحدث الـ dialog
                        setState(() {}); // ← يحدث الـ page
                        Navigator.pop(context);
                      }
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                ListTile(
                  title: Text(
                    'onboardingArabic'.tr(),
                    style: GoogleFonts.poppins(),
                  ),
                  leading: Radio<String>(
                    value: 'ar',
                    groupValue: context.locale.languageCode,
                    onChanged: (val) async {
                      await context.setLocale(const Locale('ar', 'EG'));
                      if (context.mounted) {
                        setDialogState(() {}); // ← يحدث الـ dialog
                        setState(() {}); // ← يحدث الـ page
                        Navigator.pop(context);
                      }
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'logout'.tr(),
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text('logoutConfirm'.tr(), style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr(), style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                // ✅ استخدم LoginScreen.routeName مش '/login'
                Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName,
                  (route) => false,
                );
              }
            },
            child: Text(
              'logout'.tr(),
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable Setting Card ─────────────────────────────────────────────────────
class _SettingCard extends StatelessWidget {
  const _SettingCard({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }
}
