import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sgmk_test_task/ui/home_page.dart';
import 'package:sgmk_test_task/ui/widgets/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool back;
  final List<Widget>? actions;

  const CustomAppBar({Key? key, required this.title, this.actions})
      : preferredSize = const Size.fromHeight(132),
        back = true,
        super(key: key);

  const CustomAppBar.nonBack({Key? key, required this.title, this.actions})
      : preferredSize = const Size.fromHeight(132),
        back = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 74.0, 24.0, 20.0),
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            if (back)
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    color: const Color(0x1AF43F5E),
                    borderRadius: BorderRadius.circular(9.81818)),
                child: InkWell(
                    onTap: () => Navigator.of(context).pushReplacement(Home.route()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.18),
                      child: Image.asset("assets/icons/back.png",
                          width: 8.79,
                          height: 15.35,
                          fit: BoxFit.scaleDown,
                          color: const Color(0xB3F43F5E)),
                    )),
              ),
            if (back) const SizedBox(width: 24),
            Text(
              title,
              style: TextStyles.header,
            ),
          ]),
          if (actions != null)
            Row(
              children: List<Widget>.generate((actions!.length*2)-1,(index) => (index%2)==0?actions![(index+1)~/2]:const SizedBox(width: 50)),
            )
        ],
      ),
    );
  }

  @override
  final Size preferredSize;
}
