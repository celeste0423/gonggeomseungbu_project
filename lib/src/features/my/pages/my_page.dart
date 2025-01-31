import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/data_analyze/page/data_analyze_page.dart';
import 'package:ggsb_project/src/features/my/controllers/my_page_controller.dart';
import 'package:ggsb_project/src/features/result/pages/result_page.dart';
import 'package:ggsb_project/src/features/setting/pages/setting_page.dart';
import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:ggsb_project/src/widgets/loading_indicator.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';
import 'package:rive/rive.dart';

class MyPage extends GetView<MyPageController> {
  const MyPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: false,
      title: TitleText(
        text: 'My',
      ),
    );
  }

  Widget _profile() {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${AuthController.to.user.value.nickname}님 \n안녕하세요 :)',
                style: const TextStyle(
                  color: CustomColors.blackText,
                  fontSize: 24,
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  controller.profileEditButton();
                },
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Image.asset(
                  'assets/icons/edit.png',
                  width: 20,
                ),
              )
            ],
          ),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            color: CustomColors.lightGreyBackground,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(35)),
            child: OverflowBox(
              maxHeight: double.infinity,
              maxWidth: double.infinity,
              alignment: Alignment.topCenter,
              child: Container(
                width: 180,
                height: 180,
                padding: const EdgeInsets.only(right: 2, bottom: 10),
                child: RiveAnimation.asset(
                  'assets/riv/character.riv',
                  stateMachines: ["character"],
                  onInit: controller.onRiveInit,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _graphBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            height: 160,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: StreamBuilder(
              stream: controller.timeModelStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: loadingIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('불러오는 중 에러가 발생했습니다.');
                } else {
                  //스냅샷 정리
                  controller.arrangeTimeModels(snapshot);
                  return Row(
                    children: List.generate(7, (index) {
                      return _dateBar(controller.studyTimeModelList[index]);
                    }),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '지난 7일간 공부시간',
                style: TextStyle(
                  color: CustomColors.greyText,
                  fontSize: 13,
                ),
              ),
              Text(
                controller.totalSecondsDigit,
                style: const TextStyle(
                  color: CustomColors.blackText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateBar(StudyTimeModel studyTimeModel) {
    // print('데이트바 ${studyTimeModel.date} / ${studyTimeModel.totalSeconds}');
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            height: controller.bestSeconds == 0
                ? 3
                : (100 *
                            studyTimeModel.totalSeconds! /
                            controller.bestSeconds) <
                        3
                    ? 3
                    : (100 *
                        studyTimeModel.totalSeconds! /
                        controller.bestSeconds),
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: DateUtil().dateTimeToString(DateTime.now()) ==
                      studyTimeModel.date
                  ? CustomColors.mainBlue
                  : CustomColors.subPaleBlue,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            DateUtil.getDayOfWeek(
                    DateUtil().stringToDateTime(studyTimeModel.date!))
                .substring(0, 3),
            style: TextStyle(
              color: DateUtil().dateTimeToString(DateTime.now()) ==
                      studyTimeModel.date
                  ? CustomColors.mainBlue
                  : CustomColors.lightGreyText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _button(
          Image.asset(
            'assets/icons/my_data_analyze.png',
            width: 30,
            height: 30,
          ),
          '기록 분석',
          () {
            // openAlertDialog(title: '추후 구현 예정입니다.');
            Get.to(() => const DataAnalyzePage());
          },
        ),
        _button(
          const Icon(
            Icons.analytics_outlined,
            size: 30,
            color: CustomColors.mainBlack,
          ),
          '결과 보기',
          () {
            // openAlertDialog(title: '추후 구현 예정입니다.');
            Get.to(() => const ResultPage());
          },
        ),
        Container(
          color: CustomColors.lightGreyBackground,
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 100,
          height: 1,
        ),
        _button(
          Image.asset(
            'assets/icons/my_settings.png',
            width: 30,
            height: 30,
          ),
          '설정',
          () {
            Get.to(() => const SettingPage());
          },
        ),
        _button(
          Image.asset(
            'assets/icons/my_report.png',
            width: 30,
            height: 30,
          ),
          '문의하기',
          controller.kakaoChannelButton,
        ),
      ],
    );
  }

  Widget _button(Widget icon, String text, VoidCallback onTap) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 5),
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: CustomColors.whiteBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        height: 60,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: CustomColors.blackText,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MyPageController());
    return SafeArea(
      child: Scaffold(
          appBar: _appBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  _profile(),
                  _graphBox(),
                  _buttons(),
                  const SizedBox(height: 95),
                  //height원래 95였으나 에러로 85로 임시로 바꿈
                ],
              ),
            ),
          )),
    );
  }
}
