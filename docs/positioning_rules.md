# Positioning Rules — Volleyball Manager

Canonical reference for court positioning logic in the match simulation.
Update this document whenever a confirmed rule changes. If code and doc conflict, challenge
the user and update whichever is wrong.

Coordinates: `nx` = 0.0 (own endline) → 1.0 (net); `ny` = 0.0 (top sideline) → 1.0 (bottom).
Home team: right side = bottom screen (high y). Away team: mirror of home in x; same absolute y.

---

## 1. Rotation Zone Map (5-1 System)

| Rotation | Z1 (back-right) | Z2 (front-right) | Z3 (front-mid) | Z4 (front-left) | Z5 (back-left) | Z6 (back-mid) | Bench |
|----------|-----------------|------------------|----------------|-----------------|----------------|---------------|-------|
| R1 (S serves) | S | OH1 | MB1 | OPP | OH2 | L→MB2 | MB2 |
| R2 (OH1 serves) | OH1 | MB1 | OPP | OH2 | L→MB2 | S | MB2 |
| R3 (MB1 serves) | L→MB1 | OPP | OH2 | MB2 | S | OH1 | MB1 |
| R4 (OPP serves) | OPP | OH2 | MB2 | S | OH1 | L→MB1 | MB1 |
| R5 (OH2 serves) | OH2 | MB2 | S | OH1 | L→MB1 | OPP | MB1 |
| R6 (MB2 serves) | L→MB2 | S | OH1 | MB1 | OPP | OH2 | MB2 |

Libero replaces the back-row MB. In R3/R6 (MB serves), Libero goes to bench and MB returns.

---

## 2. Attack Formation — Attacker Assignment

| Set type | Attacker | Notes |
|----------|----------|-------|
| leftSideHigh / leftSideTempo | OH1 (front row) else OH2 | OH always attacks from left (zone 4) |
| rightSideHigh / rightSideTempo | OPP | OPP always attacks from right (zone 2) |
| middle | Front-row MB (MB1 or MB2, whichever is not bench) | |
| backrow | OPP | OPP is always in zone 1 (back-right) |
| pipe | Back-row OH (whichever OH is NOT in front row) | Attacks from approximately 2 m behind net |
| tip | S | Setter tips from front court |

### Approach positions (staging for approach animation)

OH always attacks from **left side** — ny ≈ 0.10 (home) / 0.90 (away).
OPP always attacks from **right side** — ny ≈ 0.90 (home) / 0.10 (away).
MB attacks from **centre** — ny = 0.50.

### R1 edge case (S at zone 1)
In R1, OH1 is at zone 2 (right-front) and OPP is at zone 4 (left-front) due to rotation.
Both players **cross the court** during the approach animation — this is correct volleyball
behaviour ("switch after serve"). Staging positions in `positions.json` setting phase correctly
place them at the appropriate sideline (OH1 at top/left, OPP at bottom/right for home) so the
approach animation runs smoothly toward their attack pin.

**Attack contact point** — always computed from set-outcome y, not the setting-formation y,
so the contact point is correct regardless of which zone rotation has placed the attacker in.

---

## 3. Blocking Rules (Defending Team — during receive/attack phase)

### Block count (driven by pass quality of receiving team)
| Pass quality | Block count |
|-------------|-------------|
| perfect | 1 blocker |
| average | 2 blockers |
| singleOption | 3 blockers |

### Side attacks (leftSide / rightSide)

Line zone: zone 2 for leftSide attacks; zone 4 for rightSide attacks.

**Blocker order — always [line, MB, remaining]:**
| Index | Role | Net position |
|-------|------|-------------|
| 0 | Non-MB player at the line zone | Attack-side edge (line) |
| 1 | MB | Seam (closes in from zone 3 centre) |
| 2 | Remaining front-row player (3-block only) | Furthest inside |

**MB is NEVER the line blocker** — even if rotation has placed MB at the line zone (e.g. MB at
zone 4 in R3 defending rightSide). When this happens, the non-MB player physically closest to
the line zone (by zone number distance) takes the line instead. MB always occupies the seam.

**MB is NEVER a solo blocker.** There are always at least two eligible non-bench front-row
players in a 5-1 rotation.

**MB transition to zone 3 after serve:** The defense formation JSON moves the front-row MB to
`(nx=0.88, ny=0.50)` — zone 3, centre of the net — during every serve flight. From zone 3, MB
can close to either side's seam naturally. This is the standard starting position for MB on
every blocking scenario.

### MB position — 1-block
After jumping to contest the middle attack, MB lands in the centre of the court and
**cannot make it to the outside in time**. MB holds their mid-court centre position:
`nx ≈ 0.65, ny = 0.50`. They do NOT go to the net.

The real-world scenario: MB jumps to block the opposing MB's quick attack, lands, and stays in
the centre while the single outside blocker takes the line on the side attack.

### Middle / backrow / pipe / tip attacks
MB goes first (closest to attack centre), remaining front-row wings sorted by proximity.

---

## 4. Sharp-Cross Defence (Front-Court)

Applies to **1-block and 2-block** on side attacks. The remaining non-blocking, non-MB
front-row player defends the sharp-cross angle:

| Attack | Target zone | Sharp-cross player |
|--------|------------|-------------------|
| leftSide | zone 4 player | (fallback: any eligible non-MB front-row non-blocker) |
| rightSide | zone 2 player | (fallback: any eligible non-MB front-row non-blocker) |

Rules:
- MB is **never** eligible for sharp-cross.
- S **is** eligible if front-court (zone 2, 3, or 4).
- OPP is eligible if front-court.
- In a **3-block**, all front-row players are at the net — no sharp-cross defender is assigned.

---

## 5. Floor Defence (Back-Row) During Attack Phase

Zone map from `ReceiveFormationCalculator.backRowZoneMapFor(rotation)`.
In R3/R6 serving (Libero bench): the receive-bench MB fills zone 1.

| Zone | Default role | Side-attack adjustment |
|------|-------------|----------------------|
| Z1 (back-right) | S or OPP (rotation-dependent) | Line defence vs rightSide; cross defence vs leftSide |
| Z5 (back-left) | OH2 or L (rotation-dependent) | Line defence vs leftSide; cross defence vs rightSide |
| Z6 (back-centre) | MB or OH1 (rotation-dependent) | Shifts 40% toward cross-court zone for side attacks |

Zone-6 (P6) defender shifts 40% toward the cross-court side — zone 5 for leftSide, zone 1 for
rightSide attacks.

---

## 6. Pass Direction — singleOption

When pass quality is `singleOption` (serve forces predictable attack direction):

| Serve zone | Forced attack |
|-----------|--------------|
| zone5 / seam56 | leftSideHigh only |
| zone1 / seam16 | rightSideHigh only |
| zone6 (centre) | Random (both options available) |

Physical rationale: if the serve lands near the left sideline (zone5), it is geometrically
impossible for the passer to redirect the ball cross-court to the right side.

---

## 7. OH2 Approach Position

OH2 uses the same approach y as OH1 (ny = 0.10 home / 0.90 away) when attacking from the left
side. This is correct because OH2, when used as the pipe/back-row attacker, starts further back
in their run-up and contacts the ball approximately 2 m from the net — matching the same
left-side lateral coordinate as OH1's approach.

---

## 8. Confirmed Rule Reference (challenge user if violated)

| # | Rule | Implemented |
|---|------|-------------|
| 1 | MB never on the line in any block count | ✓ |
| 2 | MB never solo blocker | ✓ |
| 3 | MB always index 1 (seam) in 2-block | ✓ |
| 4 | MB holds mid-court centre in 1-block (nx=0.65, ny=0.50) | ✓ |
| 5 | MB transitions to zone 3 net (nx=0.88, ny=0.50) during every serve | ✓ (defense JSON) |
| 6 | Line blocker = non-MB player at line zone (zone 2 for leftSide, zone 4 for rightSide) | ✓ |
| 7 | When no non-MB at line zone: closest non-MB takes line | ✓ |
| 8 | Backrow attacker = OPP (always in zone 1) | ✓ |
| 9 | Pipe attacker = back-row OH (whichever OH is not front-row) | ✓ |
| 10 | OH always attacks from left side (zone 4) | ✓ |
| 11 | OPP always attacks from right side (zone 2) | ✓ |
| 12 | Z6 floor defender shifts 40% toward cross-court on side attacks | ✓ |
| 13 | singleOption forced by serve zone (z5→left, z1→right, z6→random) | ✓ |

---

## 9. Open / Deferred

- **Tip defence**: no short-ball coverage assigned. Deferred.
- **3-block sharp-cross**: with all three front-row players at net, no sharp-cross assigned (correct per user confirmation).
- **R5 blocking at P2 (leftSide defence)**: In R5 home serving, S is at zone 2 (P2). By default tactics, S/OPP should be blocking at P2. Currently S is excluded from all blocking. Needs resolution — should S be allowed to block in specific rotations, or should OPP (back-row in R5) cover P2?
- **HOME R4 MB on line**: Under investigation. Code analysis shows OH2 always takes line (index 0), MB2 always seam (index 1). Requires screenshot + debug log set-type to reproduce.
