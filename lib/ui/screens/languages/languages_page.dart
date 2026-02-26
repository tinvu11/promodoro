import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promodoro/configs/di.dart';
import 'package:promodoro/services/theme_storage_service.dart';
import 'package:promodoro/ui/commons/widgets/common_appbar.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_bloc.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';

import '../../commons/widgets/theme_background.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  late final NoisesBloc _noisesBloc;

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
      appBar: CommonAppBar(title: "Thông tin"),
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
            child: SizedBox(
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _itemLanguage("Tiếng Việt"),
                      _itemLanguage("Tiếng Anh"),
                      _itemLanguage("Tiếng Hàn"),
                      _itemLanguage("Tiếng Nhật"),
                      _itemLanguage("Tiếng Trung"),
                      _itemLanguage("Tiếng Thái"),
                      _itemLanguage("Tiếng Đức"),
                      _itemLanguage("Tiếng Tây Ban nha"),
                      _itemLanguage("Tiếng Việt"),
                      _itemLanguage("Tiếng Anh"),
                      _itemLanguage("Tiếng Hàn"),
                      _itemLanguage("Tiếng Nhật"),
                      _itemLanguage("Tiếng Trung"),
                      _itemLanguage("Tiếng Thái"),
                      _itemLanguage("Tiếng Đức"),
                      _itemLanguage("Tiếng Tây Ban nha"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _itemLanguage(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title, style: TextStyle(fontSize: 18))],
    ),
  );
}
