import 'package:image_picker/image_picker.dart';

Future<XFile?> pickGalleryImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  return pickedFile;
}