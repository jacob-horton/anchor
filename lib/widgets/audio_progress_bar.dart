import 'package:anchor/models/audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer<AudioPlayerModel>(
            builder: (context, player, _) {
              return GestureDetector(
                child: StreamBuilder(
                  stream: player.stream,
                  builder: (context, snapshot) {
                    if (player.duration == null) {
                      return Container();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AudioPlayerModel.formatFilename(player.currentTrack!),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => player.togglePausePlay(),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 5.0,
                                  right: 15.0,
                                ),
                                child: HeroIcon(
                                  player.isPlaying
                                      ? HeroIcons.pause
                                      : HeroIcons.play,
                                  style: HeroIconStyle.solid,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ProgressBar(
                                timeLabelLocation: TimeLabelLocation.none,
                                progress: snapshot.data ?? Duration.zero,
                                total: player.duration ?? Duration.zero,
                                baseBarColor: Colors.white38,
                                thumbColor: Colors.white,
                                progressBarColor: Colors.white70,
                                thumbRadius: 12.0,
                                onSeek: (position) => player.seek(position),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
