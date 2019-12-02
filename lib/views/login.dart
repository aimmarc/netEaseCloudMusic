import 'package:flutter/material.dart';
import 'package:flutter_app/common/global.dart';
import 'package:flutter_app/server/common.dart';
import 'package:flutter_app/util/request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:weui/weui.dart';
import '../layout/sample.dart';

final Widget box = Container(height: 10, child: null);

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State {
  String username = '';
  String password = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Sample(
        '登录',
        describe: false,
        showPadding: false,
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 8),
          child: Column(children: <Widget>[
            WeForm(children: [
              WeInput(
                label: '手机',
                hintText: '请输入手机号码',
                clearable: true,
                maxLength: 11,
                type: TextInputType.phone,
                onChange: (dynamic val) {
                  setState(() {
                    username = val;
                  });
                },
              ),
              WeInput(
                label: '密码',
                hintText: '请输入密码',
                obscureText: true,
                onChange: (dynamic val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
            ]),
            box,
            box,
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(children: <Widget>[
                box,
                box,
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: WeButton(
                    '登录',
                    theme: WeButtonType.warn,
                    loading: _isLoading,
                    onClick: () async {
                      if (username == '') {
                        WeToast.info(context)('请输入手机号');
                        return;
                      }
                      if (password == '') {
                        WeToast.info(context)('请输入密码');
                        return;
                      }
                      setState(() {
                        _isLoading = true;
                      });
                      final response = await DioUtil.getInstance().post(
                          "$API_PREFIX/login/cellphone?phone=$username&password=$password",
                          {'username': username, 'password': password});
                      setState(() {
                        _isLoading = false;
                      });
                      final data = response.data;
                      if (data['code'] == 200) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        data['profile'].forEach((String key, value) {
                          prefs.setString(key, value.toString());
                        });
                        getSongList();
                        Navigator.pop(context);
                      } else {
                        WeToast.info(context)(response.data['message']);
                      }
                    },
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
