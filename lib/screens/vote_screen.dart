import 'package:demos/components/vote_item.dart';
import 'package:demos/models/vote.dart';
import 'package:demos/services/api_calls.dart';
import 'package:flutter/material.dart';

class VoteScreen extends StatefulWidget {
  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {

  late Future<List<Vote>?> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiCalls.getVotes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Vote>?>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<Vote>?> snapshot) {
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return VoteItem(vote: snapshot.data![index]);
            },
          ): snapshot.hasError ? Text('error'): Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

