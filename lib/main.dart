import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/annonce_details_page.dart';
import 'pages/edit_annonce_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/mes_annonces_page.dart';
import 'pages/splash_page.dart';
import 'providers/auth.dart';
import 'providers/products_provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          create: null,
          update: (ctx, auth, products) => ProductProvider(auth.token,
              auth.userId, products == null ? [] : products.products),
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
          home: auth.isAuth
              ? HomePage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResult) => authResult.connectionState == ConnectionState.waiting ? SplashPage() : AuthPage(),
                ),
          routes: {
            HomePage.ROUTE: (ctx) => HomePage(),
            AnnonceDetailsPage.ROUTE: (ctx) => AnnonceDetailsPage(),
            MesAnnoncesPage.ROUTE: (ctx) => MesAnnoncesPage(),
            EditAnnoncePage.ROUTE: (ctx) => EditAnnoncePage(),
            /*UserProductPage.ROUTE: (ctx) => UserProductPage(),
            EditProductPage.ROUTE: (ctx) => EditProductPage(),*/
          },
        ),
      ),
    );
  }
}
