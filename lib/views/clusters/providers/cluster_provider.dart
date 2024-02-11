import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:fyllo/constants/enums.dart';
import 'package:fyllo/extensions.dart';
import 'package:fyllo/models/rack_model.dart';
import 'package:fyllo/services/maps_service.dart';
import 'package:fyllo/services/racks_service.dart';

class ClusterProvider extends ChangeNotifier {
  bool isLoading = false;
  final _mapsService = MapsService();
  final _racksService = RacksService();

  List<PlacesSearchResult> clusters = [];
  List<RackModel> racks = [];

  Future<void> searchNearby(
      {required ExploreMode mode,
      required double lat,
      required double lng,
      required double radius}) async {
    if (mode == ExploreMode.shops) {
      searchNearbyShops(
        lat: lat,
        lng: lng,
        radius: radius.mileToMeters(),
      );
    } else if (mode == ExploreMode.racks) {
      searchNearbyRacks(
        lat: lat,
        lng: lng,
        radius: radius.mileToMeters(),
      );
    }
  }

  Future<void> searchNearbyShops(
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

  Future<void> searchNearbyRacks(
      {required double lat,
      required double lng,
      required double radius}) async {
    isLoading = true;
    racks.clear();
    notifyListeners();

    final result = await _racksService
        .getRacks(); // TODO: filter based on coords and radius

    if (result?.isNotEmpty == true) {
      racks.addAll(result!);
    }

    isLoading = false;
    notifyListeners();
  }
}
