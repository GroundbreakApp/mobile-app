import 'package:flutter/material.dart';
import 'package:ground_break/components/components.dart';
import 'package:ground_break/constants/constants.dart';
import 'package:ground_break/models/models.dart';
import 'package:ground_break/services/services.dart';
import 'package:ground_break/utils/utils.dart';
import 'package:ground_break/views/pages.dart';

class MediaListPage extends StatefulWidget {
  const MediaListPage({
    Key? key,
  }) : super(key: key);

  static Route route() =>
      AppUIUtils.fadeTransitionBuilder(const MediaListPage());

  @override
  State<StatefulWidget> createState() {
    return _MediaListPageState();
  }
}

class _MediaListPageState extends State<MediaListPage> {
  final Stream<List<MediaModel>> _getMedia$ = UploadService.getMedia$();

  Widget _addTile() {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: AppBorders.roundedBorder10,
          border: Border.all(color: AppColors.white.withOpacity(0.5)),
        ),
        child: const Icon(
          Icons.add,
          color: AppColors.yellowGreen,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushReplacement(
          RecordingPage.route(),
        );
      },
    );
  }

  Widget _mediaTile(MediaModel media) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppBorders.roundedBorder10,
          image: DecorationImage(
            image: NetworkImage(media.gifUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTap: () async {
        Navigator.of(context).push(
          MediaPreviewPage.route(media: media),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: StreamBuilder<List<MediaModel>>(
        stream: _getMedia$,
        builder: (context, snapshot) {
          List<MediaModel> media = snapshot.data ?? [];
          return GridView.count(
            padding: const EdgeInsets.all(40),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 95 / 150,
            crossAxisCount: 3,
            children: [
              _addTile(),
              ...media.map((e) => _mediaTile(e)).toList(),
            ],
          );
        },
      ),
    );
  }
}
