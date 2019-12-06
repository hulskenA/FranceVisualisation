public class Button extends Widget
{

  public boolean drawStrokes           = true;
  public boolean drawColorsByItself    = true;
  public boolean isPressed             = false;
  public float   selectedNorm          = 0.5;
  public float   corner                = 0;
  public color   buttonColor           = color(DARK_THEME ? DARK_COLOR : BRIGHT_COLOR, 125);
  
  public void drawWidget()
  {
    if (drawStrokes)
    {
      stroke(DARK_THEME ? DARK_COLOR : WHITE_COLOR);
      strokeWeight(UI_STROKE_WEIGHT);
    }
    else
      noStroke();

    if (drawColorsByItself)
      fill(color(DARK_THEME ? DARK_COLOR : BRIGHT_COLOR, this.isPressed ? 255 : 125));
    else
      fill(color(buttonColor, this.isPressed ? 255 : 125));
    
    rect(this.x0, this.y0, this.widgetWidth, this.widgetHeigh,
         corner, corner, corner, corner);
  }

}
