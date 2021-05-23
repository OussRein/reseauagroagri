import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reseau_agroagri_app/pages/contact_page.dart';
import 'pages/annonce_details_page.dart';
import 'pages/edit_annonce_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/mes_annonces_page.dart';
import 'pages/splash_page.dart';
import 'providers/auth.dart';
import 'providers/annoncess_provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  static const primarySwatch = Colors.green;
  // button color
  static const buttonColor = Colors.green;
  // app name
  static const appName = 'My App';
  // boolean for showing home page if user unverified
  static const homePageUnverified = false;

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final params = {
    'appName': appName,
    'primarySwatch': primarySwatch,
    'buttonColor': buttonColor,
    'homePageUnverified': homePageUnverified,
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
          update: (ctx, auth, annonces) => AnnoncesProvider(annonces == null ? [] : annonces.annonces),
        ),
       
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
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
            /*UserProductPage.ROUTE: (ctx) => UserProductPage(),
            */
          },
        ),
      ),
    );
  }
}
