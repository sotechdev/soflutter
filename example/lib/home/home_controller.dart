import 'package:soflutter/soflutter.dart';

class HomeController extends Controller<int> {
  HomeController() : super(0);

  increment() {
    emit(state + 1);
  }
}
