import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverProvider;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingmanage/AppColors.dart';
import 'package:livingmanage/data/provider/AuthorizationProvider.dart';
import 'package:provider/provider.dart';

class ImagePickContainer extends riverProvider.ConsumerWidget {
  late AuthorizationProvider authorizationProvider;
  final imagePickerProvider = riverProvider.StateNotifierProvider<ImageState, List<XFile>>((ref) {
    return ImageState();
  });

  ImagePickContainer({super.key});

  @override
  Widget build(BuildContext context, riverProvider.WidgetRef ref) {
    authorizationProvider = Provider.of<AuthorizationProvider>(context);

    final images = ref.watch(imagePickerProvider);
    authorizationProvider.imagesPublisher.sink.add(images);

    return Row(
      children: [
        _showImagePickerButton(() => ref.read(imagePickerProvider.notifier).getMultiImage()),
        const SizedBox(width: 20),
        _selectedImageContainer(context, ref, (img) => ref.read(imagePickerProvider.notifier).delImage(img))
      ],
    );
  }

  Widget _showImagePickerButton(GestureTapCallback onClickAddPicture) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: onClickAddPicture,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: AppColors.color_FFFFFFFF,
                  border: Border.all(
                      color: AppColors.color_A3E5E5E8,
                      width: 1
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: const Center(
                child: Icon(CupertinoIcons.camera_fill, size: 24),
              ),
            ),
          ),
          const SizedBox(height: 5),
          StreamBuilder(
              stream: authorizationProvider.imagesPublisher.stream,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data?.length ?? 0}/10',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.color_FFBFCDDF,
                  ),
                );
              }
          )
        ],
      ),
    );
  }

  Widget _selectedImageContainer(BuildContext context, riverProvider.WidgetRef ref, void Function(XFile) onClickDelete) {
    final images = ref.watch(imagePickerProvider);
    double imgBoxSize = ((MediaQuery.of(context).size.width - 32) / 5) - 4;

    return Expanded(
      child: SizedBox(
        height: imgBoxSize,
        child: ListView.builder(
          itemCount: images.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => _imageBox(context, images[index], imgBoxSize, onClickDelete),
        ),
      ),
    );
  }

  Widget _imageBox(BuildContext context, XFile img, double imgBoxSize, void Function(XFile) onClickDelete) {
    return GestureDetector(
      onTap: () => onClickDelete(img),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: imgBoxSize,
        height: imgBoxSize,
        child: Stack(
          children: [
            Container(
              width: imgBoxSize,
              height: imgBoxSize,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.file(File(img.path)).image
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Icon(
                    Icons.close,
                    size: 15,
                    color: Colors.grey[400]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
 }

class ImagePickerService {
  final ImagePicker picker = ImagePicker();

  Future<List<XFile>> pickMultiImage() async {
    try {
      final pickedFile = await picker.pickMultiImage();
      return pickedFile;
    } catch (e) {
      print('ImagePickerService: $e');
      return [];
    }
  }

  Future<XFile?> pickSingleImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      return pickedFile;
    } catch (e) {
      print('ImagePickerService: $e');
      return null;
    }
  }
}

class ImageState extends riverProvider.StateNotifier<List<XFile>> {
  ImageState() : super(<XFile>[]);
  final ImagePickerService pickerService = ImagePickerService();

  @override
  set state(List<XFile> value) {
    super.state = value;
  }

  delImage(XFile image) {
    var list = [...super.state];
    list.remove(image);
    state = list;
  }

  void addImage(List<XFile> value) {
    var list = [...super.state];
    if (list.isEmpty) {
      state = value;
    } else {
      list.addAll(value);
      list.toSet().toList();
      state = list;
    }
    if (super.state.length > 10) {
      state = super.state.sublist(0, 10);
      Fluttertoast.showToast(msg: 'You can only upload 10 images');
    }
  }

  Future getMultiImage() async {
    pickerService.pickMultiImage().then((value) {
      addImage(value);
    }).catchError((onError) {
      Fluttertoast.showToast(msg: 'failed to get image');
    });
  }
}
