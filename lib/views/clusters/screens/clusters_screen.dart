import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fyllo/extensions.dart';
import 'package:fyllo/views/clusters/providers/cluster_provider.dart';
import 'package:fyllo/views/clusters/widgets/cluster_list_tile.dart';
import 'package:fyllo/widgets/custom_app_bar.dart';
import 'package:fyllo/widgets/custom_loading_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_places_autocomplete_widgets/model/place.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ClustersScreen extends StatefulWidget {
  static String routeName = "/clusters";
  const ClustersScreen({
    super.key,
    required this.area,
    required this.mileRadius,
  });

  final Place area;
  final double mileRadius;

  @override
  State<ClustersScreen> createState() => _ClustersScreenState();
}

class _ClustersScreenState extends State<ClustersScreen> {
  GoogleMapController? _mapController;
  final _itemScrollController = ItemScrollController();
  final _itemPositionsListener = ItemPositionsListener.create();
  bool isFirstBuild = true; // Used to ignore callback during initial build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ClusterProvider>(
        builder: (context, cp, child) => Stack(
          children: [
            //Map
            Padding(
              padding: const EdgeInsets.only(top: 130.0),
              child: GoogleMap(
                mapType: MapType.normal,
                markers: cp.clusters
                    .map((e) => Marker(
                          markerId: MarkerId(e.placeId),
                          position: LatLng(e.geometry!.location.lat,
                              e.geometry!.location.lng),
                          onTap: () => scrollToItem(e.placeId),
                        ))
                    .toSet(),
                circles: {
                  Circle(
                    circleId: const CircleId("mile_radius"),
                    center: LatLng(widget.area.lat!, widget.area.lng!),
                    fillColor: Colors.blue.withOpacity(0.2),
                    strokeColor: Colors.blue.withOpacity(0.4),
                    radius: widget.mileRadius.mileToMeters(),
                  )
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.area.lat!, widget.area.lng!),
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  fitMapToContents();
                  _itemPositionsListener.itemPositions
                      .addListener(itemPositionsLister);
                },
                zoomControlsEnabled: false,
              ),
            ),

            //Title
            CustomAppBar(
              phrase: cp.isLoading
                  ? "Green gears are turning! We'll be with you in a leafy moment.\nLoading..."
                  : cp.clusters.isEmpty
                      ? "Oops! Looks like a leaf got caught in the system. Let's try that again, shall we?"
                      : "Eureka! Fyllo has blossomed with the local scoop.",
            ),

            // Clusters
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                width: double.infinity,
                height: 130.0,
                child: cp.isLoading
                    ? const Center(child: CustomLoadingIndicator())
                    : (ScrollablePositionedList.builder(
                        itemScrollController: _itemScrollController,
                        itemPositionsListener: _itemPositionsListener,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        itemCount: cp.clusters.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              scrollToItem(cp.clusters[index].placeId);
                              itemPositionsLister(
                                latitude:
                                    cp.clusters[index].geometry!.location.lat,
                                longitude:
                                    cp.clusters[index].geometry!.location.lng,
                              );
                            },
                            child: ClusterListTile(
                              key: Key(cp.clusters[index].placeId),
                              cluster: cp.clusters[index],
                            ),
                          );
                        },
                      )),
              ),
            )
          ],
        ),
      ),
    );
  }

  void fitMapToContents() {
    if (_mapController == null) return;

    double zoomLevel = 12.0;
    if (widget.mileRadius > 0) {
      double radiusElevated = widget.mileRadius.mileToMeters() +
          widget.mileRadius.mileToMeters() / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 15 - log(scale) / log(2);
    }
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0.0,
          target: LatLng(widget.area.lat!, widget.area.lng!),
          zoom: zoomLevel,
        ),
      ),
    );
  }

  void scrollToItem(String placeId) {
    final indexOfPlace = Provider.of<ClusterProvider>(context, listen: false)
        .clusters
        .indexWhere((e) => e.placeId == placeId);
    if (indexOfPlace == -1) return;
    _itemScrollController.scrollTo(
      duration: const Duration(milliseconds: 500),
      index: indexOfPlace,
    );
  }

  void itemPositionsLister({double? latitude, double? longitude}) {
    double zoomLevel = 14.0;

    // Ignore unwanted zoom during initial build
    if (isFirstBuild) { 
      isFirstBuild = false;
      return;
    }

    if (_mapController == null) return;


    //Zoom to marker
    if (latitude != null && longitude != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0.0,
            target: LatLng(latitude, longitude),
            zoom: zoomLevel,
          ),
        ),
      );
      return;
    }

    //Zoom to cluster item
    final visibleIndices =
        _itemPositionsListener.itemPositions.value.map((e) => e.index).toList();
    if (visibleIndices.isNotEmpty) {
      final place = Provider.of<ClusterProvider>(context, listen: false)
          .clusters[visibleIndices.first];
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0.0,
            target: LatLng(
              place.geometry!.location.lat,
              place.geometry!.location.lng,
            ),
            zoom: zoomLevel,
          ),
        ),
      );
    }
  }
}
