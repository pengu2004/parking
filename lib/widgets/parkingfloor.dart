import 'package:flutter/material.dart';

class ParkingFloor extends StatefulWidget {
  final String floorName;
  final String vehicleType;
  final Map<int, bool> parkingState;

  const ParkingFloor({
    super.key,
    required this.floorName,
    required this.vehicleType,
    required this.parkingState,
  });

  @override
  State<ParkingFloor> createState() => _ParkingFloorState();
}

class _ParkingFloorState extends State<ParkingFloor> {
  late Map<int, bool> spots;
  @override
  void initState() {
    super.initState();
    spots = Map.from(widget.parkingState);
  }

  void bookSpot(int spot) {
    setState( () {spots[spot] = false;}); //mark it as booked
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.floorName, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,

          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          children: spots.keys.map((spot) {
            final isAvailable = spots[spot]!;

            return InkWell(
              onTap: isAvailable
                  ? () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Parking Info"),
                          content: Text(
                            "${widget.vehicleType} $spot is available",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                bookSpot(spot);
                                Navigator.of(context).pop();
                              },
                              child: const Text("Book"),
                            ),
                          ],
                        ),
                      );
                    }
                  : null,

              child: Ink(
                color: isAvailable ? Colors.green[100] : Colors.grey,
                child: Center(
                  child: Text(
                    '$spot',
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
