import 'package:easy_localization/easy_localization.dart';
import 'package:evently_1/core/firebase_functions.dart';
import 'package:evently_1/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "LoginScreen";

  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ── Helper: يفتح دايرة التحميل ويقفل الشاشة ──────────────────────────────
  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ← متقدرش تدوس برا عشان يقفل
      builder: (_) => PopScope(
        canPop: false, // ← متقدرش ترجع بزرار الـ back
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  // ── Helper: يقفل دايرة التحميل ────────────────────────────────────────────
  void _hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          !isDark
              ? "assets/images/Logo.png"
              : "assets/images/dark/Logo-dark.png",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48),
              Text(
                "loginTitel".tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                hintText: "loginEnEmail".tr(),
                prefixIcon: Icons.mail_outline,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "emailRequired".tr();
                  }
                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  if (!RegExp(pattern).hasMatch(value)) {
                    return "invalidEmail".tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                hintText: "loginEnPass".tr(),
                prefixIcon: Icons.lock_outline,
                isPasswordField: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "passwordRequired".tr();
                  }
                  if (value.length < 6) {
                    return "passwordTooShort".tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 48),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _showLoading(context); // ← افتح الـ loading

                    await FirebaseFunctions.loginWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                      () {
                        _hideLoading(context); // ← قفل الـ loading
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomeScreen.routeName,
                          (route) => false,
                        );
                      },
                      (message) {
                        _hideLoading(context); // ← قفل الـ loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message ?? "loginError".tr())),
                        );
                      },
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      "loginButt".tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "loginDont".tr(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpScreen.routeName);
                    },
                    child: Text(
                      "loginSignup".tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "loginOr".tr(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google_icon.png',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "loginWithGoogle".tr(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPasswordField;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    required this.hintText,
    required this.prefixIcon,
    this.isPasswordField = false,
    required this.controller,
    this.validator,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscure = true; // ← عشان الـ toggle يشتغل فعلاً

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPasswordField ? _obscure : false,
      validator: widget.validator,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: widget.isPasswordField
            ? IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() => _obscure = !_obscure); // ← toggle فعلي
                },
              )
            : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
