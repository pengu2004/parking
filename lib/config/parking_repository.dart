import 'package:supabase_flutter/supabase_flutter.dart';
import 'parking_state.dart';

class ParkingRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final BikeSpaces = [
    320,
    355,
    358,
    362,
    363,
    364,
    365,
    366,
    377,
    100,
    101,
    102,
    103,
    104,
    105,
    106,
    107,
    108,
  ];
  final CarSpaces = [120, 125, 130, 135, 140, 145, 150, 155, 160];
  Future<void> saveUser({
    required String name,
    required String vehicleType,
    required int slotNumber,
  }) async {
    await _client.from('parking_records').insert({
      'name': name,
      'vehicle_type': vehicleType,
      'slot_number': slotNumber,
    });
  }

  Future<int?> hasUserBookedToday({required String name}) async {
    final today = DateTime.now();
    final dateOnly = DateTime(
      today.year,
      today.month,
      today.day,
    ).toIso8601String().split('T').first;

    final response = await _client
        .from('parking_records')
        .select('slot_number')
        .eq('name', name)
        .eq('date', dateOnly)
        .limit(1);

    if (response.isEmpty) {
      return null; //
    }

    return response.first['slot_number'] as int;
  }

  Future<ParkingState> getOccupiedSpotsToday() async {
    final todaysDate = DateTime.now();
    final response = await _client
        .from('parking_records')
        .select('slot_number, vehicle_type')
        .eq('date', todaysDate.toIso8601String().split('T').first);

    final Set<int> occupiedBikeSlots = response
        .where((row) => row['vehicle_type'] == 'Bike')
        .map<int>((row) => row['slot_number'] as int)
        .toSet();

    final Set<int> occupiedCarSlots = response
        .where((row) => row['vehicle_type'] == 'Car')
        .map<int>((row) => row['slot_number'] as int)
        .toSet();

    final Map<int, bool> bikeParkingState = {
      for (var slot in BikeSpaces) slot: !occupiedBikeSlots.contains(slot),
    };
    final Map<int, bool> carParkingState = {
      for (var slot in CarSpaces) slot: !occupiedCarSlots.contains(slot),
    };
    print('Occupied Bike Slots Today: $bikeParkingState');
    print('Occupied Car Slots Today: $carParkingState');
    return ParkingState(bikeSlots: bikeParkingState, carSlots: carParkingState);
  }
}
