class ParkingState {
  final Map<int, bool> bikeSlotsTower1;
  final Map<int, bool> bikeSlotsTower2;
  final Map<int, bool> carSlots;

  ParkingState({
    required this.bikeSlotsTower1,
    required this.bikeSlotsTower2,
    required this.carSlots,
  });
}
