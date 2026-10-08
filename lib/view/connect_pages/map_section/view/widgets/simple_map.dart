import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:biz_zinda/view/connect_pages/map_section/view/widgets/profile_map_marker_widget.dart';
import 'package:biz_zinda/view/other_user_profile/view/other_user_profile_screen.dart';
import 'package:biz_zinda/view_model/connect_page_view_model.dart';

class SimpleMap extends StatelessWidget {
  const SimpleMap({super.key});

  static const Color primaryOrange = Color(0xFFFB8C00);

  String _calculateDistance(
    double? userLat,
    double? userLng,
    double? targetLat,
    double? targetLng,
  ) {
    if (userLat == null ||
        userLng == null ||
        targetLat == null ||
        targetLng == null) {
      return '0 km';
    }
    final double distanceInMeters =
        Geolocator.distanceBetween(userLat, userLng, targetLat, targetLng);
    final double distanceInKm = distanceInMeters / 1000;
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()} m';
    }
    return '${distanceInKm.round()} km';
  }

  @override
  Widget build(BuildContext context) {
    ConnectPageViewModel connectPageViewModel =
        context.watch<ConnectPageViewModel>();

    return Consumer<ConnectPageViewModel>(
      builder: (context, value, child) {
        final double? lat = value.lat;
        final double? lng = value.lng;
        if (lat == null || lng == null) {
          // Location not yet available - show a loader
          return const Center(
            child: CircularProgressIndicator(color: primaryOrange),
          );
        }

        final double? distanceRadiusKm =
            double.tryParse(connectPageViewModel.distanceInKm);

        return FlutterMap(
          mapController: value.mapController,
          options: MapOptions(
            onMapReady: value.onMapReady,
            initialCenter: LatLng(lat, lng),
            initialZoom: 11,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              tileProvider: NetworkTileProvider(
                headers: {'User-Agent': 'bizzinda/1.0 (bizzinda@gmail.com)'},
              ),
              subdomains: const ['a', 'b', 'c'],
            ),
            if (distanceRadiusKm != null && distanceRadiusKm > 0)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: LatLng(lat, lng),
                    radius: distanceRadiusKm * 1000,
                    useRadiusInMeter: true,
                    color: primaryOrange.withValues(alpha: 0.04),
                    borderStrokeWidth: 1.5,
                    borderColor: primaryOrange.withValues(alpha: 0.25),
                  ),
                ],
              ),
            MarkerLayer(
              markers: connectPageViewModel.nearestStores
                  .where((e) => e.lat != 0 && e.lng != 0)
                  .map(
                    (e) {
                      final distanceStr = _calculateDistance(
                        lat,
                        lng,
                        e.lat,
                        e.lng,
                      );
                      return Marker(
                        width: 180,
                        height: 74,
                        point: LatLng(e.lat, e.lng),
                        alignment: const Alignment(-0.74, 0.43),
                        child: ProfileMapMarkerWidget(
                          store: e,
                          distanceStr: distanceStr,
                          onTap: () {
                            if (e.id.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OtherUserProfileScreen(userId: e.id),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  )
                  .toList(),
            ),
            // User's own GPS current location indicator (Orange)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(lat, lng),
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryOrange.withValues(alpha: 0.2),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryOrange,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
