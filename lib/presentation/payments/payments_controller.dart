//(VIV [Payments Controller — 2026-10-04])

import 'package:flutter/foundation.dart';

import '../../core/storage/wallet_storage.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/services/wallet_mining_service_contract.dart';

//(VIV [Payments Status — 2026-10-04])

enum PaymentsStatus { idle, loading, loaded, noWallet, error }

//(VIV [Payments Controller Class — 2026-10-04])

class PaymentsController extends ChangeNotifier {
  PaymentsController({required this.service, required this.walletStorage});

  final WalletMiningServiceContract service;
  final WalletStorage walletStorage;

  PaymentsStatus status = PaymentsStatus.idle;

  List<Payment> payments = [];

  String? errorMessage;

  String? walletAddress;

  Future<void> loadDefaultWallet({int page = 0, int limit = 15}) async {
    status = PaymentsStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final wallets = await walletStorage.loadWallets();

      Wallet? defaultWallet;

      for (final wallet in wallets) {
        if (wallet.isDefault) {
          defaultWallet = wallet;
          break;
        }
      }

      if (defaultWallet == null) {
        walletAddress = null;
        payments = [];
        status = PaymentsStatus.noWallet;
        notifyListeners();
        return;
      }

      walletAddress = defaultWallet.address;

      payments = await service.loadPayments(
        defaultWallet.address,
        page: page,
        limit: limit,
      );

      status = PaymentsStatus.loaded;
      notifyListeners();
    } catch (error) {
      status = PaymentsStatus.error;
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> refresh({int page = 0, int limit = 15}) async {
    await loadDefaultWallet(page: page, limit: limit);
  }
}
