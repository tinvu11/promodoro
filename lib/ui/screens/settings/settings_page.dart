import 'package:flutter/material.dart';
import 'package:promodoro/ui/commons/widgets/banner_ad_widget.dart';
import 'package:promodoro/ui/commons/widgets/common_appbar.dart';
import 'package:promodoro/ui/screens/settings/widgets/config_section.dart';
import 'package:promodoro/ui/screens/settings/widgets/sound_section.dart';
import 'package:promodoro/ui/screens/settings/widgets/system_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CommonAppBar(title: "Settings", showLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: const [
              BannerAdWidget(),
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
