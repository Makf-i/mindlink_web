import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink_web_app/models/post_model.dart';
import 'package:uuid/uuid.dart';

const uid = Uuid();

class ImageNotifier extends StateNotifier<List<PostModel>> {
  ImageNotifier() : super([]);

  bool _loading = false; // Private variable to track loading state

  bool get loading => _loading; // Expose loading state

  Future<void> loadData() async {
    _setLoading(true); // Set loading to true before starting
    try {
      List<PostModel> d = [];
      final data = await FirebaseFirestore.instance
          .collection('files')
          .doc('data')
          .collection('images')
          .get();

      print("jeello");
      print("image data are $data");
      for (var i in data.docs) {
        final id = i['id'];
        final url = i['img_url'];
        final fav = i['isLiked'];
        print(i['name']);
        print(url);
        d.add(PostModel(
          id: id,
          url: url,
          isFavorite: fav,
          type: 'image',
        ));
      }
      state = d;
    } catch (e) {
      print('Error loading data: $e');
      // Handle error if needed
    } finally {
      _setLoading(false); // Set loading to false after completion
    }
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
        .collection('images')
        .where('id', isEqualTo: id)
        .get();
    if (snap.docs.isNotEmpty) {
      final docId = snap.docs.first.id; // Get the Firestore document ID

      // Update the 'isLiked' field for the found document
      FirebaseFirestore.instance
          .collection('files')
          .doc('data')
          .collection('images')
          .doc(docId)
          .update({'isLiked': likeStatus})
          .then((value) => print("Image Liked status updated"))
          .catchError((error) => print("Failed to update image: $error"));
    }
  }

  void _setLoading(bool isLoading) {
    _loading = isLoading;
    // Notify listeners if needed
  }
}

final imageProvider = StateNotifierProvider<ImageNotifier, List<PostModel>>(
  (ref) => ImageNotifier(),
);

final loadingProvider = Provider<bool>((ref) {
  final notifier = ref.watch(imageProvider.notifier);
  return notifier.loading;
});
