// @preval
const data = require('emoji-mart/dist/data').default;
const pick = require('lodash/pick');

const condensedEmojis = {};
Object.keys(data.emojis).forEach(key => {
  condensedEmojis[key] = pick(data.emojis[key], ['short_names', 'unified', 'search']);
});

// JSON.parse/stringify is to emulate what @preval is doing and avoid any
// inconsistent behavior in dev mode
module.exports = JSON.parse(JSON.stringify({
  emojis: condensedEmojis,
  skins: data.skins,
  categories: data.categories,
  short_names: data.short_names,
}));
=======
const data = require('./emoji_data_compressed');

// decompress
const emojis = {};
data.emojis.forEach(compressedEmoji => {
  const [ short_names, unified, search ] = compressedEmoji;
  emojis[short_names[0]] = {
    short_names,
    unified,
    search,
  };
});

data.emojis = emojis;

module.exports = data;