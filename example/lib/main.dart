import 'package:example/home/home_controller.dart';
import 'package:example/home/home_page.dart';
import 'package:soflutter/soflutter.dart';

void main() {
  serviceProvider.addLazySingleton<HomeController>(HomeController.new);
  serviceProvider.commit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
