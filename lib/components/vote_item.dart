import 'package:demos/components/vote_bar.dart';
import 'package:demos/components/vote_caption.dart';
import 'package:demos/models/vote.dart';
import 'package:flutter/material.dart';

class VoteItem extends StatelessWidget {

  final Vote vote;

  const VoteItem({Key? key, required this.vote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Choice> choicesList =
    vote.choices.entries.map( (entry) => Choice(entry.key, entry.value)).toList();
    return Card(
      margin: const EdgeInsets.all(16.0),
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _titleWidget(),
            _progressBarWidget(choicesList),
            _captionWidget(choicesList),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget(){
    return Text(vote.title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),);
  }

  Widget _progressBarWidget(List<Choice> choices){
    return VoteBar(choices: choices);
  }

  Widget _captionWidget(List<Choice> choices){
    return VoteCaption(choices: choices);
  }

}
