import 'package:soflutter/soflutter.dart';

class ControllerBuilderPage extends StatelessWidget {
  final Controller<int> counterController = Controller<int>(0);

  ControllerBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ControllerBuilder Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Uso básico do ControllerBuilder
            ControllerBuilder<int>(
              controller: counterController,
              builder: (context, count) {
                return Text(
                  'Count: $count',
                  style: Theme.of(context).textTheme.bodyLarge,
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => counterController.updateState(counterController.currentState - 1),
                  child: const Text('-'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => counterController.updateState(counterController.currentState + 1),
                  child: const Text('+'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => counterController.updateState(0),
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}