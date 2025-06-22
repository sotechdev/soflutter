import 'package:example/home/home_controller.dart';
import 'package:soflutter/soflutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: context.get<HomeController>().isLoading
            ? null
            : context.get<HomeController>().increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: SOPageBuilder<HomeController, int>(
        builder: (context, controller, state) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text('$state', style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
      ),
    );
  }
}
