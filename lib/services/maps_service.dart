import 'package:flutter_google_maps_webservices/places.dart';
import 'package:fyllo/api_keys.dart';

class MapsService {
  final placesSdk = GoogleMapsPlaces(apiKey: mapsApiKey);

  Future<List<PlacesSearchResult>> searchNearbyWithRadius({
    required double lat,
    required double lng,
    required double radius,
  }) async {
    final predictionResp = await placesSdk.searchNearbyWithRadius(
        Location(lat: lat, lng: lng), radius);
    return predictionResp.results;
  }
}
