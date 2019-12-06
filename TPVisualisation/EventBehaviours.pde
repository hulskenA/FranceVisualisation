// Fields
boolean isDraggingInLoclalMap     = false;
boolean isDraggingInGlobalMap     = false;
int     lastHoveredCityIndex      =    -1;
int     lastClickedCityIndex      =    -1;
int     lastMouseX                =     0;
int     lastMouseY                =     0;
int     lastFocusX                =     0;
int     lastFocusY                =     0;


// Events Methods
void keyPressed()
{
  if (key == CODED) 
  {
    if (keyCode == LEFT) // Move the Map the the left side
    {
      PANEL_IS_AT_RIGHT  = false;
      localView.x0       = rightPanel.widgetWidth;
      globalView.x0      = rightPanel.widgetWidth;
      rightPanel.x0      = 0;
      rightPanel.updateWidget();
    }
    else if (keyCode == RIGHT) // Move the Map the the right side
    {
      
      PANEL_IS_AT_RIGHT  = true;
      localView.x0       = 0;
      globalView.x0      = localView.x0 + localView.widgetWidth - globalView.widgetWidth;
      rightPanel.x0      = localView.widgetWidth;
      rightPanel.updateWidget();
    }
    else if (keyCode == UP && rightPanel.populationSelection.choosenPopulationStep < numberOfPopulationSet) // Increase population filter
    {
      rightPanel.populationSelection.choosenPopulationStep++;
      rightPanel.populationSelection.updateWidget();
      redraw();
    }
    else if (keyCode == DOWN && rightPanel.populationSelection.choosenPopulationStep > 0) // Decrease population filter
    {
      rightPanel.populationSelection.choosenPopulationStep--;
      rightPanel.populationSelection.updateWidget();
      redraw();
    }
  }
  else if (key == 'M' || key == 'm') // MiniMap switching
  {
    DRAW_GLOBAL_MAP = !DRAW_GLOBAL_MAP;
    redraw();
  }
  else if (key == 'C' || key == 'c') // Switch between colors
  {
    DARK_THEME = !DARK_THEME;
    rightPanel.selectedCityPanel.fontColor = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);
    rightPanel.populationFilterOutput.fontColor = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);
    rightPanel.altitudeFilterOutput.fontColor = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);
    rightPanel.densityFilterOutput.fontColor = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);
    rightPanel.altitudeLegend.fontColor = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);
    rightPanel.populationSelection.fontColor = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);
    rightPanel.populationSelection.choosenPopulationColor = color(DARK_THEME ? color(0, 153, 0, 200) : color(50, 200, 50, 200));
    rightPanel.populationSelection.choosenPopulationColor2 = color(DARK_THEME ? color(153, 0, 0, 200) : color(200, 50, 50, 200));
    rightPanel.densitySlider.sliderButton.buttonColor = color(DARK_THEME ? color(200, 0, 0) : color(255, 0, 0));
    redraw();
  }
}

void mouseMoved()
{
  if (localView.isCursorInside())
  {
    if (!DRAW_ONLY_LOCAL_MAP && DRAW_GLOBAL_MAP && globalView.isCursorInside())
    {
      if (lastHoveredCityIndex >= 0)
      {
        cityList[lastHoveredCityIndex].hovered = false;
        lastHoveredCityIndex = -1;
      }
      return;
    }
  
    City hoveredCity = pick(mouseX, mouseY);
    if (REDRAW_ON_EACH_INTERACTION && hoveredCity != null)
      redraw();
  }
  else if (lastHoveredCityIndex >= 0)
  {
    cityList[lastHoveredCityIndex].hovered = false;
    lastHoveredCityIndex = -1;
    if (REDRAW_ON_EACH_INTERACTION)
      redraw();
  }
}

void mouseWheel(MouseEvent event)
{
  if (localView.isCursorInside())
  {
    if (isDraggingInLoclalMap)
      return;
  
    float wheelValue = - WHEEL_SPEED * (event.getCount());
    if (localView.zoom + wheelValue > MAX_ZOOM_VALUE || localView.zoom + wheelValue < 1)
      return;
  
    if (lastHoveredCityIndex >= 0)
    {
      cityList[lastHoveredCityIndex].hovered = false;
      lastHoveredCityIndex = -1;
    }

    localView.zoom += wheelValue;
    
    localView.xFocus -= wheelValue * localView.widgetWidth / 2f;
    localView.yFocus -= wheelValue * localView.widgetHeigh / 2f;
  
    if (REDRAW_ON_EACH_INTERACTION)
      redraw();
  }
}

void mousePressed(MouseEvent evt)
{
  if (mouseButton == RIGHT)
  {
    if (localView.isCursorInside() && evt.getCount() == 2)
    {
      localView.zoom = 1;
      if (REDRAW_ON_EACH_INTERACTION)
        redraw();
    }
    if (rightPanel.altitudeLegend.isCursorInside() && evt.getCount() == 2)
    {
      rightPanel.altitudeLegend.button1.selectedNorm          = 1f;
      rightPanel.altitudeLegend.button2.selectedNorm          = 0f;
      rightPanel.altitudeLegend.selectionAsInside             = true;
      if (REDRAW_ON_EACH_INTERACTION)
        redraw();
    }
    else if (rightPanel.populationSelection.isCursorInside())
    {
      rightPanel.populationSelection.nbRightClick += evt.getCount();
      rightPanel.populationSelection.lastRightClickTimer = millis();
      if (REDRAW_ON_EACH_INTERACTION)
        redraw();
    }
    else if (rightPanel.densitySlider.isCursorInside())
    {
      rightPanel.densitySlider.nbRightClick += evt.getCount();
      rightPanel.densitySlider.lastRightClickTimer = millis();
      if (REDRAW_ON_EACH_INTERACTION)
        redraw();
    }
  }
  else
  {
    if (localView.isCursorInside())
    {
      isDraggingInGlobalMap = !DRAW_ONLY_LOCAL_MAP && DRAW_GLOBAL_MAP && globalView.isCursorInside();
      lastMouseX = mouseX;
      lastMouseY = mouseY;
      if (isDraggingInGlobalMap)
      {
        lastFocusX = localView.xFocus;
        lastFocusY = localView.yFocus;
    
        localView.xFocus = int (localView.x0 - (1f * localView.widgetWidth * localView.zoom * (mouseX - .5f * globalView.widgetWidth / localView.zoom - globalView.x0) / globalView.widgetWidth));
        localView.yFocus = int (localView.y0 - (1f * localView.widgetHeigh * localView.zoom * (mouseY - .5f * globalView.widgetHeigh / localView.zoom - globalView.y0) / globalView.widgetHeigh));
      }
      isDraggingInLoclalMap = true;
    }
    else if (rightPanel.densitySlider.isCursorInside())
    {
      rightPanel.densitySlider.sliderButton.selectedNorm = clamp((1f * mouseX - rightPanel.densitySlider.x0 - rightPanel.densitySlider.sliderButton.widgetWidth / 2f) / (rightPanel.densitySlider.widgetWidth - rightPanel.densitySlider.sliderButton.widgetWidth), 0, 1);
      rightPanel.densitySlider.sliderButton.isPressed = true;
      rightPanel.densitySlider.updateWidget();
    }
    else if (rightPanel.altitudeLegend.button1.isCursorInside())
    {
      lastMouseX = mouseX;
      lastMouseY = mouseY;
      rightPanel.altitudeLegend.button1.isPressed = true;
    }
    else if (rightPanel.altitudeLegend.button2.isCursorInside())
    {
      lastMouseX = mouseX;
      lastMouseY = mouseY;
      rightPanel.altitudeLegend.button2.isPressed = true;
    }
    else if (rightPanel.altitudeLegend.isCursorInside())
    {
        int yMin = int (rightPanel.altitudeLegend.button1.y0 + rightPanel.altitudeLegend.button1.widgetHeigh / 2f);
        int yMax = int (rightPanel.altitudeLegend.button2.y0 + rightPanel.altitudeLegend.button2.widgetHeigh / 2f);
        if (yMin > yMax)
        {
          int tmp = yMax;
          yMax = yMin;
          yMin = tmp;
        }
        rightPanel.altitudeLegend.selectionAsInside = yMin < mouseY && mouseY < yMax;
        if (REDRAW_ON_EACH_INTERACTION)
          redraw();
    }
    else if (rightPanel.populationSelection.isCursorInside())
    {
      rightPanel.populationSelection.isDragging = true;
      rightPanel.populationSelection.choosenPopulationStep = numberOfPopulationSet * (mouseX - rightPanel.populationSelection.x0) / rightPanel.populationSelection.widgetWidth;
      rightPanel.populationSelection.updateWidget();
      if (REDRAW_ON_EACH_INTERACTION)
        redraw();
    }
  }
}

void mouseDragged()
{
  if (isDraggingInLoclalMap && localView.zoom > 1)
  {
    if (lastHoveredCityIndex >= 0)
    {
      cityList[lastHoveredCityIndex].hovered = false;
      lastHoveredCityIndex = -1;
    }
  
    if (isDraggingInGlobalMap) // Dragging in Global View
    {
      localView.xFocus = int (localView.x0 - (1f * localView.widgetWidth * localView.zoom * (mouseX - .5f * globalView.widgetWidth / localView.zoom - globalView.x0) / globalView.widgetWidth));
      localView.yFocus = int (localView.y0 - (1f * localView.widgetHeigh * localView.zoom * (mouseY - .5f * globalView.widgetHeigh / localView.zoom - globalView.y0) / globalView.widgetHeigh));
    }
    else // Dragging in Local View
    {
      localView.xFocus += (mouseX - lastMouseX) * DRAG_SPEED;
      localView.yFocus += (mouseY - lastMouseY) * DRAG_SPEED;
  
      lastMouseX = mouseX;
      lastMouseY = mouseY;
    }
  
    if (REDRAW_ON_EACH_INTERACTION)
      redraw();
  }
  else if (rightPanel.densitySlider.sliderButton.isPressed)
  {
    rightPanel.densitySlider.sliderButton.selectedNorm = clamp((1f * mouseX - rightPanel.densitySlider.x0 - rightPanel.densitySlider.sliderButton.widgetWidth / 2f) / (rightPanel.densitySlider.widgetWidth - rightPanel.densitySlider.sliderButton.widgetWidth), 0, 1);
    rightPanel.densitySlider.updateWidget();
    if (REDRAW_ON_EACH_INTERACTION)
      redraw();
  }
  else if (rightPanel.altitudeLegend.button1.isPressed)
  {
    rightPanel.altitudeLegend.button1.selectedNorm = clamp(1 - (1f * mouseY - rightPanel.altitudeLegend.y0) / rightPanel.altitudeLegend.widgetHeigh, 0, 1);
    if (REDRAW_ON_EACH_INTERACTION)
      redraw();
  }
  else if (rightPanel.altitudeLegend.button2.isPressed)
  {
    rightPanel.altitudeLegend.button2.selectedNorm = clamp(1 - (1f * mouseY - rightPanel.altitudeLegend.y0) / rightPanel.altitudeLegend.widgetHeigh, 0, 1);
    if (REDRAW_ON_EACH_INTERACTION)
      redraw();
  }
  else if (rightPanel.populationSelection.isDragging)
  {
    rightPanel.populationSelection.choosenPopulationStep = numberOfPopulationSet * (mouseX - rightPanel.populationSelection.x0) / rightPanel.populationSelection.widgetWidth;
    rightPanel.populationSelection.updateWidget();
    if (REDRAW_ON_EACH_INTERACTION)
      redraw();
  }
}

void mouseReleased()
{
  isDraggingInLoclalMap                            = false;
  isDraggingInGlobalMap                            = false;
  rightPanel.altitudeLegend.button1.isPressed      = false;
  rightPanel.altitudeLegend.button2.isPressed      = false;
  rightPanel.densitySlider.sliderButton.isPressed  = false;
  rightPanel.populationSelection.isDragging        = false;
  if (localView.isCursorInside())
  {
    if (lastMouseX != mouseX || lastMouseY != mouseY || !DRAW_ONLY_LOCAL_MAP && DRAW_GLOBAL_MAP && globalView.isCursorInside())
      return;
  
    if (lastHoveredCityIndex >= 0)
    {
      if (lastClickedCityIndex >= 0)
          cityList[lastClickedCityIndex].selected = false;
      
      if (lastClickedCityIndex == lastHoveredCityIndex)
        lastClickedCityIndex = -1;
      else
      {
        lastClickedCityIndex = lastHoveredCityIndex;
        if (lastClickedCityIndex >= 0)
        {
          cityList[lastClickedCityIndex].selected = true;
        }
      }
    }
    
    if (REDRAW_ON_EACH_INTERACTION)
      redraw();
  }
}

// Used Methods
City pick(int px, int py)
{
  if (!localView.isInside(px, py) || isDraggingInLoclalMap)
    return null;

  for (int i = cityList.length-1 ; i > 0 ; --i)
    if (cityList[i] != null && cityList[i].isDrawn && cityList[i].contains(px, py, localView))
    {
      if (i == lastHoveredCityIndex)
        return null;

      if (lastHoveredCityIndex >= 0)
        cityList[lastHoveredCityIndex].hovered = false;

      lastHoveredCityIndex = i;
      cityList[i].hovered = true;
      return cityList[i];
    }

  if (lastHoveredCityIndex >= 0)
    cityList[lastHoveredCityIndex].hovered = false;

  lastHoveredCityIndex = -1;
  return null;
}
