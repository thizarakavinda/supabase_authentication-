import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_authentication/main.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.imgUrl, required this.onUpload});

  final String? imgUrl;
  final void Function(String imgUrl) onUpload;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade900,
          backgroundImage: NetworkImage(
            imgUrl != null ? '$imgUrl' : 'No image',
          ),

          radius: 65,
        ),

        IconButton(
          icon: Icon(Icons.add_a_photo_outlined),
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            // Pick an image.
            final XFile? image = await picker.pickImage(
              source: ImageSource.gallery,
            );
            if (image == null) {
              return;
            }
            final imgBytes = await image.readAsBytes();
            final userId = supabase.auth.currentUser!.id;
            final imgPath = '/$userId/profile';
            final imageExtension = image.path.split('.').last.toLowerCase();
            await supabase.storage
                .from('profiles')
                .uploadBinary(
                  imgPath,
                  imgBytes,
                  fileOptions: FileOptions(
                    upsert: true,
                    contentType: 'image/$imageExtension',
                  ),
                );
            String imgUrl = supabase.storage
                .from('profiles')
                .getPublicUrl(imgPath);
            imgUrl = Uri.parse(imgUrl)
                .replace(
                  queryParameters: {
                    't': DateTime.now().microsecondsSinceEpoch.toString(),
                  },
                )
                .toString();
            onUpload(imgUrl);
          },
        ),
      ],
    );
  }
}
