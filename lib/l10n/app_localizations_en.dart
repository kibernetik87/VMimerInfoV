// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'VMimerInfoV';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get hashrate => 'Hashrate';

  @override
  String get wallets => 'Wallets';

  @override
  String get workers => 'Workers';

  @override
  String get payments => 'Payments';

  @override
  String get settings => 'Settings';

  @override
  String get loadingStatistics => 'Loading statistics...';

  @override
  String get noWallets => 'No wallets yet';

  @override
  String get addWalletToSeeMiningStats =>
      'Add a wallet in the Wallets section to see mining statistics.';

  @override
  String get goToWallets => 'Go to Wallets';

  @override
  String get defaultWallet => 'Default wallet';

  @override
  String get miners => 'Miners';

  @override
  String get online => 'online';

  @override
  String get retry => 'Retry';

  @override
  String get unknownError => 'Unknown error.';

  @override
  String get statisticsLoadAutomatically =>
      'Statistics will load automatically for the default wallet.';

  @override
  String get totalHashes => 'Total Hashes';

  @override
  String get validShares => 'Valid Shares';

  @override
  String get invalidShares => 'Invalid Shares';

  @override
  String get paid => 'Paid';

  @override
  String get due => 'Due';

  @override
  String get transactions => 'Transactions';

  @override
  String get noMainWallet => 'No default wallet.';

  @override
  String get addWalletInWalletsSection =>
      'Add a wallet in the Wallets section.';

  @override
  String get failedToLoadHashrateHistory => 'Failed to load Hashrate history.';

  @override
  String get hashrateHistoryEmpty => 'Hashrate history is not available yet.';

  @override
  String get refresh => 'Refresh';

  @override
  String get currentHashrate => 'Current Hashrate';

  @override
  String get hashrateHistory => 'Hashrate History';

  @override
  String get expandChart => 'Expand chart';

  @override
  String get noDataForSelectedPeriod => 'No data for the selected period.';

  @override
  String get returnToPortrait => 'Return to portrait mode';

  @override
  String get both => 'Both';

  @override
  String get allTime => 'All time';

  @override
  String hourLabel(int hours) {
    return '$hours hours';
  }

  @override
  String get loadingPayments => 'Loading payments...';

  @override
  String get noDefaultWallet => 'No default wallet';

  @override
  String get selectDefaultWalletToSeePayments =>
      'Select a default wallet in the Wallets section to see payments.';

  @override
  String get paymentsWillLoadAutomatically =>
      'Payments will load automatically for the default wallet.';

  @override
  String get noPaymentsYet => 'No payments yet.';

  @override
  String get date => 'Date';

  @override
  String get mixin => 'Mixin';

  @override
  String get copyTxHash => 'Copy TX hash';

  @override
  String get txHashCopied => 'TX hash copied.';

  @override
  String get addWallet => 'Add wallet';

  @override
  String get walletsEmpty => 'No wallets yet';

  @override
  String get addPublicXmrAddress =>
      'Add a public XMR address to save and monitor your wallet.';

  @override
  String get walletName => 'Name';

  @override
  String get walletNameHint => 'For example, Main XMR';

  @override
  String get xmrAddress => 'XMR address';

  @override
  String get xmrAddressHint => 'Enter a public XMR address';

  @override
  String get enterWalletName => 'Enter a wallet name.';

  @override
  String get enterXmrAddress => 'Enter an XMR address.';

  @override
  String get checkXmrAddress => 'Check the XMR address.';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get addressCopied => 'Address copied.';

  @override
  String get deleteWallet => 'Delete wallet?';

  @override
  String deleteWalletConfirmation(String name) {
    return 'Wallet \"$name\" will be removed from the list.';
  }

  @override
  String get delete => 'Delete';

  @override
  String get setAsDefault => 'Default';

  @override
  String get copyAddress => 'Copy address';

  @override
  String get loadingWorkers => 'Loading Workers...';

  @override
  String get addAndSelectDefaultWallet =>
      'Add and select a default wallet in the Wallets section.';

  @override
  String get workersLoadAutomatically =>
      'Workers statistics will load automatically.';

  @override
  String get workersNotFound => 'No Workers found.';

  @override
  String get lastActivity => 'Last activity';

  @override
  String get loadingHistory => 'Loading history...';

  @override
  String get failedToLoadHistory => 'Failed to load history.';

  @override
  String get workerHashrateHistoryEmpty => 'Hashrate history is not available.';

  @override
  String get workerHashrateHistory => 'Worker Hashrate History';

  @override
  String get workerZeroHashrate => '0 H/s';

  @override
  String get workerOffline => 'Offline';

  @override
  String get language => 'Language';

  @override
  String get donateTitle => 'Support VMimerInfoV development';

  @override
  String get donateDescription =>
      'If you find this app useful, you can support its development with XMR.';

  @override
  String get donateCopyAddress => 'Copy donation address';

  @override
  String get donateAddressCopied => 'Donation address copied.';

  @override
  String get donateQrCode => 'Scan the QR code to donate XMR';

  @override
  String get languageUkrainian => 'Ukrainian';

  @override
  String get languageEnglish => 'English';

  @override
  String get notificationSettings => 'Notifications';

  @override
  String get hashrateNotification => 'Hashrate notifications';

  @override
  String get hashrateNotificationDescription =>
      'Notify when Hashrate crosses the specified threshold.';

  @override
  String get hashrateThreshold => 'Hashrate threshold';

  @override
  String get workersChangeNotification => 'Miner count changes';

  @override
  String get workersChangeNotificationDescription =>
      'Notify when the number of online miners changes.';

  @override
  String get notificationEventLog => 'Notification history';

  @override
  String get notificationEventLogEmpty => 'The event log is empty';

  @override
  String get notificationEventLogClear => 'Clear log';

  @override
  String get notificationEventLogClearTitle => 'Clear event log?';

  @override
  String get notificationEventLogClearDescription =>
      'All saved events will be deleted.';

  @override
  String get clear => 'Clear';

  @override
  String get editWallet => 'Edit wallet';

  @override
  String get save => 'Save';

  @override
  String get theme => 'App theme';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Matrix Mining Dark';

  @override
  String get widgets => 'Widgets';

  @override
  String get widgetRefreshSettings => 'Widget refresh';

  @override
  String get widgetRefreshDescription =>
      'Configure the automatic update interval for the widget and notifications';

  @override
  String get widgetRefreshIntervalTitle => 'Widget refresh interval';

  @override
  String get widgetRefreshIntervalDescription =>
      'Set the automatic widget refresh interval.';

  @override
  String get widgetRefreshInterval => 'Refresh interval';

  @override
  String get widgetRefreshLimits => 'Minimum: 00:01\nMaximum: 24:00';

  @override
  String get widgetRefreshSave => 'Save';

  @override
  String get widgetRefreshInvalidInterval =>
      'The value must be between 00:01 and 24:00.';

  @override
  String get widgetRefreshTimePickerHint => 'Select hours and minutes';

  @override
  String get widgetRefreshSaved => 'Refresh interval saved';

  @override
  String get notificationHashrateBelowTitle => 'Hashrate dropped';

  @override
  String notificationHashrateBelowMessage(
    Object walletPrefix,
    Object hashRate,
    Object threshold,
  ) {
    return '${walletPrefix}Hashrate $hashRate is below the threshold of $threshold.';
  }

  @override
  String get notificationHashrateRestoredTitle => 'Hashrate restored';

  @override
  String notificationHashrateRestoredMessage(
    Object walletPrefix,
    Object hashRate,
  ) {
    return '${walletPrefix}Hashrate $hashRate has returned to normal.';
  }

  @override
  String get notificationWorkersChangedTitle => 'Worker count changed';

  @override
  String notificationWorkersChangedMessage(
    Object walletPrefix,
    int previousWorkers,
    int workersOnline,
  ) {
    return '${walletPrefix}Online workers: $previousWorkers → $workersOnline.';
  }

  @override
  String walletsLoadError(Object error) {
    return 'Failed to load wallets: $error';
  }

  @override
  String walletNotificationsEnabled(Object walletName) {
    return 'Notifications for \"$walletName\" enabled';
  }

  @override
  String walletNotificationsDisabled(Object walletName) {
    return 'Notifications for \"$walletName\" disabled';
  }

  @override
  String walletSettingsSaveError(Object error) {
    return 'Failed to save settings: $error';
  }

  @override
  String walletSettingsDeleteError(Object error) {
    return 'Failed to delete wallet settings: $error';
  }

  @override
  String notificationSettingsLoadError(Object error) {
    return 'Failed to load notification settings: $error';
  }

  @override
  String get invalidHashrateThreshold => 'Enter a valid numeric threshold';

  @override
  String get walletNotificationsTitle => 'Notifications for this wallet';

  @override
  String get walletMonitoringEnabled => 'Monitoring for this wallet is enabled';

  @override
  String get walletMonitoringEnableHint =>
      'Enable to configure notifications for this wallet';

  @override
  String get notificationSettingsTitle => 'Notification settings';

  @override
  String get hashrateDropTitle => 'Hashrate drop';

  @override
  String get hashrateDropDescription =>
      'Notify when hashrate falls below the threshold';

  @override
  String get hashrateThresholdLabel => 'Hashrate threshold';

  @override
  String get hashrateThresholdHint => 'For example, 15 KH/s';

  @override
  String get hashrateUnitLabel => 'Unit';

  @override
  String get saveHashrateThreshold => 'Save threshold';

  @override
  String get hashrateRestoredTitle => 'Hashrate restored';

  @override
  String get hashrateRestoredDescription =>
      'Notify when hashrate rises above the threshold again';

  @override
  String get workersChangeTitle => 'Worker count changed';

  @override
  String get workersChangeDescription =>
      'Notify when the number of workers increases or decreases';

  @override
  String walletNotificationEventsTitle(Object walletName) {
    return 'Notifications: $walletName';
  }

  @override
  String get noWalletNotificationEvents =>
      'There are no events for this wallet yet.';

  @override
  String get dashboardSubtitle => 'XMR wallet monitoring';

  @override
  String get hashrate2 => 'Hashrate²';

  @override
  String get miningPool => 'Mining pool';

  @override
  String get aboutApp => 'About app';

  @override
  String get aboutDescription =>
      'Monitor Monero mining through the MoneroOcean pool. View hashrate, worker activity, statistics, mining history, and payments. Configure notifications and widgets to keep track of your miners. VMimerInfoV uses public wallet data and does not control mining hardware.';

  @override
  String get developerContact => 'Developer contact';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackDescription => 'Report a bug or suggest an improvement';

  @override
  String get sendFeedback => 'Contact developer';

  @override
  String get feedbackEmailSubject => 'VMimerInfoV — Feedback';

  @override
  String get feedbackEmailBody =>
      'Hello! I would like to report an issue or suggest an improvement for VMimerInfoV.';

  @override
  String get feedbackOpenError => 'Could not open the email app';

  @override
  String get appVersion => 'Version';
}
