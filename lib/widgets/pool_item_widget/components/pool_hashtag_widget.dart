import 'package:demos/models/hashtag.dart';
import 'package:demos/screens/pools/deep_navigation_pool_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PoolHashtagsWidget extends StatefulWidget {
  const PoolHashtagsWidget({Key? key, this.hashtags}) : super(key: key);

  final List<Hashtag>? hashtags;

  @override
  State<PoolHashtagsWidget> createState() => _PoolHashtagsWidgetState();
}

class _PoolHashtagsWidgetState extends State<PoolHashtagsWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.hashtags != null && widget.hashtags!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              alignment: WrapAlignment.start,
              children: _buildHashtagCards,
            ),
          )
        : SizedBox.shrink();
  }

  List<Widget> get _buildHashtagCards {
    return widget.hashtags!.map((e) {
      return hashtagItem(e);
    }).toList();
  }

  Widget hashtagItem(Hashtag hashtag) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => DeepNavigationPoolScreen(
                hashtag: hashtag.title,
              )),
        );
      },

      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        side: BorderSide(width: 1, color: Colors.grey.shade400),
        padding: const EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
          minimumSize: Size.zero,
        primary: Colors.grey.shade200,
      ),
      child: Text(
        '#${hashtag.title!}',
        style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
      ),
    );
  }
}
