import React, { Component } from "react";
import classnames from "classnames";
import _ from "lodash";

export default class btcTile extends Component {
  render() {
    return (
      <div className="w-100 h-100 relative" style={{ background: "#1a1a1a" }}>
        <p
          className="gray label-regular b absolute"
          style={{ left: 8, top: 4 }}
        >
          BTC Price Ticker
        </p>
        <div className="flex-col">
          <p className="white absolute" style={{ top: 25, left: 8 }}>
            ${this.props.data.price}{" "}
          </p>
        </div>
      </div>
    );
  }
}

window.btcTile = btcTile;
