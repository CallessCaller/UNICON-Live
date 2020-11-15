import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/model/artists.dart';

class LiveIndicatorProfile extends StatefulWidget {
  final Artist artist;

  const LiveIndicatorProfile({Key key, this.artist}) : super(key: key);
  @override
  _LiveIndicatorProfileState createState() => _LiveIndicatorProfileState();
}

class _LiveIndicatorProfileState extends State<LiveIndicatorProfile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: 110,
            height: 110,
            child: CachedNetworkImage(
              imageUrl: widget.artist.profile,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: _controller,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: appKeyColor,
                  width: 2.0,
                ),
              ),
              width: 110,
              height: 110,
            ),
          ),
        ),
      ],
    );
  }
}
