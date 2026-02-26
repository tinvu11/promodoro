import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promodoro/ui/commons/widgets/banner_ad_widget.dart';
import 'package:promodoro/ui/commons/widgets/common_appbar.dart';
import 'package:promodoro/ui/screens/settings/widgets/config_section.dart';
import 'package:promodoro/ui/screens/settings/widgets/sound_section.dart';
import 'package:promodoro/ui/screens/settings/widgets/system_section.dart';

import '../../bloc/iap/iap_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPremium = context
        .watch<IapBloc>()
        .state
        .boughtNoAdsTime != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CommonAppBar(title: "Settings", showLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              BannerAdWidget(isPremium: isPremium, paddingHorizontal: 16),
              SizedBox(height: 8),
              ConfigSection(),
              SoundSection(),
              SystemSection(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
