import 'package:equatable/equatable.dart';

import '../../../../data/models/theme_model.dart';

enum NoiseStatus { initial, loading, success, error }

class NoisesState extends Equatable {
  final NoiseStatus status;
  final List<ThemeModel> themes;
  final String? errorMessage;

  const NoisesState({
    this.status = NoiseStatus.initial,
    this.themes = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, themes, errorMessage];

  NoisesState copyWith({
    NoiseStatus? status,
    List<ThemeModel>? themes,
    String? errorMessage,
  }) {
    return NoisesState(
      status: status ?? this.status,
      themes: themes ?? this.themes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
