import 'package:easy_localization/easy_localization.dart';
import 'package:evently_1/providers/home_provider.dart';
import 'package:evently_1/screens/add_event/add_event_screen.dart';
import 'package:evently_1/screens/home/tabs/favorite_page.dart';
import 'package:evently_1/screens/home/tabs/home_page.dart';
import 'package:evently_1/screens/home/tabs/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "HomeScreen";

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: Consumer<HomeProvider>(
        // استخدم Consumer للحصول على HomeProvider
        builder: (context, homeProvider, child) {
          var provider = Provider.of<ThemeProvider>(context);
          return Scaffold(
            appBar: AppBar(
              title: ListTile(
                title: Text(
                  "homeTitle".tr(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                subtitle: Text(
                  "Osama Rabie",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              actions: [
                // Icon for theme toggle
                InkWell(
                  child: Container(
                    width: 34,
                    height: 34,
                    child: ImageIcon(
                      AssetImage(
                        provider.currentTheme == ThemeMode.dark
                            ? "assets/images/moon.png"
                            : "assets/images/dark/sun.png",


                      ),
                    ),
                  ),
                  onTap: () {
                    // Toggle between dark and light themes
                    provider.toggleTheme();
                  },
                ),
                SizedBox(width: 8),

                // Button to switch between languages
                InkWell(
                  child: Container(
                    width: 34,
                    height: 34,
                    child: Center(
                      child: Text(
                        "appBarrLang".tr(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onTap: () {
                    // Toggle between languages
                    Locale currentLocale = context.locale;
                    if (currentLocale == Locale('en', 'US')) {
                      context.setLocale(Locale('ar', 'EG'));
                    } else {
                      context.setLocale(Locale('en', 'US'));
                    }
                  },
                ),
                SizedBox(width: 16),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              hoverColor: Colors.transparent,
              onPressed: () {
                Navigator.pushNamed(context, AddEventScreen.routeName);
              },
              child: Icon(Icons.add, color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: homeProvider.selectedIndex,
              onTap: (value) {
                homeProvider.changSelectedIndex(value);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: "BottomNavigationBarHome".tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: "BottomNavigationBarFavorite".tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "BottomNavigationBarProfile".tr(),
                ),
              ],
              selectedItemColor: Theme.of(context).colorScheme.primary,
              // اللون المختار
              unselectedItemColor: Theme.of(context).colorScheme.onSecondary,
              // اللون الغير مختار
              backgroundColor: Theme.of(
                context,
              ).scaffoldBackgroundColor, // خلفية الشريط
            ),
            body: tabs[homeProvider.selectedIndex],
          );
        },
      ),
    );
  }

  List<Widget> tabs = [HomePage(), FavoritePage(), ProfilePage()];
}
