import 'package:cached_network_image/cached_network_image.dart';
import 'package:demos/utils/constants.dart';
import 'package:flutter/material.dart';

class UserPicture extends StatelessWidget {
  const UserPicture({Key? key, required this.url, this.size = TOP_BAR_AVATAR_SIZE}) : super(key: key);

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url ?? 'null',
      width: size,
      height: size,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: imageProvider, fit: BoxFit.contain),
        ),
      ),
      placeholder: (context, url) => SizedBox(height: size, width: size,),
      errorWidget: (context, url, error) => Icon(Icons.person, size: size,),
    );
  }
}
