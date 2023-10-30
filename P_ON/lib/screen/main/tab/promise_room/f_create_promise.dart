import 'package:after_layout/after_layout.dart';
import 'package:fast_app_base/screen/main/tab/promise_room/f_selected_friends.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../common/common.dart';
import '../../../../common/constant/app_colors.dart';
import '../../../../common/util/app_keyboard_util.dart';
import '../../../../common/widget/w_basic_appbar.dart';
import './dto_promise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 추가


class CreatePromise extends ConsumerStatefulWidget {
  const CreatePromise({super.key});

  @override
  ConsumerState<CreatePromise> createState() => _CreatePromiseState();
}

class _CreatePromiseState extends ConsumerState<CreatePromise> with AfterLayoutMixin {
  final node = FocusNode();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(updateText);
    node.addListener(updateText);
  }

  void updateText() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        // extendBody: extendBody,
        body: Column(
          children: [
            const BasicAppBar(text: '약속 생성', isProgressBar: true, percentage: 33),
            Container(
                margin: const EdgeInsets.all(24),
                alignment: Alignment.topLeft,
                child: '약속명을 입력해 주세요'.text.black.size(16).semiBold.make()),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: textController.text.isEmpty && !node.hasFocus
                        ? Colors.grey
                        : AppColors.mainBlue2,
                  )),
              child: TextField(
                focusNode: node,
                controller: textController,
                decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            )
          ],
        ),
        bottomSheet: Container(
          width: double.infinity,
          height: 48,
          margin: EdgeInsets.all(24),
          child: FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: textController.text.isEmpty
                    ? Colors.grey
                    : AppColors.mainBlue),
            onPressed: () {
              ref.read(promiseProvider.notifier).setPromiseTitle(textController.text);
              Nav.push(const SelectedFriends());
            },
            child: const Text('다음'),
          ),
        ),
      )),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    AppKeyboardUtil.show(context, node);
  }
}