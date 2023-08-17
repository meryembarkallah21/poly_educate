import 'package:polyeducate/screens/booking_page.dart';
import 'package:polyeducate/screens/professor_details.dart';
import 'package:polyeducate/screens/success_booked.dart';
import 'package:polyeducate/utils/config.dart';
import 'package:polyeducate/main_layout.dart';
import 'package:polyeducate/screens/auth_page.dart';
import 'package:polyeducate/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/auth_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //this is for push navigator
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    //define ThemeData here
    return  ChangeNotifierProvider <AuthModel>(
      create: (context)=> AuthModel() ,
      child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Polyeducate',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            //pre-define input decoration
            inputDecorationTheme: const InputDecorationTheme(
              focusColor: Config.primaryColor,
              border: Config.outlinedBorder,
              focusedBorder: Config.focusBorder,
              errorBorder: Config.errorBorder,
              enabledBorder: Config.outlinedBorder,
              floatingLabelStyle: TextStyle(color: Config.primaryColor),
              prefixIconColor: Colors.black38,
            ),
            scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Config.primaryColor,
              selectedItemColor: Colors.white,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.grey.shade700,
              elevation: 10,
              type: BottomNavigationBarType.fixed,
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const AuthPage(),
            'main': (context) => const MainLayout(),
            'booking_page' : (context) =>  BookingPage(),
            'success_booking' : (context) =>  const AppointmentBooked(),

          },

      ),
    );
  }
}
