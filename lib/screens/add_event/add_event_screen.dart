import 'package:easy_localization/easy_localization.dart';
import 'package:evently_1/models/task_model.dart';
import 'package:evently_1/providers/add_event_provider.dart';
import 'package:evently_1/widget/date_time_row.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class AddEventScreen extends StatefulWidget {
  static const String routeName = "AddEventScreen";

  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => AddEventProvider(),
      builder: (context, _) {
        var addEventProvider = Provider.of<AddEventProvider>(context);

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
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onPrimary,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onTertiary,
                  size: 18,
                ),
              ),
            ),
            title: Text(
              "addEvent".tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Theme
                    .of(context)
                    .colorScheme
                    .onSurface,
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
                    // ── Event Image ────────────────────────────────
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/images/${addEventProvider
                            .categories[addEventProvider
                            .selectedCategoryIndex]}-1.png",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Category Chips ─────────────────────────────
                    SizedBox(
                      height: 45,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: addEventProvider.categories.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final isSelected =
                              index == addEventProvider.selectedCategoryIndex;
                          return GestureDetector(
                            onTap: () =>
                                addEventProvider.changeCategory(index),
                            child: Chip(
                              avatar: _categoryIcon(
                                addEventProvider.categories[index],
                                isSelected
                                    ? Theme
                                    .of(context)
                                    .colorScheme
                                    .onPrimary
                                    : Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                              ),
                              label:
                              Text(addEventProvider.categories[index]),
                              backgroundColor: isSelected
                                  ? Theme
                                  .of(context)
                                  .colorScheme
                                  .primary
                                  : Theme
                                  .of(context)
                                  .colorScheme
                                  .onPrimary,
                              labelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: isSelected
                                    ? Theme
                                    .of(context)
                                    .colorScheme
                                    .onPrimary
                                    : Theme
                                    .of(context)
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Title ──────────────────────────────────────
                    Text("title".tr(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onSurface,
                        )),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: titleController,
                      validator: (v) =>
                      v == null || v
                          .trim()
                          .isEmpty ? 'Required' : null,
                      decoration: _inputDecoration(
                          context, themeProvider, "eventTitle".tr()),
                    ),
                    const SizedBox(height: 16),

                    // ── Description ────────────────────────────────
                    Text("description".tr(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onSurface,
                        )),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      validator: (v) =>
                      v == null || v
                          .trim()
                          .isEmpty ? 'Required' : null,
                      decoration: _inputDecoration(
                          context, themeProvider, "eventDescription".tr()),
                    ),
                    const SizedBox(height: 16),

                    // ── Date ───────────────────────────────────────
                    DateTimeRow(
                      icon: Icons.date_range,
                      label: "eventDate".tr(),
                      actionLabel: selectedDate != null
                          ? DateFormat('dd MMM yyyy', context.locale
                          .languageCode).format(selectedDate!)
                          : "chooseDate".tr(),
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 16),

                    // ── Time ───────────────────────────────────────
                    DateTimeRow(
                      icon: Icons.access_time,
                      label: "eventTime".tr(),
                      actionLabel: selectedTime != null
                          ? selectedTime!.format(context)
                          : "chooseTime".tr(),
                      onTap: _pickTime,
                    ),
                    const SizedBox(height: 40),

                    // ── Add Button ─────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Theme
                              .of(context)
                              .colorScheme
                              .primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: addEventProvider.isLoading
                            ? null
                            : () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                  Text("chooseDate".tr())),
                            );
                            return;
                          }

                          // دمج التاريخ والوقت
                          final dateTime = selectedTime != null
                              ? DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          )
                              : selectedDate!;

                          final task = TaskModel(
                            title: titleController.text.trim(),
                            description:
                            descriptionController.text.trim(),
                            category: addEventProvider.categories[
                            addEventProvider.selectedCategoryIndex],
                            date: dateTime.millisecondsSinceEpoch,
                          );

                          try {
                            await addEventProvider.addEvent(task);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                    content:
                                    Text('Error: ${e.toString()}')),
                              );
                            }
                          }
                        },
                        child: addEventProvider.isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                            : Text(
                          "addEventButton".tr(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onPrimary,
                          ),
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

  InputDecoration _inputDecoration(BuildContext context,
      ThemeProvider themeProvider,
      String hintText,) {
    final borderSide = BorderSide(
      color: themeProvider.currentTheme == ThemeMode.dark
          ? const Color(0xFF002D8F)
          : Colors.transparent,
    );
    return InputDecoration(
      filled: true,
      fillColor: Theme
          .of(context)
          .colorScheme
          .onPrimary,
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
      ),
      enabledBorder:
      OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: borderSide),
      focusedBorder:
      OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: borderSide),
      errorBorder:
      OutlineInputBorder(borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder:
      OutlineInputBorder(borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget? _categoryIcon(String category, Color color) {
    final icons = {
      'Book Club': Icons.menu_book_outlined,
      'Sport': Icons.directions_bike_outlined,
      'Birthday': Icons.cake_outlined,
      'Exhibition': Icons.museum_outlined,
      'Meeting': Icons.groups_outlined,
    };
    final icon = icons[category];
    if (icon == null) return null;
    return Icon(icon, size: 16, color: color);
  }
}