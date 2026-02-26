// Đảm bảo đúng path tới file Failure của bạn
part of 'iap_bloc.dart';

class IapState extends Equatable {
  final Failure? failure;
  final bool isLoading;
  final List<ProductDetails> products;
  final List<PurchaseDetails> purchases;
  final int? boughtNoAdsTime;

  const IapState({
    this.failure,
    this.isLoading = false,
    this.products = const [],
    this.purchases = const [],
    this.boughtNoAdsTime,
  });

  // Hàm copyWith thay thế cho logic của Freezed
  IapState copyWith({
    Failure? failure,
    bool? isLoading,
    List<ProductDetails>? products,
    List<PurchaseDetails>? purchases,
    int? boughtNoAdsTime,
  }) {
    return IapState(
      // Dùng logic "allow null" cho failure và boughtNoAdsTime
      failure: failure ?? this.failure,
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      purchases: purchases ?? this.purchases,
      boughtNoAdsTime: boughtNoAdsTime ?? this.boughtNoAdsTime,
    );
  }

  @override
  List<Object?> get props => [
    failure,
    isLoading,
    products,
    purchases,
    boughtNoAdsTime,
  ];
}
