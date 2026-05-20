import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_mates/ui/friends/friend.dart';

class FriendDetailBody extends StatelessWidget {
  FriendDetailBody(this.friend);
  final Friend friend;

  Widget _buildLocationInfo(TextTheme textTheme) {
    return  Row(
      children: <Widget>[
         Icon(
          Icons.place,
          color: Colors.white,
          size: 16.0,
        ),
         Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child:  Text(
            friend.location,
            style: textTheme.headlineMedium?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color) {
    return  Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child:  CircleAvatar(
        backgroundColor: color,
        child:  Icon(
          iconData,
          color: Colors.white,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
         Text(
          friend.name,
          style: textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),
         Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: _buildLocationInfo(textTheme),
        ),
         Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child:  Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting '
                'industry. Lorem Ipsum has been the industry\'s standard dummy '
                'text ever since the 1500s.',
            style:
                textTheme.bodyMedium?.copyWith(color: Colors.white70, fontSize: 16.0),
          ),
        ),
         Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child:  Row(
            children: <Widget>[
              _createCircleBadge(Icons.beach_access, theme.colorScheme.secondary),
              _createCircleBadge(Icons.cloud, Colors.white12),
              _createCircleBadge(Icons.shop, Colors.white12),
            ],
          ),
        ),
      ],
    );
  }
}
