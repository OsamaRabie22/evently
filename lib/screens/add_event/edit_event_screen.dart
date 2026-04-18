import 'package:easy_localization/easy_localization.dart';
import 'package:evently_1/helpers/firestore_helper.dart';
import 'package:evently_1/models/task_model.dart';
import 'package:evently_1/providers/add_event_provider.dart';
import 'package:evently_1/widget/date_time_row.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class EditEventScreen extends StatefulWidget {
  static const String routeName = "EditEventScreen";
  const EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool isLoading = false;
  late TaskModel event;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      event =
      ModalRoute.of(context)!.settings.arguments as TaskModel;
      final dt = DateTime.fromMillisecondsSinceEpoch(event.date);
      titleController = TextEditingController(text: event.title);
      descriptionController =
          TextEditingController(text: event.description);
      selectedDate = dt;
      selectedTime = TimeOfDay.fromDateTime(dt);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked =
    await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null) setState(() => selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => AddEventProvider()
        ..setInitialCategory(event.category),
      builder: (context, _) {
        final addEventProvider = Provider.of<AddEventProvider>(context);

        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.only(
                  left: context.locale.languageCode == 'ar' ? 0 : 16,
                  right: context.locale.languageCode == 'ar' ? 16 : 0,
                ),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Icon(Icons.arrow_back_ios_new,
                    color: Theme.of(context).colorScheme.onTertiary,
                    size: 18),
              ),
            ),
            title: Text(
              'editEvent'.tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/images/${addEventProvider.categories[addEventProvider.selectedCategoryIndex]}-1.png",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Categories
                    SizedBox(
                      height: 45,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: addEventProvider.categories.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final isSelected = index ==
                              addEventProvider.selectedCategoryIndex;
                          return GestureDetector(
                            onTap: () =>
                                addEventProvider.changeCategory(index),
                            child: Chip(
                              label: Text(
                                  addEventProvider.categories[index]),
                              backgroundColor: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                  .colorScheme
                                  .onPrimary,
                              labelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: isSelected
                                    ? Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    : Theme.of(context)
                                    .colorScheme
                                    .onSurface,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: themeProvider.currentTheme ==
                                      ThemeMode.dark
                                      ? const Color(0xFF002D8F)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Text('title'.tr(),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color:
                            Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: titleController,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Required'
                          : null,
                      decoration: _inputDecoration(
                          context, themeProvider, 'eventTitle'.tr()),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text('description'.tr(),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color:
                            Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Required'
                          : null,
                      decoration: _inputDecoration(
                          context, themeProvider, 'eventDescription'.tr()),
                    ),
                    const SizedBox(height: 16),

                    // Date
                    DateTimeRow(
                      icon: Icons.date_range,
                      label: 'eventDate'.tr(),
                      actionLabel: DateFormat(
                          'dd MMM yyyy',
                          context.locale.languageCode)
                          .format(selectedDate),
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 16),

                    // Time
                    DateTimeRow(
                      icon: Icons.access_time,
                      label: 'eventTime'.tr(),
                      actionLabel: selectedTime.format(context),
                      onTap: _pickTime,
                    ),
                    const SizedBox(height: 40),

                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                          if (!_formKey.currentState!.validate())
                            return;

                          final dateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          setState(() => isLoading = true);
                          try {
                            final updated = TaskModel(
                              id: event.id,
                              title: titleController.text.trim(),
                              description:
                              descriptionController.text.trim(),
                              category: addEventProvider.categories[
                              addEventProvider
                                  .selectedCategoryIndex],
                              date: dateTime.millisecondsSinceEpoch,
                              isFavorite: event.isFavorite,
                            );
                            await FirestoreHelper.updateTask(updated);
                            if (context.mounted)
                              Navigator.pop(context);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(
                                      'Error: ${e.toString()}')));
                            }
                          } finally {
                            if (mounted)
                              setState(() => isLoading = false);
                          }
                        },
                        child: isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white),
                        )
                            : Text(
                          'updateEvent'.tr(),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(
      BuildContext context, ThemeProvider themeProvider, String hintText) {
    final borderSide = BorderSide(
      color: themeProvider.currentTheme == ThemeMode.dark
          ? const Color(0xFF002D8F)
          : Colors.transparent,
    );
    return InputDecoration(
      filled: true,
      fillColor: Theme.of(context).colorScheme.onPrimary,
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
          fontSize: 16,
          color: Theme.of(context).colorScheme.inversePrimary),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: borderSide),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: borderSide),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red)),
      border:
      OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}