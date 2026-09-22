import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../core/constants/app_constants.dart';

class GeocodingService {
  static final Map<String, String> _addressCache = {};

  Future<String> getPlaceName(LatLng position) async {
    final cacheKey =
        '${position.latitude.toStringAsFixed(3)},${position.longitude.toStringAsFixed(3)}';

    if (_addressCache.containsKey(cacheKey)) {
      return _addressCache[cacheKey]!;
    }

    try {
      final url = Uri.parse(
        '${AppConstants.nominatimBaseUrl}?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=16',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': AppConstants.nominatimUserAgent},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final address = data['address'] as Map<String, dynamic>?;

        if (address != null) {
          final suburb =
              address['suburb'] ??
              address['neighbourhood'] ??
              address['residential'] ??
              address['road'];
          final city = address['city'] ?? address['town'] ?? address['county'];

          String result = 'Location Area';
          if (suburb != null && city != null) {
            result = '$suburb, $city';
          } else if (city != null) {
            result = '$city';
          } else if (suburb != null) {
            result = '$suburb';
          } else {
            result =
                data['display_name']?.toString().split(',').first ??
                'Location Area';
          }

          _addressCache[cacheKey] = result;
          return result;
        }
      }
    } catch (_) {
    }

    return 'Location Area';
  }
}

