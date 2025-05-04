// map_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'experience_service.dart';
import 'experience_model.dart';
import 'experience_details_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String? _selectedCategory;
  final List<String> _categories = ['All', 'Food', 'Nature', 'Culture', 'Event', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experience Map'),
        actions: [
          DropdownButton<String>(
            value: _selectedCategory ?? 'All',
            items: _categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedCategory = val == 'All' ? null : val;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Experience>>(
        stream: ExperienceService().getExperiences(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          List<Experience> experiences = snapshot.data!;
          if (_selectedCategory != null) {
            experiences = experiences.where((e) => e.category == _selectedCategory).toList();
          }

          return FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(23.8103, 90.4125),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: experiences.map((e) => Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(e.latitude, e.longitude),
                  child: IconButton(
                    icon: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExperienceDetailsPage(experience: e),
                        ),
                      );
                    },
                  ),
                )).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}