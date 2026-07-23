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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ── Loading Helpers ────────────────────────────────────────────────────────
  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

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
                "signUpTitel".tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                hintText: "signUpEnName".tr(),
                prefixIcon: Icons.person_outline,
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "nameRequired".tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                hintText: "signUpEnEmail".tr(),
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
                hintText: "signUpEnPass".tr(),
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
              SizedBox(height: 16),
              CustomTextFormField(
                hintText: "signUpEnConfirmPass".tr(),
                prefixIcon: Icons.lock_outline,
                isPasswordField: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "confirmPasswordRequired".tr();
                  }
                  if (value != _passwordController.text) {
                    return "passwordMismatch".tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 48),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _showLoading(context); // ← افتح الـ loading

                    await FirebaseFunctions.createUserWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                      _nameController.text,
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
                          SnackBar(
                            content: Text(message ?? "signUpError".tr()),
                          ),
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
                      "signUpButt".tr(),
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
                    "signUpDont".tr(),
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
                      "signUpLogin".tr(),
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
                    "signUpOr".tr(),
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
                        "signUpWithGoogle".tr(),
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

// ── CustomTextFormField ────────────────────────────────────────────────────────
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
  bool _obscure = true;

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
                onPressed: () => setState(() => _obscure = !_obscure),
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
