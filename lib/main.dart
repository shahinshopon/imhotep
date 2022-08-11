import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:imhotep/viewmodels/app_vm.dart';
import 'package:imhotep/wrapper.dart';
import 'package:imhotep/wrapper_builder.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51KfNDaIkbCk4Dm9U5Fsg6T8OlW21JvJqtz6DrBWDPKT1T1qQ8L2Wb8DX1Eb5OYrFXf20yuQcCXU6rn2OP3nYGKbv00YHUZFU8o';
  MobileAds.instance.initialize();
  await Peaman.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _color = {
    50: Color(0xFF5972FF),
    100: Color(0xFF5972FF),
    200: Color(0xFF5972FF),
    300: Color(0xFF5972FF),
    400: Color(0xFF5972FF),
    500: Color(0xFF5972FF),
    600: Color(0xFF5972FF),
    700: Color(0xFF5972FF),
    800: Color(0xFF5972FF),
    900: Color(0xFF5972FF),
  };

  @override
  Widget build(BuildContext context) {
    MaterialColor blueColor = MaterialColor(0xFF5972FF, _color);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppVm>(
          create: (_) => AppVm(),
        ),
        StreamProvider<PeamanUser?>(
          create: (_) => PAuthProvider.user,
          initialData: null,
        )
      ],
      builder: (context, child) {
        return WrapperBuilder(
          builder: (context) {
            return MaterialApp(
              title: 'Mr. Imhotep',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: GoogleFonts.nunito().fontFamily,
                primarySwatch: blueColor,
              ),
              home: Wrapper(),
            );
          },
        );
      },
    );
  }
}
