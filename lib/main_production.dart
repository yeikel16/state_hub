import 'package:state_hub/app/app.dart';
import 'package:state_hub/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
