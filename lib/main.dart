import 'package:flutter/material.dart';
import 'package:flutter_location/screens/home_screen/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            textTheme: GoogleFonts.montserratTextTheme(),
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xff1a186b),
                brightness: Brightness.dark)),
        theme: ThemeData(
            brightness: Brightness.light,
            textTheme: GoogleFonts.montserratTextTheme(),
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xff1a186b))),
        home: const HomeScreen(),
      );
}
