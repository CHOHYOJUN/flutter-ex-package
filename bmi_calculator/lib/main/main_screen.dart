import 'package:flutter/material.dart';

import '../result/result_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  // ㅡㅡㅡㅡㅡ [ initState, dispose ] ㅡㅡㅡㅡㅡ

  @override
  void initState() {
    super.initState();

    /// 로드 기능
    load();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // ㅡㅡㅡㅡㅡ [ save, load ] ㅡㅡㅡㅡㅡ

  Future save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('height', double.parse(_heightController.text));
    await prefs.setDouble('weight', double.parse(_weightController.text));
  }

  Future load() async {
    final prefs = await SharedPreferences.getInstance();
    final double? height = prefs.getDouble('height');
    final double? weight = prefs.getDouble('weight');

    if (height != null && weight != null) {
      _heightController.text = '$height';
      _weightController.text = '$weight';
      print('키 : $height, 몸무게 : $weight');
    }
  }

  // ㅡㅡㅡㅡㅡ [ 메인 뷰 ] ㅡㅡㅡㅡㅡ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비만도 계산기'),
      ),
      body: Padding(
        // form()을 padding으로 감쌈
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formKey,
            // GlobalKey<FormState>() <-- 를 통해서 form의 상태를 알 수 가 있다.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end, // 정렬
              children: [
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '키',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? '키를 입력하세요' : null,
                ), // 에러를 표시하는 필드, 사용하려면 Form()으로 감싸줘야 함.
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '몸무게',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? '몸무게 를 입력하세요' : null,
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == false ?? false) {
                        return;
                      }

                      /// 저장 기능
                      save();

                      // navpush -> 라이브 템플릿 추가
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                            height: double.parse(_heightController.text),
                            weight: double.parse(_weightController.text),
                          ),
                        ),
                      );
                    },
                    child: const Text('결과')),
              ],
            )),
      ),
    );
  }
}
