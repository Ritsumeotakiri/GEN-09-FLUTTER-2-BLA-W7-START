import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/ui/providers/async_calue.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  AsyncValue<List<RidePreference>> pastPreferences = AsyncValue.loading();

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    fetchPastPreferences();
  }

  /// Fetch past preferences and handle loading, success, and error states
  Future<void> fetchPastPreferences() async {
    pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      final pastPrefs = await repository.getPastPreferences();
      pastPreferences = AsyncValue.success(
          List.unmodifiable(pastPrefs)); // Ensure immutability
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }

    notifyListeners();
  }

  /// Get the current ride preference
  RidePreference? get currentPreference => _currentPreference;

  /// Set a new current preference and update the history
  void setCurrentPreference(RidePreference pref) {
    if (_currentPreference != pref) {
      _currentPreference = pref;

      if (pastPreferences.data != null) {
        final updatedPreferences =
            List<RidePreference>.from(pastPreferences.data!);
        updatedPreferences.remove(pref);
        updatedPreferences.add(pref);
        pastPreferences =
            AsyncValue.success(List.unmodifiable(updatedPreferences));
      }

      notifyListeners();
    }
  }

  /// Add a new preference to the repository and update the provider state
  Future<void> addPreference(RidePreference preference) async {
    try {
      await repository.addPreference(preference);

      // Check if the new preference is already in the list
      if (pastPreferences.data?.contains(preference) == false) {
        final updatedPreferences =
            List<RidePreference>.from(pastPreferences.data ?? []);
        updatedPreferences.add(preference);
        pastPreferences =
            AsyncValue.success(List.unmodifiable(updatedPreferences));
      }

      notifyListeners();
    } catch (error) {
      debugPrint('Error adding preference: $error');
    }
  }
}
