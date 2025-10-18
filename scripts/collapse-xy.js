#!/usr/bin/env node
// Collapse inner objects that are exactly x/y numeric pairs into one line.
// Handles negatives, integers, decimals, and scientific notation.

const fs = require("fs");
const path = process.argv[2];
if (!path) {
  console.error("Usage: node scripts/collapse-xy.js <file>");
  process.exit(1);
}

let text = fs.readFileSync(path, "utf8");

// Number: optional sign, int/float (incl .5 and 10.), optional exponent
const NUM = String.raw`[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?`;

// { "x": <num>, "y": <num> }
const xy = new RegExp(
  String.raw`\{\s*"x"\s*:\s*(${NUM})\s*,\s*"y"\s*:\s*(${NUM})\s*\}`,
  "g"
);

// { "y": <num>, "x": <num> }
const yx = new RegExp(
  String.raw`\{\s*"y"\s*:\s*(${NUM})\s*,\s*"x"\s*:\s*(${NUM})\s*\}`,
  "g"
);

// Replace with canonical order
text = text.replace(xy, `{ "x": $1, "y": $2 }`).replace(yx, `{ "x": $2, "y": $1 }`);

fs.writeFileSync(path, text);