import 'package:p_on/common/cli_common.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/fab/w_bottom_nav_floating_button.riverpod.dart';
import 'package:p_on/screen/main/s_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/tab/promise_room/f_create_promise.dart';
import 'package:p_on/screen/main/tab/schedule/f_create_schedule.dart';
import 'package:p_on/screen/main/tab/tab_item.dart';

import '../../../common/widget/animated_width_collapse.dart';

class BottomFloatingActionButton extends ConsumerWidget {
  static const height = 100.0;
  BottomFloatingActionButton({super.key});

  final duration = 300.ms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
//     final floatingButtonState = ref.watch(floatingButtonStateProvider);
//     final isSmall = floatingButtonState.isSmall;
//     final isExpanded = floatingButtonState.isExpanded;
//     final isHided = floatingButtonState.isHided;

    final isSmall = ref.watch(floatingButtonStateProvider).isSmall; // 필요하다면 유지
    final currentTab = ref.read(currentTabProvider);

    return Align(
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 스위치 문으로 사용할 필요가 있네
          switch(currentTab){
            TabItem.home => Tap(
              onTap: () {
                Nav.push(const CreatePromise());
              },
              child: AnimatedContainer(
                duration: duration,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: const Color(0xff3F48CC),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0, 4))
                    ]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 30,),
                    AnimatedWidthCollapse(
                      visible: !isSmall,
                      duration: duration,
                      child: SizedBox(width: 5), // 텍스트가 보일 때 사이 간격
                    ),
                    AnimatedWidthCollapse(
                      visible: !isSmall,
                      duration: duration,
                      child: '약속생성'.text.white.fontFamily('Pretendard').fontWeight(FontWeight.w500).make(),
                    )
                  ],
                ),
              ),
            ).pOnly(
                bottom: MainScreenState.bottomNavigatorHeight +
                    context.viewPaddingBottom +
                    10,
                right: 20),
            TabItem.history => SizedBox.shrink(),
            TabItem.blankField => SizedBox.shrink(),
            TabItem.plan => Tap(
              onTap: () {
                // Nav.push(const LastCreateSchedule());
                Nav.push(const CreateSchedule());
              },
              child: AnimatedContainer(
                duration: duration,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColors.calendarYellow,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0, 4))
                    ]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: AppColors.mainBlue, size: 30,),
                    AnimatedWidthCollapse(
                      visible: !isSmall,
                      duration: duration,
                      child: SizedBox(width: 5), // 텍스트가 보일 때 사이 간격
                    ),
                    AnimatedWidthCollapse(
                      visible: !isSmall,
                      duration: duration,
                      child: '일정생성'.text.hexColor('#3F48CC').fontFamily('Pretendard').fontWeight(FontWeight.w500).make(),
                    )
                  ],
                ),
              ),
            ).pOnly(
                bottom: MainScreenState.bottomNavigatorHeight +
                    context.viewPaddingBottom +
                    10,
                right: 20),
            TabItem.my => SizedBox.shrink(),
          },
        ],
      ),
    );
  }
}


//     return Stack(
//       children: [
//         IgnorePointer(
//           ignoring: !isExpanded,
//           child: AnimatedContainer(
//             duration: duration,
//             color: isExpanded ? Colors.black.withOpacity(0.4) : Colors.transparent,
//           ),
//         ),
//         IgnorePointer(
//           ignoring: isHided,
//           child: Align(
//               alignment: Alignment.bottomRight,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   IgnorePointer(
//                     ignoring: !isExpanded,
//                     child: AnimatedOpacity(
//                       opacity: isExpanded ? 1 : 0,
//                       duration: duration,
//                       child: Column(
//                         children: [
//                           Container(
//                             width: 160,
//                             padding: const EdgeInsets.all(15),
//                             margin: const EdgeInsets.only(right: 15),
//                             decoration: BoxDecoration(
//                                 color: context.appColors.floatingActionLayer,
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Tap(onTap: () {
//                                   context.go('/main/history');
//
//                                 }, child: _floatItem('알바', '$basePath/fab/fab_01.png')),
//                                 _floatItem('과외/클래스', '$basePath/fab/fab_02.png'),
//                                 _floatItem('농수산물', '$basePath/fab/fab_03.png'),
//                                 _floatItem('부동산', '$basePath/fab/fab_04.png'),
//                                 _floatItem('중고차', '$basePath/fab/fab_05.png'),
//                               ],
//                             ),
//                           ),
//                           height5,
//                           Tap(
//                             onTap: () {
//                               // extra: , 이걸통해서 데이터 계속 불러오지 않게 할 수 있다.
//                               Nav.push(const CreatePromise());
//                             },
//                             child: Container(
//                               width: 160,
//                               padding: const EdgeInsets.all(15),
//                               margin: const EdgeInsets.only(right: 15, bottom: 10),
//                               decoration: BoxDecoration(
//                                   color: context.appColors.floatingActionLayer,
//                                   borderRadius: BorderRadius.circular(10)),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   _floatItem('내 물건 팔기', '$basePath/fab/fab_06.png'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Tap(
//                     onTap: () {
//                       ref.read(floatingButtonStateProvider.notifier).onTapButton();
//                     },
//                     child: AnimatedContainer(
//                       duration: duration,
//                       height: 60,
//                       padding: const EdgeInsets.symmetric(horizontal: 18),
//                       decoration: BoxDecoration(
//                           color: isExpanded
//                               ? context.appColors.floatingActionLayer
//                               : const Color(0xff3F48CC),
//                           borderRadius: BorderRadius.circular(30)),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           AnimatedRotation(
//                               turns: isExpanded ? 0.125 : 0,
//                               duration: duration,
//                               child: const Icon(Icons.add, color: Colors.white,)),
//                           AnimatedWidthCollapse(
//                             visible: !isSmall,
//                             duration: duration,
//                             child: '일정 생성'.text.white.make(),
//                           )
//                         ],
//                       ),
//                     ),
//                   ).pOnly(
//                       bottom:
//                       MainScreenState.bottomNavigatorHeight + context.viewPaddingBottom + 10,
//                       right: 20),
//                 ],
//               )),
//         )
//       ],
//     );
//   }
//
//   _floatItem(String title, String imagePath) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Image.asset(
//           imagePath,
//           width: 30,
//         ),
//         const Width(8),
//         title.text.make(),
//       ],
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// class BottomFloatingActionButton extends StatelessWidget {
//   const BottomFloatingActionButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey,
//                 offset: Offset(0, -2),
//                 blurRadius: 3
//             )
//           ]
//       ),
//       child: FloatingActionButton.large(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         onPressed: () {},
//         child: Image.asset('assets/image/main/핑키1.png', fit: BoxFit.contain, width: 85,),
//       ),
//     );
//   }
// }
