import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:state_hub/src/dependencies.config.dart';

@InjectableInit()
Future<void> configureDependencies() async => GetIt.I.init();

@module
abstract class RegisterModule {}
