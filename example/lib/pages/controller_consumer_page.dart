

import 'package:soflutter/soflutter.dart';

class ControllerConsumerPage extends StatelessWidget {
  final Controller<double> sliderController = Controller<double>(0.5);

  ControllerConsumerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ControllerConsumer Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Uso do ControllerConsumer com acesso direto à controller
            ControllerConsumer<double>(
              controller: sliderController,
              builder: (context, value, controller) {
                return Column(
                  children: [
                    Text(
                      'Value: ${value.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    Slider(
                      value: value,
                      onChanged: (newValue) {
                        controller.updateState(newValue);
                      },
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: value,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => sliderController.updateState(0.5),
              child: const Text('Reset to 0.5'),
            ),
          ],
        ),
      ),
    );
  }
}