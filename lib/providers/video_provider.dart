import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink_web_app/models/post_model.dart';

class VideoNotifier extends StateNotifier<List<PostModel>> {
  VideoNotifier() : super([]);

  void loadData() async {
    List<PostModel> d = [];
    final data = await FirebaseFirestore.instance
        .collection('files')
        .doc('data')
        .collection('videos')
        .get();

    print("jeello");
    print("image data are $data");
    for (var i in data.docs) {
      final id = i['id'];
      final url = i['vid_url'];
      final fav = i['isLiked'];
      print(i['name']);
      d.add(PostModel(
        id: id,
        url: url,
        isFavorite: fav,
        type: 'video',
      ));
    }
    state = d;
  }

  void addToLikedImage(String id, bool fav) async {
    var likeStatus = !fav;

    state = [
      for (var i in state)
        if (i.id == id) i.copyWith(isFavorite: likeStatus) else i
    ];

    final snap = await FirebaseFirestore.instance
        .collection('files')
        .doc('data')
        .collection('videos')
        .where('id', isEqualTo: id)
        .get();
    if (snap.docs.isNotEmpty) {
      final docId = snap.docs.first.id; // Get the Firestore document ID

      // Update the 'isLiked' field for the found document
      FirebaseFirestore.instance
          .collection('files')
          .doc('data')
          .collection('videos')
          .doc(docId)
          .update({'isLiked': likeStatus})
          .then((value) => print("video Liked status updated"))
          .catchError((error) => print("Failed to update video: $error"));
    }
  }
}

final videoProvider = StateNotifierProvider<VideoNotifier, List<PostModel>>(
  (ref) => VideoNotifier(),
);
