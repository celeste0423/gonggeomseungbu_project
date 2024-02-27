import 'package:circular_motion/circular_motion.dart';
import 'package:flutter/material.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:rive/rive.dart';

class CharacterList extends StatelessWidget {
  List<RoomStreamModel> roomStreamList;

  CharacterList({
    Key? key,
    required this.roomStreamList,
  }) : super(key: key);

  late List<List<SMINumber?>> stateMachineList =
      List<List<SMINumber?>>.generate(
    roomStreamList.length,
    (roomStreamIndex) => List<SMINumber?>.generate(
      4,
      (stateMachineIndex) => null,
    ),
  );

  late List<StateMachineController?> riveControllers = List.generate(
    roomStreamList.length,
    (index) => null,
  );

  Widget _characterCard(int index) {
    return Container(
      width: 110,
      height: 110,
      child: RiveAnimation.asset(
        'assets/riv/character.riv',
        stateMachines: ["character"],
        onInit: (artboard) => onRiveInit(artboard, index),
      ),
    );
  }

  void onRiveInit(Artboard artboard, int index) {
    riveControllers[index] =
        StateMachineController.fromArtboard(artboard, 'character');
    artboard.addController(riveControllers[index]!);
    for (int stateMachineIndex = 0;
        stateMachineIndex < 4;
        stateMachineIndex++) {
      stateMachineList[index][stateMachineIndex] = riveControllers[index]!
              .findInput<double>(_getInputNameByIndex(stateMachineIndex))
          as SMINumber;
    }
    riveCharacterInit(index);
  }

  String _getInputNameByIndex(int index) {
    switch (index) {
      case 0:
        return 'action';
      case 1:
        return 'hat';
      case 2:
        return 'shield';
      case 3:
        return 'color';
      default:
        throw Exception('Invalid index: $index');
    }
  }

  void riveCharacterInit(int controllerIndex) {
    CharacterModel characterModel =
        roomStreamList[controllerIndex].characterData!;
    stateMachineList[controllerIndex][0]!.value =
        characterModel.actionState!.toDouble();
    stateMachineList[controllerIndex][1]!.value =
        characterModel.hat!.toDouble();
    stateMachineList[controllerIndex][2]!.value =
        characterModel.shield!.toDouble();
    stateMachineList[controllerIndex][3]!.value =
        characterModel.bodyColor!.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return CircularMotion.builder(
      itemCount: roomStreamList.length,
      builder: (context, index) {
        return _characterCard(index);
      },
    );
  }
}
