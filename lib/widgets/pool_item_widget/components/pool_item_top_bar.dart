import 'package:cached_network_image/cached_network_image.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/utils/constants.dart';
import 'package:demos/utils/util_general.dart';
import 'package:demos/widgets/user_picture.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PoolItemTopBar extends StatelessWidget {
  const PoolItemTopBar({Key? key, required this.pool}) : super(key: key);

  final Pool pool;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = pool.endDate?.difference(now);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              UserPicture(url: pool.user?.profilePicUrl),
              SizedBox(width: 8.0,),
              Text(pool.user!.displayName ?? '', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
            ],
          ),
          pool.endDate != null && pool.endDate!.isAfter(DateTime.now()) ? Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 16,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(formatDuration(difference!)),
            ],
          ):SizedBox.shrink(),
        ],
      ),
    );
  }
}
