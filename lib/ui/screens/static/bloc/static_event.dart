part of 'static_bloc.dart';

sealed class StaticEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class LoadStaticEvent extends StaticEvent {}

final class RefreshStaticEvent extends StaticEvent {}

/// Tạo dữ liệu mẫu cho tháng hiện tại (chỉ dùng để test)
final class SeedSampleDataEvent extends StaticEvent {}
