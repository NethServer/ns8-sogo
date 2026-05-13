module.exports = {
  publicPath: "./",
  // needed for newer axios versions
  transpileDependencies: ["axios"],
  configureWebpack: {
    optimization: {
      splitChunks: {
        minSize: 10000,
        maxSize: 250000,
      },
    },
  },
};
