import 'package:flutter/material.dart';
import 'package:gossip_app/utils/colors_const.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Alert CommonMessage(
  context, {
  required String errorTxt,
  bool showIcon = true,
  int btnType = 1,
  List<DialogButton>? buttons,
}) =>
    Alert(
      onWillPopActive: buttons != null,
      context: context,
      style: AlertStyle(
        backgroundColor: Colors.white,
      ),
      closeIcon: Container(),
      content: Column(
        children: [
          if (showIcon)
            Icon(
              btnType == 1
                  ? FontAwesomeIcons.circleExclamation
                  : btnType == 2
                      ? FontAwesomeIcons.triangleExclamation
                      : FontAwesomeIcons.checkDouble,
              color: btnType == 1
                  ? kErrorMessageColor
                  : btnType == 2
                      ? Colors.amber
                      : kSuccessColor,
              size: 25,
            ),
          if (showIcon)
            Text(
              btnType == 1
                  ? 'Error Message'
                  : btnType == 2
                      ? "Warning Message"
                      : "Information",
              style: TextStyle(
                color: btnType == 1
                    ? kErrorMessageColor
                    : btnType == 2
                        ? Colors.amber
                        : kSuccessColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          Text(
            errorTxt,
            style: TextStyle(
              fontSize: 17,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
      buttons: buttons ?? [],
    );
