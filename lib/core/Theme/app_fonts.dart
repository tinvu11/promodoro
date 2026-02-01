import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppFonts {
  static final regular = TextStyle(
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static final medium = TextStyle(
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static final semibold = TextStyle(
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final regular_white_14 = regular.copyWith(fontSize: 14);
  static final regular_white_16 = regular.copyWith(fontSize: 16);
  static final regular_white_18 = regular.copyWith(fontSize: 18);
  static final regular_white_20 = regular.copyWith(fontSize: 20);

  static final regular_grey = regular.copyWith(color: AppColors.textSecondary);
  static final regular_grey_14 = regular_grey.copyWith(fontSize: 14);
  static final regular_grey_16 = regular_grey.copyWith(fontSize: 16);
  static final regular_grey_18 = regular_grey.copyWith(fontSize: 18);
  static final regular_grey_20 = regular_grey.copyWith(fontSize: 20);
  static final regular_grey_22 = regular_grey.copyWith(fontSize: 22);

  static final medium_white_14 = medium.copyWith(fontSize: 14);
  static final medium_white_16 = medium.copyWith(fontSize: 16);
  static final medium_white_18 = medium.copyWith(fontSize: 18);
  static final medium_white_20 = medium.copyWith(fontSize: 20);
  static final medium_white_22 = medium.copyWith(fontSize: 22);
  static final medium_white_26 = medium.copyWith(fontSize: 26);
  static final medium_white_28 = medium.copyWith(fontSize: 28);

  static final medium_grey = medium.copyWith(color: AppColors.textSecondary);
  static final medium_grey_14 = medium_grey.copyWith(fontSize: 14);
  static final medium_greye_16 = medium_grey.copyWith(fontSize: 16);
  static final medium_grey_18 = medium_grey.copyWith(fontSize: 18);
  static final medium_grey_20 = medium_grey.copyWith(fontSize: 20);
  static final medium_grey_22 = medium_grey.copyWith(fontSize: 22);

  static final semibold_white_14 = semibold.copyWith(fontSize: 14);
  static final msemibold_white_16 = semibold.copyWith(fontSize: 16);
  static final semibold_white_18 = semibold.copyWith(fontSize: 18);
  static final semibold_white_20 = semibold.copyWith(fontSize: 20);
  static final semibold_white_40 = semibold.copyWith(fontSize: 40);
}
