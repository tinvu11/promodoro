import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promodoro/l10n/generated/app_localizations.dart';
import 'package:promodoro/configs/di.dart';
import 'package:promodoro/services/theme_storage_service.dart';
import 'package:promodoro/ui/commons/widgets/common_appbar.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';

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
        ],
      ),
    );
  }
}
