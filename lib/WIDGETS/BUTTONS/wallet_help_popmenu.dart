import 'package:flutter/material.dart';
import 'package:seller_app/SCREENS/wallet/withdrawel_helper.dart';

class HelpPopupMenu extends StatelessWidget {
  final BuildContext context;

  const HelpPopupMenu({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'help',
            child: Text(
              'Help',
              style: TextStyle(
                color: Colors.black87,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ),
        ];
      },
      onSelected: (value) {
        if (value == 'help') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const  WithdrawalHelpPage(),
            ),
          );
        }
      },
    );
  }
}
