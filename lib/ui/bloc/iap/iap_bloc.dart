import 'dart:async';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../core/failure.dart';
import '../../../data/repositories/iap_repository.dart';
import '../../../utils/GlobalValues.dart';

part 'iap_event.dart';
part 'iap_state.dart';

class IapBloc extends Bloc<IapEvent, IapState> {
  final IapRepository _iapRepository;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final Amplitude _amplitude;

  IapBloc({required IapRepository iapRepository, required Amplitude amplitude})
    : _iapRepository = iapRepository,
      _amplitude = amplitude,
      super(const IapState()) {
    on<ListenForPurchases>(_onListenForPurchases);
    on<RestorePurchases>(_onRestorePurchases);
    on<PurchaseProduct>(_onPurchaseProduct);
    on<EmitState>(_onEmitState);
  }

  _onListenForPurchases(
    ListenForPurchases event,
    Emitter<IapState> emit,
  ) async {
    debugPrint('IapBloc -> _onListenForPurchases');
    int? boughtNoAdsTime = GlobalValues.boughtNoAdsTime;
    if (boughtNoAdsTime != null && boughtNoAdsTime != -1) {
      debugPrint(
        'IapBloc -> _onListenForPurchases -> boughtNoAdsTime: ${DateTime.fromMillisecondsSinceEpoch(boughtNoAdsTime)}',
      );
    } else if (boughtNoAdsTime == -1) {
      debugPrint(
        'IapBloc -> _onListenForPurchases -> boughtNoAdsTime: premium',
      );
    } else {
      debugPrint('IapBloc -> _onListenForPurchases -> boughtNoAdsTime: null');
    }
    if (boughtNoAdsTime != null &&
        boughtNoAdsTime != -1 &&
        DateTime.now().isAfter(
          DateTime.fromMillisecondsSinceEpoch(boughtNoAdsTime),
        )) {
      emit(state.copyWith(boughtNoAdsTime: null));
      GlobalValues.setBoughtNoAdsTime(null);
    } else {
      emit(state.copyWith(boughtNoAdsTime: boughtNoAdsTime));
    }
    final productsResult = await _iapRepository.getProducts();
    productsResult.fold(
      (failure) {
        debugPrint(
          'IapBloc -> _onListenForPurchases -> getProducts -> failure: $failure',
        );
      },
      (products) {
        debugPrint(
          'IapBloc -> _onListenForPurchases -> getProducts -> success -> products: ${products.length}',
        );
        emit(state.copyWith(products: products));
      },
    );
    _subscription = _iapRepository.subscription.listen((purchases) {
      if (isClosed) {
        _subscription?.cancel();
        return;
      }
      for (final purchase in purchases) {
        debugPrint(
          'IapBloc -> _onListenForPurchases -> purchase: ${purchase.productID} -> ${purchase.status}',
        );
        if (purchase.status == PurchaseStatus.pending) {
          add(EmitState(state.copyWith(isLoading: true)));
        } else {
          if (purchase.status == PurchaseStatus.error) {
            _amplitude.track(BaseEvent('purchase_error'));
            FirebaseAnalytics.instance.logEvent(
              name: 'purchase_error',
              parameters: {'error': purchase.error?.message ?? ''},
            );
            add(
              EmitState(
                state.copyWith(
                  failure: Failure(message: purchase.error?.message),
                  isLoading: false,
                ),
              ),
            );
            add(EmitState(state.copyWith(failure: null, isLoading: false)));
          } else {
            if (purchase.status == PurchaseStatus.purchased) {
              _amplitude.track(BaseEvent('purchase_success'));
              _processPurchase(purchase.productID);
              final isPrimary =
                  purchase.productID ==
                  const String.fromEnvironment('PRIMARY_PRODUCT_ID');
              if (!isPrimary) {
                _iapRepository.consumePurchase(purchase);
              }
            } else if (purchase.status == PurchaseStatus.restored) {
              _amplitude.track(BaseEvent('purchase_restored'));
              final currentPurchased = [...state.purchases];
              if (!currentPurchased.contains(purchase)) {
                currentPurchased.add(purchase);
              }
              add((EmitState(state.copyWith(purchases: currentPurchased))));
            } else if (purchase.status == PurchaseStatus.canceled) {
              _amplitude.track(BaseEvent('purchase_canceled'));
              add(
                EmitState(
                  state.copyWith(
                    failure: Failure(message: "Purchase canceled"),
                    isLoading: false,
                  ),
                ),
              );
              add(EmitState(state.copyWith(failure: null, isLoading: false)));
            }
          }
          if (purchase.pendingCompletePurchase) {
            _iapRepository.completePurchase(purchase);
          }
        }
      }
    });
    _iapRepository.restorePurchases();
  }

  _onRestorePurchases(RestorePurchases event, Emitter<IapState> emit) async {
    debugPrint('IapBloc -> _onRestorePurchases');
    final purchased = state.purchases;
    if (purchased.isEmpty) {
      emit(state.copyWith(failure: Failure(message: "No purchases found")));
      emit(state.copyWith(failure: null));
      return;
    }
    for (final purchase in purchased) {
      await _processPurchase(purchase.productID);
    }
  }

  _onPurchaseProduct(PurchaseProduct event, Emitter<IapState> emit) async {
    debugPrint('IapBloc -> _onPurchaseProduct -> purchasing: ${event.id}');
    emit(state.copyWith(isLoading: true));
    // if (appFlavor != 'production' || event.isFree) {
    //   await Future.delayed(const Duration(seconds: 3));
    //   _processPurchase(event.id);
    //   return;
    // }
    final product = state.products.firstWhereOrNull(
      (element) => element.id == event.id,
    );
    if (product == null) {
      emit(
        state.copyWith(
          isLoading: false,
          failure: Failure(
            message:
                "This product is not available now, please try again later",
          ),
        ),
      );
      emit(state.copyWith(isLoading: false, failure: null));
      return;
    }
    final result = await _iapRepository.purchaseProduct(product);
    result.fold(
      (failure) {
        debugPrint('IapBloc -> _onPurchaseProduct -> failure: $failure');
        emit(state.copyWith(failure: failure, isLoading: false));
        emit(state.copyWith(failure: null));
      },
      (_) {
        debugPrint('IapBloc -> _onPurchaseProduct -> success');
      },
    );
  }

  _onEmitState(EmitState event, Emitter<IapState> emit) {
    debugPrint('IapBloc -> _onEmitState');
    emit(event.state);
  }

  _processPurchase(String id) {
    const String lifetimeId = String.fromEnvironment('PRIMARY_PRODUCT_ID');
    const String yearlyId = String.fromEnvironment('YEARLY_PRODUCT_ID');

    if (id == lifetimeId) {
      GlobalValues.setBoughtNoAdsTime(-1);
      add(EmitState(state.copyWith(boughtNoAdsTime: -1, isLoading: false)));
    } else if (id == yearlyId) {
      final now = DateTime.now();
      final currentDeadline = state.boughtNoAdsTime;

      DateTime newTime;
      if (currentDeadline == null || currentDeadline == -1) {
        // Nếu chưa có hạn hoặc đang là vĩnh viễn (nhưng lại mua gói năm)
        newTime = now.add(const Duration(days: 365));
      } else {
        // Nếu đang có hạn (ví dụ còn 10 ngày), cộng dồn thêm 365 ngày
        newTime = DateTime.fromMillisecondsSinceEpoch(
          currentDeadline,
        ).add(const Duration(days: 365));
      }

      GlobalValues.setBoughtNoAdsTime(newTime.millisecondsSinceEpoch);
      add(
        EmitState(
          state.copyWith(
            boughtNoAdsTime: newTime.millisecondsSinceEpoch,
            isLoading: false,
          ),
        ),
      );
    }
  }
}
