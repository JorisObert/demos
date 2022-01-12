import 'package:cached_network_image/cached_network_image.dart';
import 'package:demos/utils/constants.dart';
import 'package:flutter/material.dart';

class UserPicture extends StatelessWidget {
  const UserPicture({Key? key, required this.url}) : super(key: key);

  final String? url;

  @override
  Widget build(BuildContext context) {
    print(url);
    return CachedNetworkImage(
      imageUrl: url ?? 'null',
      width: TOP_BAR_AVATAR_SIZE,
      height: TOP_BAR_AVATAR_SIZE,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: imageProvider, fit: BoxFit.contain),
        ),
      ),
      placeholder: (context, url) => SizedBox(height: TOP_BAR_AVATAR_SIZE, width: TOP_BAR_AVATAR_SIZE,),
      errorWidget: (context, url, error) => Icon(Icons.person, size: TOP_BAR_AVATAR_SIZE,),
    );
  }
}
