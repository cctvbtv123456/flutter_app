import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/shop/constants/index.dart';
import 'package:flutter_app2/shop/search/hotSug.dart';
import 'package:flutter_app2/shop/search/recomend.dart';
import 'package:flutter_app2/shop/search/topbar.dart';
import 'package:flutter_app2/shop/services/search.dart';
import 'searchlist.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {

  List hotWords = [];
  List<String> recomendWords = [];
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: KColorConstant.searchAppBarBgColor,
          leading: SearchTopBarLeadingWidget(),
          actions: <Widget>[
            SearchTopBarActionWidget(
              //跳转到搜索列表
              onActionTap: () => goSearchList(controller.text),
            )
          ],
          elevation: 0,
          titleSpacing: 0,
          title: SearchTopBarTitleWidget(
            seachTxtChanged: seachTxtChanged,
            controller: controller,
          )),
      body: recomendWords.length == 0
          ? HotSugWidget(hotWords:hotWords,goSearchList: goSearchList,)
          : RecomendListWidget(recomendWords, onItemTap: goSearchList),
    );
  }

  void initData() async {
    List querys = await getHotSugs();
    setState(() {
      hotWords = querys;
    });
  }

  onSearchBtTap() {
    if (controller.text.trim().isNotEmpty) {
      goSearchList(controller.text);
    }
  }

  void seachTxtChanged(String q) async {
    var result = await getSuggest(q) as List;
    recomendWords = result.map((dynamic i) {
      List item = i as List;
      return item[0] as String;
    }).toList();
    //刷新界面
    setState(() {});
  }

  goSearchList(String keyWord) {
    if (keyWord.trim().isNotEmpty) {
      Navigator.push(context,
          CupertinoPageRoute(builder: (BuildContext context) {
        return SearchResultListPage(keyWord);
      }));
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }
}
