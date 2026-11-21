//(VIV [VMimerInfoV Widget Test — 2026-11-08])

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vmimerinfov/core/app_dependencies.dart';
import 'package:vmimerinfov/main.dart';

void main() {
  testWidgets('VMimerInfoV main navigation renders', (tester) async {
    //(VIV [Reset Test Locale And Theme Storage — 2026-11-08])

    SharedPreferences.setMockInitialValues({});

    final dependencies = AppDependencies();

    await tester.pumpWidget(VMimerInfoVApp(dependencies: dependencies));

    //) VIV [Reset Test Locale And Theme Storage — 2026-11-08]

    //(VIV [Wait For Locale And Theme Loading — 2026-11-08])

    await tester.pumpAndSettle();

    //) VIV [Wait For Locale And Theme Loading — 2026-11-08]

    //(VIV [Verify Main Navigation — 2026-11-08])

    expect(find.byType(NavigationBar), findsOneWidget);

    expect(find.text('Гаманці'), findsOneWidget);
    expect(find.text('Воркери'), findsOneWidget);
    expect(find.text('Виплати'), findsOneWidget);
    expect(find.text('Налаштування'), findsOneWidget);

    //) VIV [Verify Main Navigation — 2026-11-08]

    dependencies.dispose();
  });
}

//) VIV [VMimerInfoV Widget Test — 2026-11-08]
