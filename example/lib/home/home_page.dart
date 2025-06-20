import 'package:example/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:soflutter/soflutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home Page'),
      ),
      body: Center(
        child: BaseBuilder<HomeController, int>(
          builder: (context, count) => Text('Contador: $count'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.get<HomeController>().increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
