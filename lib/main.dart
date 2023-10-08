import 'package:bloc/bloc.dart';
import 'package:elevator/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/appCubit.dart';
import 'cubit/appStates.dart';
import 'modules/home_screen.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // AppCubit.deleteDb("elevator.db");
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDb(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: AppCubit.isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: defaultColor),
              useMaterial3: true,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: defaultColor,
                selectedLabelStyle: TextStyle(color: defaultColor),
                unselectedItemColor: Colors.grey,
                unselectedLabelStyle: TextStyle(color: Colors.grey),
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,),
            ),
            // darkTheme: ThemeData(
            //   colorScheme: ColorScheme.fromSeed(seedColor: defaultColor),
            //   scaffoldBackgroundColor: Colors.black45,
            //   backgroundColor: Colors.black45,
            //   appBarTheme: AppBarTheme(backgroundColor: Colors.black45),
            //   //useMaterial3: true,
            //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
            //     selectedItemColor: defaultColor,
            //     selectedLabelStyle: TextStyle(color: defaultColor),
            //     unselectedItemColor: Colors.grey,
            //     unselectedLabelStyle: TextStyle(color: Colors.grey),
            //     showUnselectedLabels: true,
            //     type: BottomNavigationBarType.fixed,),
            // ),
            home: Directionality(child: const MyHomePage(),
            textDirection: TextDirection.rtl),
          );
        },
      ),
    );
  }
}
