import java.lang.Math;

public class PopulationSelection extends Widget
{
  
  public TextWidget minPopulationText        = new TextWidget();
  public TextWidget maxPopulationText        = new TextWidget();
  public color      fontColor                = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);
  public int        choosenPopulationColor   = color(0, 153, 0, 200);
  public int        choosenPopulationColor2  = color(153, 0, 0, 200);
  public int        choosenPopulationStep    = numberOfPopulationSet;
  public boolean    isDragging               = false;
  
  private float     fontSize                 = .65f * FONT_SIZE;
  
  
  public void setupWidget()
  {
    this.updateWidget();
    
    // Max Value
    maxPopulationText.message   = maxPopulation + "ha";
    maxPopulationText.x0        = this.x0 + this.widgetWidth;
    maxPopulationText.y0        = int (this.y0 + this.widgetHeigh);
    maxPopulationText.xAlign    = RIGHT;
    maxPopulationText.yAlign    = TOP;
    maxPopulationText.fontSize  = this.fontSize;
    

    // Min Value
    minPopulationText.x0        = this.x0;
    minPopulationText.y0        = int (this.y0 + this.widgetHeigh);
    minPopulationText.xAlign    = LEFT;
    minPopulationText.yAlign    = TOP;
    minPopulationText.fontSize  = this.fontSize;
    minPopulationText.message   = minPopulation + "ha";
  }

  public void drawWidget()
  {
    this.update();
    stroke(DARK_THEME ? DARK_COLOR : WHITE_COLOR);
    strokeWeight(UI_STROKE_WEIGHT);
    line(this.x0, this.y0 + this.widgetHeigh / 2f, this.x0 + this.widgetWidth, this.y0 + this.widgetHeigh / 2f);
    float widthStep = 1f * this.widgetWidth / numberOfPopulationSet;
    float heighStep = 0;
    for (int i = 0; i < numberOfPopulationSet; i++)
    {
      if (drawPopulationAsMax && i <= choosenPopulationStep)
        fill(choosenPopulationColor);
      else if (!drawPopulationAsMax && i >= choosenPopulationStep)
        fill(choosenPopulationColor2);
      else
        fill(color(DARK_THEME ? BRIGHT_COLOR : DARK_COLOR));
      heighStep = map(populationCount.get(i), 0, maxPopulationCityCounter, this.widgetHeigh/20f, this.widgetHeigh);
      rect(this.x0 + i * widthStep, this.y0 + (this.widgetHeigh - heighStep) / 2f, widthStep, heighStep);
    }
    minPopulationText.fontColor = fontColor;
    maxPopulationText.fontColor = fontColor;
    minPopulationText.drawWidget();
    maxPopulationText.drawWidget();
  }
  
  public void updateWidget()
  {
    populationToDisplay = (choosenPopulationStep + (drawPopulationAsMax ? 1 : 0)) * (maxPopulation - minPopulation + 1) / numberOfPopulationSet;
  }
  
  public boolean populationIsInSelection(int population)
  {
    return (drawPopulationAsMax && population <= populationToDisplay) || (!drawPopulationAsMax && population >= populationToDisplay);
  }

  public void simpleClick()
  {
    drawPopulationAsMax = !drawPopulationAsMax;
    updateWidget();
  }
  
  public void doubleClick()
  {
    this.choosenPopulationStep = drawPopulationAsMax ? numberOfPopulationSet-1 : 0;
    this.updateWidget();
    if (REDRAW_ON_EACH_INTERACTION)
      redraw();
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
