import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'theme.dart';

class BounceDashApp extends ConsumerWidget {
  const BounceDashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Bounce Dash',
      debugShowCheckedModeBanner: false,
      theme: buildBounceDashTheme(),
      routerConfig: router,
    );
  }
}
