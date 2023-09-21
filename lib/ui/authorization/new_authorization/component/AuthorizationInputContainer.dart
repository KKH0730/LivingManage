import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:livingmanage/AppColors.dart';
import 'package:livingmanage/data/provider/AuthorizationProvider.dart';
import 'package:provider/provider.dart';

class AuthorizationInputContainer extends StatefulWidget {
  TextEditingController titleEditController = TextEditingController();
  TextEditingController contentEditController = TextEditingController();
  void Function() onChangedText;

  AuthorizationInputContainer({super.key, required this.onChangedText});

  @override
  State<StatefulWidget> createState() => _AuthorizationInputContainerState(onChangedText: onChangedText);
}

class _AuthorizationInputContainerState extends State<AuthorizationInputContainer> {
  late AuthorizationProvider makeRequestProvider;
  TextEditingController titleEditController = TextEditingController();
  TextEditingController contentEditController = TextEditingController();
  void Function() onChangedText;

  _AuthorizationInputContainerState({ required this.onChangedText });

  @override
  Widget build(BuildContext context) {
    makeRequestProvider = Provider.of<AuthorizationProvider>(context);

    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            CupertinoTextField(
              cursorColor: AppColors.color_FF000000,
              controller: titleEditController,
              maxLines: 1,
              maxLength: 50,
              keyboardType: TextInputType.text,
              padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 15),
              style: const TextStyle(
                  color: AppColors.color_FF000000,
                  fontSize: 22,
                  fontWeight: FontWeight.w500
              ),
              placeholder: 'make_request_title_placeholder'.tr(),
              placeholderStyle:
              const TextStyle(
                  color: AppColors.color_FFB9B9BB,
                  fontSize: 22,
                  fontWeight: FontWeight.w600
              ),
              decoration: BoxDecoration(
                  color: AppColors.TRANSPARENT,
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: AppColors.TRANSPARENT)),
              onChanged: (value) {
                String beforeTitle = makeRequestProvider.title;

                makeRequestProvider.title = value;

                if(beforeTitle.isNotEmpty && value.isEmpty || beforeTitle.isEmpty && value.isNotEmpty) {
                  onChangedText();
                }
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              height: 2,
              color: AppColors.color_79ECE9E9,
            ),
            Expanded(
              child: CupertinoTextField(
                cursorColor: AppColors.color_FF000000,
                controller: contentEditController,
                maxLength: 500,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10, right: 15),
                style: const TextStyle(
                    color: AppColors.color_FF000000,
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                ),
                textAlignVertical: TextAlignVertical.top,
                placeholder: 'make_request_content_placeholder'.tr(),
                placeholderStyle: const TextStyle(
                    color: AppColors.color_FFC7C7CB,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),
                decoration: BoxDecoration(
                    color: AppColors.TRANSPARENT,
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: AppColors.TRANSPARENT)),
                onChanged: (value) {
                  String beforeContent = makeRequestProvider.content;

                  makeRequestProvider.content = value;

                  if(beforeContent.isNotEmpty && value.isEmpty
                  || beforeContent.isEmpty && value.isNotEmpty
                  ) {
                    onChangedText();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}