import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkImage(url) {
  return CachedNetworkImage(
    imageUrl: url,
    fit: BoxFit.cover,
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        CircularProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
