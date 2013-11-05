// Generated by CoffeeScript 1.6.3
var TileGroup;

TileGroup = (function() {
  function TileGroup(tileContainer, groupTitlesTag, groupIdx, groupTitle) {
    this.tileContainer = tileContainer;
    this.groupTitlesTag = groupTitlesTag;
    this.groupIdx = groupIdx;
    this.groupTitle = groupTitle;
    this.tiles = [];
    this.tilePositions = [];
    this.groupIdTag = "sqGroupTitle" + groupIdx;
    $(groupTitlesTag).append("<div class=\"sqGroupTitle\" id=\"" + this.groupIdTag + "\">" + this.groupTitle + "\n</div>");
  }

  TileGroup.prototype.clearTiles = function() {
    var tile, _i, _len, _ref;
    _ref = this.tiles;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tile = _ref[_i];
      tile.removeFromDoc();
    }
    return this.tiles = [];
  };

  TileGroup.prototype.numTiles = function() {
    return this.tiles.length;
  };

  TileGroup.prototype.findBestPlaceForTile = function(colSpan, tilesDown, tilesAcross) {
    var bestColIdx, bestRowIdx, colIdx, colTest, posValid, rowIdx, spanTest, tilePos, _i, _j, _k, _l, _len, _m, _ref, _ref1, _ref2, _ref3, _ref4, _ref5;
    bestColIdx = 0;
    bestRowIdx = 0;
    for (rowIdx = _i = 0, _ref = tilesDown - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; rowIdx = 0 <= _ref ? ++_i : --_i) {
      for (colIdx = _j = 0, _ref1 = tilesAcross - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; colIdx = 0 <= _ref1 ? ++_j : --_j) {
        if ((colIdx + colSpan) > tilesAcross) {
          continue;
        }
        posValid = true;
        _ref2 = this.tilePositions;
        for (_k = 0, _len = _ref2.length; _k < _len; _k++) {
          tilePos = _ref2[_k];
          if (tilePos[1] !== rowIdx) {
            continue;
          }
          for (colTest = _l = colIdx, _ref3 = colIdx + colSpan - 1; colIdx <= _ref3 ? _l <= _ref3 : _l >= _ref3; colTest = colIdx <= _ref3 ? ++_l : --_l) {
            for (spanTest = _m = _ref4 = tilePos[0], _ref5 = tilePos[0] + tilePos[2] - 1; _ref4 <= _ref5 ? _m <= _ref5 : _m >= _ref5; spanTest = _ref4 <= _ref5 ? ++_m : --_m) {
              if (spanTest === colTest) {
                posValid = false;
                break;
              }
            }
          }
          if (!posValid) {
            break;
          }
        }
        bestColIdx = colIdx;
        bestRowIdx = rowIdx;
        if (posValid) {
          break;
        }
      }
      if (posValid) {
        break;
      }
    }
    return [bestColIdx, bestRowIdx, colSpan];
  };

  TileGroup.prototype.getColsInGroup = function(tilesDown) {
    var cellCount, estColCount, maxColSpan, tile, tileIdx, _i, _j, _len, _len1, _ref, _ref1;
    this.tiles.sort(this.sortByTileWidth);
    this.tilePositions = [];
    cellCount = 0;
    maxColSpan = 1;
    _ref = this.tiles;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tile = _ref[_i];
      cellCount += tile.colSpan;
      maxColSpan = maxColSpan < tile.colSpan ? tile.colSpan : maxColSpan;
    }
    estColCount = Math.floor((cellCount + tilesDown - 1) / tilesDown);
    estColCount = estColCount < maxColSpan ? maxColSpan : estColCount;
    _ref1 = this.tiles;
    for (tileIdx = _j = 0, _len1 = _ref1.length; _j < _len1; tileIdx = ++_j) {
      tile = _ref1[tileIdx];
      this.tilePositions.push(this.findBestPlaceForTile(tile.colSpan, tilesDown, estColCount));
    }
    return estColCount;
  };

  TileGroup.prototype.addTile = function(tileColour, colSpan) {
    var tile;
    tile = new Tile(tileColour, colSpan);
    tile.setTileIndex(this.tileContainer.getNextTileIdx());
    tile.addToDoc();
    return this.tiles.push(tile);
  };

  TileGroup.prototype.addExistingTile = function(tile) {
    tile.setTileIndex(this.tileContainer.getNextTileIdx());
    tile.addToDoc();
    return this.tiles.push(tile);
  };

  TileGroup.prototype.sortByTileWidth = function(a, b) {
    return a.colSpan - b.colSpan;
  };

  TileGroup.prototype.repositionTiles = function() {
    var fontScaling, fontSize, tile, tileHeight, tileIdx, tileWidth, titleX, titleY, xPos, yPos, _i, _len, _ref, _ref1, _ref2, _ref3, _results;
    _ref = this.tileContainer.getGroupTitlePos(this.groupIdx), titleX = _ref[0], titleY = _ref[1], fontSize = _ref[2];
    $("#" + this.groupIdTag).css({
      "margin-left": titleX + "px",
      "margin-top": titleY + "px",
      "font-size": fontSize
    });
    _ref1 = this.tiles;
    _results = [];
    for (tileIdx = _i = 0, _len = _ref1.length; _i < _len; tileIdx = ++_i) {
      tile = _ref1[tileIdx];
      _ref2 = this.tileContainer.getTileSize(tile.colSpan), tileWidth = _ref2[0], tileHeight = _ref2[1];
      _ref3 = this.tileContainer.getCellPos(this.groupIdx, this.tilePositions[tileIdx][0], this.tilePositions[tileIdx][1]), xPos = _ref3[0], yPos = _ref3[1], fontScaling = _ref3[2];
      _results.push(this.tiles[tileIdx].reposition(xPos, yPos, tileWidth, tileHeight, fontScaling));
    }
    return _results;
  };

  TileGroup.prototype.findExistingTile = function(tileName) {
    var existingTile, tile, _i, _len, _ref;
    existingTile = null;
    _ref = this.tiles;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tile = _ref[_i];
      if (tile.tileName === tileName) {
        existingTile = tile;
        break;
      }
    }
    return existingTile;
  };

  return TileGroup;

})();
