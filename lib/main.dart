//(VIV [VMimerInfoV Main — 2026-10-06])

import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:widget_refresh_bridge/widget_refresh_bridge.dart';

import 'core/services/widget_refresh_scheduler.dart';
import 'core/app_dependencies.dart';
import 'core/services/background_monitor_service.dart';
import 'core/services/notification_service.dart';
import 'l10n/app_localizations.dart';
import 'presentation/dashboard/dashboard_controller.dart';
import 'presentation/dashboard/dashboard_page.dart';
import 'presentation/hashrate/hashrate_controller.dart';
import 'presentation/hashrate/hashrate_page.dart';
import 'presentation/payments/payments_controller.dart';
import 'presentation/payments/payments_page.dart';
import 'presentation/settings/settings_page.dart';
import 'presentation/wallets/wallets_page.dart';
import 'presentation/widget/widget_wallet_selection_page.dart';
import 'presentation/workers/workers_controller.dart';
import 'presentation/workers/workers_page.dart';

//(VIV [Widget Refresh Channel — 2026-10-06])

const MethodChannel _widgetRefreshChannel = MethodChannel(
  'com.example.vmimerinfov/widget',
);

//) VIV [Widget Refresh Channel — 2026-10-06]

//(VIV [VMimerInfoV Notification Initialization — 2026-10-04])

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = AppDependencies();

  //(VIV [Initialize Notification Service — 2026-11-02])
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermission();
  //) VIV [Initialize Notification Service — 2026-11-02]

  //(VIV [Background Monitor Initialization — 2026-11-02])

  final backgroundMonitorService = BackgroundMonitorService();

  await backgroundMonitorService.initialize();

  //) VIV [Background Monitor Initialization — 2026-11-02]]

  //(VIV [Widget Refresh Scheduling — 2026-10-05])

  final initialRoute =
      WidgetsBinding.instance.platformDispatcher.defaultRouteName;

  if (!initialRoute.startsWith('/widget-config')) {
    final widgetRefreshScheduler = WidgetRefreshScheduler();

    await widgetRefreshScheduler.scheduleFromApp();
  }

  //) VIV [Widget Refresh Scheduling — 2026-10-05]

  runApp(VMimerInfoVApp(dependencies: dependencies));
}

//) VIV [VMimerInfoV Notification Initialization — 2026-10-04]

//(VIV [VMimerInfoV App — 2026-10-04])

class VMimerInfoVApp extends StatefulWidget {
  const VMimerInfoVApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  State<VMimerInfoVApp> createState() => _VMimerInfoVAppState();
}

//) VIV [VMimerInfoV App — 2026-10-04]

//(VIV [VMimerInfoV App State — 2026-10-06])

class _VMimerInfoVAppState extends State<VMimerInfoVApp> {
  Locale _locale = const Locale('uk');

  bool _localeLoaded = false;

  //(VIV [Theme Mode State — 2026-11-08])
  ThemeMode _themeMode = ThemeMode.system;
  bool _themeLoaded = false;
  //) VIV [Theme Mode State — 2026-11-08]

  bool _widgetRefreshChecked = false;

  bool _isWidgetRefresh = false;

  //(VIV [VMimerInfoV App Initialization — 2026-10-06])
  @override
  void initState() {
    super.initState();

    _widgetRefreshChannel.setMethodCallHandler(_handleWidgetRefreshMethodCall);

    _loadLocale();
    _loadThemeMode();
    _checkWidgetRefresh();
  }
  //) VIV [VMimerInfoV App Initialization — 2026-10-06]

  //(VIV [Load Saved Locale — 2026-10-04])

  Future<void> _loadLocale() async {
    final languageCode = await widget.dependencies.localeStorage
        .loadLanguageCode();

    if (!mounted) {
      return;
    }

    setState(() {
      if (languageCode == 'en') {
        _locale = const Locale('en');
      } else {
        _locale = const Locale('uk');
      }

      _localeLoaded = true;
    });
  }

  //) VIV [Load Saved Locale — 2026-10-04]
  //(VIV [Load Saved Theme Mode — 2026-11-08])

  Future<void> _loadThemeMode() async {
    final savedTheme = await widget.dependencies.themeStorage.loadThemeMode();

    if (!mounted) {
      return;
    }

    setState(() {
      switch (savedTheme) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'system':
        default:
          _themeMode = ThemeMode.system;
          break;
      }

      _themeLoaded = true;
    });
  }

  //) VIV [Load Saved Theme Mode — 2026-11-08]
  //(VIV [Handle Widget Refresh Method Call — 2026-10-06])

  Future<void> _handleWidgetRefreshMethodCall(MethodCall call) async {
    if (call.method != 'widgetRefreshRequested') {
      return;
    }

    final walletId = call.arguments is Map
        ? call.arguments['walletId']?.toString()
        : null;

    if (walletId == null || walletId.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isWidgetRefresh = true;
      });
    }

    await _refreshWidgetWallet(walletId);
  }

  //) VIV [Handle Widget Refresh Method Call — 2026-10-06]
  //(VIV [Check Widget Refresh Request — 2026-10-06])

  Future<void> _checkWidgetRefresh() async {
    if (!Platform.isAndroid) {
      if (mounted) {
        setState(() {
          _widgetRefreshChecked = true;
        });
      }

      return;
    }

    try {
      final result = await _widgetRefreshChannel.invokeMethod<dynamic>(
        'getPendingWidgetRefresh',
      );

      if (result is Map) {
        final walletId = result['walletId']?.toString();

        if (walletId != null && walletId.isNotEmpty) {
          if (mounted) {
            setState(() {
              _isWidgetRefresh = true;
            });
          }

          await _refreshWidgetWallet(walletId);
        }
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint(
          '[VMimerInfoV Widget Refresh] '
          'ERROR: $error',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _widgetRefreshChecked = true;
        });
      }
    }
  }

  //) VIV [Check Widget Refresh Request — 2026-10-06]

  //(VIV [Refresh Widget Wallet — 2026-10-06])

  Future<void> _refreshWidgetWallet(String walletId) async {
    try {
      final wallets = await widget.dependencies.walletStorage.loadWallets();

      final walletIndex = wallets.indexWhere((wallet) => wallet.id == walletId);

      if (walletIndex == -1) {
        if (kDebugMode) {
          debugPrint(
            '[VMimerInfoV Widget Refresh] '
            'Wallet not found: $walletId',
          );
        }
        return;
      }

      final wallet = wallets[walletIndex];
      if (kDebugMode) {
        debugPrint(
          '[VMimerInfoV Widget Refresh] '
          'Refreshing wallet: ${wallet.id}',
        );
      }
      await widget.dependencies.miningDataService.refresh(
        wallet.id,
        wallet.address,
      );
      if (kDebugMode) {
        debugPrint(
          '[VMimerInfoV Widget Refresh] '
          'Mining data refreshed',
        );
      }
      final widgetBridge = WidgetRefreshBridge();

      await widgetBridge.updateAllWidgets();
      if (kDebugMode) {
        debugPrint(
          '[VMimerInfoV Widget Refresh] '
          'Widgets updated',
        );
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          '[VMimerInfoV Widget Refresh] '
          'ERROR: $error',
        );
      }
      if (kDebugMode) {
        debugPrint(
          '[VMimerInfoV Widget Refresh] '
          'STACK: $stackTrace',
        );
      }
    } finally {
      try {
        await _widgetRefreshChannel.invokeMethod<void>('finishWidgetRefresh');
      } catch (error) {
        if (kDebugMode) {
          debugPrint(
            '[VMimerInfoV Widget Refresh] '
            'Finish ERROR: $error',
          );
        }
      }

      if (mounted) {
        setState(() {
          _isWidgetRefresh = false;
        });
      }
    }
  }

  //) VIV [Refresh Widget Wallet — 2026-10-06]

  //(VIV [Change Locale — 2026-10-04])

  Future<void> _changeLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });

    await widget.dependencies.localeStorage.saveLanguageCode(
      locale.languageCode,
    );
  }

  //) VIV [Change Locale — 2026-10-04]
  //(VIV [Change Theme Mode — 2026-11-08])

  Future<void> _changeThemeMode(ThemeMode themeMode) async {
    setState(() {
      _themeMode = themeMode;
    });

    await widget.dependencies.themeStorage.saveThemeMode(themeMode.name);
  }

  //) VIV [Change Theme Mode — 2026-11-08]
  @override
  Widget build(BuildContext context) {
    //(VIV [Detect Initial Route — 2026-10-05])

    final initialRoute =
        WidgetsBinding.instance.platformDispatcher.defaultRouteName;

    final widgetConfigUri = Uri.tryParse(initialRoute);

    final appWidgetId =
        int.tryParse(widgetConfigUri?.queryParameters['appWidgetId'] ?? '') ??
        -1;

    final isWidgetConfiguration = initialRoute.startsWith('/widget-config');

    //) VIV [Detect Initial Route — 2026-10-05]

    //(VIV [Widget Refresh Loading Screen — 2026-10-06])

    if (!_widgetRefreshChecked || _isWidgetRefresh) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VMimerInfoV',
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: _themeMode,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    //) VIV [Widget Refresh Loading Screen — 2026-10-06]

    if (!_localeLoaded || !_themeLoaded) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VMimerInfoV',
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: _themeMode,

        //(VIV [Initial Route During Loading — 2026-10-05])
        initialRoute: initialRoute,

        onGenerateRoute: (settings) {
          final routeName = settings.name ?? '/';

          if (routeName.startsWith('/widget-config')) {
            return MaterialPageRoute<void>(
              builder: (_) => WidgetWalletSelectionPage(
                dependencies: widget.dependencies,
                appWidgetId: appWidgetId,
              ),
            );
          }

          return null;
        },

        //) VIV [Initial Route During Loading — 2026-10-05]
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    //(VIV [VMimerInfoV Material App — 2026-10-05])

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VMimerInfoV',

      //(VIV [Initial Route Configuration — 2026-10-05])
      initialRoute: initialRoute,

      //) VIV [Initial Route Configuration — 2026-10-05]

      //(VIV [Localization Configuration — 2026-10-05])
      locale: _locale,

      supportedLocales: const [Locale('uk'), Locale('en')],

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      //) VIV [Localization Configuration — 2026-10-05]

      //(VIV [Widget Configuration Route — 2026-10-05])
      onGenerateRoute: (settings) {
        final routeName = settings.name ?? '/';

        if (routeName.startsWith('/widget-config')) {
          return MaterialPageRoute<void>(
            builder: (_) => WidgetWalletSelectionPage(
              dependencies: widget.dependencies,
              appWidgetId: appWidgetId,
            ),
          );
        }

        return null;
      },

      //) VIV [Widget Configuration Route — 2026-10-05]

      //(VIV [Main App Home Route — 2026-10-05])
      home: isWidgetConfiguration
          ? WidgetWalletSelectionPage(
              dependencies: widget.dependencies,
              appWidgetId: appWidgetId,
            )
          : MainShell(
              dependencies: widget.dependencies,
              locale: _locale,
              onLocaleChanged: _changeLocale,
              themeMode: _themeMode,
              onThemeModeChanged: _changeThemeMode,
            ),

      //) VIV [Main App Home Route — 2026-10-05]
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _themeMode,
    );
  }
}

//) VIV [VMimerInfoV App State — 2026-10-06]

//(VIV [Light Theme — 2026-10-03])

ThemeData _buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: Colors.green,
  );
}

//) VIV [Light Theme — 2026-10-03]

//(VIV [Matrix Mining Dark Theme — 2026-10-03])

ThemeData _buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: Colors.green,
    scaffoldBackgroundColor: const Color(0xFF050805),
    cardTheme: const CardThemeData(color: Color(0xFF0B120B)),
  );
}

//) VIV [Matrix Mining Dark Theme — 2026-10-03]

//(VIV [Main Shell — 2026-10-04])

class MainShell extends StatefulWidget {
  const MainShell({
    required this.dependencies,
    required this.locale,
    required this.onLocaleChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final AppDependencies dependencies;
  final Locale locale;

  final Future<void> Function(Locale locale) onLocaleChanged;

  //(VIV [Theme Mode Parameters — 2026-11-08])
  final ThemeMode themeMode;

  final Future<void> Function(ThemeMode themeMode) onThemeModeChanged;
  //) VIV [Theme Mode Parameters — 2026-11-08]

  @override
  State<MainShell> createState() => _MainShellState();
}

//) VIV [Main Shell — 2026-10-04]

//(VIV [Main Shell State — 2026-10-04])

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final DashboardController _dashboardController;

  late final HashrateController _hashrateController;

  late final WorkersController _workersController;

  late final PaymentsController _paymentsController;

  @override
  void initState() {
    super.initState();

    _dashboardController = DashboardController(
      service: widget.dependencies.walletMiningService,
      walletStorage: widget.dependencies.walletStorage,
      miningDataService: widget.dependencies.miningDataService,
      poolNameFor: widget.dependencies.poolNameFor,
    );

    //(VIV [Hashrate Controller Initialization — 2026-10-04])

    _hashrateController = HashrateController(
      service: widget.dependencies.walletMiningService,
      walletStorage: widget.dependencies.walletStorage,
    );

    //) VIV [Hashrate Controller Initialization — 2026-10-04]

    _workersController = WorkersController(
      service: widget.dependencies.walletMiningService,
      walletStorage: widget.dependencies.walletStorage,
    );

    //(VIV [Payments Controller Initialization — 2026-10-04])

    _paymentsController = PaymentsController(
      service: widget.dependencies.walletMiningService,
      walletStorage: widget.dependencies.walletStorage,
    );

    //) VIV [Payments Controller Initialization — 2026-10-04]
  }

  @override
  void dispose() {
    _dashboardController.dispose();
    _hashrateController.dispose();
    _workersController.dispose();
    _paymentsController.dispose();

    super.dispose();
  }

  String _titleForIndex(AppLocalizations localizations, int index) {
    switch (index) {
      case 0:
        return localizations.dashboard;

      case 1:
        return localizations.hashrate;

      case 2:
        return localizations.wallets;

      case 3:
        return localizations.workers;

      case 4:
        return localizations.payments;

      case 5:
        return localizations.settings;

      default:
        return '';
    }
  }

  Future<void> _onNavigationChanged(int index) async {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      await _dashboardController.loadDefaultWallet();
    }

    //(VIV [Load Hashrate On Navigation — 2026-10-04])

    if (index == 1) {
      await _hashrateController.loadDefaultWallet();
    }

    //) VIV [Load Hashrate On Navigation — 2026-10-04]
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(_titleForIndex(localizations, _currentIndex))),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardPage(controller: _dashboardController),
          HashratePage(controller: _hashrateController),
          WalletsPage(poolNameFor: widget.dependencies.poolNameFor),
          WorkersPage(controller: _workersController),
          PaymentsPage(controller: _paymentsController),
          SettingsPage(
            locale: widget.locale,
            onLocaleChanged: widget.onLocaleChanged,
            themeMode: widget.themeMode,
            onThemeModeChanged: widget.onThemeModeChanged,
          ),
        ],
      ),
      //(VIV [Bottom Navigation Bar — 2026-11-03])

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          _onNavigationChanged(index);
        },
        destinations: [
          NavigationDestination(
            icon: Image.asset(
              'assets/icons/dashboard_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            selectedIcon: Image.asset(
              'assets/icons/dashboard_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            label: localizations.dashboard,
          ),
          NavigationDestination(
            icon: Image.asset(
              'assets/icons/hashrate_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            selectedIcon: Image.asset(
              'assets/icons/hashrate_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            label: localizations.hashrate,
          ),
          NavigationDestination(
            icon: Image.asset(
              'assets/icons/wallet_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            selectedIcon: Image.asset(
              'assets/icons/wallet_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            label: localizations.wallets,
          ),
          NavigationDestination(
            icon: Image.asset(
              'assets/icons/workers_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            selectedIcon: Image.asset(
              'assets/icons/workers_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            label: localizations.workers,
          ),
          NavigationDestination(
            icon: Image.asset(
              'assets/icons/payments_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            selectedIcon: Image.asset(
              'assets/icons/payments_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            label: localizations.payments,
          ),
          NavigationDestination(
            icon: Image.asset(
              'assets/icons/settings_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            selectedIcon: Image.asset(
              'assets/icons/settings_nav.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            label: localizations.settings,
          ),
        ],
      ),

      //) VIV [Bottom Navigation Bar — 2026-11-03]
    );
  }
}

//) VIV [Main Shell State — 2026-10-04]
