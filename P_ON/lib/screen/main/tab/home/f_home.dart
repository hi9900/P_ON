import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/widget/w_list_container.dart';
import 'package:p_on/common/widget/w_rounded_container.dart';
import 'package:p_on/screen/dialog/d_message.dart';
import 'package:p_on/screen/main/tab/home/bank_accounts_dummy.dart';
import 'package:p_on/screen/main/tab/home/w_my_plan_and_promise.dart';
import 'package:p_on/screen/main/tab/home/w_p_on_app_bar.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:p_on/screen/main/tab/promise_room/f_create_promise.dart';
import 'package:flutter/material.dart';

import '../../../../common/widget/w_big_button.dart';
import '../../../dialog/d_color_bottom.dart';
import '../../../dialog/d_confirm.dart';
import '../../fab/w_bottom_nav_floating_button.dart';
import '../../fab/w_bottom_nav_floating_button.riverpod.dart';
import '../../s_main.dart';
import '../promise_room/vo_server_url.dart';
import 'bank_accounts_dummy.dart';

import 'package:dio/dio.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';

import 'package:p_on/screen/main/user/token_state.dart';
import 'package:p_on/screen/main/user/user_state.dart';

import 'home_scroll_provider/scroll_controller_provider.dart';
import 'package:p_on/screen/main/tab/tab_item.dart';

class HomeFragment extends ConsumerStatefulWidget {
  const HomeFragment({super.key});

  @override
  ConsumerState<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends ConsumerState<HomeFragment> {
  // final 문제였슴 ㅡㅡ
  late ScrollController scrollController;
  List<dynamic>? promise;

  @override
  void initState() {
    print('f_home');

    super.initState();
    scrollController = ref.read(homeScrollControllerProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    if (!mounted) return;
    final floatingState = ref.read(floatingButtonStateProvider);
    if (scrollController.position.pixels > 100 && !floatingState.isSmall) {
      ref.read(floatingButtonStateProvider.notifier).changeButtonSize(true);
    } else if (scrollController.position.pixels < 100 &&
        floatingState.isSmall) {
      ref.read(floatingButtonStateProvider.notifier).changeButtonSize(false);
    }
  }

  // 뺴버리면 에러 안뜸
  // @override
  void dispose() {
    scrollController.removeListener(_scrollListener); // 리스너 해제
    super.dispose();
  }

  late var _user;

  @override
  Widget build(BuildContext context) {
    scrollController = ref.watch(homeScrollControllerProvider);
    _user = ref.watch(userStateProvider);
    ref.watch(currentTabProvider);

    return Container(
      // color: Colors.white,
      child: Stack(
        children: [
          RefreshIndicator(
            color: const Color(0xff3F48CC),
            backgroundColor: const Color(0xffFFBA20),
            edgeOffset: PONAppBar.appBarHeight,
            onRefresh: () async {
              const MyPlanAndPromise();
              await sleepAsync(2000.ms);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: PONAppBar.appBarHeight + 10,
                bottom: BottomFloatingActionButton.height,
              ),
              // 반응형으로 만들기위해서 컨트롤넣음
              controller: scrollController,
              // 리스트가 적을때는 스크롤이 되지 않도록 기본 설정이 되어있는 문제해결.
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 멘트
                  RoundedContainer(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          '${_user?.nickName ?? ''}'
                              .text
                              .fontWeight(FontWeight.w800)
                              .size(26)
                              .color(AppColors.mainBlue)
                              .make(),
                          '님,'
                              .text
                              .semiBold
                              .size(24)
                              .color(Colors.black)
                              .make(),
                        ],
                      ),
                      '다가오는 약속이 있어요!'
                          .text
                          .semiBold
                          .size(24)
                          .color(Colors.black)
                          .make(),
                    ],
                  )),
                  // 약속방들
                  const MyPlanAndPromise(),
                  height100
                ],
              ),
            ),
          ),
          const PONAppBar(),
        ],
      ),
    );
  }
}
