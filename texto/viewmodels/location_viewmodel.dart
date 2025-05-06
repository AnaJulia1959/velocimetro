import 'dart:async';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';

class LocationViewModel extends ChangeNotifier {
  LocationModel? _current;
  double _totalDistance = 0.0;
  double _averageSpeed = 0.0;
  Duration _elapsedTime = Duration.zero;
  DateTime? _startTime;
  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;

  LocationModel? get current => _current;
  double get totalDistance => _totalDistance / 1000; // em km
  double get averageSpeed => _averageSpeed;
  Duration get elapsedTime => _elapsedTime;

  LocationViewModel() {
    _init();
  }

  Future<void> _init() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    _startTime = DateTime.now();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      if (_lastPosition != null) {
        double distance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        _totalDistance += distance;
        _elapsedTime = DateTime.now().difference(_startTime!);
        _averageSpeed = _totalDistance / _elapsedTime.inSeconds * 3.6; // m/s para km/h
      }
      _lastPosition = position;
      _current = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        speed: position.speed * 3.6, // m/s para km/h
      );
      notifyListeners();
    });
  }

  void reset() {
    _totalDistance = 0.0;
    _averageSpeed = 0.0;
    _elapsedTime = Duration.zero;
    _startTime = DateTime.now();
    _lastPosition = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
