// Generated by CoffeeScript 1.6.3
var TileContainer;

TileContainer = (function() {
  function TileContainer(parentTag, groupTitlesTag) {
    this.parentTag = parentTag;
    this.groupTitlesTag = groupTitlesTag;
    this.groups = [];
    this.groupCols = [];
    this.groupSepPixels = 30;
    this.groupTitlesTopMargin = 60;
    this.tileSepXPixels = 20;
    this.tileSepYPixels = 20;
    this.nextTileIdx = 0;
  }

  TileContainer.prototype.clearTiles = function() {
    var group, _i, _len, _ref;
    _ref = this.groups;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      group = _ref[_i];
      group.clearTiles();
    }
    return $(this.parentTag).html("<div id=\"sqTileContainer\" style=\"width:3000px;height:350px;display:block;zoom:1;\">\n</div>");
  };

  TileContainer.prototype.clearTileGroup = function(groupIdx) {
    return this.groups[groupIdx].clearTiles();
  };

  TileContainer.prototype.addGroup = function(groupTitle) {
    var groupIdx, newTileGroup;
    groupIdx = this.groups.length;
    newTileGroup = new TileGroup(this, this.groupTitlesTag, groupIdx, groupTitle);
    this.groups.push(newTileGroup);
    return groupIdx;
  };

  TileContainer.prototype.calcLayout = function() {
    var group, isPortrait, winHeight, winWidth, _i, _len, _ref;
    winWidth = $(window).width();
    winHeight = $(window).height();
    isPortrait = winWidth < winHeight;
    this.tilesAcross = isPortrait ? 3 : 5;
    this.tilesDown = isPortrait ? 5 : 3;
    this.cellWidth = (winWidth - (this.groupSepPixels * Math.floor((this.tilesAcross - 1) / 3))) / this.tilesAcross;
    this.cellHeight = (winHeight - this.groupTitlesTopMargin) / this.tilesDown;
    this.tileWidth = this.cellWidth - this.tileSepXPixels;
    this.tileHeight = this.cellHeight - this.tileSepYPixels;
    this.groupCols = [];
    _ref = this.groups;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      group = _ref[_i];
      this.groupCols.push(group.getColsInGroup(this.tilesDown, isPortrait));
    }
    return isPortrait;
  };

  TileContainer.prototype.getTileSize = function(colSpan) {
    return [this.tileWidth * colSpan + (this.tileSepXPixels * (colSpan - 1)), this.tileHeight];
  };

  TileContainer.prototype.getGroupStartX = function(groupIdx) {
    var gIdx, xStart;
    gIdx = 0;
    xStart = 0;
    while (gIdx < groupIdx) {
      xStart += this.groupCols[gIdx] * this.cellWidth;
      gIdx += 1;
    }
    xStart += groupIdx * this.groupSepPixels;
    return xStart;
  };

  TileContainer.prototype.calcFontSizePercent = function() {
    return 100 * Math.max(this.cellWidth, this.cellHeight) / 300;
  };

  TileContainer.prototype.getGroupTitlePos = function(groupIdx) {
    var xStart;
    xStart = this.getGroupStartX(groupIdx);
    return [xStart, 10, "200%"];
  };

  TileContainer.prototype.getCellPos = function(groupIdx, colIdx, rowIdx) {
    var cellX, cellY, colInGroup, fontScaling, xStart;
    xStart = this.getGroupStartX(groupIdx);
    colInGroup = colIdx;
    cellX = xStart + colInGroup * this.cellWidth;
    cellY = this.groupTitlesTopMargin + rowIdx * this.cellHeight;
    fontScaling = this.calcFontSizePercent();
    return [cellX, cellY, fontScaling];
  };

  TileContainer.prototype.getNextTileIdx = function() {
    this.nextTileIdx += 1;
    return this.nextTileIdx;
  };

  TileContainer.prototype.addTileToGroup = function(groupIdx, tile) {
    return this.groups[groupIdx].addExistingTile(tile);
  };

  TileContainer.prototype.reDoLayout = function() {
    var group, isPortrait, _i, _len, _ref, _results;
    isPortrait = this.calcLayout();
    _ref = this.groups;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      group = _ref[_i];
      _results.push(group.repositionTiles(isPortrait));
    }
    return _results;
  };

  TileContainer.prototype.findExistingTile = function(tileName) {
    var existingTile, group, _i, _len, _ref;
    existingTile = null;
    _ref = this.groups;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      group = _ref[_i];
      existingTile = group.findExistingTile(tileName);
      if (existingTile !== null) {
        break;
      }
    }
    return existingTile;
  };

  return TileContainer;

})();
