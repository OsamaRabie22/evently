import 'package:easy_localization/easy_localization.dart';
import 'package:evently_1/helpers/firestore_helper.dart';
import 'package:evently_1/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import 'edit_event_screen.dart';


class EventDetailsScreen extends StatelessWidget {
  static const String routeName = "EventDetailsScreen";
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as TaskModel;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dateTime =
    DateTime.fromMillisecondsSinceEpoch(event.date);

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
                color: Theme.of(context).colorScheme.onTertiary, size: 18),
          ),
        ),
        title: Text(
          'eventDetails'.tr(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          // Edit
          IconButton(
            icon: Icon(Icons.edit_outlined,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () => Navigator.pushNamed(
              context,
              EditEventScreen.routeName,
              arguments: event,
            ),
          ),
          // Delete
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('deleteEvent'.tr()),
                  content: Text('deleteConfirm'.tr()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('cancel'.tr()),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('delete'.tr(),
                          style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await FirestoreHelper.deleteTask(event.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/images/${event.category}-1.png",
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color:
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Center(
                      child: Icon(Icons.image_not_supported_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 40)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              event.title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // Date & Time Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_outlined,
                      color: Theme.of(context).colorScheme.primary, size: 36),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd MMMM', context.locale.languageCode)
                            .format(dateTime),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        DateFormat('hh:mm a', context.locale.languageCode)
                            .format(dateTime),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description label
            Text(
              'description'.tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // Description text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                event.description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}