import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicapp/provider/album_provider.dart';
import 'package:musicapp/provider/artist_provider.dart';
import 'package:musicapp/provider/favourite_provider.dart';
import 'package:musicapp/provider/language_provider.dart';
import 'package:musicapp/provider/theme_provider.dart';
import 'package:musicapp/provider/track_provider.dart';
import 'package:musicapp/screens/login.dart';
import 'package:musicapp/screens/splashscreen.dart';
import 'package:musicapp/translation/codegen_loader.g.dart';
import 'package:provider/provider.dart';

const String url =
    "https://exam.calmgrass-743c6f7f.francecentral.azurecontainerapps.io/";

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xffE6DBDD), // transparent status bar
  ));
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      child: MyApp(),
      supportedLocales: const [
        Locale('en'),
        Locale('am'),
      ],
      startLocale: const Locale('am'),
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      path: 'assets/translation'));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LanguageProvider()),
          ChangeNotifierProvider(create: (context) => AlbumProvider()),
          ChangeNotifierProvider(create: (context) => TrackProvider()),
          ChangeNotifierProvider(create: (context) => ArtistProvider()),
          ChangeNotifierProvider(create: (context) => FavouriteProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        child: MaterialApp(
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'Music app',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
        ));
  }
}
