class OnboardingPageModel {
  final String imagePath;       // الصورة في الـ light mode
  final String darkImagePath;   // الصورة في الـ dark mode
  final String titleKey;        // مفتاح الـ localization للعنوان
  final String descriptionKey;  // مفتاح الـ localization للوصف

  OnboardingPageModel({
    required this.imagePath,
    required this.darkImagePath,
    required this.titleKey,
    required this.descriptionKey,
  });
}