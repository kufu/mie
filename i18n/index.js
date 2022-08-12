const en = require("./translations.en.json");
const ja = require("./translations.ja.json");

const i18n = {
  translations: {
    en,
    ja,
  },
  defaultLang: "en",
  useBrowserDefault: true,
};

module.exports = i18n;