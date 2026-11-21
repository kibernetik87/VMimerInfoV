//(VIV [Wallets Page — 2026-10-18])

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/models/notification_event.dart';
import '../../core/storage/notification_event_storage.dart';
import '../../core/storage/notification_storage.dart';
import '../../core/storage/wallet_storage.dart';
import '../../domain/entities/wallet.dart';
import '../../l10n/app_localizations.dart';

//(VIV [Wallets Page Debug Logger — 2026-11-21])
void _debugLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
//) VIV [Wallets Page Debug Logger — 2026-11-21]
//(VIV [Wallets Page Class — 2026-10-18])

class WalletsPage extends StatefulWidget {
  const WalletsPage({required this.poolNameFor, super.key});

  final String? Function(String poolId) poolNameFor;

  @override
  State<WalletsPage> createState() => _WalletsPageState();
}

//) VIV [Wallets Page Class — 2026-10-18]

//(VIV [Wallets Page State — 2026-10-18])

class _WalletsPageState extends State<WalletsPage> {
  final WalletStorage _walletStorage = WalletStorage();
  final NotificationStorage _notificationStorage = NotificationStorage();

  List<Wallet> _wallets = [];
  final Map<String, bool> _notificationsEnabled = {};
  final Set<String> _notificationSavingWalletIds = {};

  bool _isLoading = true;
  bool _hasLoadedWallets = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasLoadedWallets) {
      _hasLoadedWallets = true;
      _loadWallets();
    }
  }

  // (VIV [Open Wallet Notification Events — 2026-10-18])

  Future<void> _openWalletNotificationEvents(Wallet wallet) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _WalletNotificationEventsPage(wallet: wallet),
      ),
    );
  }

  //) VIV [Open Wallet Notification Events — 2026-10-18]

  // (VIV [Load Wallets — 2026-10-18])

  Future<void> _loadWallets() async {
    _debugLog('[VIV WALLETS PAGE] LOAD START');
    final localizations = AppLocalizations.of(context)!;

    try {
      final wallets = await _walletStorage.loadWallets();
      final notificationSettings = <String, bool>{};

      for (final wallet in wallets) {
        if (wallet.id.isEmpty) {
          continue;
        }

        notificationSettings[wallet.id] = await _notificationStorage
            .loadMonitoringEnabled(walletId: wallet.id);
      }

      if (!mounted) {
        return;
      }
      _debugLog(
        '[VIV WALLETS PAGE] LOADED '
        'wallets=${wallets.length}, '
        'settings=$notificationSettings',
      );
      setState(() {
        _wallets = wallets;
        _notificationsEnabled
          ..clear()
          ..addAll(notificationSettings);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.walletsLoadError(error.toString())),
        ),
      );
    }
  }

  //) VIV [Load Wallets — 2026-10-18]

  // (VIV [Save Wallets — 2026-10-18])

  Future<void> _saveWallets() async {
    await _walletStorage.saveWallets(_wallets);
  }

  //) VIV [Save Wallets — 2026-10-18]

  // (VIV [Set Wallet Notifications — 2026-10-18])

  Future<void> _setWalletNotifications(Wallet wallet, bool enabled) async {
    final localizations = AppLocalizations.of(context)!;
    final walletId = wallet.id;

    if (walletId.isEmpty || _notificationSavingWalletIds.contains(walletId)) {
      return;
    }

    final previousValue = _notificationsEnabled[walletId] ?? false;

    setState(() {
      _notificationsEnabled[walletId] = enabled;
      _notificationSavingWalletIds.add(walletId);
    });

    try {
      await _notificationStorage.saveMonitoringEnabled(
        enabled,
        walletId: walletId,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled
                ? localizations.walletNotificationsEnabled(wallet.name)
                : localizations.walletNotificationsDisabled(wallet.name),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _notificationsEnabled[walletId] = previousValue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.walletSettingsSaveError(error.toString()),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _notificationSavingWalletIds.remove(walletId);
        });
      }
    }
  }

  //) VIV [Set Wallet Notifications — 2026-10-18]

  // (VIV [Show Add Wallet Dialog — 2026-10-18])

  Future<void> _showAddWalletDialog() async {
    final wallet = await showDialog<Wallet>(
      context: context,
      builder: (context) => _AddWalletDialog(poolNameFor: widget.poolNameFor),
    );

    if (wallet == null || !mounted) {
      return;
    }

    final newWallet = Wallet(
      id: wallet.id,
      name: wallet.name,
      address: wallet.address,
      createdAt: wallet.createdAt,
      lastSuccessfulUpdate: wallet.lastSuccessfulUpdate,
      isDefault: _wallets.isEmpty,
      poolId: wallet.poolId,
    );

    setState(() {
      _wallets = [..._wallets, newWallet];
      _notificationsEnabled[newWallet.id] = false;
    });

    await _saveWallets();
  }

  //) VIV [Show Add Wallet Dialog — 2026-10-18]

  // (VIV [Edit Wallet Dialog — 2026-10-18])

  Future<void> _showEditWalletDialog(Wallet wallet) async {
    final updatedWallet = await showDialog<Wallet>(
      context: context,
      builder: (context) =>
          _EditWalletDialog(wallet: wallet, poolNameFor: widget.poolNameFor),
    );

    if (updatedWallet == null || !mounted) {
      return;
    }

    setState(() {
      _wallets = _wallets.map((current) {
        if (current.id != wallet.id) {
          return current;
        }

        return Wallet(
          id: current.id,
          name: updatedWallet.name,
          address: updatedWallet.address,
          createdAt: current.createdAt,
          lastSuccessfulUpdate: current.lastSuccessfulUpdate,
          isDefault: current.isDefault,
          poolId: updatedWallet.poolId,
        );
      }).toList();
    });

    await _saveWallets();
  }

  //) VIV [Edit Wallet Dialog — 2026-10-18]

  // (VIV [Set Default Wallet — 2026-10-18])

  Future<void> _setDefaultWallet(Wallet wallet) async {
    setState(() {
      _wallets = _wallets.map((current) {
        return Wallet(
          id: current.id,
          name: current.name,
          address: current.address,
          createdAt: current.createdAt,
          lastSuccessfulUpdate: current.lastSuccessfulUpdate,
          isDefault: current.id == wallet.id,
          poolId: current.poolId,
        );
      }).toList();
    });

    await _saveWallets();
  }

  //) VIV [Set Default Wallet — 2026-10-18]

  // (VIV [Copy Wallet Address — 2026-10-18])

  Future<void> _copyAddress(Wallet wallet) async {
    await Clipboard.setData(ClipboardData(text: wallet.address));

    if (!mounted) {
      return;
    }

    final localizations = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(localizations.addressCopied)));
  }

  //) VIV [Copy Wallet Address — 2026-10-18]

  // (VIV [Delete Wallet — 2026-10-18])

  Future<void> _deleteWallet(Wallet wallet) async {
    final localizations = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.deleteWallet),
          content: Text(localizations.deleteWalletConfirmation(wallet.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    try {
      await _notificationStorage.removeWalletSettings(wallet.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _wallets = _wallets.where((item) => item.id != wallet.id).toList();

        _notificationsEnabled.remove(wallet.id);
        _notificationSavingWalletIds.remove(wallet.id);

        if (_wallets.isNotEmpty && !_wallets.any((item) => item.isDefault)) {
          final first = _wallets.first;

          _wallets[0] = Wallet(
            id: first.id,
            name: first.name,
            address: first.address,
            createdAt: first.createdAt,
            lastSuccessfulUpdate: first.lastSuccessfulUpdate,
            isDefault: true,
            poolId: first.poolId,
          );
        }
      });

      await _saveWallets();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.walletSettingsDeleteError(error.toString()),
          ),
        ),
      );
    }
  }

  //) VIV [Delete Wallet — 2026-10-18]

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_wallets.isEmpty) {
      return _EmptyWalletsView(onAddWallet: _showAddWalletDialog);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FilledButton.icon(
          onPressed: _showAddWalletDialog,
          icon: const Icon(Icons.add),
          label: Text(localizations.addWallet),
        ),
        const SizedBox(height: 16),
        ..._wallets.map(
          (wallet) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _WalletCard(
              key: ValueKey(wallet.id),
              wallet: wallet,
              poolName: widget.poolNameFor(wallet.poolId),
              notificationStorage: _notificationStorage,
              notificationsEnabled: _notificationsEnabled[wallet.id] ?? false,
              notificationSaving: _notificationSavingWalletIds.contains(
                wallet.id,
              ),
              onNotificationChanged: (enabled) {
                _setWalletNotifications(wallet, enabled);
              },
              onOpenEvents: () {
                _openWalletNotificationEvents(wallet);
              },
              onEdit: () => _showEditWalletDialog(wallet),
              onSetDefault: () => _setDefaultWallet(wallet),
              onCopy: () => _copyAddress(wallet),
              onDelete: () => _deleteWallet(wallet),
            ),
          ),
        ),
      ],
    );
  }
}

//) VIV [Wallets Page State — 2026-10-18]

//(VIV [Empty Wallets View — 2026-10-18])

class _EmptyWalletsView extends StatelessWidget {
  const _EmptyWalletsView({required this.onAddWallet});

  final VoidCallback onAddWallet;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              localizations.walletsEmpty,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.addPublicXmrAddress,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAddWallet,
              icon: const Icon(Icons.add),
              label: Text(localizations.addWallet),
            ),
          ],
        ),
      ),
    );
  }
}

//) VIV [Empty Wallets View — 2026-10-18]

//(VIV [Add Wallet Dialog — 2026-10-18])

class _AddWalletDialog extends StatefulWidget {
  const _AddWalletDialog({required this.poolNameFor});

  final String? Function(String poolId) poolNameFor;

  @override
  State<_AddWalletDialog> createState() => _AddWalletDialogState();
}

//) VIV [Add Wallet Dialog — 2026-10-18]

//(VIV [Add Wallet Dialog State — 2026-10-18])

class _AddWalletDialogState extends State<_AddWalletDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedPoolId = Wallet.defaultPoolId;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // (VIV [Add Wallet — 2026-10-18])

  void _addWallet() {
    final localizations = AppLocalizations.of(context)!;

    final name = _nameController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = localizations.enterWalletName;
      });
      return;
    }

    if (address.isEmpty) {
      setState(() {
        _errorMessage = localizations.enterXmrAddress;
      });
      return;
    }

    if (address.length < 90) {
      setState(() {
        _errorMessage = localizations.checkXmrAddress;
      });
      return;
    }

    Navigator.of(context).pop(
      Wallet(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        address: address,
        createdAt: DateTime.now(),
        poolId: _selectedPoolId,
      ),
    );
  }

  //) VIV [Add Wallet — 2026-10-18]

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final poolName = widget.poolNameFor(_selectedPoolId);

    return AlertDialog(
      title: Text(localizations.addWallet),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (poolName != null) ...[
              DropdownButtonFormField<String>(
                initialValue: _selectedPoolId,
                decoration: InputDecoration(
                  labelText: localizations.miningPool,
                  prefixIcon: const Icon(Icons.pool_outlined),
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: Wallet.defaultPoolId,
                    child: Text(poolName),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _selectedPoolId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: localizations.walletName,
                hintText: localizations.walletNameHint,
                prefixIcon: const Icon(Icons.label_outline),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              minLines: 2,
              maxLines: 4,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: localizations.xmrAddress,
                hintText: localizations.xmrAddressHint,
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addWallet(),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.cancel),
        ),
        FilledButton(onPressed: _addWallet, child: Text(localizations.add)),
      ],
    );
  }
}

//) VIV [Add Wallet Dialog State — 2026-10-18]

//) VIV [Add Wallet Dialog — 2026-10-18]

//(VIV [Edit Wallet Dialog — 2026-10-18])

class _EditWalletDialog extends StatefulWidget {
  const _EditWalletDialog({required this.wallet, required this.poolNameFor});

  final Wallet wallet;
  final String? Function(String poolId) poolNameFor;

  @override
  State<_EditWalletDialog> createState() => _EditWalletDialogState();
}

//) VIV [Edit Wallet Dialog — 2026-10-18]

//(VIV [Edit Wallet Dialog State — 2026-10-18])

class _EditWalletDialogState extends State<_EditWalletDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;

  late String _selectedPoolId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.wallet.name);

    _addressController = TextEditingController(text: widget.wallet.address);

    _selectedPoolId = widget.wallet.poolId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // (VIV [Save Edited Wallet — 2026-10-18])

  void _saveWallet() {
    final localizations = AppLocalizations.of(context)!;

    final name = _nameController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = localizations.enterWalletName;
      });
      return;
    }

    if (address.isEmpty) {
      setState(() {
        _errorMessage = localizations.enterXmrAddress;
      });
      return;
    }

    if (address.length < 90) {
      setState(() {
        _errorMessage = localizations.checkXmrAddress;
      });
      return;
    }

    Navigator.of(context).pop(
      Wallet(
        id: widget.wallet.id,
        name: name,
        address: address,
        createdAt: widget.wallet.createdAt,
        lastSuccessfulUpdate: widget.wallet.lastSuccessfulUpdate,
        isDefault: widget.wallet.isDefault,
        poolId: _selectedPoolId,
      ),
    );
  }

  //) VIV [Save Edited Wallet — 2026-10-18]

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final poolName = widget.poolNameFor(_selectedPoolId);

    return AlertDialog(
      title: Text(localizations.editWallet),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (poolName != null) ...[
              DropdownButtonFormField<String>(
                initialValue: _selectedPoolId,
                decoration: InputDecoration(
                  labelText: localizations.miningPool,
                  prefixIcon: const Icon(Icons.pool_outlined),
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: _selectedPoolId,
                    child: Text(poolName),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _selectedPoolId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: localizations.walletName,
                hintText: localizations.walletNameHint,
                prefixIcon: const Icon(Icons.label_outline),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              minLines: 2,
              maxLines: 4,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: localizations.xmrAddress,
                hintText: localizations.xmrAddressHint,
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _saveWallet(),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.cancel),
        ),
        FilledButton(onPressed: _saveWallet, child: Text(localizations.save)),
      ],
    );
  }
}

//) VIV [Edit Wallet Dialog State — 2026-10-18]

//) VIV [Edit Wallet Dialog — 2026-10-18]

//(VIV [Wallet Card — 2026-11-02])

class _WalletCard extends StatefulWidget {
  const _WalletCard({
    super.key,
    required this.wallet,
    required this.poolName,
    required this.notificationStorage,
    required this.notificationsEnabled,
    required this.notificationSaving,
    required this.onNotificationChanged,
    required this.onOpenEvents,
    required this.onEdit,
    required this.onSetDefault,
    required this.onCopy,
    required this.onDelete,
  });

  final Wallet wallet;
  final String? poolName;
  final NotificationStorage notificationStorage;
  final bool notificationsEnabled;
  final bool notificationSaving;
  final ValueChanged<bool> onNotificationChanged;
  final VoidCallback onOpenEvents;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  @override
  State<_WalletCard> createState() => _WalletCardState();
}

//) VIV [Wallet Card — 2026-11-02]

// (VIV [Wallet Card State — 2026-11-02])

class _WalletCardState extends State<_WalletCard> {
  bool _settingsExpanded = false;
  bool _hashrateEnabled = false;
  bool _hashrateRestoredEnabled = false;
  bool _workersChangeEnabled = false;

  bool _settingsLoading = false;
  bool _settingsSaving = false;

  // Запобігає повторному початковому завантаженню налаштувань.
  bool _initialSettingsLoadStarted = false;

  final TextEditingController _hashrateController = TextEditingController();

  String _hashrateUnit = 'H/s';

  static const Map<String, double> _hashrateUnits = {
    'H/s': 1,
    'kH/s': 1000,
    'MH/s': 1000000,
    'GH/s': 1000000000,
    'TH/s': 1000000000000,
  };

  @override
  void initState() {
    super.initState();

    _debugLog(
      '[VIV WALLET CARD] INIT '
      'walletId=${widget.wallet.id}, '
      'notificationsEnabled=${widget.notificationsEnabled}',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Тут уже доступні Localizations та інші InheritedWidget.
    if (!_initialSettingsLoadStarted) {
      _initialSettingsLoadStarted = true;

      if (widget.notificationsEnabled) {
        _loadNotificationSettings();
      }
    }
  }

  @override
  void didUpdateWidget(covariant _WalletCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    _debugLog(
      '[VIV WALLET CARD] UPDATE '
      'walletId=${widget.wallet.id}, '
      'oldEnabled=${oldWidget.notificationsEnabled}, '
      'newEnabled=${widget.notificationsEnabled}',
    );

    if (oldWidget.wallet.id != widget.wallet.id ||
        oldWidget.notificationsEnabled != widget.notificationsEnabled) {
      if (widget.notificationsEnabled) {
        _loadNotificationSettings();
      } else {
        setState(() {
          _hashrateEnabled = false;
          _hashrateRestoredEnabled = false;
          _workersChangeEnabled = false;
          _hashrateController.clear();
          _hashrateUnit = 'H/s';
          _settingsLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _hashrateController.dispose();
    super.dispose();
  }

  // (VIV [Load Wallet Card Notification Settings — 2026-11-02])

  Future<void> _loadNotificationSettings() async {
    _debugLog(
      '[VIV NOTIFICATION LOAD] START '
      'walletId=${widget.wallet.id}',
    );

    final localizations = AppLocalizations.of(context)!;

    setState(() {
      _settingsLoading = true;
    });

    try {
      final storage = widget.notificationStorage;
      final walletId = widget.wallet.id;

      final hashrateEnabled = await storage.loadHashrateEnabled(
        walletId: walletId,
      );

      final hashrateRestoredEnabled = await storage.loadHashrateRestoredEnabled(
        walletId: walletId,
      );

      final workersChangeEnabled = await storage.loadWorkersChangeEnabled(
        walletId: walletId,
      );

      final threshold = await storage.loadHashrateThreshold(walletId: walletId);

      if (!mounted) return;

      setState(() {
        _hashrateEnabled = hashrateEnabled;
        _hashrateRestoredEnabled = hashrateRestoredEnabled;
        _workersChangeEnabled = workersChangeEnabled;

        _hashrateUnit = _unitForHashrate(threshold);

        _hashrateController.text = threshold > 0
            ? _trimNumber(threshold / _hashrateUnits[_hashrateUnit]!)
            : '';

        _settingsLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _settingsLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.notificationSettingsLoadError(error.toString()),
          ),
        ),
      );
    }

    _debugLog(
      '[VIV NOTIFICATION LOAD] '
      'walletId=${widget.wallet.id}, '
      'hashrate=$_hashrateEnabled, '
      'restored=$_hashrateRestoredEnabled, '
      'workers=$_workersChangeEnabled',
    );
  }

  //) VIV [Load Wallet Card Notification Settings — 2026-11-02]

  // (VIV [Format Wallet Card Hashrate — 2026-11-02])

  String _trimNumber(double value) {
    return value.toStringAsFixed(3).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  String _unitForHashrate(double value) {
    if (value >= 1000000000000) return 'TH/s';
    if (value >= 1000000000) return 'GH/s';
    if (value >= 1000000) return 'MH/s';
    if (value >= 1000) return 'kH/s';
    return 'H/s';
  }

  //) VIV [Format Wallet Card Hashrate — 2026-11-02]

  // (VIV [Save Wallet Card Notification Setting — 2026-11-02])

  Future<void> _saveSetting({
    required Future<void> Function() save,
    required VoidCallback update,
  }) async {
    final localizations = AppLocalizations.of(context)!;

    if (_settingsSaving) return;

    setState(() {
      _settingsSaving = true;
    });

    try {
      await save();

      if (!mounted) return;

      setState(update);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.walletSettingsSaveError(error.toString()),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _settingsSaving = false;
        });
      }
    }
  }

  //) VIV [Save Wallet Card Notification Setting — 2026-11-02]

  // (VIV [Save Wallet Card Hashrate Threshold — 2026-11-02])

  Future<void> _saveHashrateThreshold() async {
    final localizations = AppLocalizations.of(context)!;

    final number = double.tryParse(
      _hashrateController.text.trim().replaceAll(',', '.'),
    );

    if (number == null || !number.isFinite || number <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.invalidHashrateThreshold)),
      );
      return;
    }

    final value = number * _hashrateUnits[_hashrateUnit]!;

    if (!value.isFinite || value <= 0) return;

    await _saveSetting(
      save: () => widget.notificationStorage.saveHashrateThreshold(
        value,
        walletId: widget.wallet.id,
      ),
      update: () {},
    );
  }

  //) VIV [Save Wallet Card Hashrate Threshold — 2026-11-02]

  String _shortenAddress(String address) {
    if (address.length <= 20) {
      return address;
    }

    return '${address.substring(0, 10)}...'
        '${address.substring(address.length - 10)}';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final storage = widget.notificationStorage;
    final walletId = widget.wallet.id;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.wallet.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: localizations.notificationSettingsTitle,
                  onPressed: widget.notificationsEnabled
                      ? () {
                          setState(() {
                            _settingsExpanded = !_settingsExpanded;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.settings_outlined),
                ),
                PopupMenuButton<String>(
                  tooltip: localizations.editWallet,
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        widget.onEdit();
                        break;
                      case 'copy':
                        widget.onCopy();
                        break;
                      case 'default':
                        widget.onSetDefault();
                        break;
                      case 'delete':
                        widget.onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: ListTile(
                        leading: const Icon(Icons.edit_outlined),
                        title: Text(localizations.editWallet),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'copy',
                      child: ListTile(
                        leading: const Icon(Icons.copy),
                        title: Text(localizations.copyAddress),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    if (!widget.wallet.isDefault)
                      PopupMenuItem<String>(
                        value: 'default',
                        child: ListTile(
                          leading: const Icon(Icons.star_border),
                          title: Text(localizations.setAsDefault),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: const Icon(Icons.delete_outline),
                        title: Text(localizations.delete),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.poolName != null) ...[
              const SizedBox(height: 4),
              Text(
                '${localizations.miningPool}: ${widget.poolName}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (widget.wallet.isDefault) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  avatar: const Icon(Icons.star, size: 16),
                  label: Text(localizations.defaultWallet),
                ),
              ),
            ],
            const SizedBox(height: 12),
            SelectableText(
              _shortenAddress(widget.wallet.address),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            const Divider(),

            // (VIV [Wallet General Notifications — 2026-11-02])
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.notifications_active_outlined),
              title: Text(localizations.walletNotificationsTitle),
              subtitle: Text(
                widget.notificationsEnabled
                    ? localizations.walletMonitoringEnabled
                    : localizations.walletMonitoringEnableHint,
              ),
              value: widget.notificationsEnabled,
              onChanged: widget.notificationSaving
                  ? null
                  : widget.onNotificationChanged,
            ),

            if (widget.notificationSaving ||
                _settingsSaving ||
                (widget.notificationsEnabled && _settingsLoading))
              const LinearProgressIndicator(),

            //) VIV [Wallet General Notifications — 2026-11-02]

            // (VIV [Wallet Detailed Notification Settings — 2026-11-02])
            if (widget.notificationsEnabled && _settingsExpanded) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  localizations.notificationSettingsTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (_settingsLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  ),
                )
              else ...[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(localizations.hashrateDropTitle),
                  subtitle: Text(localizations.hashrateDropDescription),
                  value: _hashrateEnabled,
                  onChanged: _settingsSaving
                      ? null
                      : (value) {
                          _saveSetting(
                            save: () => storage.saveHashrateEnabled(
                              value,
                              walletId: walletId,
                            ),
                            update: () {
                              _hashrateEnabled = value;
                            },
                          );
                        },
                ),
                if (_hashrateEnabled)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: _hashrateController,
                                enabled: !_settingsSaving,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: InputDecoration(
                                  labelText:
                                      localizations.hashrateThresholdLabel,
                                  hintText: localizations.hashrateThresholdHint,
                                  suffixIcon: const Icon(Icons.speed),
                                  border: const OutlineInputBorder(),
                                ),
                                onSubmitted: (_) => _saveHashrateThreshold(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: localizations.hashrateUnitLabel,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _hashrateUnit,
                                    isExpanded: true,
                                    items: _hashrateUnits.keys.map((unit) {
                                      return DropdownMenuItem<String>(
                                        value: unit,
                                        child: Text(unit),
                                      );
                                    }).toList(),
                                    onChanged: _settingsSaving
                                        ? null
                                        : (unit) {
                                            if (unit == null) return;

                                            setState(() {
                                              _hashrateUnit = unit;
                                            });
                                          },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: _settingsSaving
                                ? null
                                : _saveHashrateThreshold,
                            icon: const Icon(Icons.save),
                            label: Text(localizations.saveHashrateThreshold),
                          ),
                        ),
                      ],
                    ),
                  ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(localizations.hashrateRestoredTitle),
                  subtitle: Text(localizations.hashrateRestoredDescription),
                  value: _hashrateRestoredEnabled,
                  onChanged: _settingsSaving
                      ? null
                      : (value) {
                          _saveSetting(
                            save: () => storage.saveHashrateRestoredEnabled(
                              value,
                              walletId: walletId,
                            ),
                            update: () {
                              _hashrateRestoredEnabled = value;
                            },
                          );
                        },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(localizations.workersChangeTitle),
                  subtitle: Text(localizations.workersChangeDescription),
                  value: _workersChangeEnabled,
                  onChanged: _settingsSaving
                      ? null
                      : (value) {
                          _saveSetting(
                            save: () => storage.saveWorkersChangeEnabled(
                              value,
                              walletId: walletId,
                            ),
                            update: () {
                              _workersChangeEnabled = value;
                            },
                          );
                        },
                ),
              ],
            ],

            //) VIV [Wallet Detailed Notification Settings — 2026-11-02]
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: widget.onOpenEvents,
                icon: const Icon(Icons.history),
                label: Text(localizations.notificationEventLog),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//) VIV [Wallet Card State — 2026-11-02]

//(VIV [Wallet Notification Events Page — 2026-10-18])

class _WalletNotificationEventsPage extends StatefulWidget {
  const _WalletNotificationEventsPage({required this.wallet});

  final Wallet wallet;

  @override
  State<_WalletNotificationEventsPage> createState() =>
      _WalletNotificationEventsPageState();
}

class _WalletNotificationEventsPageState
    extends State<_WalletNotificationEventsPage> {
  final NotificationEventStorage _storage = NotificationEventStorage();

  Timer? _refreshTimer;
  List<NotificationEvent> _events = [];

  bool _loading = true;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();

    _loadEvents();

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _loadEvents(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  // (VIV [Load Wallet Notification Events — 2026-10-18])

  Future<void> _loadEvents() async {
    if (_refreshing) {
      return;
    }

    _refreshing = true;

    try {
      final allEvents = await _storage.loadEvents();

      final walletEvents =
          allEvents
              .where((event) => event.walletId == widget.wallet.id)
              .toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      if (!mounted) {
        return;
      }

      final hasChanged =
          walletEvents.length != _events.length ||
          !_sameEventIds(walletEvents, _events);

      if (hasChanged || _loading) {
        setState(() {
          _events = walletEvents;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted && _loading) {
        setState(() {
          _loading = false;
        });
      }
    } finally {
      _refreshing = false;
    }
  }

  bool _sameEventIds(
    List<NotificationEvent> first,
    List<NotificationEvent> second,
  ) {
    if (first.length != second.length) {
      return false;
    }

    for (var i = 0; i < first.length; i++) {
      if (first[i].id != second[i].id) {
        return false;
      }
    }

    return true;
  }

  //) VIV [Load Wallet Notification Events — 2026-10-18]

  // (VIV [Wallet Notification Event Icon — 2026-10-18])

  IconData _eventIcon(String type) {
    switch (type) {
      case 'hashrate_below':
        return Icons.trending_down;
      case 'hashrate_restored':
        return Icons.trending_up;
      case 'workers_changed':
        return Icons.memory;
      default:
        return Icons.notifications;
    }
  }

  //) VIV [Wallet Notification Event Icon — 2026-10-18]

  // (VIV [Format Wallet Notification Event Date — 2026-10-18])

  String _formatDateTime(DateTime timestamp) {
    final value = timestamp.toLocal();

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$day.$month.$year $hour:$minute';
  }

  //) VIV [Format Wallet Notification Event Date — 2026-10-18]

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.walletNotificationEventsTitle(widget.wallet.name),
        ),
        actions: [
          IconButton(
            tooltip: localizations.refresh,
            onPressed: _loadEvents,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _events.isEmpty
          ? RefreshIndicator(
              onRefresh: _loadEvents,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 180),
                  const Icon(Icons.notifications_none, size: 56),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      localizations.noWalletNotificationEvents,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadEvents,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(_eventIcon(event.type)),
                      title: Text(event.title),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.message),
                            const SizedBox(height: 4),
                            Text(
                              _formatDateTime(event.timestamp),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
    );
  }
}

//) VIV [Wallet Notification Events Page — 2026-10-18]
