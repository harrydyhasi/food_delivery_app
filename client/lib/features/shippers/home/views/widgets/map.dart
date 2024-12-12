import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_h2d/features/shippers/home/controllers/map_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = Get.put(MapWidgetController());
    final flutterMapController = MapController();

    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            FlutterMap(
              mapController:
                  flutterMapController, // Assign the controller to the map
              options: MapOptions(
                initialCenter: mapController.currentPosition
                    .value, // Use center instead of initialCenter
                initialZoom: 13.0,
                minZoom: 5.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: mapController.currentPosition.value,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 126,
              right: 16,
              child: FloatingActionButton(
                onPressed: () async {
                  await mapController.getCurrentLocation();
                  flutterMapController.move(
                    mapController.currentPosition.value,
                    13.0, // Keep the zoom level constant or adjust as needed
                  );
                },
                child: const Icon(
                  Icons.my_location,
                  color: MyColors.iconColor,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
