import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:fyllo/services/maps_service.dart';

class ClusterProvider extends ChangeNotifier {
  bool isLoading = false;
  final _mapsService = MapsService();

  List<PlacesSearchResult> clusters = [];

  Future<void> searchNearby(
      {required double lat,
      required double lng,
      required double radius}) async {
    isLoading = true;
    clusters.clear();
    notifyListeners();

    final predictions = await _mapsService.searchNearbyWithRadius(
      lat: lat,
      lng: lng,
      radius: radius,
    );

    if (predictions.isNotEmpty) {
      clusters.addAll(predictions);
    }

    isLoading = false;
    notifyListeners();
  }
}
