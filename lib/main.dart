import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:reseau_agroagri_app/models/locale_constant.dart';
import 'package:reseau_agroagri_app/models/localizations_delegate.dart';
import 'package:reseau_agroagri_app/pages/contact_page.dart';
import 'package:reseau_agroagri_app/pages/messages_page.dart';
import 'package:reseau_agroagri_app/pages/profile_page.dart';
import 'pages/annonce_details_page.dart';
import 'pages/edit_annonce_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/mes_annonces_page.dart';
import 'pages/splash_page.dart';
import 'providers/auth.dart';
import 'providers/annoncess_provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static const primarySwatch = Colors.green;
  // button color
  static const buttonColor = Colors.green;
  // app name
  static const appName = 'My App';
  // boolean for showing home page if user unverified
  static const homePageUnverified = false;
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  final params = {
    'appName': MyApp.appName,
    'primarySwatch': MyApp.primarySwatch,
    'buttonColor': MyApp.buttonColor,
    'homePageUnverified': MyApp.homePageUnverified,
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, AnnoncesProvider>(
          create: null,
          update: (ctx, auth, annonces) =>
              AnnoncesProvider(annonces == null ? [] : annonces.annonces),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner : false,
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: _locale,
          supportedLocales: [
            const Locale('fr', ''), // English, no country code
            const Locale('ar', ''), // Spanish, no country code
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale?.languageCode == locale?.languageCode &&
                  supportedLocale?.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales?.first;
          },
          title: 'Shopping app',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.blueGrey,
            fontFamily: "Railway",
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: TextStyle(color: Colors.cyan),
                  bodyText2: TextStyle(color: Colors.lightGreen),
                  headline6: GoogleFonts.pacifico(),
                ),
          ),
          home: FutureBuilder(
              // Initialize FlutterFire:
              future: _initialization,
              builder: (context, appSnapshot) {
                return appSnapshot.connectionState != ConnectionState.done
                    ? SplashPage()
                    : StreamBuilder(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (ctx, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SplashPage();
                          }
                          if (userSnapshot.hasData) {
                            return HomePage();
                          }
                          return AuthPage();
                        },
                      );
              }),

          /*auth.isAuth
              ? HomePage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResult) => authResult.connectionState == ConnectionState.waiting ? SplashPage() : AuthPage(),
                ),*/
          routes: {
            HomePage.ROUTE: (ctx) => HomePage(),
            AnnonceDetailsPage.ROUTE: (ctx) => AnnonceDetailsPage(),
            MesAnnoncesPage.ROUTE: (ctx) => MesAnnoncesPage(),
            EditAnnoncePage.ROUTE: (ctx) => EditAnnoncePage(),
            ContactPage.ROUTE: (ctx) => ContactPage(),
            MassagesPage.ROUTE: (ctx) => MassagesPage(),
            ProfilePage.ROUTE: (ctx) => ProfilePage(),
          },
        ),
      ),
    );
  }
}
