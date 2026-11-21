//(VIV [Payments Page — 2026-10-04])

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/payment.dart';
import '../../l10n/app_localizations.dart';
import 'payments_controller.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({required this.controller, super.key});

  final PaymentsController controller;

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

//(VIV [Payments Page State — 2026-10-04])

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onControllerChanged);

    // Автоматичне завантаження виплат
    // гаманця за замовчуванням.
    widget.controller.loadDefaultWallet();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _refreshPayments() async {
    await widget.controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshPayments,
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (controller.status == PaymentsStatus.loading)
              const _PaymentsLoading(),
            if (controller.status == PaymentsStatus.noWallet)
              const _PaymentsNoWallet(),
            if (controller.status == PaymentsStatus.error)
              _PaymentsError(
                message:
                    controller.errorMessage ??
                    AppLocalizations.of(context)!.unknownError,
                onRetry: _refreshPayments,
              ),
            if (controller.status == PaymentsStatus.loaded)
              _PaymentsList(payments: controller.payments),
            if (controller.status == PaymentsStatus.idle) const _PaymentsHint(),
          ],
        ),
      ),
    );
  }
}

//(VIV [Payments Loading — 2026-10-04])

class _PaymentsLoading extends StatelessWidget {
  const _PaymentsLoading();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(localizations.loadingPayments, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

//(VIV [Payments No Wallet — 2026-10-04])

class _PaymentsNoWallet extends StatelessWidget {
  const _PaymentsNoWallet();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 52,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 14),
            Text(
              localizations.noDefaultWallet,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.selectDefaultWalletToSeePayments,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Payments Error — 2026-10-04])

class _PaymentsError extends StatelessWidget {
  const _PaymentsError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(message)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(localizations.retry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Payments Hint — 2026-10-04])

class _PaymentsHint extends StatelessWidget {
  const _PaymentsHint();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          localizations.paymentsWillLoadAutomatically,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

//(VIV [Payments List — 2026-10-04])

class _PaymentsList extends StatelessWidget {
  const _PaymentsList({required this.payments});

  final List<Payment> payments;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (payments.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.payments_outlined, size: 48),
              const SizedBox(height: 12),
              Text(localizations.noPaymentsYet, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final payment in payments) ...[
          _PaymentCard(payment: payment),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

//(VIV [Payment Card — 2026-10-04])

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payments, color: colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${payment.amount.toStringAsFixed(9)} XMR',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(label: Text(payment.type.toUpperCase())),
              ],
            ),
            const SizedBox(height: 14),
            _PaymentValueRow(
              title: localizations.date,
              value: _formatPaymentDate(payment.timestamp),
            ),
            const SizedBox(height: 8),
            _PaymentValueRow(
              title: localizations.mixin,
              value: payment.mixin.toString(),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _shortenTransactionHash(payment.txnHash),
                    style: const TextStyle(fontFamily: 'monospace'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: localizations.copyTxHash,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: payment.txnHash));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localizations.txHashCopied)),
                    );
                  },
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//(VIV [Payment Value Row — 2026-10-04])

class _PaymentValueRow extends StatelessWidget {
  const _PaymentValueRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

//(VIV [Payment Date Formatter — 2026-10-04])

String _formatPaymentDate(DateTime value) {
  final localValue = value.toLocal();

  final day = localValue.day.toString().padLeft(2, '0');
  final month = localValue.month.toString().padLeft(2, '0');
  final year = localValue.year.toString();

  final hour = localValue.hour.toString().padLeft(2, '0');
  final minute = localValue.minute.toString().padLeft(2, '0');

  return '$day.$month.$year $hour:$minute';
}

//(VIV [Payment Transaction Hash Formatter — 2026-10-04])

String _shortenTransactionHash(String value) {
  if (value.length <= 24) {
    return value;
  }

  return '${value.substring(0, 12)}...'
      '${value.substring(value.length - 12)}';
}
