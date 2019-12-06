class MapCanvas extends Widget
{

  public boolean isMiniMap;

  public float zoom;    
  public int xFocus;
  public int yFocus;
  
  public float minCircleRadius;
  public float maxCircleRadius;
  public float circleStrokeWeight;


  public void drawWidget()
  {
    if (!isMiniMap)
    {
      if (this.xFocus > 0)
        this.xFocus = 0;
      else if (this.xFocus < (-1 * this.zoom + 1) * this.widgetWidth)
        this.xFocus = int ((-1 * this.zoom + 1) *this.widgetWidth);
  
      if (this.yFocus > 0)
        this.yFocus = 0;
      else if (this.yFocus < (-1 * this.zoom + 1) * this.widgetHeigh)
        this.yFocus = int ((-1 * this.zoom + 1) * this.widgetHeigh);
    }

    colorMode(HSB, 360, 100, 100);
    for (City city : cityList)
      if (city != null)
      {
        if (isMiniMap)
          city.drawMiniCity(this);
        else if (!city.hovered && !city.selected)
          city.drawCity(this);
      }

    colorMode(RGB, 255, 255, 255);
  }

}
