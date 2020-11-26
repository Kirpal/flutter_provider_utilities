

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_utilities/src/mixin/message_notifier_mixin.dart';
import 'package:tuple/tuple.dart';

class MessageListener<T extends MessageNotifierMixin> extends StatelessWidget {

  final Widget child;
  final void Function(String error) onError;

  final void Function() onErrorTap;
  final String errorActionLabel;
  final Color errorActionLabelColor;

  final void Function() onInfoTap;
  final String infoActionLabel;
  final Color infoActionLabelColor;

  final Duration snackBarDisplayTime;

  const MessageListener({Key key, @required this.child, this.onError, this.onErrorTap, this.errorActionLabel = 'Segnala', this.errorActionLabelColor = Colors.white, this.onInfoTap, this.infoActionLabel = 'Info', this.infoActionLabelColor = Colors.white, this.snackBarDisplayTime = const Duration(milliseconds: 4000)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<T, Tuple2<String, String>>(
      selector: (ctx, model) => Tuple2(model.error, model.info),
      shouldRebuild: (before, after) {
        return before.item1 != after.item1 || before.item2 != after.item2;
      },
      builder: (context, tuple, child){
        if (tuple.item1 != null) { 
          WidgetsBinding.instance.addPostFrameCallback((_){
            _handleError(context, tuple.item1); });
        }
        if (tuple.item2 != null) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            _handleInfo(context, tuple.item2); });
        }
        return child;
      },
      child: child
    );
  }

  void _handleError(BuildContext context, String error) {
    if (ModalRoute.of(context).isCurrent){
      Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[600],
          duration: snackBarDisplayTime,
          action: onErrorTap != null ? SnackBarAction(
            label: errorActionLabel,
            onPressed: onErrorTap,
            textColor: errorActionLabelColor
          ) : null,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.error),
              Expanded(child: Padding( padding:EdgeInsets.only(left:16), child:Text(error) ))
            ],
          ),
        ),
      );
      if (onError != null) { onError(error); }
      Provider.of<T>(context, listen: false).clearError();
    }
  }

  void _handleInfo(BuildContext context, String info) {
    if (ModalRoute.of(context).isCurrent){
      Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.lightBlue,
          duration: snackBarDisplayTime,
          action: onErrorTap != null ? SnackBarAction(
            label: infoActionLabel,
            onPressed: onInfoTap,
            textColor: infoActionLabelColor
          ) : null,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.info),
              Expanded(child: Padding( padding:EdgeInsets.only(left:16), child:Text(info) ))
            ],
          ),
        ),
      );
      Provider.of<T>(context, listen: false).clearInfo();
    }
    
  }

}