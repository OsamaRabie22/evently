import 'package:easy_localization/easy_localization.dart';
import 'package:evently_1/core/firebase_functions.dart';
import 'package:evently_1/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = "SignUpScreen";

  SignUpScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
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
        // Using SingleChildScrollView to handle overflow
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey, // Attach formKey to the Form widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48),
              // Translate text here
              Text(
                "signUpTitel".tr(), // Translate "Create your account"
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              SizedBox(height: 16),
              // TextFormField for Name
              CustomTextFormField(
                hintText: "signUpEnName".tr(), // Translate "Enter your name"
                prefixIcon: Icons.person_outline,
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "nameRequired".tr(); // Translate "Name is required"
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // TextFormField for Email
              CustomTextFormField(
                hintText: "signUpEnEmail".tr(), // Translate "Enter your email"
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
                hintText: "signUpEnPass".tr(), // Translate "Enter your password"
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
              SizedBox(height: 16),
              // TextFormField for Confirm Password
              CustomTextFormField(
                hintText: "signUpEnConfirmPass".tr(),
                // Translate "Confirm your password"
                prefixIcon: Icons.lock_outline,
                isPasswordField: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "confirmPasswordRequired".tr(); // Translate "Confirm password is required"
                  }
                  if (value != _passwordController.text) {
                    return "passwordMismatch".tr(); // Translate "Passwords do not match"
                  }
                  return null;
                },
              ),
              SizedBox(height: 48),
              InkWell(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    FirebaseFunctions.createUserWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                      _nameController.text,
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
                      "signUpButt".tr(), // Translate "Sign up"
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
              // "Already have an account?" text row, centered
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the Row
                children: [
                  Text(
                    "signUpDont".tr(), // Translate "Already have an account?"
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    child: Text(
                      "signUpLogin".tr(), // Translate "Login"
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
                // Center the "OR" text
                children: [
                  Text(
                    "signUpOr".tr(), // Translate "OR"
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Sign up with Google Button
              InkWell(
                onTap: () {
                  // Add your Google sign-in logic here
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
                        "signUpWithGoogle".tr(),
                        // Translate "Sign up with Google"
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