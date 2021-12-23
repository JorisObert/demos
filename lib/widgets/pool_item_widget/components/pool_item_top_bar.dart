import 'package:cached_network_image/cached_network_image.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/utils/constants.dart';
import 'package:demos/utils/util_general.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PoolItemTopBar extends StatelessWidget {
  const PoolItemTopBar({Key? key, required this.pool}) : super(key: key);

  final Pool pool;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = pool.endDate?.difference(now);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: 'null',
              imageBuilder: (context, imageProvider) => Container(
                width: TOP_BAR_AVATAR_SIZE,
                height: TOP_BAR_AVATAR_SIZE,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => SizedBox(height: TOP_BAR_AVATAR_SIZE, width: TOP_BAR_AVATAR_SIZE,),
              errorWidget: (context, url, error) => Icon(Icons.error, size: TOP_BAR_AVATAR_SIZE,),
            ),
            SizedBox(width: 8.0,),
            Text(pool.user!.properties['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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
    );
  }
}
