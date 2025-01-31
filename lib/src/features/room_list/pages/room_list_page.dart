import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/room_detail/pages/room_detail_page.dart';
import 'package:ggsb_project/src/features/room_list/controllers/room_list_page_controller.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/loading_indicator.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';
import 'package:ggsb_project/src/widgets/text_field_box.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class RoomListPage extends GetView<RoomListPageController> {
  const RoomListPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      title: TitleText(text: '방 목록'),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(right: 20),
      //     child: Image.asset(
      //       'assets/icons/setting.png',
      //       width: 30,
      //     ),
      //   ),
      // ],
    );
  }

  Widget _sayingBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Container(
        height: 80,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: CustomColors.lightGreyBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            ' 끝날 때까지 항상 불가능해 보인다\n– 넬슨 만델라-',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CustomColors.blackText,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  // Widget _sayingBox() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
  //     child: GestureDetector(
  //       onTap: () {
  //         controller.getSaying();
  //       },
  //       child: Container(
  //         height: 80,
  //         width: double.infinity,
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //         decoration: BoxDecoration(
  //           color: CustomColors.lightGreyBackground,
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: Center(
  //           child: SingleChildScrollView(
  //             scrollDirection: Axis.vertical,
  //             child: Obx(
  //                   () => Text(
  //                 controller.saying.value,
  //                 style: const TextStyle(
  //                   color: CustomColors.blackText,
  //                   fontSize: 12,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _roomList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Obx(
        () => !controller.isRoomListLoading.value
            ? !controller.isNoRoomList.value
                ? FutureBuilder<List<RoomModel>>(
                    future: controller.getRoomList(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<RoomModel>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: loadingIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Text('에러 발생');
                      } else {
                        List<RoomModel> roomList = snapshot.data!;
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 30,
                          ),
                          itemCount: roomList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < roomList.length) {
                              return _roomCard(roomList[index]);
                            } else {
                              return _joinRoomCard();
                            }
                          },
                        );
                      }
                    },
                  )
                : CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Get.dialog(_joinRoomDialog());
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/add.svg',
                          color: CustomColors.greyBackground,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '화면을 터치해 방에 가입해 보세요',
                          style: TextStyle(
                            color: CustomColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  )
            : Center(child: loadingIndicator()),
      ),
    );
  }

  Widget _roomCard(RoomModel roomModel) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Get.to(() => const RoomDetailPage(), arguments: roomModel);
      },
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.nameToRoomColor(roomModel.color!),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 16),
              Text(
                roomModel.roomName!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${roomModel.uidList!.length}/6명',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        roomModel.creatorName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    roomModel.roomType == 'day' ? '일 단위' : '기간 없음',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _joinRoomCard() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Get.dialog(_joinRoomDialog());
      },
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.lightGreyBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              SvgPicture.asset(
                'assets/icons/add.svg',
                width: 25,
                color: CustomColors.greyBackground,
              ),
              const SizedBox(height: 20),
              const Text(
                '방에 참가하기',
                style: TextStyle(
                  color: CustomColors.lightGreyText,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _joinRoomDialog() {
    return Dialog(
      child: Container(
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: CustomColors.whiteBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '방에 참가하기',
              style: TextStyle(
                color: CustomColors.blackText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextFieldBox(
              textEditingController: controller.joinRoomIdController,
              hintText: '초대코드를 입력해주세요',
              backgroundColor: CustomColors.lightGreyBackground,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: MainButton(
                    buttonText: '취소',
                    onTap: () {
                      Get.back();
                    },
                    backgroundColor: CustomColors.greyBackground,
                    height: 45,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MainButton(
                    buttonText: '참가',
                    onTap: () {
                      controller.joinRoomButton();
                    },
                    height: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(RoomListPageController());
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: Column(
          children: [
            _sayingBox(),
            Expanded(child: _roomList()),
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}
