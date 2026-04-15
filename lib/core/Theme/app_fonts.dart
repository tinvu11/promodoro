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

  static final regularWhite14 = regular.copyWith(fontSize: 14);
  static final regularWhite16 = regular.copyWith(fontSize: 16);
  static final regularWhite18 = regular.copyWith(fontSize: 18);
  static final regularWhite20 = regular.copyWith(fontSize: 20);

  static final regularGrey = regular.copyWith(color: AppColors.textSecondary);
  static final regularGrey14 = regularGrey.copyWith(fontSize: 14);
  static final regularGrey16 = regularGrey.copyWith(fontSize: 16);
  static final regularGrey18 = regularGrey.copyWith(fontSize: 18);
  static final regularGrey20 = regularGrey.copyWith(fontSize: 20);
  static final regularGrey22 = regularGrey.copyWith(fontSize: 22);

  static final mediumWhite14 = medium.copyWith(fontSize: 14);
  static final mediumWhite16 = medium.copyWith(fontSize: 16);
  static final mediumWhite18 = medium.copyWith(fontSize: 18);
  static final mediumWhite20 = medium.copyWith(fontSize: 20);
  static final mediumWhite22 = medium.copyWith(fontSize: 22);
  static final mediumWhite26 = medium.copyWith(fontSize: 26);
  static final mediumWhite28 = medium.copyWith(fontSize: 28);

  static final mediumGrey = medium.copyWith(color: AppColors.textSecondary);
  static final mediumGrey14 = mediumGrey.copyWith(fontSize: 14);
  static final mediumGrey16 = mediumGrey.copyWith(fontSize: 16);
  static final mediumGrey18 = mediumGrey.copyWith(fontSize: 18);
  static final mediumGrey20 = mediumGrey.copyWith(fontSize: 20);
  static final mediumGrey22 = mediumGrey.copyWith(fontSize: 22);

  static final semiboldWhite14 = semibold.copyWith(fontSize: 14);
  static final semiboldWhite16 = semibold.copyWith(fontSize: 16);
  static final semiboldWhite18 = semibold.copyWith(fontSize: 18);
  static final semiboldWhite20 = semibold.copyWith(fontSize: 20);
  static final semiboldWhite40 = semibold.copyWith(fontSize: 40);
}
