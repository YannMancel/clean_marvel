import 'package:clean_marvel/app.dart';
import 'package:clean_marvel/service_locator.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  return runApp(
    const App(),
  );
}
