class City //<>// //<>// //<>//
{

  // Data
  public int     postalcode  = 0;
  public int     iseeCode    = 0;
  public String  name        = "";
  public float   x           = 0;
  public float   y           = 0;
  public int     population  = 0;
  public float   surface     = 0;
  public float   density     = 0;
  public float   altitude    = 0;

  // Visualisation Fields
  public boolean isDrawn     = false;
  public boolean hovered     = false;
  public boolean selected    = false;


  public void drawCity(MapCanvas canvas)
  {
    int xCoord = this.mapX(canvas);
    int yCoord = this.mapY(canvas);
    float circleRadius = this.getCircleRadius(canvas);

    if (!this.needToDrawCity(canvas, xCoord, yCoord, circleRadius) || (!(this.selected || this.hovered) && (!rightPanel.altitudeLegend.altitudeIsInSelection(this.altitude) ||
                                                                                                            !rightPanel.populationSelection.populationIsInSelection(this.population) ||
                                                                                                            !rightPanel.densitySlider.populationIsInSelection(this.density))))
    {
      isDrawn = false;
      return;
    }
    
    isDrawn = true;
    strokeWeight(canvas.circleStrokeWeight);
    stroke(color(DARK_THEME ? DARK_COLOR : DARK_COLOR + WHITE_COLOR - BRIGHT_COLOR));
    if (canvas.isMiniMap)
      fill(DARK_COLOR + WHITE_COLOR - BRIGHT_COLOR);
    else
      fill(this.hovered || this.selected ? color(DARK_THEME ? WHITE_COLOR : DARK_COLOR, 175) : this.mapToColor());

    circle(xCoord, yCoord, circleRadius);
  }

  public void drawMiniCity(MapCanvas canvas)
  {
    if (!rightPanel.altitudeLegend.altitudeIsInSelection(this.altitude) || !rightPanel.populationSelection.populationIsInSelection(this.population) || !rightPanel.densitySlider.populationIsInSelection(this.density))
    {
      isDrawn = false;
      return;
    }

    int xCoord = this.mapX(canvas);
    int yCoord = this.mapY(canvas);
    stroke(this.mapToColor());
    point(xCoord, yCoord);
  }

  public void drawInfos(MapCanvas canvas)
  {
    int xCoord          = mapX(canvas);
    int yCoord          = mapY(canvas);
    float circleRadius  = getCircleRadius(canvas);

    textSize(FONT_SIZE_CITY);
    textAlign(RIGHT, CENTER);
    fill(color(DARK_THEME ? WHITE_COLOR : DARK_COLOR), 220);

    float fontCityWidth   = textWidth(this.name) + 2 * BOX_WIDTH_PADDING;
    float fontCityHeight  = FONT_SIZE_CITY + 2 * BOX_WIDTH_PADDING;

    strokeWeight(UI_STROKE_WEIGHT);

    float xRect = xCoord - fontCityWidth - circleRadius/2;
    float xText = xCoord - BOX_WIDTH_PADDING - circleRadius/2;
    if (xRect < canvas.x0)
    {
      xRect = xCoord + circleRadius/2;
      xText = xCoord + BOX_WIDTH_PADDING + circleRadius/2;
      textAlign(LEFT, CENTER);
    }

    rect(xRect, yCoord - int(fontCityHeight/2f), fontCityWidth, fontCityHeight);
    fill(color(DARK_THEME ? DARK_COLOR : BRIGHT_COLOR));
    text(this.name, xText, yCoord - BOX_HEIGH_PADDING);
  }

  public boolean contains(int px, int py, MapCanvas canvas)
  {
    return dist(this.mapX(canvas), this.mapY(canvas), px, py) <= this.getCircleRadius(canvas) / 2f;
  }

  private int mapX(MapCanvas canvas)
  {
    return canvas.x0 + canvas.xPadding + canvas.xFocus + (int) (map(this.x, minX, maxX, 0, canvas.widgetWidth - 2*canvas.xPadding) * canvas.zoom);
  }

  private int mapY(MapCanvas canvas)
  {
    return canvas.y0 + canvas.yPadding + canvas.yFocus + (int) ((canvas.widgetWidth - 2 * canvas.yPadding - map(this.y, minY, maxY, 0, canvas.widgetWidth - 2 * canvas.yPadding)) * canvas.zoom);
  }

  private color mapToColor()
  {
    return mapToHSBColorWithQuartiles(this.altitude, minAltitude, firstQuartileAltitude, medianAltitude, thirdQuartileAltitude, maxAltitude);
  }

  private float getCircleRadius(MapCanvas canvas)
  {
    return map(this.density, minDensity, maxDensity, canvas.minCircleRadius, canvas.maxCircleRadius) * canvas.zoom;
  }

  public boolean needToDrawCity(Widget canvas, int px, int py, float radius)
  {
    return px >= canvas.x0 - radius/2 && px <= canvas.x0 + canvas.widgetWidth + radius/2 && py >= canvas.y0 - radius/2 && py <= canvas.y0 + canvas.widgetHeigh + radius/2;
  }
  
}


// Mapping Color Method
public color mapToHSBColorWithQuartiles(float value, float minValue, float firstQuartile, float median, float thirdQuartile, float maxValue)
{
  float tmp;
  if (value <= firstQuartile)
    tmp = MAX_COLOR_VALUE - map(value, minValue, firstQuartile, 0, MAX_COLOR_VALUE/4f);
  else if (value <= median)
    tmp = MAX_COLOR_VALUE - map(value, firstQuartile, median, MAX_COLOR_VALUE/4f, MAX_COLOR_VALUE/2f);
  else if (value <= thirdQuartile)
    tmp = MAX_COLOR_VALUE - map(value, median, thirdQuartile, MAX_COLOR_VALUE/2f, 3 * MAX_COLOR_VALUE/4f);
  else
    tmp = MAX_COLOR_VALUE - map(value, thirdQuartile, maxValue, 3 * MAX_COLOR_VALUE/4f, MAX_COLOR_VALUE);
    
  return color(tmp, 100, 100);
}
