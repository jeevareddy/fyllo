import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fyllo/extensions.dart';
import 'package:fyllo/views/clusters/providers/cluster_provider.dart';
import 'package:fyllo/views/clusters/screens/clusters_screen.dart';
import 'package:fyllo/views/home/widgets/custom_autocomplete_location_input.dart';
import 'package:fyllo/widgets/custom_app_bar.dart';
import 'package:fyllo/widgets/custom_slider_input.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_places_autocomplete_widgets/model/place.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Place? _selectedPlace;
  double _mileRadius = 5.0;

  final _initialCenter = const LatLng(37.4219999, -122.0840575);

  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Map View
          Padding(
            padding: const EdgeInsets.only(top: 130.0, bottom: 265.0),
            child: GoogleMap(
              mapType: MapType.normal,
              markers: <Marker>{
                if (_selectedPlace != null)
                  Marker(
                    markerId: const MarkerId("origin"),
                    position:
                        LatLng(_selectedPlace!.lat!, _selectedPlace!.lng!),
                  ),
              },
              circles: {
                if (_selectedPlace != null)
                  Circle(
                    circleId: const CircleId("mile_radius"),
                    center: LatLng(_selectedPlace!.lat!, _selectedPlace!.lng!),
                    fillColor: Colors.blue.withOpacity(0.2),
                    strokeColor: Colors.blue.withOpacity(0.4),
                    radius: _mileRadius.mileToMeters(),
                  )
              },
              initialCameraPosition: CameraPosition(
                target: _initialCenter,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              zoomControlsEnabled: true,
            ),
          ),

          //Title
          const CustomAppBar(
            phrase:
                "Time to plant your thoughts! 🌱 What local area are we exploring today?",
          ),
          //Input Form
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomAutoCompleteLocationInput(
                    labelText: "Area",
                    hintText: "locality, city, state or country",
                    controller: TextEditingController(
                      text: _selectedPlace?.formattedAddress,
                    ),
                    onPlaceSelected: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedPlace = val;
                          fitMapToContents();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  CustomSliderInput(
                    labelText: "Mile Radius",
                    value: _mileRadius,
                    onChanged: (val) {
                      setState(() {
                        _mileRadius = val;
                        fitMapToContents();
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: onExploreNowPressed,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text("EXPLORE NOW"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void onExploreNowPressed() {
    if (_selectedPlace == null) return;

    Provider.of<ClusterProvider>(context, listen: false).searchNearby(
      lat: _selectedPlace!.lat!,
      lng: _selectedPlace!.lng!,
      radius: _mileRadius,
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ClustersScreen(
          area: _selectedPlace!,
          mileRadius: _mileRadius,
        );
      }),
    );
  }

  void fitMapToContents() {
    if (_mapController == null || _selectedPlace == null) return;

    double zoomLevel = 12.0;
    if (_mileRadius > 0) {
      double radiusElevated =
          _mileRadius.mileToMapsZoom() + _mileRadius.mileToMeters() / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 13 - log(scale) / log(2);
    }
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0.0,
          target: LatLng(_selectedPlace!.lat!, _selectedPlace!.lng!),
          zoom: zoomLevel,
        ),
      ),
    );
  }
}
