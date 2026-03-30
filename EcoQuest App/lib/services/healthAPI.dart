import 'package:health/health.dart';

Future<int> getAllSteps() async {
  final health = Health();

  final types = [HealthDataType.STEPS];

  bool available = await health.isHealthConnectAvailable();
  if (!available) return 0;


  bool accessWasGranted = await health.requestAuthorization(types);

  if (!accessWasGranted) return 0;

  final now = DateTime.now();
  final start = DateTime(2000);

  final healthData = await health.getHealthDataFromTypes(
    startTime: start,
    endTime: now,
    types: types,
  );

  int totalSteps = 0;
  for (var entry in healthData) {
    if (entry.type == HealthDataType.STEPS) {
      totalSteps += (entry.value as num).toInt();
    }
  }

  return totalSteps;
}
