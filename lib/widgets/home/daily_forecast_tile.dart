import 'package:flutter/material.dart';

import '../../models/daily_forecast.dart';

class DailyForecastTile extends StatelessWidget {
  final DailyForecast? daily;
  final bool isCelsius;
  final bool isLastTile;

  const DailyForecastTile({
    required this.daily,
    required this.isCelsius,
    this.isLastTile = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            SizedBox(
              width: 50,
              child: Text(
                daily?.dailyText ?? '',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, isLastTile ? 0 : 8),
              child: Icon(daily?.weatherCode.icon, size: 30),
            ),
            SizedBox(
              width: 100,
              child: Text(
                '${daily?.temperatureMinText(isCelsius)} - ${daily?.temperatureMaxText(isCelsius)}',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: .end,
              ),
            ),
          ],
        ),
        if (!isLastTile) Divider(height: 1),
      ],
    );
  }
}
