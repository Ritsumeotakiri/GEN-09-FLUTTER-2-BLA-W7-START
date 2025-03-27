import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/providers/ridesPreferencesProviser.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onRidePrefSelected(BuildContext context, RidePreference newPreference) {
    context
        .read<RidesPreferencesProvider>()
        .setCurrentPreferrence(newPreference);
  }

  void onPreferencePressed(BuildContext context) async {
    final provider = context.read<RidesPreferencesProvider>();

    RidePreference? newPreference =
        await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: provider.currentPreference!),
      ),
    );

    if (newPreference != null) {
      provider.setCurrentPreferrence(newPreference);
    }
  }

  void onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onFilterPressed(BuildContext context) {
    // Handle filter button press
  }

  @override
  Widget build(BuildContext context) {
    final ridePreference =
        context.watch<RidesPreferencesProvider>().currentPreference;
    final matchingRides = ridePreference == null
        ? []
        : RidesService.instance.getRidesFor(ridePreference, RideFilter());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            RidePrefBar(
              ridePreference: ridePreference!,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () => onPreferencePressed(context),
              onFilterPressed: () => onFilterPressed(context),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) => RideTile(
                  ride: matchingRides[index],
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
