// Generated by CoffeeScript 1.6.3
var Tile;

Tile = (function() {
  function Tile(bkColour, colSpan, clickFn, clickParam, tileName) {
    this.bkColour = bkColour;
    this.colSpan = colSpan;
    this.clickFn = clickFn;
    this.clickParam = clickParam;
    this.tileName = tileName;
    this.contentFontScaling = 1;
  }

  Tile.prototype.addToDoc = function() {
    var _this = this;
    this.parentTag = "#sqTileContainer";
    this.tileId = "sqTile" + this.tileIdx;
    $(this.parentTag).append("<a class=\"sqTile\" id=\"" + this.tileId + "\" href=\"javascript:void(0);\" style=\"background-color:" + this.bkColour + ";display:block;opacity:1;\">\n  <div class=\"sqInner\">\n  </div>\n</div>");
    if (this.clickFn != null) {
      $("#" + this.tileId).click(function() {
        return _this.clickFn(_this.clickParam);
      });
    }
    return this.contents = $("#" + this.tileId + ">.sqInner");
  };

  Tile.prototype.removeFromDoc = function() {
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
      "font-size": (fontScaling * this.contentFontScaling) + "%"
    });
  };

  Tile.prototype.setContentFontScaling = function(contentFontScaling) {
    this.contentFontScaling = contentFontScaling;
    return this.setPositionCss(this.posX, this.posY, this.sizeX, this.sizeY, this.fontScaling);
  };

  Tile.prototype.getElement = function(element) {
    return $('#' + this.tileId + " " + element);
  };

  return Tile;

})();
