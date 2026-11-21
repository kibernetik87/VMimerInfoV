//(VIV [Widget Wallet Selection Page — 2026-10-08])

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_dependencies.dart';
import '../../core/services/widget_refresh_scheduler.dart';
import '../../domain/entities/wallet.dart';

//(VIV [Widget Wallet Selection Page Class — 2026-10-08])

class WidgetWalletSelectionPage extends StatefulWidget {
  const WidgetWalletSelectionPage({
    required this.dependencies,
    required this.appWidgetId,
    super.key,
  });

  final AppDependencies dependencies;
  final int appWidgetId;

  @override
  State<WidgetWalletSelectionPage> createState() =>
      _WidgetWalletSelectionPageState();
}

//) VIV [Widget Wallet Selection Page Class — 2026-10-08]

//(VIV [Widget Wallet Selection Page State — 2026-10-08])

class _WidgetWalletSelectionPageState extends State<WidgetWalletSelectionPage> {
  static const MethodChannel _channel = MethodChannel(
    'com.example.vmimerinfov/widget_config',
  );

  bool _loading = true;
  bool _saving = false;

  List<Wallet> _wallets = [];

  @override
  void initState() {
    super.initState();

    _loadWallets();
  }

  //(VIV [Load Wallets For Widget — 2026-10-05])

  Future<void> _loadWallets() async {
    final wallets = await widget.dependencies.walletStorage.loadWallets();

    if (!mounted) {
      return;
    }

    setState(() {
      _wallets = wallets;
      _loading = false;
    });
  }

  //) VIV [Load Wallets For Widget — 2026-10-05]

  //(VIV [Select Widget Wallet — 2026-10-08])

  Future<void> _selectWallet(Wallet wallet) async {
    if (_saving) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await _channel.invokeMethod<void>('saveWidgetConfiguration', {
        'appWidgetId': widget.appWidgetId,
        'walletId': wallet.id,
        'walletName': wallet.name,
      });

      //(VIV [Schedule Initial Widget Refresh — 2026-10-05])

      final scheduler = WidgetRefreshScheduler();

      await scheduler.scheduleImmediate(
        widgetWallets: <int, String>{widget.appWidgetId: wallet.id},
      );

      //) VIV [Schedule Initial Widget Refresh — 2026-10-05]

      //(VIV [Finish Widget Configuration — 2026-10-05])

      await _channel.invokeMethod<void>('finishWidgetConfiguration');

      //) VIV [Finish Widget Configuration — 2026-10-05]
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Не вдалося налаштувати віджет: '
            '${error.message ?? error.code}',
          ),
        ),
      );
    }
  }

  //) VIV [Select Widget Wallet — 2026-10-08]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Налаштування віджета')),
      body: _buildBody(),
    );
  }

  //(VIV [Widget Wallet Selection Body — 2026-10-05])

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_wallets.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Немає доданих гаманців.', textAlign: TextAlign.center),
        ),
      );
    }

    if (_saving) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _wallets.length,
      separatorBuilder: (_, _) {
        return const SizedBox(height: 8);
      },
      itemBuilder: (context, index) {
        final wallet = _wallets[index];

        return Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: Text(wallet.name),
            subtitle: Text(
              wallet.address,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: wallet.isDefault ? const Icon(Icons.star) : null,
            onTap: () => _selectWallet(wallet),
          ),
        );
      },
    );
  }
}

//) VIV [Widget Wallet Selection Page State — 2026-10-08]

//) VIV [Widget Wallet Selection Page — 2026-10-08]
