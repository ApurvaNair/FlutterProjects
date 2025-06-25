import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/FlashCardData.dart';
import 'models/Deck.dart';
import 'pages/CardsListPage.dart';
import 'pages/CardsSwipePage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'pages/SchedulePage.dart';
import 'pages/StatsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('notifications');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FlashCardData()),
        ChangeNotifierProvider(create: (context) => Decks()),
      ],
      child: MyApp(flutterLocalNotificationsPlugin),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  const MyApp(this.flutterLocalNotificationsPlugin, {Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FIKIRA FLASHCARDS",
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: _buildRoutes(),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/': (context) => CardsListPage(),
      CardsSwipePage.routeName: (context) => CardsSwipePage(),
      SchedulePage.routeName: (context) => SchedulePage(),
      '/stats': (context) => StatsPage(),
    };
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primaryColor: const Color(0xFFF2F2F2),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: "Raleway",
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: Colors.amberAccent)
          .copyWith(background: Colors.white),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
      ).copyWith(secondary: Colors.orangeAccent),
    );
  }
}
