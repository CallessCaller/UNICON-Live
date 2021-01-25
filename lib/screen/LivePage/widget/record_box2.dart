import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testing_layout/components/constant.dart';
import 'package:testing_layout/components/uni_icon_icons.dart';
import 'package:testing_layout/model/artists.dart';
import 'package:testing_layout/model/records.dart';
import 'package:testing_layout/model/users.dart';
import 'package:testing_layout/providers/stream_of_user.dart';
import 'package:testing_layout/screen/LivePage/screen/record_streaming.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../components/constant.dart';

class RecordBox2 extends StatefulWidget {
  final Records record;
  const RecordBox2({Key key, this.record}) : super(key: key);

  @override
  _RecordBoxState createState() => _RecordBoxState();
}

class _RecordBoxState extends State<RecordBox2> {
  @override
  void initState() {
    super.initState();

    // takeSnapshot();
  }

  Image image;
  Widget _fetchData(BuildContext context) {
    String id = widget.record.name.replaceAll('.mp4', '');
    if (id.contains('_')) {
      id = id.split('_')[0];
    }

    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('Users').doc(id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildBody(context, snapshot.data);
      },
    );
  }

  // void takeSnapshot() async {
  //   Uint8List bytes = await VideoThumbnail.thumbnailData(
  //     video:
  //         'http://ynw.fastedge.net:1935/vod/_definst_/${widget.record.name}/playlist.m3u8', // Path of that video
  //     imageFormat: ImageFormat.PNG,
  //     quality: 100,
  //     maxHeight: 75,
  //   );
  //   image = Image.memory(bytes); // Here's your frame
  // }

  Widget _buildBody(BuildContext context, DocumentSnapshot snapshot) {
    Artist artist = Artist.fromSnapshot(snapshot);
    var userDB = Provider.of<UserDB>(context);
    final DateFormat serverFormat = DateFormat('yyyy-MM-dd');
    return InkWell(
      onTap: () async {
        var recordSanp = await FirebaseFirestore.instance
            .collection('Records')
            .doc(widget.record.name)
            .get();
        List<dynamic> total = recordSanp.data()['total'];
        total.add(userDB.id);

        recordSanp.reference.update({'total': total});
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => StreamProvider.value(
              value: StreamOfuser().getUser(userDB.id),
              child: RecordStreaming(
                record: widget.record,
                artist: artist,
                userDB: userDB,
              ),
            ),
          ),);

      },
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: (MediaQuery.of(context).size.width * 0.4) / 1.7,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff707070), width: 0.5),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
              image: DecorationImage(
                image: artist.liveImage == null
                    ? artist.resizedProfile != null &&
                            artist.resizedProfile != ''
                        ? NetworkImage(artist.resizedProfile)
                        : NetworkImage(artist.profile)
                    : artist.resizedLiveImage != null &&
                            artist.resizedLiveImage != ''
                        ? NetworkImage(artist.resizedLiveImage)
                        : NetworkImage(artist.liveImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 20),
          Container(
            color: Colors.transparent,
            height: (MediaQuery.of(context).size.width * 0.4) / 1.7,
            width: MediaQuery.of(context).size.width * 0.6 - 22 - 20 - 20,
            child: Stack(
              children: [
                Positioned(
                  top: 9,
                  child: Text(
                    artist.liveTitle != null && artist.liveTitle != ''
                        ? artist.liveTitle
                        : artist.name,
                    style: subtitle3,
                  ),
                ),
                Positioned(
                  top: 34,
                  child: Text(
                    '${artist.name}님의 지난 공연',
                    style: TextStyle(
                      fontSize: widgetFontSize,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 56,
                  left: 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 15,
                        color: Color(0xffB5B5B5),
                      ),
                      SizedBox(width: 3),
                      Text(
                        (widget.record.total.length.toString() + '명'),
                        style: TextStyle(
                          fontSize: widgetFontSize,
                          color: Color(0xffB5B5B5),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text('∙',
                          style: TextStyle(
                            color: Color(0xffB5B5B5),
                          )),
                      SizedBox(width: 5),
                      Text(
                        (serverFormat.format(widget.record.date.toDate()))
                            .toString(),
                        style: TextStyle(
                          fontSize: widgetFontSize - 1,
                          color: Color(0xffB5B5B5),
                        ),
                      ),
                      artist.fee != 0
                          ? Row(
                              children: [
                                Text('∙',
                                    style: TextStyle(
                                      color: Color(0xffB5B5B5),
                                    )),
                                Icon(
                                  UniIcon.unicoin,
                                  color: appKeyColor,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  artist.fee.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: textFontSize,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return _fetchData(context);
  }
}
