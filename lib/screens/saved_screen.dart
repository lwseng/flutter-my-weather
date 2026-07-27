import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/base/base_content_view.dart';
import '../widgets/common/general_list_tile.dart';
import '../widgets/common/general_confirm_dialog.dart';
import '../widgets/common/adaptive_textfield.dart';
import '../../providers/weather_provider.dart';
import '../../providers/saved_locations_provider.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  Future<void> showDeleteDialog(BuildContext context, int locationId) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => GeneralConfirmDialog(
        title: 'Remove location?',
        content: Text(
          'Are you sure you want to remove this location?',
          style: TextTheme.of(context).bodyMedium,
        ),
        onConfirm: () {
          context.read<SavedLocationsProvider>().removeLocation(locationId);
          Navigator.pop(dialogContext);
        },
      ),
    );
  }

  Future<String?> showRenameDialog(
    BuildContext context, {
    required String currentName,
  }) async {
    final controller = TextEditingController(text: currentName);

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => GeneralConfirmDialog(
        title: 'Set Your Preference Name',
        content: AdaptiveTextField(
          controller: controller,
          hintText: 'Enter Preference Name',
          autofocus: true,
        ),
        onConfirm: () => Navigator.pop(dialogContext, controller.text.trim()),
      ),
    );
    await WidgetsBinding.instance.endOfFrame;
    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Your Saved Location')),
        body: BaseContentView(
          isLoading: false,
          errorMessage: null,
          content: Padding(
            padding: const .all(20.0),
            child: Consumer2<SavedLocationsProvider, WeatherProvider>(
              builder: (context, savedProvider, weatherProvider, child) {
                final savedLocations = savedProvider.savedLocations;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final result = savedLocations[index];
                    return GeneralListTile(
                      leading:
                          weatherProvider.selectedLocationId ==
                              result.location.id
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const SizedBox(width: 24),
                      titleText: result.displayName.isNotEmpty
                          ? result.displayName
                          : result.location.name,
                      subTitleText: result.location.state.isNotEmpty
                          ? '${result.location.state}, ${result.location.country}'
                          : result.location.country,
                      onTap: () async {
                        final weatherProvider = context.read<WeatherProvider>();
                        if (weatherProvider.selectedLocationId ==
                            result.location.id) {
                          return;
                        }
                        await weatherProvider.fetchWeatherForSavedPosition(
                          result,
                        );
                      },
                      actionList: [
                        if (!result.isCurrentLocation)
                        IconButton(
                          onPressed: () async {
                            final newName = await showRenameDialog(
                              context,
                              currentName: result.displayName,
                            );
                            if (!context.mounted) return;
                            if (newName != null && newName.isNotEmpty) {
                              context
                                  .read<SavedLocationsProvider>()
                                  .renameLocation(result.location.id, newName);
                              final weatherProvider = context
                                  .read<WeatherProvider>();

                              if (weatherProvider.selectedLocationId ==
                                  result.location.id) {
                                weatherProvider.updateLocationName(newName);
                              }
                            }
                          },
                          icon: const Icon(Icons.edit_note_sharp),
                          iconSize: 30,
                        ),
                        if (!result.isCurrentLocation)
                          IconButton(
                            onPressed: () {
                              showDeleteDialog(context, result.location.id);
                            },
                            icon: const Icon(Icons.delete_outline_sharp),
                            iconSize: 30,
                          ),
                      ],
                    );
                  },
                  itemCount: savedLocations.length,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
