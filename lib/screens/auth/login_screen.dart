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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation

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
        // Adding SingleChildScrollView for scrolling
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey, // Attach formKey to the Form widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48),
              // Translate the title
              Text(
                "loginTitel".tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              SizedBox(height: 16),
              // TextFormField for Email
              CustomTextFormField(
                hintText: "loginEnEmail".tr(), // Translate hint
                prefixIcon: Icons.mail_outline,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "emailRequired".tr(); // Translate "Email is required"
                  }
                  // Add regex for email validation
                  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  RegExp regExp = RegExp(pattern);
                  if (!regExp.hasMatch(value)) {
                    return "invalidEmail".tr(); // Translate "Invalid email address"
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // TextFormField for Password
              CustomTextFormField(
                hintText: "loginEnPass".tr(), // Translate hint
                prefixIcon: Icons.lock_outline,
                isPasswordField: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "passwordRequired".tr(); // Translate "Password is required"
                  }
                  if (value.length < 6) {
                    return "passwordTooShort".tr(); // Translate "Password too short"
                  }
                  return null;
                },
              ),
              SizedBox(height: 48),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    bool success = await FirebaseFunctions.LoginWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                          () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomeScreen.routeName,
                              (route) => false,
                        );
                      },
                          (message) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      },
                    );
                    if (!success) {
                      // Show error if login failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("loginError".tr()), // Translate error message
                        ),
                      );
                    }
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
                      "loginButt".tr(), // Translate "Login"
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
              // "Don't have an account?" text row, centered
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "loginDont".tr(), // Translate "Don't have an account?"
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
                      "loginSignup ".tr(), // Translate "Sign up"
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
              // "OR" text centered
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "loginOr".tr(), // Translate "OR"
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Login with Google Button
              InkWell(
                onTap: () {
                  // Handle Google login action
                },
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
                        width: 24, // Size of the Google icon
                        height: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "loginWithGoogle".tr(), // Translate "Login with Google"
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

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPasswordField;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  CustomTextFormField({
    required this.hintText,
    required this.prefixIcon,
    this.isPasswordField = false,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPasswordField,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        suffixIcon: isPasswordField
            ? IconButton(
          icon: Icon(
            isPasswordField ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            // Password visibility toggle handled outside
          },
        )
            : null,
        hintText: hintText,
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