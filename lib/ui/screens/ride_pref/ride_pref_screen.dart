import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/providers/ridesPreferencesProviser.dart';

import '../../../model/ride/ride_pref.dart';
// Fixed import typo
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

/// Ride Preferences Screen
///
/// This screen allows users to:
/// - Enter their ride preferences and launch a search.
/// - Select a previous ride preference and launch a search.
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    final provider =
        Provider.of<RidesPreferencesProvider>(context, listen: false);
    provider.setCurrentPreference(newPreference);

    // Navigate to the rides screen with an animation
    await Navigator.of(context).push(
      AnimationUtils.createBottomToTopRoute(const RidesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RidesPreferencesProvider>(context);
    final pastPreferencesState = provider.pastPreferences;

    // Handle Loading State
    if (pastPreferencesState.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('Loading...'),
          ],
        ),
      );
    }

    // Handle Error State
    if (pastPreferencesState.error != null) {
      return const Center(
        child: Text(
          'No connection. Try later',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    // Handle Success State
    final pastPreferences = pastPreferencesState.data ?? [];
    final currentRidePreference = provider.currentPreference;

    return Stack(
      children: [
        // Background Image
        const BlaBackground(),

        // Foreground Content
        Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              "Your pick of rides at low price",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 100),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ride Preference Form
                  RidePrefForm(
                    initialPreference: currentRidePreference,
                    onSubmit: (newPreference) =>
                        onRidePrefSelected(context, newPreference),
                  ),
                  const SizedBox(height: 16),

                  // Past Preferences History
                  if (pastPreferences.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: pastPreferences.length,
                        itemBuilder: (ctx, index) => RidePrefHistoryTile(
                          ridePref: pastPreferences.reversed.toList()[index],
                          onPressed: () => onRidePrefSelected(
                              context, pastPreferences[index]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Background Widget with Image
class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
