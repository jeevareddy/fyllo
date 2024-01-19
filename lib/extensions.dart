extension DoubleExtension on double {
  double mileToMeters() {
    return this * 1609.34;
  }
  double mileToMapsZoom() {
    return this * 2.0;
  }
}