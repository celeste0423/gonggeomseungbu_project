import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/constants/service_urls.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:http/http.dart' as http;

class SignupPageController extends GetxController {
  Rx<String> uid = ''.obs;
  Rx<String> email = ''.obs;

  Rx<bool> isSignupLoading = false.obs;

  TextEditingController nicknameController = TextEditingController();

  Rx<bool> isSchoolLoading = false.obs;
  String nullSchoolName = '학교를 검색하세요(선택)';
  late Rx<String> schoolName = nullSchoolName.obs;
  TextEditingController schoolSearchController = TextEditingController();
  String selectedSchoolType = 'elem_list';
  late RxList<dynamic> schoolNameList = [nullSchoolName].obs;

  Rx<bool> isMale = true.obs;

  Future<List<String>> searchSchools(
    String searchQuery,
    String gubun,
  ) async {
    // API 엔드포인트
    String apiUrl =
        '${ServiceUrls.schoolApiRequestUrl}${dotenv.env['SCHOOL_API_SECRET_KEY']}&svcType=api&svcCode=SCHOOL&contentType=json&gubun=$gubun&searchSchulNm=$searchQuery';
    // HTTP GET 요청 보내기
    http.Response response = await http.get(Uri.parse(apiUrl));
    // HTTP 응답 확인
    if (response.statusCode == 200) {
      // JSON 데이터 파싱
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> content = data['dataSearch']['content'];
      // schoolName 필드 값만 추출하여 List<String>에 추가

      List<String> schoolInfos = [];
      for (var item in content) {
        String schoolInfo = '${item['schoolName']} (${item['region']})';
        schoolInfos.add(schoolInfo);
        // List<String> schoolNames = [];
        // for (var item in content) {
        //   schoolNames.add(item['schoolName']);
      }
      return schoolInfos;
    } else {
      // HTTP 요청이 실패한 경우 에러 처리
      throw openAlertDialog(
          title: '학교 정보 로드에 실패했습니다.',
          content: '에러코드: ${response.statusCode.toString()}');
    }
  }

  void schoolSearchButton() async {
    isSchoolLoading(true);
    schoolNameList(
        await searchSchools(schoolSearchController.text, selectedSchoolType));
    print(schoolNameList.value);
    isSchoolLoading(false);
  }

  Future<void> signUpButton() async {
    isSignupLoading(true);
    if (nicknameController.text == '') {
      isSignupLoading(false);
      openAlertDialog(title: '닉네임을 입력해주세요');
    } else {
      UserModel userData = UserModel(
        uid: uid.value,
        deviceToken: await AuthController().getDeviceToken(),
        nickname: nicknameController.text,
        loginType: AuthController.loginType,
        email: email.value,
        gender: isMale.value ? 'male' : 'female',
        school: schoolName.value == nullSchoolName ? null : schoolName.value,
        isTimer: false,
        totalSeconds: 0,
        cash: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await AuthController.to.signUp(userData);
      isSignupLoading(false);
    }
  }
}
