
//(VIV [Settings Page — 2026-11-08])

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import 'widget_refresh_settings_page.dart';

//(VIV [Settings Page Class — 2026-11-08])

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    required this.locale,
    required this.onLocaleChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final Locale locale;
  final Future<void> Function(Locale locale) onLocaleChanged;

  //(VIV [Theme Mode Parameters — 2026-11-08])
  final ThemeMode themeMode;
  final Future<void> Function(ThemeMode themeMode) onThemeModeChanged;
  //) VIV [Theme Mode Parameters — 2026-11-08]

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

//) VIV [Settings Page Class — 2026-11-08]

//(VIV [Settings Page State — 2026-11-08])

class _SettingsPageState extends State<SettingsPage> {
  //(VIV [Donation Address — 2026-11-14])

  static const String _donationAddress =
      '83uMituHLV51ziN4AUxSvcPkLbj3Mk4KbSEWzPrfXTNiSprKx3tuVp7ix4wTLJXEd8iU1wJ7zuZFraKnDEW4wBwG6Vg5RQj';

  //) VIV [Donation Address — 2026-11-14]

  //(VIV [Feedback Email — 2026-11-15])

  static const String _feedbackEmail = 'vmimerinfov@gmail.com';

  //) VIV [Feedback Email — 2026-11-15]

  //(VIV [Package Info Initialization — 2026-11-15])

  late final Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  //) VIV [Package Info Initialization — 2026-11-15]

  //(VIV [Open Widget Refresh Settings — 2026-11-08])

  void _openWidgetRefreshSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const WidgetRefreshSettingsPage(),
      ),
    );
  }

  //) VIV [Open Widget Refresh Settings — 2026-11-08]

  //(VIV [Copy Donation Address — 2026-11-14])

  Future<void> _copyDonationAddress() async {
    await Clipboard.setData(
      const ClipboardData(text: _donationAddress),
    );

    if (!mounted) return;

    final localizations = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.donateAddressCopied),
      ),
    );
  }

  //) VIV [Copy Donation Address — 2026-11-14]

  //(VIV [Send Feedback — 2026-11-15])

  Future<void> _sendFeedback() async {
    final localizations = AppLocalizations.of(context)!;

    final emailUri = Uri(
      scheme: 'mailto',
      path: _feedbackEmail,
      queryParameters: {
        'subject': localizations.feedbackEmailSubject,
        'body': localizations.feedbackEmailBody,
      },
    );

    try {
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.feedbackOpenError),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.feedbackOpenError),
        ),
      );
    }
  }

  //) VIV [Send Feedback — 2026-11-15]

  //(VIV [Build Settings Page — 2026-11-08])

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        //(VIV [Language Settings Section — 2026-11-08])
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(localizations.language),
          subtitle: Text(
            widget.locale.languageCode == 'en'
                ? localizations.languageEnglish
                : localizations.languageUkrainian,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: [
            ButtonSegment<String>(
              value: 'uk',
              label: Text(localizations.languageUkrainian),
            ),
            ButtonSegment<String>(
              value: 'en',
              label: Text(localizations.languageEnglish),
            ),
          ],
          selected: {widget.locale.languageCode},
          onSelectionChanged: (selection) {
            widget.onLocaleChanged(Locale(selection.first));
          },
        ),
        //) VIV [Language Settings Section — 2026-11-08]

        const SizedBox(height: 32),

        //(VIV [Theme Settings Section — 2026-11-08])
        Text(
          localizations.theme,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          segments: [
            ButtonSegment<ThemeMode>(
              value: ThemeMode.system,
              label: Text(localizations.themeSystem),
              icon: const Icon(Icons.settings_suggest_outlined),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.light,
              label: Text(localizations.themeLight),
              icon: const Icon(Icons.light_mode_outlined),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.dark,
              label: Text(localizations.themeDark),
              icon: const Icon(Icons.dark_mode_outlined),
            ),
          ],
          selected: {widget.themeMode},
          onSelectionChanged: (selection) {
            widget.onThemeModeChanged(selection.first);
          },
        ),
        //) VIV [Theme Settings Section — 2026-11-08]

        const SizedBox(height: 32),

        //(VIV [Widget Settings Section — 2026-11-08])
        Text(
          localizations.widgets,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.widgets_outlined),
            title: Text(localizations.widgetRefreshSettings),
            subtitle: Text(localizations.widgetRefreshDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: _openWidgetRefreshSettings,
          ),
        ),
        //) VIV [Widget Settings Section — 2026-11-08]

        const SizedBox(height: 32),

        //(VIV [Donation Settings Section — 2026-11-14])
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  localizations.donateTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.donateDescription,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SelectableText(
                  _donationAddress,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _copyDonationAddress,
                    icon: const Icon(Icons.copy),
                    label: Text(localizations.donateCopyAddress),
                  ),
                ),
              ],
            ),
          ),
        ),
        //) VIV [Donation Settings Section — 2026-11-14]

        const SizedBox(height: 32),

        //(VIV [About App Section — 2026-11-15])
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.aboutApp,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(localizations.aboutDescription),
                const SizedBox(height: 16),
                FutureBuilder<PackageInfo>(
                  future: _packageInfoFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }

                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final packageInfo = snapshot.data!;

                    return Text(
                      '${localizations.appVersion}: '
                          '${packageInfo.version} '
                          '(${packageInfo.buildNumber})',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        //) VIV [About App Section — 2026-11-15]

        const SizedBox(height: 16),

        //(VIV [Feedback Section — 2026-11-15])
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.developerContact,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.feedback_outlined),
                  title: Text(localizations.feedback),
                  subtitle: Text(localizations.feedbackDescription),
                ),
                SelectableText(_feedbackEmail),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _sendFeedback,
                    icon: const Icon(Icons.email_outlined),
                    label: Text(localizations.sendFeedback),
                  ),
                ),
              ],
            ),
          ),
        ),
        //) VIV [Feedback Section — 2026-11-15]
      ],
    );
  }

//) VIV [Build Settings Page — 2026-11-08]
}

//) VIV [Settings Page State — 2026-11-08]

//) VIV [Settings Page — 2026-11-08]
