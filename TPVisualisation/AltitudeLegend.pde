public class AltitudeLegend extends Widget
{
  
  public color       fontColor             = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);
  public Button      button1               = new Button();
  public Button      button2               = new Button();
  public boolean     selectionAsInside     = true;
  public float       minAltitudeToDisplay  = minAltitude;
  public float       maxAltitudeToDisplay  = maxAltitude;
  
  
  //private float altitudeStep = 0;
  private float      fontSize              = .65f * FONT_SIZE;
  private TextWidget maxValue              = new TextWidget();
  private TextWidget thirdQuartile         = new TextWidget();
  private TextWidget median                = new TextWidget();
  private TextWidget firstQuartile         = new TextWidget();
  private TextWidget minValue              = new TextWidget();


  public void setupWidget()
  {
    // Buttons
    this.button1.widgetWidth           = ALTITUDE_BUTTON_SIZE;
    this.button1.widgetHeigh           = ALTITUDE_BUTTON_SIZE;
    this.button1.x0                    = int (this.x0 - this.button1.widgetWidth / 2f);
    this.button1.selectedNorm          = 1f;
    this.button1.corner                = ALTITUDE_BUTTON_CORNER;
    
    this.button2.widgetWidth           = ALTITUDE_BUTTON_SIZE;
    this.button2.widgetHeigh           = ALTITUDE_BUTTON_SIZE;
    this.button2.x0                    = int (this.x0 + widgetWidth - this.button2.widgetWidth / 2f);
    this.button2.selectedNorm          = 0f;
    this.button2.corner                = ALTITUDE_BUTTON_CORNER;

    float xAlignement = this.button2.x0 + this.button2.widgetWidth + this.xPadding;
    
    // Max Value
    maxValue.x0              = int (xAlignement);
    maxValue.y0              = int (this.y0 - this.fontSize);
    maxValue.fontSize        = this.fontSize;
    maxValue.message         = maxAltitude + "km";
    
    // Third Quartile
    thirdQuartile.x0         = int (xAlignement);
    thirdQuartile.y0         = int (this.y0 - this.fontSize + this.widgetHeigh / 4f);
    thirdQuartile.fontSize   = this.fontSize;
    thirdQuartile.message    = int (thirdQuartileAltitude) + "km";
    
    // Median
    median.x0                = int (xAlignement);
    median.y0                = int (this.y0 - this.fontSize + this.widgetHeigh / 2f);
    median.fontSize          = this.fontSize;
    median.message           = int (medianAltitude) + "km";
    
    // First Quartile
    firstQuartile.x0         = int (xAlignement);
    firstQuartile.y0         = int (this.y0 - this.fontSize + 3f * this.widgetHeigh / 4);
    firstQuartile.fontSize   = this.fontSize;
    firstQuartile.message    = int (firstQuartileAltitude) + "km";
    
    // Min Value
    minValue.x0              = int (xAlignement);
    minValue.y0              = int (this.y0 - this.fontSize + this.widgetHeigh);
    minValue.fontSize        = this.fontSize;
    minValue.message         = int (minAltitude) + "km";
  }

  public void drawWidget()
  {
    // Rect Around Legend
    stroke(DARK_THEME ? DARK_COLOR : BRIGHT_COLOR);
    strokeWeight(UI_STROKE_WEIGHT);
    rect(this.x0, this.y0, this.widgetWidth, this.widgetHeigh);
    
    // Gradiant Color Linear
    float tmp = 0;
    float tmpMax = 0;
    float tmpMin = 0;
    colorMode(HSB, 360, 100, 100);
    for (int y = 0; y < this.widgetHeigh - UI_STROKE_WEIGHT; y++)
    {
      tmp = 1 - (1f * y) / (this.widgetHeigh - UI_STROKE_WEIGHT);
      if (this.button1.selectedNorm > this.button2.selectedNorm)
      {
        tmpMax = this.button1.selectedNorm;
        tmpMin = this.button2.selectedNorm;
      }
      else
      {
        tmpMax = this.button2.selectedNorm;
        tmpMin = this.button1.selectedNorm;
      }
      for (int x = 0; x < this.widgetWidth - UI_STROKE_WEIGHT; x++)
      {
        if ((selectionAsInside && tmp < tmpMax && tmp > tmpMin) || (!selectionAsInside && !(tmp < tmpMax && tmp > tmpMin)))
          stroke(color(map(y, 0, this.widgetHeigh - UI_STROKE_WEIGHT, 0, MAX_COLOR_VALUE), 100, 100));
        else
          stroke(color(map(y, 0, this.widgetHeigh - UI_STROKE_WEIGHT, 0, MAX_COLOR_VALUE), 85, 50));

        point(this.x0 + UI_STROKE_WEIGHT + x, this.y0 + UI_STROKE_WEIGHT + y);
      }
    }
    /*
    // Gradiant Color Not Linear
    colorMode(HSB, 360, 100, 100);
    for (int x = 0; x < this.widgetWidth - 2 * UI_STROKE_WEIGHT; x++)
      for (int y = 0; y < this.widgetHeigh - 2 * UI_STROKE_WEIGHT; y++)
      {
        stroke(mapToHSBColorWithQuartiles(maxAltitude - y * altitudeStep, minAltitude, firstQuartileAltitude, medianAltitude, thirdQuartileAltitude, maxAltitude));
        point(this.x0 + 250 + UI_STROKE_WEIGHT + x, this.y0 + UI_STROKE_WEIGHT + y);
      }
    */
    colorMode(RGB, 255, 255, 255);
    stroke(DARK_THEME ? DARK_COLOR : BRIGHT_COLOR);

    // Max Text
    maxValue.fontColor = this.fontColor;
    maxValue.drawWidget();
    line(maxValue.x0 - 2.5 * SIZE_MULTIPLIER, maxValue.y0 + maxValue.fontSize, this.button2.x0 + this.button2.widgetWidth/2f, maxValue.y0 + maxValue.fontSize);

    // Third Quartile Text
    thirdQuartile.fontColor = this.fontColor;
    thirdQuartile.drawWidget();
    line(thirdQuartile.x0 - 2.5 * SIZE_MULTIPLIER, thirdQuartile.y0 + thirdQuartile.fontSize, this.button2.x0, thirdQuartile.y0 + thirdQuartile.fontSize);

    // Median Text
    median.fontColor = this.fontColor;
    median.drawWidget();
    line(median.x0 - 2.5 * SIZE_MULTIPLIER, median.y0 + median.fontSize, this.button2.x0, median.y0 + median.fontSize);

    // first Quartile Text
    firstQuartile.fontColor = this.fontColor;
    firstQuartile.drawWidget();
    line(firstQuartile.x0 - 2.5 * SIZE_MULTIPLIER, firstQuartile.y0 + firstQuartile.fontSize, this.button2.x0, firstQuartile.y0 + firstQuartile.fontSize);

    // Min Text
    minValue.fontColor = this.fontColor;
    minValue.drawWidget();
    line(minValue.x0 - 2.5 * SIZE_MULTIPLIER, minValue.y0 + minValue.fontSize, this.button2.x0 + this.button2.widgetWidth / 2, minValue.y0 + minValue.fontSize);

    // Scroll Button
    this.updateWidget();
    this.button1.drawWidget();
    this.button2.drawWidget();
    strokeWeight(1.5f * UI_STROKE_WEIGHT);
    line(this.x0 + this.button1.widgetWidth / 2f, this.button1.y0 + this.button1.widgetHeigh / 2f + UI_STROKE_WEIGHT / 2f, this.x0 + this.widgetWidth, this.button1.y0 + this.button1.widgetHeigh / 2f + UI_STROKE_WEIGHT / 2f);
    line(this.x0, this.button2.y0 + this.button2.widgetHeigh / 2f + UI_STROKE_WEIGHT / 2f, this.button2.x0, this.button2.y0 + this.button2.widgetHeigh / 2f + UI_STROKE_WEIGHT / 2f);
  }
  
  public void updateWidget()
  {
    this.button1.y0 = int (this.y0 - ALTITUDE_BUTTON_SIZE / 2f + this.widgetHeigh * (1f - this.button1.selectedNorm));
    this.button2.y0 = int (this.y0 - ALTITUDE_BUTTON_SIZE / 2f + this.widgetHeigh * (1f - this.button2.selectedNorm));

    float alt1 = convertToAltitude(this.button1);
    float alt2 = convertToAltitude(this.button2);
    if (alt1 > alt2)
    {
      minAltitudeToDisplay = alt2;
      maxAltitudeToDisplay = alt1;
    }
    else
    {
      minAltitudeToDisplay = alt1;
      maxAltitudeToDisplay = alt2;
    }
  }
  
  public float convertToAltitude(Button b)
  {
    if (b.selectedNorm <= .25f)
      return map(b.selectedNorm, 0, .25f, minAltitude, firstQuartileAltitude);
    else if (b.selectedNorm <= .5f)
      return map(b.selectedNorm, .25f, .5f, firstQuartileAltitude, medianAltitude);
    else if (b.selectedNorm <= .75f)
      return map(b.selectedNorm, .5f, .75f, medianAltitude, thirdQuartileAltitude);
    else 
      return map(b.selectedNorm, .75f, 1f, thirdQuartileAltitude, maxAltitude);
  }
  
  public boolean altitudeIsInSelection(float alt)
  {
    float tmpMax = 0;
    float tmpMin = 0;
    if (this.button1.selectedNorm > this.button2.selectedNorm)
    {
      tmpMax = this.convertToAltitude(this.button1);
      tmpMin = this.convertToAltitude(this.button2);
    }
    else
    {
      tmpMax = this.convertToAltitude(this.button2);
      tmpMin = this.convertToAltitude(this.button1);
    }

    return (selectionAsInside && (tmpMin <= alt && alt <= tmpMax)) || (!selectionAsInside && !(tmpMin <= alt && alt <= tmpMax));
  }

}
