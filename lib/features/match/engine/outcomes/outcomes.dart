enum ServeOutcome { inPlay, fault }

enum PassOutcome { perfect, average, singleOption, overpass, shank }

enum SetOutcome { middle, outside, backrow, pipe, tip }

enum AttackDirection {
  lineDefense,
  crossDefence,
  leftBlock,
  rightBlock,
  noBlock,
  middleBlock,
  seam,
}

enum AttackOutcome { kill, blocked, dug, error }
