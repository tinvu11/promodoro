import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pomodoro/configs/di.dart';
import 'package:pomodoro/core/Theme/app_fonts.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:pomodoro/services/theme_storage_service.dart';
import 'package:pomodoro/ui/commons/widgets/common_appbar.dart';
import 'package:pomodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/theme_background.dart';

class InfosPage extends StatefulWidget {
  const InfosPage({super.key});

  @override
  State<InfosPage> createState() => _InfosPageState();
}

class _InfosPageState extends State<InfosPage> {
  /// Resolved synchronously to avoid first-frame background flicker.
  String? _initialBgPath;

  @override
  void initState() {
    super.initState();

    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is SuccessSettingState) {
      final themeId = settingsState.settingsModel.selectedThemeId;
      if (themeId.isNotEmpty) {
        final service = DI.sl<ThemeStorageService>();
        _initialBgPath = service.bgPathOfSync(themeId);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(title: AppLocalizations.of(context)!.information),
      body: Stack(
        children: [
          RepaintBoundary(
            key: ValueKey(_initialBgPath ?? 'default'),
            child: ThemeBackground(
              localImagePath: _initialBgPath,
              sigmaX: 15,
              sigmaY: 15,
              darkAlpha: 0.55,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  _itemLanguage(
                    l10n.email,
                    iconStart: Icons.email_outlined,
                    icon: Icons.navigate_next,
                    onTap: _sendEmail,
                  ),
                  _itemLanguage(
                    l10n.share,
                    iconStart: Icons.share,
                    icon: Icons.navigate_next,
                    onTap: () {},
                  ),
                  _itemLanguage(
                    l10n.policy,
                    iconStart: Icons.note_add,
                    icon: Icons.navigate_next,
                    onTap: _openPrivacyPolicy,
                  ),
                  _itemLanguage(
                    l10n.terms,
                    iconStart: Icons.note_add,
                    icon: Icons.navigate_next,
                    onTap: _openTermsOfUse,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 0,
                    horizontalTitleGap: 12,
                    leading: Icon(
                      Icons.numbers,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                    title: Text(l10n.version, style: AppFonts.mediumWhite18),
                    trailing: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final version = snapshot.data?.version ?? "1.0.0";
                        return Text(version, style: AppFonts.regularGrey16);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _itemLanguage(
  String title, {
  required IconData iconStart,
  VoidCallback? onTap,
  IconData? icon,
}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        horizontalTitleGap: 12,
        leading: Icon(iconStart, color: AppColors.textSecondary, size: 22),
        title: Text(title, style: AppFonts.mediumWhite18),
        trailing: icon != null
            ? Icon(icon, color: AppColors.textSecondary, size: 28)
            : SizedBox.shrink(),
      ),
    ),
  );
}

Future<void> _sendEmail() async {
  final contactEmail = const String.fromEnvironment("CONTACT_EMAIL");
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: contactEmail,
    queryParameters: {'subject': 'FeedBack'},
  );
  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {
    debugPrint("Không thể mở ứng dụng Email");
  }
}

void _openTermsOfUse() async {
  final termsOfUseUrl = const String.fromEnvironment("TERMS_OF_USE_URL");
  await launchUrl(Uri.parse(termsOfUseUrl));
}

void _openPrivacyPolicy() async {
  final privacyPolicyUrl = const String.fromEnvironment("PRIVACY_POLICY_URL");
  await launchUrl(Uri.parse(privacyPolicyUrl));
}
