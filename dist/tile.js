const _jsxFileName = "/Users/liamfitzgerald/dev/urbit/bitcoin-ticker/tile/tile.js";import React, { Component } from "react";
import classnames from "classnames";
import _ from "lodash";

export default class btcTile extends Component {
  render() {
    return (
      React.createElement('div', { className: "w-100 h-100 relative"  , style: { background: "#1a1a1a" }, __self: this, __source: {fileName: _jsxFileName, lineNumber: 8}}
        , React.createElement('p', {
          className: "gray label-regular b absolute"   ,
          style: { left: 8, top: 4 }, __self: this, __source: {fileName: _jsxFileName, lineNumber: 9}}
        , "BTC Price Ticker"

        )
        , React.createElement('div', { className: "flex-col", __self: this, __source: {fileName: _jsxFileName, lineNumber: 15}}
          , React.createElement('p', { className: "white absolute" , style: { top: 25, left: 8 }, __self: this, __source: {fileName: _jsxFileName, lineNumber: 16}}, "$"
            , this.props.data.price, " "
          )
        )
      )
    );
  }
}

window.btcTile = btcTile;
