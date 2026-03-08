import 'dart:ui';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promodoro/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../configs/di.dart';
import '../../../core/Theme/app_colors.dart';
import '../../../core/Theme/app_fonts.dart';
import '../../bloc/iap/iap_bloc.dart';

class PaywallDialog extends StatefulWidget {
  @override
  State<PaywallDialog> createState() => _PaywallDialogState();

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Premium',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curve,
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
      pageBuilder: (context, anim1, anim2) {
        // Trả về chính StatelessWidget này
        return PaywallDialog();
      },
    );
  }
}

class _PaywallDialogState extends State<PaywallDialog> {
  static const primaryId = String.fromEnvironment("PRIMARY_PRODUCT_ID");
  static const secondaryId = String.fromEnvironment("SECONDARY_PRODUCT_ID");
  final _amplitude = DI.sl<Amplitude>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IapBloc, IapState>(
      builder: (context, state) {
        final primaryPrice =
            state.products
                .firstWhereOrNull((element) => element.id == primaryId)
                ?.price ??
            '\$4.99';
        final secondaryPrice =
            state.products
                .firstWhereOrNull((element) => element.id == secondaryId)
                ?.price ??
            '\$1.99';
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 12,
                  bottom: 28,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.glassBorder, width: 1),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withAlpha(30),
                      Colors.white.withAlpha(15),
                    ],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.premiumFeatures,
                        style: AppFonts.semibold_white_20.copyWith(
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppLocalizations.of(context)!.unlockAllFeatures,
                        style: AppFonts.regular_grey_14,
                      ),
                      const SizedBox(height: 20),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFeatureRow(
                            Icons.shield,
                            AppLocalizations.of(context)!.noAds,
                          ),
                          SizedBox(height: 12),
                          _buildFeatureRow(
                            Icons.support,

                            AppLocalizations.of(context)!.prioritySupport,
                          ),
                          SizedBox(height: 12),

                          _buildFeatureRow(
                            Icons.flash_on,

                            AppLocalizations.of(context)!.optimizePerformance,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Plan cards ──
                      _buildPlanCard(
                        // icon: Icons.all_inclusive,
                        title: AppLocalizations.of(context)!.lifetime,
                        subtitle: AppLocalizations.of(context)!.buyOnce,
                        price: primaryPrice,
                        highlight: true,
                        onTap: () {
                          _amplitude.track(
                            BaseEvent('paywall_dialog_purchase_product'),
                          );
                          context.read<IapBloc>().add(
                            PurchaseProduct(primaryId),
                          );
                          context.pop();
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildPlanCard(
                        // icon: Icons.calendar_today,
                        title: AppLocalizations.of(context)!.yearly,
                        subtitle: AppLocalizations.of(context)!.save40,
                        price: secondaryPrice,
                        onTap: () {
                          _amplitude.track(
                            BaseEvent('paywall_dialog_purchase_product'),
                          );
                          context.read<IapBloc>().add(
                            PurchaseProduct(secondaryId),
                          );
                          context.pop();
                        },
                      ),
                      const SizedBox(height: 30),

                      // ── Restore button ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: _openTermsOfUse,
                            child: Text(
                              AppLocalizations.of(context)!.terms,
                              style: AppFonts.medium_grey_14.copyWith(
                                decorationColor: AppColors.textSecondary,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () => _onRestorePurchase(context),
                            child: Text(
                              AppLocalizations.of(context)!.restore,
                              style: AppFonts.medium_grey_14.copyWith(
                                decorationColor: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _openPrivacyPolicy,
                            child: Text(
                              AppLocalizations.of(context)!.policy,
                              style: AppFonts.medium_grey_14.copyWith(
                                decorationColor: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ── Close button ──
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _amplitude.track(BaseEvent('paywall_dialog_close'));
    super.dispose();
  }

  void _openTermsOfUse() async {
    final termsOfUseUrl = const String.fromEnvironment("TERMS_OF_USE_URL");
    await launchUrl(Uri.parse(termsOfUseUrl));
  }

  void _openPrivacyPolicy() async {
    final privacyPolicyUrl = const String.fromEnvironment("PRIVACY_POLICY_URL");
    await launchUrl(Uri.parse(privacyPolicyUrl));
  }

  void _onRestorePurchase(BuildContext context) {
    context.read<IapBloc>().add(RestorePurchases());
    _amplitude.track(BaseEvent('paywall_dialog_restore_purchase'));
    context.pop();
  }
}

Widget _buildPlanCard({
  // required IconData icon,
  required String title,
  required String subtitle,
  required String price,
  bool highlight = false,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight
              ? AppColors.textSecondary.withAlpha(120)
              : Colors.white.withAlpha(30),
          width: highlight ? 1.5 : 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: highlight
              ? [
                  AppColors.textPrimary.withAlpha(40),
                  AppColors.textPrimary.withAlpha(15),
                ]
              : [Colors.white.withAlpha(15), Colors.white.withAlpha(8)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppFonts.medium_white_16),
                    if (highlight) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.textPrimary.withAlpha(80),
                        ),
                        child: Text(
                          'HOT',
                          style: AppFonts.regular.copyWith(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppFonts.regular_grey_14),
              ],
            ),
          ),
          Text(
            price,
            style: AppFonts.medium_white_14.copyWith(
              color: highlight
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildFeatureRow(IconData icon, String text) {
  return Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withAlpha(15),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(text, style: AppFonts.regular_white_16, softWrap: true),
      ),
    ],
  );
}
