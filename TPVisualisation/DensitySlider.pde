public class DensitySlider extends Widget
{

  private Button sliderButton = new Button();

  private float rect0;
  private float rectWidth;

  
  public DensitySlider()
  {
    this.sliderButton.selectedNorm  = 0f;
  }

  public void setupWidget()
  {
    // Buttons
    this.sliderButton.widgetWidth           = this.widgetHeigh;
    this.sliderButton.widgetHeigh           = this.widgetHeigh;
    this.sliderButton.y0                    = int (this.y0);
    this.sliderButton.corner                = ALTITUDE_BUTTON_CORNER * 2;
    this.sliderButton.buttonColor           = color(200, 0, 0);
    this.sliderButton.drawColorsByItself    = false;
  }

  public void drawWidget()
  {
    this.update();
    stroke(DARK_THEME ? DARK_COLOR : BRIGHT_COLOR);
    strokeWeight(UI_STROKE_WEIGHT);
    this.sliderButton.x0 = int (map(sliderButton.selectedNorm, 0f, 1f, this.x0, this.x0 + this.widgetWidth - this.sliderButton.widgetWidth));

    if (drawDensityAsMin)
    {
      rect0 = this.sliderButton.x0;
      rectWidth = this.sliderButton.widgetWidth + (this.widgetWidth - this.sliderButton.widgetWidth) * (1f - this.sliderButton.selectedNorm);
    }
    else
    {
      rect0 = this.x0;
      rectWidth = this.sliderButton.widgetWidth + (this.widgetWidth - this.sliderButton.widgetWidth) * this.sliderButton.selectedNorm;
    }
    fill(color(DARK_THEME ? DARK_COLOR : BRIGHT_COLOR), 25);
    rect(rect0, this.y0, rectWidth, this.widgetHeigh, 
         ALTITUDE_BUTTON_CORNER * 2, ALTITUDE_BUTTON_CORNER * 2, ALTITUDE_BUTTON_CORNER * 2, ALTITUDE_BUTTON_CORNER * 2);

    
    if (drawDensityAsMin)
    {
      rect0 = this.x0;
      rectWidth = this.sliderButton.widgetWidth + (this.widgetWidth - this.sliderButton.widgetWidth) * this.sliderButton.selectedNorm;
    }
    else
    {
      rect0 = this.sliderButton.x0;
      rectWidth = this.sliderButton.widgetWidth + (this.widgetWidth - this.sliderButton.widgetWidth) * (1f - this.sliderButton.selectedNorm);
    }
    fill(color(this.sliderButton.buttonColor, 40));
    rect(rect0, this.y0, rectWidth, this.widgetHeigh, 
         ALTITUDE_BUTTON_CORNER * 2, ALTITUDE_BUTTON_CORNER * 2, ALTITUDE_BUTTON_CORNER * 2, ALTITUDE_BUTTON_CORNER * 2);

    this.sliderButton.drawWidget();
  }
  
  public void updateWidget()
  {
    densityToDraw = map((float)Math.pow(rightPanel.densitySlider.sliderButton.selectedNorm, 4), 0f, 1f, minDensity, maxDensity);
  }
  
  public void simpleClick()
  {
    drawDensityAsMin = !drawDensityAsMin;
  }
  
  public void doubleClick()
  {
    this.sliderButton.selectedNorm = drawDensityAsMin ? 0f : 1f;
    this.updateWidget();
  }

  public boolean populationIsInSelection(float density)
  {
    return (drawDensityAsMin && density >= densityToDraw) || (!drawDensityAsMin && density <= densityToDraw);
  }

  private void update()
  {
    if (this.nbRightClick == 0)
      return;
  
    if (this.nbRightClick >= 2)
    {
      this.doubleClick();
      this.nbRightClick = 0;
    }
    else if (millis() - this.lastRightClickTimer >= rightClickTimerToTrigger)
    {
      this.simpleClick();
      this.nbRightClick = 0;
    }
  }

}
