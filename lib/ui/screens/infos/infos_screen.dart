import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:promodoro/configs/di.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import 'package:promodoro/l10n/generated/app_localizations.dart';
import 'package:promodoro/services/theme_storage_service.dart';
import 'package:promodoro/ui/commons/widgets/common_appbar.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/theme_background.dart';

class InfosPage extends StatefulWidget {
  const InfosPage({super.key});

  @override
  State<InfosPage> createState() => _InfosPageState();
}

class _InfosPageState extends State<InfosPage> {
  /// Đường dẫn bg tính sync để tránh nháy frame đầu tiên.
  String? _initialBgPath;

  @override
  void initState() {
    super.initState();

    // Khởi tạo preview cho theme đang active
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
    // Dừng preview audio khi rời trang — dùng reference đã lưu
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 0,
                    horizontalTitleGap: 12,
                    leading: Icon(
                      Icons.numbers,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                    title: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final version = snapshot.data?.version ?? "1.0.0";
                        return Text(
                          "Version  $version",
                          style: AppFonts.medium_white_18,
                        );
                      },
                    ),
                  ),
                  _itemLanguage(
                    "Email",
                    iconStart: Icons.email_outlined,
                    icon: Icons.navigate_next,
                    onTap: _sendEmail,
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
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0,
      horizontalTitleGap: 12,
      leading: Icon(iconStart, color: AppColors.textSecondary, size: 22),
      title: Text(title, style: AppFonts.medium_white_18),
      trailing: icon != null
          ? Icon(icon, color: AppColors.textSecondary, size: 28)
          : SizedBox.shrink(),
    ),
  );
}

Future<void> _sendEmail() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'vutin686@gmail.com', // Thay bằng email của bạn
    queryParameters: {'subject': 'FeedBack'},
  );
  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {
    print("Không thể mở ứng dụng Email");
  }
}
