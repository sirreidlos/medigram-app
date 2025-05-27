import 'package:flutter/material.dart';
import 'package:medigram_app/constants/style.dart';

class PopupHeader extends StatelessWidget {
  const PopupHeader(this.goPage, this.header, this.needConfirmation,
      {super.key});

  final MaterialPageRoute goPage;
  final String header;
  final bool needConfirmation;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        IconButton(
          onPressed: () {
            if (needConfirmation) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: Text(
                          'Are you sure to go back? Your changes will not be saved.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {},
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.push(context, goPage);
                          },
                        ),
                      ],
                    );
                  });
            } else {
              Navigator.push(context, goPage);
            }
          },
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        Text(header, style: header2),
      ],
    );
  }
}
