import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:promodoro/data/models/theme_model.dart';

abstract interface class RemoteData {
  Future<List<ThemeModel>> getResources();
}

class RemoteDataImpl implements RemoteData {
  final FirebaseFirestore _firestore;

  const RemoteDataImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<List<ThemeModel>> getResources() async {
    try {
      final querySnapshot = await _firestore.collection('resources').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ThemeModel.formFirebase(data, doc.id);
      }).toList();
    } catch (e, stackTrace) {
      log(
        'Error fetching resources from Firestore',
        error: e,
        stackTrace: stackTrace,
        name: 'RemoteData',
      );
      rethrow;
    }
  }
}
