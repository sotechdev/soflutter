

import 'package:soflutter/soflutter.dart';

class AsyncControllerBuilderPage extends StatefulWidget {
  const AsyncControllerBuilderPage({super.key});

  @override
  State<AsyncControllerBuilderPage> createState() => _AsyncControllerBuilderPageState();
}

class _AsyncControllerBuilderPageState extends State<AsyncControllerBuilderPage> {
  final AsyncController<String> dataController = AsyncController<String>();

  Future<String> _fetchData(CancellationToken cancellationToken) async {
    await Future.delayed(const Duration(seconds: 5));
    if (DateTime.now().second % 5 == 0) {
      throw Exception('Failed to load data (simulated error)');
    }
    return 'Data loaded at ${DateTime.now().toIso8601String()}';
  }

  @override
  void dispose() {
    dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AsyncControllerBuilder Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: AsyncControllerBuilder<String>(
                controller: dataController,
                builder: (context, state, data) {
                  return Center(
                    child: Text('Generic builder: $state - ${data ?? "no data"}'),
                  );
                },
                initial: const Center(child: Text('Press the button to load data')),
                loading: const Center(child: CircularProgressIndicator()),
                error: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 50),
                      const SizedBox(height: 20),
                      Text(
                        'Error: ${dataController.currentError}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                success: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 50),
                        const SizedBox(height: 20),
                        Text(
                          dataController.currentData ?? 'No data',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                cancelled: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel, color: Colors.orange, size: 50),
                      SizedBox(height: 20),
                      Text('Operation cancelled'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => dataController.execute(_fetchData),
                  child: const Text('Load Data'),
                ),
                ElevatedButton(
                  onPressed: () => dataController.cancel(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => dataController.reset(),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}