const { i18n } = require("./next-i18next.config");

module.exports = {
  webpack5: true,
  webpack: (config) => {
    config.resolve.fallback = { fs: false };

    return config;
  },
  i18n,
}
