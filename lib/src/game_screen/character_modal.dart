import 'package:dev_rpg/src/game_screen/character_style.dart';
import 'package:dev_rpg/src/game_screen/skill_badge.dart';
import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:dev_rpg/src/widgets/buttons/wide_button.dart';
import 'package:dev_rpg/src/widgets/keyboard.dart';
import 'package:dev_rpg/src/widgets/prowess_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:flare_flutter/flare_controls.dart';

/// Displays the stats of an [Character] and offers the option to upgrade them.
class CharacterModal extends StatelessWidget {
  final FlareControls _controls = FlareControls();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    var character = Provider.of<Character>(context);
    var characterStyle = CharacterStyle.from(character);
    FocusScope.of(context).requestFocus(_focusNode);
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {
        if (event.runtimeType == RawKeyDownEvent &&
            (event.logicalKey.keyId == KeyCode.backspace ||
                event.logicalKey.keyId == KeyCode.escape)) {
          _focusNode.unfocus();
          Navigator.pop(context, null);
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              borderOnForeground: false,
              color: Colors.transparent,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(241, 241, 241, 1.0),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: FlareActor(characterStyle.flare,
                            alignment: Alignment.topCenter,
                            shouldClip: false,
                            fit: BoxFit.contain,
                            animation: "idle",
                            controller: _controls),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: ButtonTheme(
                          minWidth: 0.0,
                          child: FlatButton(
                            padding: const EdgeInsets.all(0.0),
                            shape: null,
                            onPressed: () => Navigator.pop(context, null),
                            child: const Icon(
                              Icons.cancel,
                              color: Color.fromRGBO(69, 69, 82, 1.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Level ${character.level}",
                          style:
                              contentStyle.apply(color: secondaryContentColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0, bottom: 6.0),
                          child: Text(
                            characterStyle.name,
                            style: contentLargeStyle,
                          ),
                        ),
                        Text(
                          characterStyle.description,
                          style: contentSmallStyle,
                        ),
                        Column(
                          children: character.prowess.keys
                              .map((Skill skill) => Padding(
                                    padding: const EdgeInsets.only(top: 32.0),
                                    child: Column(children: <Widget>[
                                      Row(
                                        children: [
                                          Row(children: [
                                            const Icon(Icons.chevron_right,
                                                color: skillTextColor),
                                            const SizedBox(width: 4),
                                            Text(
                                              skillDisplayName[skill],
                                              style: contentStyle.apply(
                                                  color: skillTextColor),
                                            )
                                          ]),
                                          Expanded(child: Container()),
                                          Text(
                                            character.prowess[skill].toString(),
                                            style: contentLargeStyle,
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: ProwessProgress(
                                            color: skillColor[skill],
                                            borderRadius:
                                                BorderRadius.circular(3.5),
                                            progress:
                                                character.prowess[skill] / 100),
                                      )
                                    ]),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 40),
                        WideButton(
                          onPressed: () {
                            if (character.canUpgrade && character.upgrade()) {
                              _controls.play("success");
                            }
                          },
                          paddingTweak: const EdgeInsets.only(right: -7.0),
                          background: character.canUpgrade
                              ? const Color.fromRGBO(84, 114, 239, 1.0)
                              : contentColor.withOpacity(0.1),
                          child: Row(
                            children: [
                              Text(
                                character.isHired ? "UPGRADE" : "HIRE",
                                style: buttonTextStyle.apply(
                                  color: character.canUpgrade
                                      ? Colors.white
                                      : contentColor.withOpacity(0.25),
                                ),
                              ),
                              Expanded(child: Container()),
                              const Icon(Icons.stars,
                                  color: Color.fromRGBO(249, 209, 81, 1.0)),
                              const SizedBox(width: 4),
                              Text(
                                character.upgradeCost.toString(),
                                style: buttonTextStyle.apply(
                                  fontSizeDelta: -2,
                                  color: character.canUpgrade
                                      ? const Color.fromRGBO(241, 241, 241, 1.0)
                                      : contentColor.withOpacity(0.25),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}