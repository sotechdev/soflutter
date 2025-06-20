import 'package:example/home/home_controller.dart';
import 'package:example/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:soflutter/soflutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ServiceProvider(
      providers: [Provider<HomeController>(create: (_) => HomeController())],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: Consumer<HomeController, int>(
              builder: (context, state) => HomePage(),
            ),
          );
        },
      ),
    );
  }
}
