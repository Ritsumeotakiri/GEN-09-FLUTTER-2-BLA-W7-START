import '../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';
import '../../dummy_data/dummy_data.dart';

class MockRidePreferencesRepository extends RidePreferencesRepository {
  List<RidePreference> _pastPreferences = List.from(fakeRidePrefs);

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    // Simulate a delay to mimic a real database or network call
    await Future.delayed(const Duration(milliseconds: 2000));
    return List.unmodifiable(_pastPreferences); // Prevent modifications
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    // Simulate a delay to mimic a real database or network call
    await Future.delayed(const Duration(milliseconds: 2000));

    // Create a new list to maintain immutability
    final updatedPreferences = List<RidePreference>.from(_pastPreferences);
    updatedPreferences
        .removeWhere((existingPref) => existingPref == preference);
    updatedPreferences.add(preference);

    _pastPreferences = List.unmodifiable(updatedPreferences); // Update safely
  }
}
