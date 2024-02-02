import 'package:event/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

SnackBar delegatedSnackBar(String output, bool isSuccess) {
  return SnackBar(
    content: Stack(
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
              color: isSuccess
                  ? Constants.primaryColor
                  : Constants.secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Row(
            children: [
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      isSuccess ? "Oh Great!" : "Oh snap!",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      output,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: SvgPicture.asset(
            "assets/bubbles.svg",
            height: 48,
            width: 40,
            color: isSuccess
                ? Constants.primaryColor
                : Constants.secondaryColor,
          ),
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
