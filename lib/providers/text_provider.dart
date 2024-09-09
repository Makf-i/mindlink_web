import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink_web_app/models/post_model.dart';

class TextNotifier extends StateNotifier<List<PostModel>> {
  TextNotifier() : super([]);

  void loadData() async {
    List<PostModel> d = [];
    final datas = await FirebaseFirestore.instance
        .collection('files')
        .doc('data')
        .collection('text')
        .get();

    for (var i in datas.docs) {
      final id = i['id'];
      const url = "url";
      final des = i['msg'];
      final fav = i['isLiked'];
      print(des);

      d.add(PostModel(
        id: id,
        description: des,
        url: url,
        isFavorite: fav,
        type: 'text',
      ));
    }
    state = d;
  }

  void addToLikedImage(String id, bool fav) async {
    var likeStatus = !fav;

    state = [
      for (PostModel i in state)
        if (i.id == id) i.copyWith(isFavorite: likeStatus) else i
    ];

    final snap = await FirebaseFirestore.instance
        .collection('files')
        .doc('data')
        .collection('text')
        .where('id', isEqualTo: id)
        .get();
    if (snap.docs.isNotEmpty) {
      final docId = snap.docs.first.id; // Get the Firestore document ID

      // Update the 'isLiked' field for the found document
      FirebaseFirestore.instance
          .collection('files')
          .doc('data')
          .collection('text')
          .doc(docId)
          .update({'isLiked': likeStatus})
          .then((value) => print("Image Liked status updated"))
          .catchError((error) => print("Failed to update image: $error"));
    }
  }
}

final textProvider = StateNotifierProvider<TextNotifier, List<PostModel>>(
  (ref) => TextNotifier(),
);
