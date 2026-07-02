import 'package:flutter/material.dart';

/// Fa comparire il [child] con una dissolvenza + risalita dal basso, dopo
/// un ritardo proporzionale a [index]. Usato per far entrare le scelte di
/// dialogo una dopo l'altra invece che tutte insieme, in stile Duskwood.
class StaggeredEntrance extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration stagger;

  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
    this.stagger = const Duration(milliseconds: 90),
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.stagger * widget.index, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : const Offset(0, 0.35),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
