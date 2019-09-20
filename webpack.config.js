const path = require('path');

const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const FixStyleOnlyEntriesPlugin = require('webpack-fix-style-only-entries');

module.exports = {
  entry: {
    bundle: path.resolve(__dirname, 'frontend/index.scss'),
    userbox: path.resolve(__dirname, 'frontend/userbox.scss')
  },
  output: {
    path: path.resolve(__dirname, 'app/assets/bundle/trestle/auth')
  },
  optimization: {
    splitChunks: {
      cacheGroups: {
        styles: {
          name: 'bundle',
          test: /\.css$/,
          chunks: 'all',
          enforce: true
        }
      }
    },
    minimizer: [
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  module: {
    rules: [
      {
        test: /\.s?[ac]ss$/,
        use: [
          { loader: MiniCssExtractPlugin.loader },
          { loader: 'css-loader' },
          { loader: 'postcss-loader', options: { plugins: [ require('autoprefixer') ] } },
          { loader: 'sass-loader' }
        ]
      }
    ]
  },
  plugins: [
    new FixStyleOnlyEntriesPlugin(),
    new MiniCssExtractPlugin({
      filename: '[name].css'
    })
  ]
}
