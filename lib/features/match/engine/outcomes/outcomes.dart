enum ServeOutcome { inPlay, fault, ace }

enum PassOutcome { perfect, average, singleOption, overpass, shank }

enum SetOutcome {
  leftSideHigh,
  leftSideTempo,
  rightSideHigh,
  rightSideTempo,
  middle,
  backrow,
  pipe,
  tip,
}

enum AttackDirection {
  // OH (left-side) directions ─────────────────────────────────────────────
  ohLine,          // beat block down the line → zone 1 defender
  ohCrossShallow,  // cross court, shallow  → zone 5 defender
  ohCrossSharp,    // sharp angle cross     → zone 4 defender

  // OPP / right-side OH (mirror of OH) ────────────────────────────────────
  oppLine,         // beat block down the line → zone 5 defender
  oppCrossShallow, // cross court, shallow  → zone 1 defender
  oppCrossSharp,   // sharp angle cross     → zone 2 defender

  // MB / pipe / backrow ───────────────────────────────────────────────────
  middleZone1,     // to zone 1
  middleZone5,     // to zone 5
  middleZone6,     // deep to zone 6 (pipe / backrow only)

  // Aimed at the block (all set types) ───────────────────────────────────
  atBlock,
}

enum AttackOutcome { kill, blocked, dug, error }

/// Quality of the transition touch after a dug or partially-blocked attack.
/// Mirrors [PassOutcome] so [getSetOutcome] can reuse the same set-options
/// logic without modification.
///
/// - [perfect]      — Clean dig: setter has full attack repertoire (3 options).
/// - [average]      — Contested dig: setter has tempo options only (2 options).
/// - [singleOption] — Scramble dig: setter forced to one high ball.
/// - [freeball]     — Ball returned softly; opponent receives as a free ball
///                    and attacks again with perfect-quality options.
enum TransitionOutcome { perfect, average, singleOption, freeball }

extension TransitionOutcomeX on TransitionOutcome {
  /// Maps to the equivalent [PassOutcome] so [getSetOutcome] works unchanged.
  /// [freeball] maps to [PassOutcome.average] — the team receiving the free
  /// ball gets decent options but not a full system.
  PassOutcome toPassOutcome() => switch (this) {
        TransitionOutcome.perfect      => PassOutcome.perfect,
        TransitionOutcome.average      => PassOutcome.average,
        TransitionOutcome.singleOption => PassOutcome.singleOption,
        TransitionOutcome.freeball     => PassOutcome.average,
      };
}

/// Result of an attack aimed directly at the block ([AttackDirection.atBlock]).
///
/// - [tool]    — Attacker wipes the block edge; ball goes out on defender's
///               side → point to attacker.
/// - [stuff]   — Blocker controls the ball cleanly → point to defender.
/// - [partial] — Ball deflects off the block and remains on the defender's
///               side; defending team plays the ball as a freeball.
enum BlockTouchResult { tool, stuff, partial }
