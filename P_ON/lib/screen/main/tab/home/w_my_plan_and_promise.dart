import 'package:p_on/common/common.dart';
import 'package:p_on/common/widget/w_list_container.dart';
import 'package:p_on/screen/main/tab/home/vo/vo_bank_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'w_custom_text.dart';

class MyPlanAndPromise extends StatelessWidget {
  final PlanData promise;

  const MyPlanAndPromise(this.promise, {super.key});

  @override
  Widget build(BuildContext context) {
    DateTime? planDate;
    if (promise.PlanDate != "미정") {
      planDate = DateTime.parse(promise.PlanDate);
    }

    final currentDate = DateTime.now();
    bool isClose = false;

    if (planDate != null) {
      final diff = currentDate.difference(planDate).inDays;
      if (diff.abs() < 3) {
        isClose = true;
      }
    }

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: double.infinity,
          child: ListContainer(
            isDateClose: isClose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                      promise.Plantitle.length > 12
                          ? '${promise.Plantitle.substring(0, 12)}...'
                          : promise.Plantitle,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                          color: isClose ? Colors.white : Colors.black)),
                ),
                Container(
                  height: 30,
                  child: Row(children: [
                    CustomText(text: '일시 | ', textColor: isClose),
                    promise.PlanDate == '미정'
                        ? const CreateVote()
                        : CustomText(
                            text: promise.PlanDate, textColor: isClose),
                  ]),
                ),
                Container(
                  height: 30,
                  child: Row(
                    children: [
                      CustomText(text: '시간 | ', textColor: isClose),
                      promise.PlanTime == '미정'
                          ? const CreateVote()
                          : CustomText(
                              text: promise.PlanTime, textColor: isClose),
                    ],
                  ),
                ),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomText(text: '장소 | ', textColor: isClose),
                          promise.PlanLocation == '미정'
                              ? const CreateVote()
                              : CustomText(
                                  text: promise.PlanLocation,
                                  textColor: isClose),
                        ],
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: const Color(0xffEFF3F9),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..scale(-1.0, 1.0),
                              child: IconButton(
                                icon: const Icon(Icons.chat_bubble, size: 15),
                                onPressed: () {
                                  // 버튼 누르면 해당 채팅방으로 이동
                                  print('눌렸');
                                },
                                color: Color(0xffFFBA20),
                              ),
                            ),
                          ),
                          if (promise.PlanChat)
                          const Positioned(
                              right: 5,
                              top: 5,
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.red,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            right: 20,
            child: Image(
              image: isClose
                  ? const AssetImage('assets/image/main/핑키3.png')
                  : const AssetImage('assets/image/main/핑키2.png'),
              fit: BoxFit.contain,
              width: 60,
            )),
      ],
    );
    // 받아온 데이터에 미정 포함되면 투표생성 버튼 보여주기
  }
}

class CreateVote extends StatelessWidget {
  const CreateVote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      width: 80,
      height: 25,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(const Color(0xFFFF7F27)),
        ),
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '투표',
              style: TextStyle(color: Color(0xFFFF7F27), fontSize: 14),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFFF7F27))
          ],
        ),
      ),
    );
  }
}