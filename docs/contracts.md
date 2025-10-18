# Data Contracts

## positions.json
Key format: `"<team>|<phase>|r<1..6>|<tacticKey>"`.
- team: `home` | `away`
- phase: `serve` | `receive`
- tacticKey:
  - for serve: `default`
  - for receive: `p2_L+OH1`, `p3_L+OH1+OPP`, `p4_default`, etc.

Value:
```json
{
  "anchors": {
    "server_start": {"x": -0.10, "y": 0.75},
    "seam16": {"x": 0.10, "y": 0.63},
    "zone6": {"x": 0.10, "y": 0.50}
  },
  "roles": {
    "S":   {"x": 0.20, "y": 0.65},
    "L":   {"x": 0.25, "y": 0.40},
    "OH1": {"x": 0.30, "y": 0.30}
  }
}