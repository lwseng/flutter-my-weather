import 'package:flutter/material.dart';

class GeneralListTile extends StatelessWidget {
  final Widget? leading;
  final String titleText;
  final String subTitleText;
  final VoidCallback? onTap;
  final List<Widget> actionList;
  final bool isLastTile;

  const GeneralListTile({
    this.leading,
    required this.titleText,
    required this.subTitleText,
    this.onTap,
    this.actionList = const [],
    this.isLastTile = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(5),
          onTap: onTap,
          leading: leading,
          title: Text(titleText, style: TextTheme.of(context).titleMedium),
          subtitle: Text(subTitleText, style: TextTheme.of(context).bodyMedium),
          trailing: (actionList.isEmpty)
              ? null
              : Row(mainAxisSize: .min, children: actionList),
        ),
        if (!isLastTile) const Divider(height: 1),
      ],
    );
  }
}
