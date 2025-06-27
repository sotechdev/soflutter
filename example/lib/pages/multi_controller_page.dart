import 'package:soflutter/soflutter.dart';

class MultiControllerPage extends StatelessWidget {
  final Controller<int> counterController = Controller<int>(0);
  final AsyncController<String> dataController = AsyncController<String>();

  MultiControllerPage({super.key});

  Future<String> _fetchData(CancellationToken cancellationToken) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Counter is at ${counterController.currentState}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MultiControllerBuilder Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MultiControllerBuilder<int, String>(
          controller: counterController,
          asyncController: dataController,
          builder: (context, count, asyncState, asyncData) {
            return Column(
              children: [
                // Seção do contador
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Counter: $count',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => counterController.updateState(count - 1),
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => counterController.updateState(count + 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        if (asyncState == AsyncState.initial)
                          const Text('Press button to fetch data'),
                        if (asyncState == AsyncState.loading)
                          const CircularProgressIndicator(),
                        if (asyncState == AsyncState.success)
                          Text(asyncData ?? 'No data'),
                        if (asyncState == AsyncState.error)
                          Text(
                            'Error: ${dataController.currentError}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        if (asyncState == AsyncState.cancelled)
                          const Text('Operation cancelled', style: TextStyle(color: Colors.orange)),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () => dataController.execute(_fetchData),
                          child: const Text('Fetch Data'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}