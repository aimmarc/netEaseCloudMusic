import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/box.dart';

class ImageBlock extends StatelessWidget {
  final item;

  ImageBlock(this.item);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              imageUrl: item['picUrl'],
              height: 100.0,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
            ),
          ),
          box,
          Text(
            item['name'],
            maxLines: 2,
            style: TextStyle(fontSize: 13.0),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
