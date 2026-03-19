import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class HandstandTimerApp extends StatelessWidget {
  const HandstandTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HandstandTimer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
