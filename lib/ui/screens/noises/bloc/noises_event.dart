import 'package:equatable/equatable.dart';

sealed class NoisesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class LoadNoises extends NoisesEvent {}

final class RefreshNoises extends NoisesEvent {}

final class SaveNoises extends NoisesEvent {}
