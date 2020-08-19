import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Helper.dart';
import 'package:dropdown_search/dropdownSearch.dart' as da;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Helper(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(
            title: Center(child: const Text('Covid19')),
          ),
          body: MyApp2(),
        ),
      ),
    );
  }
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Helper>(context, listen: false);
    final H = MediaQuery
        .of(context)
        .size
        .height;
    return ListView(
      children: <Widget>[
        SizedBox(
          height: H * .1,
        ),
        Center(
          child: const Text(
            'Global',
            style: const TextStyle(
              fontFamily: 'oo',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
        ),
        SizedBox(
          height: H * .02,
        ),
        FutureBuilder(
          initialData: [0, 0, 0, 0, 0, 0],
          future: data.ByAll(),
          builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
            String p =
            ((snapshot.data[1].toDouble() / snapshot.data[0].toDouble()) *
                100)
                .toStringAsFixed(3);
            return FittedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Cloumn("Cases", snapshot.data[0].toString(), 0xffAAAAAA,
                      neww: snapshot.data[3]),
                  const SizedBox(width: 10),
                  Cloumn('Deaths', snapshot.data[1].toString(), 0xffFF0000,
                      neww: snapshot.data[4]),
                  const SizedBox(width: 10),
                  Cloumn('Recovered', snapshot.data[2].toString(), 0xff8ACA2B),
                  const SizedBox(width: 10),
                  Cloumn('Active', snapshot.data[5].toString(), 0xffF5B03B),
                  const SizedBox(width: 10),
                  Cloumn('Deaths Percentage', p + '%', 0xffDCC18F),
                ],
              ),
            );
          },
        ),
        SizedBox(height: H * .1),
        Center(
          child: const Text('SELECT COUNTRY',
              style: const TextStyle(
                fontFamily: 'oo',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              )),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: FutureBuilder(
            future: data.getcountires(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              return da.DropdownSearch(
                dropdownBuilder: (cc, aa, bb) {
                  return Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(aa),
                        SizedBox(
                          width: 10,
                          child: FlatButton(),
                        ),
                        Icon(Icons.expand_more),
                      ],
                    ),
                  );
                },
                searchBoxDecoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search By Country'),
                selectedItem: data.selected,
                items: snapshot.data,
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
                showSearchBox: true,
                onChanged: (selectedItem) {
                  data.setCountry(selectedItem);
                },
              );
            },
          ),
        ),
        SizedBox(
          height: H * .025,
        ),
        Consumer<Helper>(
          builder: (BuildContext context, value, Widget child) {
            return FutureBuilder(
              initialData: [0, 0, 0, 0, 0, 0],
              future: value.ByCounty(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                String p = ((snapshot.data[1].toDouble() /
                    snapshot.data[0].toDouble()) *
                    100)
                    .toStringAsFixed(3);
                return FittedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Cloumn("Cases", snapshot.data[0].toString(), 0xffAAAAAA,
                          neww: snapshot.data[3]),
                      const SizedBox(width: 10),
                      Cloumn('Deaths', snapshot.data[1].toString(), 0xffFF0000,
                          neww: snapshot.data[4]),
                      const SizedBox(width: 10),
                      Cloumn(
                          'Recovered', snapshot.data[2].toString(), 0xff8ACA2B),
                      const SizedBox(width: 10),
                      Cloumn('Active', snapshot.data[5].toString(), 0xffF5B03B),
                      const SizedBox(width: 10),
                      Cloumn('Deaths Percentage', p + '%', 0xffDCC18F),
                    ],
                  ),
                );
              },
            );
          },
        ),
        SizedBox(
          height: H * .2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.home,
              size: 40,
              color: Colors.white,
            ),
            const Text(
              'STAY AT HOME',
              style: const TextStyle(
                  fontFamily: 'oo',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            )
          ],
        )
      ],
    );
  }
}

class Cloumn extends StatelessWidget {
  final String _text;
  final _num;
  final int _c;
  final int neww;

  const Cloumn(this._text, this._num, this._c, {this.neww});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(_text),
        Text(_num,
            style: TextStyle(
                color: Color(_c), fontSize: 23, fontWeight: FontWeight.bold)),
        if (neww != null && neww != 0)
          Text(
            '+' + neww.toString(),
            style: TextStyle(
                backgroundColor: Color(_c),
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold),
          )
      ],
    );
  }
}
