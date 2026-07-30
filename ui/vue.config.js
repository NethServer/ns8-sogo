module.exports = {
  css: {
    loaderOptions: {
      sass: {
        sassOptions: {
          silenceDeprecations: ["import", "global-builtin", "color-functions", "if-function", "legacy-js-api"],
        },
      },
    },
  },
  publicPath: "./",
  // needed for newer axios versions
  transpileDependencies: ["axios"],
  configureWebpack: {
    optimization: {
      splitChunks: {
        maxSize: 500000,
      },
    },
  },
};
