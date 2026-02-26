part of 'iap_bloc.dart';

abstract class IapEvent extends Equatable {
  const IapEvent();

  @override
  List<Object?> get props => [];
}

class ListenForPurchases extends IapEvent {
  const ListenForPurchases();
}

class RestorePurchases extends IapEvent {
  const RestorePurchases();
}

class PurchaseProduct extends IapEvent {
  final String id;
  final bool isFree;

  const PurchaseProduct(this.id, {this.isFree = false});

  @override
  List<Object?> get props => [id, isFree];
}

class EmitState extends IapEvent {
  final IapState state;

  const EmitState(this.state);

  @override
  List<Object?> get props => [state];
}
