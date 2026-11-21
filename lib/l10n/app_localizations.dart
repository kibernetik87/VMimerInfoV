import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In uk, this message translates to:
  /// **'VMimerInfoV'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In uk, this message translates to:
  /// **'Панель'**
  String get dashboard;

  /// No description provided for @hashrate.
  ///
  /// In uk, this message translates to:
  /// **'Хешрейт'**
  String get hashrate;

  /// No description provided for @wallets.
  ///
  /// In uk, this message translates to:
  /// **'Гаманці'**
  String get wallets;

  /// No description provided for @workers.
  ///
  /// In uk, this message translates to:
  /// **'Воркери'**
  String get workers;

  /// No description provided for @payments.
  ///
  /// In uk, this message translates to:
  /// **'Виплати'**
  String get payments;

  /// No description provided for @settings.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування'**
  String get settings;

  /// No description provided for @loadingStatistics.
  ///
  /// In uk, this message translates to:
  /// **'Завантаження статистики...'**
  String get loadingStatistics;

  /// No description provided for @noWallets.
  ///
  /// In uk, this message translates to:
  /// **'Гаманців ще немає'**
  String get noWallets;

  /// No description provided for @addWalletToSeeMiningStats.
  ///
  /// In uk, this message translates to:
  /// **'Додайте гаманець у розділі «Гаманці», щоб побачити статистику майнінгу.'**
  String get addWalletToSeeMiningStats;

  /// No description provided for @goToWallets.
  ///
  /// In uk, this message translates to:
  /// **'До гаманців'**
  String get goToWallets;

  /// No description provided for @defaultWallet.
  ///
  /// In uk, this message translates to:
  /// **'Гаманець за замовчуванням'**
  String get defaultWallet;

  /// No description provided for @miners.
  ///
  /// In uk, this message translates to:
  /// **'Майнери'**
  String get miners;

  /// No description provided for @online.
  ///
  /// In uk, this message translates to:
  /// **'онлайн'**
  String get online;

  /// No description provided for @retry.
  ///
  /// In uk, this message translates to:
  /// **'Повторити'**
  String get retry;

  /// No description provided for @unknownError.
  ///
  /// In uk, this message translates to:
  /// **'Невідома помилка.'**
  String get unknownError;

  /// No description provided for @statisticsLoadAutomatically.
  ///
  /// In uk, this message translates to:
  /// **'Статистика завантажиться автоматично для гаманця за замовчуванням.'**
  String get statisticsLoadAutomatically;

  /// No description provided for @totalHashes.
  ///
  /// In uk, this message translates to:
  /// **'Усього хешів'**
  String get totalHashes;

  /// No description provided for @validShares.
  ///
  /// In uk, this message translates to:
  /// **'Прийняті шари'**
  String get validShares;

  /// No description provided for @invalidShares.
  ///
  /// In uk, this message translates to:
  /// **'Відхилені шари'**
  String get invalidShares;

  /// No description provided for @paid.
  ///
  /// In uk, this message translates to:
  /// **'Виплачено'**
  String get paid;

  /// No description provided for @due.
  ///
  /// In uk, this message translates to:
  /// **'До виплати'**
  String get due;

  /// No description provided for @transactions.
  ///
  /// In uk, this message translates to:
  /// **'Транзакції'**
  String get transactions;

  /// No description provided for @noMainWallet.
  ///
  /// In uk, this message translates to:
  /// **'Немає основного гаманця.'**
  String get noMainWallet;

  /// No description provided for @addWalletInWalletsSection.
  ///
  /// In uk, this message translates to:
  /// **'Додайте гаманець у розділі «Гаманці».'**
  String get addWalletInWalletsSection;

  /// No description provided for @failedToLoadHashrateHistory.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося завантажити історію Hashrate.'**
  String get failedToLoadHashrateHistory;

  /// No description provided for @hashrateHistoryEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Історія Hashrate поки що відсутня.'**
  String get hashrateHistoryEmpty;

  /// No description provided for @refresh.
  ///
  /// In uk, this message translates to:
  /// **'Оновити'**
  String get refresh;

  /// No description provided for @currentHashrate.
  ///
  /// In uk, this message translates to:
  /// **'Поточний Hashrate'**
  String get currentHashrate;

  /// No description provided for @hashrateHistory.
  ///
  /// In uk, this message translates to:
  /// **'Історія Hashrate'**
  String get hashrateHistory;

  /// No description provided for @expandChart.
  ///
  /// In uk, this message translates to:
  /// **'Розгорнути графік'**
  String get expandChart;

  /// No description provided for @noDataForSelectedPeriod.
  ///
  /// In uk, this message translates to:
  /// **'Немає даних за вибраний період.'**
  String get noDataForSelectedPeriod;

  /// No description provided for @returnToPortrait.
  ///
  /// In uk, this message translates to:
  /// **'Повернути вертикальний режим'**
  String get returnToPortrait;

  /// No description provided for @both.
  ///
  /// In uk, this message translates to:
  /// **'Обидва'**
  String get both;

  /// No description provided for @allTime.
  ///
  /// In uk, this message translates to:
  /// **'Весь час'**
  String get allTime;

  /// Hashrate history period in hours
  ///
  /// In uk, this message translates to:
  /// **'{hours} год'**
  String hourLabel(int hours);

  /// No description provided for @loadingPayments.
  ///
  /// In uk, this message translates to:
  /// **'Завантаження виплат...'**
  String get loadingPayments;

  /// No description provided for @noDefaultWallet.
  ///
  /// In uk, this message translates to:
  /// **'Гаманця за замовчуванням немає'**
  String get noDefaultWallet;

  /// No description provided for @selectDefaultWalletToSeePayments.
  ///
  /// In uk, this message translates to:
  /// **'Виберіть гаманець за замовчуванням у розділі «Гаманці», щоб побачити виплати.'**
  String get selectDefaultWalletToSeePayments;

  /// No description provided for @paymentsWillLoadAutomatically.
  ///
  /// In uk, this message translates to:
  /// **'Виплати завантажаться автоматично для гаманця за замовчуванням.'**
  String get paymentsWillLoadAutomatically;

  /// No description provided for @noPaymentsYet.
  ///
  /// In uk, this message translates to:
  /// **'Виплат поки немає.'**
  String get noPaymentsYet;

  /// No description provided for @date.
  ///
  /// In uk, this message translates to:
  /// **'Дата'**
  String get date;

  /// No description provided for @mixin.
  ///
  /// In uk, this message translates to:
  /// **'Mixin'**
  String get mixin;

  /// No description provided for @copyTxHash.
  ///
  /// In uk, this message translates to:
  /// **'Копіювати TX hash'**
  String get copyTxHash;

  /// No description provided for @txHashCopied.
  ///
  /// In uk, this message translates to:
  /// **'TX hash скопійовано.'**
  String get txHashCopied;

  /// No description provided for @addWallet.
  ///
  /// In uk, this message translates to:
  /// **'Додати гаманець'**
  String get addWallet;

  /// No description provided for @walletsEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Гаманців ще немає'**
  String get walletsEmpty;

  /// No description provided for @addPublicXmrAddress.
  ///
  /// In uk, this message translates to:
  /// **'Додайте публічну XMR-адресу, щоб зберігати та моніторити свій гаманець.'**
  String get addPublicXmrAddress;

  /// No description provided for @walletName.
  ///
  /// In uk, this message translates to:
  /// **'Назва'**
  String get walletName;

  /// No description provided for @walletNameHint.
  ///
  /// In uk, this message translates to:
  /// **'Наприклад, Main XMR'**
  String get walletNameHint;

  /// No description provided for @xmrAddress.
  ///
  /// In uk, this message translates to:
  /// **'XMR адреса'**
  String get xmrAddress;

  /// No description provided for @xmrAddressHint.
  ///
  /// In uk, this message translates to:
  /// **'Введіть публічну XMR-адресу'**
  String get xmrAddressHint;

  /// No description provided for @enterWalletName.
  ///
  /// In uk, this message translates to:
  /// **'Введіть назву гаманця.'**
  String get enterWalletName;

  /// No description provided for @enterXmrAddress.
  ///
  /// In uk, this message translates to:
  /// **'Введіть XMR-адресу.'**
  String get enterXmrAddress;

  /// No description provided for @checkXmrAddress.
  ///
  /// In uk, this message translates to:
  /// **'Перевірте XMR-адресу.'**
  String get checkXmrAddress;

  /// No description provided for @cancel.
  ///
  /// In uk, this message translates to:
  /// **'Скасувати'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In uk, this message translates to:
  /// **'Додати'**
  String get add;

  /// No description provided for @addressCopied.
  ///
  /// In uk, this message translates to:
  /// **'Адресу скопійовано.'**
  String get addressCopied;

  /// No description provided for @deleteWallet.
  ///
  /// In uk, this message translates to:
  /// **'Видалити гаманець?'**
  String get deleteWallet;

  /// Confirmation message before deleting a wallet
  ///
  /// In uk, this message translates to:
  /// **'Гаманець «{name}» буде видалено зі списку.'**
  String deleteWalletConfirmation(String name);

  /// No description provided for @delete.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get delete;

  /// No description provided for @setAsDefault.
  ///
  /// In uk, this message translates to:
  /// **'Основний'**
  String get setAsDefault;

  /// No description provided for @copyAddress.
  ///
  /// In uk, this message translates to:
  /// **'Копіювати адресу'**
  String get copyAddress;

  /// No description provided for @loadingWorkers.
  ///
  /// In uk, this message translates to:
  /// **'Завантаження Workers...'**
  String get loadingWorkers;

  /// No description provided for @addAndSelectDefaultWallet.
  ///
  /// In uk, this message translates to:
  /// **'Додайте та виберіть гаманець за замовчуванням у розділі «Гаманці».'**
  String get addAndSelectDefaultWallet;

  /// No description provided for @workersLoadAutomatically.
  ///
  /// In uk, this message translates to:
  /// **'Статистика Workers завантажиться автоматично.'**
  String get workersLoadAutomatically;

  /// No description provided for @workersNotFound.
  ///
  /// In uk, this message translates to:
  /// **'Workers не знайдено.'**
  String get workersNotFound;

  /// No description provided for @lastActivity.
  ///
  /// In uk, this message translates to:
  /// **'Остання активність'**
  String get lastActivity;

  /// No description provided for @loadingHistory.
  ///
  /// In uk, this message translates to:
  /// **'Завантаження історії...'**
  String get loadingHistory;

  /// No description provided for @failedToLoadHistory.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося завантажити історію.'**
  String get failedToLoadHistory;

  /// No description provided for @workerHashrateHistoryEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Історія Hashrate відсутня.'**
  String get workerHashrateHistoryEmpty;

  /// No description provided for @workerHashrateHistory.
  ///
  /// In uk, this message translates to:
  /// **'Історія Hashrate Worker'**
  String get workerHashrateHistory;

  /// No description provided for @workerZeroHashrate.
  ///
  /// In uk, this message translates to:
  /// **'0 H/s'**
  String get workerZeroHashrate;

  /// No description provided for @workerOffline.
  ///
  /// In uk, this message translates to:
  /// **'Офлайн'**
  String get workerOffline;

  /// No description provided for @language.
  ///
  /// In uk, this message translates to:
  /// **'Мова'**
  String get language;

  /// No description provided for @donateTitle.
  ///
  /// In uk, this message translates to:
  /// **'Підтримати розвиток VMimerInfoV'**
  String get donateTitle;

  /// No description provided for @donateDescription.
  ///
  /// In uk, this message translates to:
  /// **'Якщо застосунок корисний для вас, підтримайте його розвиток переказом XMR.'**
  String get donateDescription;

  /// No description provided for @donateCopyAddress.
  ///
  /// In uk, this message translates to:
  /// **'Копіювати адресу для донату'**
  String get donateCopyAddress;

  /// No description provided for @donateAddressCopied.
  ///
  /// In uk, this message translates to:
  /// **'Адресу для донату скопійовано.'**
  String get donateAddressCopied;

  /// No description provided for @donateQrCode.
  ///
  /// In uk, this message translates to:
  /// **'Відскануйте QR-код, щоб надіслати XMR'**
  String get donateQrCode;

  /// No description provided for @languageUkrainian.
  ///
  /// In uk, this message translates to:
  /// **'Українська'**
  String get languageUkrainian;

  /// No description provided for @languageEnglish.
  ///
  /// In uk, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @notificationSettings.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення'**
  String get notificationSettings;

  /// No description provided for @hashrateNotification.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення про Hashrate'**
  String get hashrateNotification;

  /// No description provided for @hashrateNotificationDescription.
  ///
  /// In uk, this message translates to:
  /// **'Повідомляти, коли Hashrate перетинає заданий поріг.'**
  String get hashrateNotificationDescription;

  /// No description provided for @hashrateThreshold.
  ///
  /// In uk, this message translates to:
  /// **'Поріг Hashrate'**
  String get hashrateThreshold;

  /// No description provided for @workersChangeNotification.
  ///
  /// In uk, this message translates to:
  /// **'Зміна кількості майнерів'**
  String get workersChangeNotification;

  /// No description provided for @workersChangeNotificationDescription.
  ///
  /// In uk, this message translates to:
  /// **'Повідомляти, коли змінюється кількість майнерів онлайн.'**
  String get workersChangeNotificationDescription;

  /// No description provided for @notificationEventLog.
  ///
  /// In uk, this message translates to:
  /// **'Журнал подій'**
  String get notificationEventLog;

  /// No description provided for @notificationEventLogEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Журнал подій порожній'**
  String get notificationEventLogEmpty;

  /// No description provided for @notificationEventLogClear.
  ///
  /// In uk, this message translates to:
  /// **'Очистити журнал'**
  String get notificationEventLogClear;

  /// No description provided for @notificationEventLogClearTitle.
  ///
  /// In uk, this message translates to:
  /// **'Очистити журнал подій?'**
  String get notificationEventLogClearTitle;

  /// No description provided for @notificationEventLogClearDescription.
  ///
  /// In uk, this message translates to:
  /// **'Усі збережені події буде видалено.'**
  String get notificationEventLogClearDescription;

  /// No description provided for @clear.
  ///
  /// In uk, this message translates to:
  /// **'Очистити'**
  String get clear;

  /// No description provided for @editWallet.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати гаманець'**
  String get editWallet;

  /// No description provided for @save.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти'**
  String get save;

  /// No description provided for @theme.
  ///
  /// In uk, this message translates to:
  /// **'Тема оформлення'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In uk, this message translates to:
  /// **'Як у системі'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In uk, this message translates to:
  /// **'Світла'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In uk, this message translates to:
  /// **'Matrix Mining Dark'**
  String get themeDark;

  /// No description provided for @widgets.
  ///
  /// In uk, this message translates to:
  /// **'Віджети'**
  String get widgets;

  /// No description provided for @widgetRefreshSettings.
  ///
  /// In uk, this message translates to:
  /// **'Оновлення віджета'**
  String get widgetRefreshSettings;

  /// No description provided for @widgetRefreshDescription.
  ///
  /// In uk, this message translates to:
  /// **'Налаштувати інтервал автоматичного оновлення віджета, та сповіщень'**
  String get widgetRefreshDescription;

  /// No description provided for @widgetRefreshIntervalTitle.
  ///
  /// In uk, this message translates to:
  /// **'Інтервал оновлення віджета'**
  String get widgetRefreshIntervalTitle;

  /// No description provided for @widgetRefreshIntervalDescription.
  ///
  /// In uk, this message translates to:
  /// **'Встановіть інтервал автоматичного оновлення віджета.'**
  String get widgetRefreshIntervalDescription;

  /// No description provided for @widgetRefreshInterval.
  ///
  /// In uk, this message translates to:
  /// **'Інтервал оновлення'**
  String get widgetRefreshInterval;

  /// No description provided for @widgetRefreshLimits.
  ///
  /// In uk, this message translates to:
  /// **'Мінімум: 00:01\nМаксимум: 24:00'**
  String get widgetRefreshLimits;

  /// No description provided for @widgetRefreshSave.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти'**
  String get widgetRefreshSave;

  /// No description provided for @widgetRefreshInvalidInterval.
  ///
  /// In uk, this message translates to:
  /// **'Значення має бути від 00:01 до 24:00.'**
  String get widgetRefreshInvalidInterval;

  /// No description provided for @widgetRefreshTimePickerHint.
  ///
  /// In uk, this message translates to:
  /// **'Оберіть години та хвилини'**
  String get widgetRefreshTimePickerHint;

  /// No description provided for @widgetRefreshSaved.
  ///
  /// In uk, this message translates to:
  /// **'Інтервал оновлення збережено'**
  String get widgetRefreshSaved;

  /// No description provided for @notificationHashrateBelowTitle.
  ///
  /// In uk, this message translates to:
  /// **'Зниження хешрейту'**
  String get notificationHashrateBelowTitle;

  /// No description provided for @notificationHashrateBelowMessage.
  ///
  /// In uk, this message translates to:
  /// **'{walletPrefix}Хешрейт {hashRate} нижче порогу {threshold}.'**
  String notificationHashrateBelowMessage(
    Object walletPrefix,
    Object hashRate,
    Object threshold,
  );

  /// No description provided for @notificationHashrateRestoredTitle.
  ///
  /// In uk, this message translates to:
  /// **'Хешрейт відновлено'**
  String get notificationHashrateRestoredTitle;

  /// No description provided for @notificationHashrateRestoredMessage.
  ///
  /// In uk, this message translates to:
  /// **'{walletPrefix}Хешрейт {hashRate} відновився до нормального рівня.'**
  String notificationHashrateRestoredMessage(
    Object walletPrefix,
    Object hashRate,
  );

  /// No description provided for @notificationWorkersChangedTitle.
  ///
  /// In uk, this message translates to:
  /// **'Зміна кількості воркерів'**
  String get notificationWorkersChangedTitle;

  /// No description provided for @notificationWorkersChangedMessage.
  ///
  /// In uk, this message translates to:
  /// **'{walletPrefix}Онлайн-воркери: {previousWorkers} → {workersOnline}.'**
  String notificationWorkersChangedMessage(
    Object walletPrefix,
    int previousWorkers,
    int workersOnline,
  );

  /// No description provided for @walletsLoadError.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося завантажити гаманці: {error}'**
  String walletsLoadError(Object error);

  /// No description provided for @walletNotificationsEnabled.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення для «{walletName}» увімкнено'**
  String walletNotificationsEnabled(Object walletName);

  /// No description provided for @walletNotificationsDisabled.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення для «{walletName}» вимкнено'**
  String walletNotificationsDisabled(Object walletName);

  /// No description provided for @walletSettingsSaveError.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося зберегти налаштування: {error}'**
  String walletSettingsSaveError(Object error);

  /// No description provided for @walletSettingsDeleteError.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося видалити налаштування гаманця: {error}'**
  String walletSettingsDeleteError(Object error);

  /// No description provided for @notificationSettingsLoadError.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося завантажити налаштування сповіщень: {error}'**
  String notificationSettingsLoadError(Object error);

  /// No description provided for @invalidHashrateThreshold.
  ///
  /// In uk, this message translates to:
  /// **'Введіть коректне числове значення порогу'**
  String get invalidHashrateThreshold;

  /// No description provided for @walletNotificationsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення для цього гаманця'**
  String get walletNotificationsTitle;

  /// No description provided for @walletMonitoringEnabled.
  ///
  /// In uk, this message translates to:
  /// **'Моніторинг для цього гаманця увімкнено'**
  String get walletMonitoringEnabled;

  /// No description provided for @walletMonitoringEnableHint.
  ///
  /// In uk, this message translates to:
  /// **'Увімкніть, щоб налаштувати сповіщення цього гаманця'**
  String get walletMonitoringEnableHint;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування сповіщень'**
  String get notificationSettingsTitle;

  /// No description provided for @hashrateDropTitle.
  ///
  /// In uk, this message translates to:
  /// **'Падіння хешрейту'**
  String get hashrateDropTitle;

  /// No description provided for @hashrateDropDescription.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщати, коли хешрейт опуститься нижче порогу'**
  String get hashrateDropDescription;

  /// No description provided for @hashrateThresholdLabel.
  ///
  /// In uk, this message translates to:
  /// **'Пороговий хешрейт'**
  String get hashrateThresholdLabel;

  /// No description provided for @hashrateThresholdHint.
  ///
  /// In uk, this message translates to:
  /// **'Наприклад: 15'**
  String get hashrateThresholdHint;

  /// No description provided for @hashrateUnitLabel.
  ///
  /// In uk, this message translates to:
  /// **'Одиниця'**
  String get hashrateUnitLabel;

  /// No description provided for @saveHashrateThreshold.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти поріг'**
  String get saveHashrateThreshold;

  /// No description provided for @hashrateRestoredTitle.
  ///
  /// In uk, this message translates to:
  /// **'Відновлення хешрейту'**
  String get hashrateRestoredTitle;

  /// No description provided for @hashrateRestoredDescription.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщати, коли хешрейт знову стане вищим за поріг'**
  String get hashrateRestoredDescription;

  /// No description provided for @workersChangeTitle.
  ///
  /// In uk, this message translates to:
  /// **'Зміна кількості воркерів'**
  String get workersChangeTitle;

  /// No description provided for @workersChangeDescription.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщати про збільшення або зменшення кількості воркерів'**
  String get workersChangeDescription;

  /// No description provided for @walletNotificationEventsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Сповіщення: {walletName}'**
  String walletNotificationEventsTitle(Object walletName);

  /// No description provided for @noWalletNotificationEvents.
  ///
  /// In uk, this message translates to:
  /// **'Для цього гаманця поки немає подій.'**
  String get noWalletNotificationEvents;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In uk, this message translates to:
  /// **'Моніторинг XMR-гаманця'**
  String get dashboardSubtitle;

  /// No description provided for @hashrate2.
  ///
  /// In uk, this message translates to:
  /// **'Хешрейт²'**
  String get hashrate2;

  /// No description provided for @miningPool.
  ///
  /// In uk, this message translates to:
  /// **'Майнінг-пул'**
  String get miningPool;

  /// No description provided for @aboutApp.
  ///
  /// In uk, this message translates to:
  /// **'Про програму'**
  String get aboutApp;

  /// No description provided for @aboutDescription.
  ///
  /// In uk, this message translates to:
  /// **'Моніторинг майнінгу Monero через пул MoneroOcean. Переглядайте хешрейт, активність воркерів, статистику, історію майнінгу та виплати. Налаштовуйте сповіщення й віджети для зручного контролю роботи майнерів. VMimerInfoV використовує публічні дані гаманців і не керує роботою майнінгового обладнання.'**
  String get aboutDescription;

  /// No description provided for @developerContact.
  ///
  /// In uk, this message translates to:
  /// **'Контакт розробника'**
  String get developerContact;

  /// No description provided for @feedback.
  ///
  /// In uk, this message translates to:
  /// **'Зворотний зв\'язок'**
  String get feedback;

  /// No description provided for @feedbackDescription.
  ///
  /// In uk, this message translates to:
  /// **'Повідомити про помилку або запропонувати покращення'**
  String get feedbackDescription;

  /// No description provided for @sendFeedback.
  ///
  /// In uk, this message translates to:
  /// **'Написати розробнику'**
  String get sendFeedback;

  /// No description provided for @feedbackEmailSubject.
  ///
  /// In uk, this message translates to:
  /// **'VMimerInfoV — зворотний зв\'язок'**
  String get feedbackEmailSubject;

  /// No description provided for @feedbackEmailBody.
  ///
  /// In uk, this message translates to:
  /// **'Вітаю! Хочу повідомити про проблему або запропонувати покращення програми VMimerInfoV.'**
  String get feedbackEmailBody;

  /// No description provided for @feedbackOpenError.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося відкрити поштовий клієнт'**
  String get feedbackOpenError;

  /// No description provided for @appVersion.
  ///
  /// In uk, this message translates to:
  /// **'Версія'**
  String get appVersion;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
