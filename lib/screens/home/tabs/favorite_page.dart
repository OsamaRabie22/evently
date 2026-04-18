import 'package:easy_localization/easy_localization.dart';
import 'package:evently_1/helpers/firestore_helper.dart';
import 'package:evently_1/providers/theme_provider.dart';
import 'package:evently_1/screens/add_event/event_details_screen.dart';
import 'package:evently_1/widget/event_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // ── Search Bar ──────────────────────────────────────────
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'searchForEvent'.tr(),
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Favorites Stream ────────────────────────────────────
          Expanded(
            child: StreamBuilder(
              stream: FirestoreHelper.getFavoritesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final events = snapshot.data?.docs
                    .map((doc) => doc.data())
                    .toList() ??
                    [];

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
                            event.id, event.isFavorite),
                        themeProvider: themeProvider,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}