import 'package:flutter/material.dart';
import 'package:sgmk_test_task/ui/widgets/text_styles.dart';

class SelectAssertDialog extends StatelessWidget {
  static const List<String> assertsStr = [
    "assets/pizza/p1.png",
    "assets/pizza/p2.png",
    "assets/pizza/p3.png",
    "assets/pizza/p4.png",
  ];
  const SelectAssertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Image",style: TextStyles.header),
      content: SingleChildScrollView(
          child: Center(
              child: Wrap(
                  children:
                  assertsStr.map((e) => AssertCard(e)).toList()))),
    );
  }
}

class AssertCard extends StatelessWidget {
  final String assertStr;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap:  () => Navigator.of(context).pop(assertStr),
        child: SizedBox(
          width: 96,
          height: 96,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(assertStr),
          ),
        ),
      ),
    );
  }

  const AssertCard(this.assertStr, {Key? key}) : super(key: key);
}
