int rightClickTimerToTrigger = 150;


public abstract class Widget
{

  public int nbRightClick = 0;
  public int lastRightClickTimer = -1;

  public int x0 = 0;
  public int y0 = 0;

  public int xPadding = 0;
  public int yPadding = 0;

  public int widgetWidth = 0;
  public int widgetHeigh = 0;
  
  
  public abstract void drawWidget();
  
  public void setupWidget()
  {}
  public void updateWidget()
  {}

  public boolean isCursorInside()
  {
    return mouseX >= this.x0 && mouseX <= this.x0+this.widgetWidth && mouseY >= this.y0 && mouseY <= this.y0+this.widgetHeigh;
  }

  public boolean isInside(int px, int py)
  {
    return px >= this.x0 && px <= this.x0+this.widgetWidth && py >= this.y0 && py <= this.y0+this.widgetHeigh;
  }

}
