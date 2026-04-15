import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:pomodoro/ui/commons/widgets/banner_ad_widget.dart';
import 'package:pomodoro/ui/commons/widgets/common_appbar.dart';
import 'package:pomodoro/ui/screens/settings/widgets/config_section.dart';
import 'package:pomodoro/ui/screens/settings/widgets/sound_section.dart';
import 'package:pomodoro/ui/screens/settings/widgets/system_section.dart';

import '../../bloc/iap/iap_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<IapBloc>().state.boughtNoAdsTime != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        title: AppLocalizations.of(context)!.settings,
        showLeading: false,
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                BannerAdWidget(isPremium: isPremium, paddingHorizontal: 16),
                const SizedBox(height: 8),
                const ConfigSection(),
                const SoundSection(),
                const SystemSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
