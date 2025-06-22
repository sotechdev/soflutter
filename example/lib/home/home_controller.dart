import 'package:soflutter/soflutter.dart';

class HomeController extends SOController<int> {
  HomeController() : super(0);

  Future<void> increment() async {
    setLoading(true);
    await Future.delayed(Duration(seconds: 1));
    emit(state + 1);
    setLoading(false);
  }
}
