


import 'package:easy_localization/easy_localization.dart';
import 'package:evently_1/helpers/firestore_helper.dart';
import 'package:evently_1/providers/home_page_provider.dart';
import 'package:evently_1/providers/theme_provider.dart';
import 'package:evently_1/screens/add_event/event_details_screen.dart';
import 'package:evently_1/widget/event_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageProvider(),
      builder: (context, _) {
        final provider = Provider.of<HomePageProvider>(context);
        final themeProvider = Provider.of<ThemeProvider>(context);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ── Category Chips ────────────────────────────────────
              SizedBox(
                height: 45,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final isSelected = index == provider.selectedCategoryIndex;
                    return GestureDetector(
                      onTap: () => provider.changeCategory(index),
                      child: Chip(
                        avatar: _categoryIcon(
                          provider.categories[index],
                          isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.primary,
                        ),
                        label: Text(provider.categories[index]),
                        backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary,
                        labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: themeProvider.currentTheme == ThemeMode.dark
                                ? const Color(0xFF002D8F)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ── Events Stream ─────────────────────────────────────
              Expanded(
                child: StreamBuilder(
                  stream: FirestoreHelper.getTasksStream(),
                  builder: (context, snapshot) {
                    // Loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Error
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    // Empty
                    final allEvents =
                        snapshot.data?.docs.map((doc) => doc.data()).toList() ??
                        [];
                    final events = provider.filterEvents(allEvents);

                    if (events.isEmpty) {
                      return Center(
                        child: Text(
                          'noEventsFound'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: events.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            EventDetailsScreen.routeName,
                            arguments: event,
                          ),
                          child: EventCard(
                            event: event,
                            onFavoriteTap: () => FirestoreHelper.toggleFavorite(
                              event.id,
                              event.isFavorite,
                            ),
                            themeProvider: themeProvider,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget? _categoryIcon(String category, Color color) {
    final icons = {
      'All': Icons.grid_view_rounded,
      'Sport': Icons.directions_bike_outlined,
      'Birthday': Icons.cake_outlined,
      'Meeting': Icons.groups_outlined,
      'Exhibition': Icons.museum_outlined,
      'Book Club': Icons.menu_book_outlined,
    };
    final icon = icons[category];
    if (icon == null) return null;
    return Icon(icon, size: 16, color: color);
  }
}
