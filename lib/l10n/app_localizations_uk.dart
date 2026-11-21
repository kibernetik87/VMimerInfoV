// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'VMimerInfoV';

  @override
  String get dashboard => 'Панель';

  @override
  String get hashrate => 'Хешрейт';

  @override
  String get wallets => 'Гаманці';

  @override
  String get workers => 'Воркери';

  @override
  String get payments => 'Виплати';

  @override
  String get settings => 'Налаштування';

  @override
  String get loadingStatistics => 'Завантаження статистики...';

  @override
  String get noWallets => 'Гаманців ще немає';

  @override
  String get addWalletToSeeMiningStats =>
      'Додайте гаманець у розділі «Гаманці», щоб побачити статистику майнінгу.';

  @override
  String get goToWallets => 'До гаманців';

  @override
  String get defaultWallet => 'Гаманець за замовчуванням';

  @override
  String get miners => 'Майнери';

  @override
  String get online => 'онлайн';

  @override
  String get retry => 'Повторити';

  @override
  String get unknownError => 'Невідома помилка.';

  @override
  String get statisticsLoadAutomatically =>
      'Статистика завантажиться автоматично для гаманця за замовчуванням.';

  @override
  String get totalHashes => 'Усього хешів';

  @override
  String get validShares => 'Прийняті шари';

  @override
  String get invalidShares => 'Відхилені шари';

  @override
  String get paid => 'Виплачено';

  @override
  String get due => 'До виплати';

  @override
  String get transactions => 'Транзакції';

  @override
  String get noMainWallet => 'Немає основного гаманця.';

  @override
  String get addWalletInWalletsSection =>
      'Додайте гаманець у розділі «Гаманці».';

  @override
  String get failedToLoadHashrateHistory =>
      'Не вдалося завантажити історію Hashrate.';

  @override
  String get hashrateHistoryEmpty => 'Історія Hashrate поки що відсутня.';

  @override
  String get refresh => 'Оновити';

  @override
  String get currentHashrate => 'Поточний Hashrate';

  @override
  String get hashrateHistory => 'Історія Hashrate';

  @override
  String get expandChart => 'Розгорнути графік';

  @override
  String get noDataForSelectedPeriod => 'Немає даних за вибраний період.';

  @override
  String get returnToPortrait => 'Повернути вертикальний режим';

  @override
  String get both => 'Обидва';

  @override
  String get allTime => 'Весь час';

  @override
  String hourLabel(int hours) {
    return '$hours год';
  }

  @override
  String get loadingPayments => 'Завантаження виплат...';

  @override
  String get noDefaultWallet => 'Гаманця за замовчуванням немає';

  @override
  String get selectDefaultWalletToSeePayments =>
      'Виберіть гаманець за замовчуванням у розділі «Гаманці», щоб побачити виплати.';

  @override
  String get paymentsWillLoadAutomatically =>
      'Виплати завантажаться автоматично для гаманця за замовчуванням.';

  @override
  String get noPaymentsYet => 'Виплат поки немає.';

  @override
  String get date => 'Дата';

  @override
  String get mixin => 'Mixin';

  @override
  String get copyTxHash => 'Копіювати TX hash';

  @override
  String get txHashCopied => 'TX hash скопійовано.';

  @override
  String get addWallet => 'Додати гаманець';

  @override
  String get walletsEmpty => 'Гаманців ще немає';

  @override
  String get addPublicXmrAddress =>
      'Додайте публічну XMR-адресу, щоб зберігати та моніторити свій гаманець.';

  @override
  String get walletName => 'Назва';

  @override
  String get walletNameHint => 'Наприклад, Main XMR';

  @override
  String get xmrAddress => 'XMR адреса';

  @override
  String get xmrAddressHint => 'Введіть публічну XMR-адресу';

  @override
  String get enterWalletName => 'Введіть назву гаманця.';

  @override
  String get enterXmrAddress => 'Введіть XMR-адресу.';

  @override
  String get checkXmrAddress => 'Перевірте XMR-адресу.';

  @override
  String get cancel => 'Скасувати';

  @override
  String get add => 'Додати';

  @override
  String get addressCopied => 'Адресу скопійовано.';

  @override
  String get deleteWallet => 'Видалити гаманець?';

  @override
  String deleteWalletConfirmation(String name) {
    return 'Гаманець «$name» буде видалено зі списку.';
  }

  @override
  String get delete => 'Видалити';

  @override
  String get setAsDefault => 'Основний';

  @override
  String get copyAddress => 'Копіювати адресу';

  @override
  String get loadingWorkers => 'Завантаження Workers...';

  @override
  String get addAndSelectDefaultWallet =>
      'Додайте та виберіть гаманець за замовчуванням у розділі «Гаманці».';

  @override
  String get workersLoadAutomatically =>
      'Статистика Workers завантажиться автоматично.';

  @override
  String get workersNotFound => 'Workers не знайдено.';

  @override
  String get lastActivity => 'Остання активність';

  @override
  String get loadingHistory => 'Завантаження історії...';

  @override
  String get failedToLoadHistory => 'Не вдалося завантажити історію.';

  @override
  String get workerHashrateHistoryEmpty => 'Історія Hashrate відсутня.';

  @override
  String get workerHashrateHistory => 'Історія Hashrate Worker';

  @override
  String get workerZeroHashrate => '0 H/s';

  @override
  String get workerOffline => 'Офлайн';

  @override
  String get language => 'Мова';

  @override
  String get donateTitle => 'Підтримати розвиток VMimerInfoV';

  @override
  String get donateDescription =>
      'Якщо застосунок корисний для вас, підтримайте його розвиток переказом XMR.';

  @override
  String get donateCopyAddress => 'Копіювати адресу для донату';

  @override
  String get donateAddressCopied => 'Адресу для донату скопійовано.';

  @override
  String get donateQrCode => 'Відскануйте QR-код, щоб надіслати XMR';

  @override
  String get languageUkrainian => 'Українська';

  @override
  String get languageEnglish => 'English';

  @override
  String get notificationSettings => 'Сповіщення';

  @override
  String get hashrateNotification => 'Сповіщення про Hashrate';

  @override
  String get hashrateNotificationDescription =>
      'Повідомляти, коли Hashrate перетинає заданий поріг.';

  @override
  String get hashrateThreshold => 'Поріг Hashrate';

  @override
  String get workersChangeNotification => 'Зміна кількості майнерів';

  @override
  String get workersChangeNotificationDescription =>
      'Повідомляти, коли змінюється кількість майнерів онлайн.';

  @override
  String get notificationEventLog => 'Журнал подій';

  @override
  String get notificationEventLogEmpty => 'Журнал подій порожній';

  @override
  String get notificationEventLogClear => 'Очистити журнал';

  @override
  String get notificationEventLogClearTitle => 'Очистити журнал подій?';

  @override
  String get notificationEventLogClearDescription =>
      'Усі збережені події буде видалено.';

  @override
  String get clear => 'Очистити';

  @override
  String get editWallet => 'Редагувати гаманець';

  @override
  String get save => 'Зберегти';

  @override
  String get theme => 'Тема оформлення';

  @override
  String get themeSystem => 'Як у системі';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Matrix Mining Dark';

  @override
  String get widgets => 'Віджети';

  @override
  String get widgetRefreshSettings => 'Оновлення віджета';

  @override
  String get widgetRefreshDescription =>
      'Налаштувати інтервал автоматичного оновлення віджета, та сповіщень';

  @override
  String get widgetRefreshIntervalTitle => 'Інтервал оновлення віджета';

  @override
  String get widgetRefreshIntervalDescription =>
      'Встановіть інтервал автоматичного оновлення віджета.';

  @override
  String get widgetRefreshInterval => 'Інтервал оновлення';

  @override
  String get widgetRefreshLimits => 'Мінімум: 00:01\nМаксимум: 24:00';

  @override
  String get widgetRefreshSave => 'Зберегти';

  @override
  String get widgetRefreshInvalidInterval =>
      'Значення має бути від 00:01 до 24:00.';

  @override
  String get widgetRefreshTimePickerHint => 'Оберіть години та хвилини';

  @override
  String get widgetRefreshSaved => 'Інтервал оновлення збережено';

  @override
  String get notificationHashrateBelowTitle => 'Зниження хешрейту';

  @override
  String notificationHashrateBelowMessage(
    Object walletPrefix,
    Object hashRate,
    Object threshold,
  ) {
    return '$walletPrefixХешрейт $hashRate нижче порогу $threshold.';
  }

  @override
  String get notificationHashrateRestoredTitle => 'Хешрейт відновлено';

  @override
  String notificationHashrateRestoredMessage(
    Object walletPrefix,
    Object hashRate,
  ) {
    return '$walletPrefixХешрейт $hashRate відновився до нормального рівня.';
  }

  @override
  String get notificationWorkersChangedTitle => 'Зміна кількості воркерів';

  @override
  String notificationWorkersChangedMessage(
    Object walletPrefix,
    int previousWorkers,
    int workersOnline,
  ) {
    return '$walletPrefixОнлайн-воркери: $previousWorkers → $workersOnline.';
  }

  @override
  String walletsLoadError(Object error) {
    return 'Не вдалося завантажити гаманці: $error';
  }

  @override
  String walletNotificationsEnabled(Object walletName) {
    return 'Сповіщення для «$walletName» увімкнено';
  }

  @override
  String walletNotificationsDisabled(Object walletName) {
    return 'Сповіщення для «$walletName» вимкнено';
  }

  @override
  String walletSettingsSaveError(Object error) {
    return 'Не вдалося зберегти налаштування: $error';
  }

  @override
  String walletSettingsDeleteError(Object error) {
    return 'Не вдалося видалити налаштування гаманця: $error';
  }

  @override
  String notificationSettingsLoadError(Object error) {
    return 'Не вдалося завантажити налаштування сповіщень: $error';
  }

  @override
  String get invalidHashrateThreshold =>
      'Введіть коректне числове значення порогу';

  @override
  String get walletNotificationsTitle => 'Сповіщення для цього гаманця';

  @override
  String get walletMonitoringEnabled =>
      'Моніторинг для цього гаманця увімкнено';

  @override
  String get walletMonitoringEnableHint =>
      'Увімкніть, щоб налаштувати сповіщення цього гаманця';

  @override
  String get notificationSettingsTitle => 'Налаштування сповіщень';

  @override
  String get hashrateDropTitle => 'Падіння хешрейту';

  @override
  String get hashrateDropDescription =>
      'Сповіщати, коли хешрейт опуститься нижче порогу';

  @override
  String get hashrateThresholdLabel => 'Пороговий хешрейт';

  @override
  String get hashrateThresholdHint => 'Наприклад: 15';

  @override
  String get hashrateUnitLabel => 'Одиниця';

  @override
  String get saveHashrateThreshold => 'Зберегти поріг';

  @override
  String get hashrateRestoredTitle => 'Відновлення хешрейту';

  @override
  String get hashrateRestoredDescription =>
      'Сповіщати, коли хешрейт знову стане вищим за поріг';

  @override
  String get workersChangeTitle => 'Зміна кількості воркерів';

  @override
  String get workersChangeDescription =>
      'Сповіщати про збільшення або зменшення кількості воркерів';

  @override
  String walletNotificationEventsTitle(Object walletName) {
    return 'Сповіщення: $walletName';
  }

  @override
  String get noWalletNotificationEvents =>
      'Для цього гаманця поки немає подій.';

  @override
  String get dashboardSubtitle => 'Моніторинг XMR-гаманця';

  @override
  String get hashrate2 => 'Хешрейт²';

  @override
  String get miningPool => 'Майнінг-пул';

  @override
  String get aboutApp => 'Про програму';

  @override
  String get aboutDescription =>
      'Моніторинг майнінгу Monero через пул MoneroOcean. Переглядайте хешрейт, активність воркерів, статистику, історію майнінгу та виплати. Налаштовуйте сповіщення й віджети для зручного контролю роботи майнерів. VMimerInfoV використовує публічні дані гаманців і не керує роботою майнінгового обладнання.';

  @override
  String get developerContact => 'Контакт розробника';

  @override
  String get feedback => 'Зворотний зв\'язок';

  @override
  String get feedbackDescription =>
      'Повідомити про помилку або запропонувати покращення';

  @override
  String get sendFeedback => 'Написати розробнику';

  @override
  String get feedbackEmailSubject => 'VMimerInfoV — зворотний зв\'язок';

  @override
  String get feedbackEmailBody =>
      'Вітаю! Хочу повідомити про проблему або запропонувати покращення програми VMimerInfoV.';

  @override
  String get feedbackOpenError => 'Не вдалося відкрити поштовий клієнт';

  @override
  String get appVersion => 'Версія';
}
