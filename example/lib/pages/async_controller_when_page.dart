import 'package:soflutter/soflutter.dart';

class AsyncControllerWhenPage extends StatelessWidget {
  final AsyncController<List<String>> listController =
      AsyncController<List<String>>();

  AsyncControllerWhenPage({super.key});

  Future<List<String>> _fetchList(CancellationToken cancellationToken) async {
    await Future.delayed(const Duration(seconds: 5));
    // Simular erro 30% das vezes
    if (DateTime.now().second % 3 == 0) {
      throw Exception('Network error');
    }
    return List.generate(5, (i) => 'Item ${i + 1} - ${DateTime.now().second}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AsyncControllerWhenBuilder Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Uso do AsyncControllerWhenBuilder
            Expanded(
              child: AsyncControllerWhenBuilder<List<String>>(
                controller: listController,
                initial: () => const Center(child: Text('No data loaded yet')),
                loading: () => BusyIndicator(
                  "Loading data",
                  onCancel: listController.cancel,
                ),
                success: (data) => ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(data[index]),
                    leading: const Icon(Icons.check),
                  ),
                ),
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 50,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                cancelled: () => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel, color: Colors.orange, size: 50),
                      SizedBox(height: 20),
                      Text('Operation was cancelled'),
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
                  onPressed: () => listController.execute(_fetchList),
                  child: const Text('Load List'),
                ),
                ElevatedButton(
                  onPressed: () => listController.cancel(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => listController.reset(),
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
