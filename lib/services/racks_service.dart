import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fyllo/models/rack_model.dart';

class RacksService {
  final _endpointName = "racks";

  Future<List<RackModel>?> getRacks() async {
    try {
      final restOperation = Amplify.API.get(_endpointName);
      final response = await restOperation.response;
      final data = jsonDecode(response.decodeBody()) as List;
      return data.map((e) => RackModel.fromMap(e)).toList();
    } on ApiException catch (e) {
      debugPrint('GET call failed: $e');
    }
    return null;
  }
}
