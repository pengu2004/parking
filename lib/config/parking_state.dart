class ParkingState {
  final Map<int, bool> bikeSlots;
  final Map<int, bool> carSlots;

  ParkingState({required this.bikeSlots, required this.carSlots});
}
