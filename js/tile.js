// Generated by CoffeeScript 1.6.3
var Tile;

Tile = (function() {
  function Tile(tileBasics) {
    this.tileBasics = tileBasics;
    this.contentFontScaling = 1;
  }

  Tile.prototype.addToDoc = function() {
    var _this = this;
    this.parentTag = "#sqTileContainer";
    this.tileId = "sqTile" + this.tileIdx;
    $(this.parentTag).append("<a class=\"sqTile\" id=\"" + this.tileId + "\" \n		href=\"javascript:void(0);\" \n		style=\"background-color:" + this.tileBasics.bkColour + ";\n				display:block; opacity:1;\">\n  <div class=\"sqInner\">\n  </div>\n</a>");
    if (this.tileBasics.clickFn != null) {
      $("#" + this.tileId).click(function() {
        return _this.tileBasics.clickFn(_this.tileBasics.clickParam);
      });
    }
    return this.contents = $("#" + this.tileId + ">.sqInner");
  };

  Tile.prototype.removeFromDoc = function() {
    console.log("clearInterval " + this.refreshId);
    if (this.refreshId != null) {
      clearInterval(this.refreshId);
    }
    return $('#' + this.tileId).remove();
  };

  Tile.prototype.setTileIndex = function(tileIdx) {
    this.tileIdx = tileIdx;
  };

  Tile.prototype.reposition = function(posX, posY, sizeX, sizeY, fontScaling) {
    this.posX = posX;
    this.posY = posY;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.fontScaling = fontScaling;
    return this.setPositionCss(this.posX, this.posY, this.sizeX, this.sizeY, this.fontScaling);
  };

  Tile.prototype.setPositionCss = function(posX, posY, sizeX, sizeY, fontScaling) {
    return $('#' + this.tileId).css({
      "margin-left": posX + "px",
      "margin-top": posY + "px",
      "width": sizeX + "px",
      "height": sizeY + "px",
      "font-size": (fontScaling * this.contentFontScaling) + "%",
      "display": "block"
    });
  };

  Tile.prototype.setContentFontScaling = function(contentFontScaling) {
    this.contentFontScaling = contentFontScaling;
    return this.setPositionCss(this.posX, this.posY, this.sizeX, this.sizeY, this.fontScaling);
  };

  Tile.prototype.getElement = function(element) {
    return $('#' + this.tileId + " " + element);
  };

  Tile.prototype.isVisible = function(isPortrait) {
    if (this.tileBasics.visibility === "all") {
      return true;
    }
    if (this.tileBasics.visibility === "portrait" && isPortrait) {
      return true;
    }
    if (this.tileBasics.visibility === "landscape" && (!isPortrait)) {
      return true;
    }
    return false;
  };

  Tile.prototype.setInvisible = function() {
    return $('#' + this.tileId).css({
      "display": "none"
    });
  };

  Tile.prototype.setRefreshInterval = function(intervalInSecs, callbackFn, firstCallNow) {
    var _this = this;
    this.callbackFn = callbackFn;
    if (firstCallNow) {
      this.callbackFn();
    }
    this.refreshId = setInterval(function() {
      return _this.callbackFn();
    }, intervalInSecs * 1000);
    return console.log("setInterval " + this.refreshId + " intv = " + intervalInSecs);
  };

  return Tile;

})();
