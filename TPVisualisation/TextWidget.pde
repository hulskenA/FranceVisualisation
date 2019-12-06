class TextWidget extends Widget
{

  public int   xAlign   = LEFT;
  public int   yAlign   = TOP;
  public float fontSize = 0;
  public String message = "";

  public color fontColor = color(DARK_THEME ? WHITE_COLOR : DARK_COLOR);


  public void drawWidget()
  {
    textAlign(xAlign, yAlign);
    textSize(this.fontSize);
    fill(this.fontColor);
    text(this.message, this.x0 + xPadding, this.y0 + yPadding + this.fontSize / 2f);
  }
}
