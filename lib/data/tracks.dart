class TrackDetail {
  final String name;
  final int level;

  const TrackDetail({
    required this.name,
    required this.level,
  });
}

const tracks = {
  // Level 1
  'breeze.ogg': TrackDetail(name: 'breeze.ogg', level: 1),
  'homes.ogg': TrackDetail(name: 'homes.ogg', level: 1),
  'openings.ogg': TrackDetail(name: 'openings.ogg', level: 1),
  'signs.mp3': TrackDetail(name: 'signs.mp3', level: 1),
  'warm.mp3': TrackDetail(name: 'warm.mp3', level: 1),

  // Level 2
  'change.ogg': TrackDetail(name: 'change.ogg', level: 2),
  'float.ogg': TrackDetail(name: 'float.ogg', level: 2),
  'sleepy.ogg': TrackDetail(name: 'sleepy.ogg', level: 2),
  'trains.ogg': TrackDetail(name: 'trains.ogg', level: 2),
  'walks.ogg': TrackDetail(name: 'walks.ogg', level: 2),

  // Level 3
  'difference.ogg': TrackDetail(name: 'difference.ogg', level: 3),
  'drifting.ogg': TrackDetail(name: 'drifting.ogg', level: 3),
  'halls.ogg': TrackDetail(name: 'halls.ogg', level: 3),
  'motions.ogg': TrackDetail(name: 'motions.ogg', level: 3),
  'summer.ogg': TrackDetail(name: 'summer.ogg', level: 3),
};
