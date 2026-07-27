import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/location_data.dart';
import '../../models/saved_location.dart';
import '../../screens/location_preview_screen.dart';
import '../../providers/saved_locations_provider.dart';
import '../common/general_list_tile.dart';

class SearchResultSection extends StatelessWidget {
  final Location result;

  const SearchResultSection({required this.result, super.key});

  @override
  Widget build(BuildContext context) {
    final isSaved = context.select<SavedLocationsProvider, bool>(
      (provider) => provider.isSaved(result.id),
    );

    return GeneralListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => LocationPreviewScreen(location: result),
        ),
      ),
      titleText: result.name,
      subTitleText: result.state.isNotEmpty
          ? '${result.state}, ${result.country}'
          : result.country,
      actionList: [
        isSaved
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Added',
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ],
                ),
              )
            : IconButton(
                onPressed: () => context
                    .read<SavedLocationsProvider>()
                    .addLocation(SavedLocation(location: result)),
                icon: const Icon(Icons.add),
              ),
      ],
    );
  }
}
