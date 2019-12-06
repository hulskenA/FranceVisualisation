import java.util.*;

// Parametrization - Color
boolean DARK_THEME                  = true;
color   WHITE_COLOR                 = color(255);
color   BRIGHT_COLOR                = color(200);
color   DARK_COLOR                  = color(0);

// Parametrization - Window
boolean IS_4K_SCREEN                = false;
boolean DRAW_ONLY_LOCAL_MAP         = false;
boolean DRAW_GLOBAL_MAP             = true;
boolean DRAW_RIGHT_PANEL_MAP        = true;
boolean REDRAW_ON_EACH_INTERACTION  = false;
boolean PANEL_IS_AT_RIGHT           = true;
int     SIZE_MULTIPLIER             = IS_4K_SCREEN ? 2 : 1;

// Parametrization - UI
int     X_PADDING                   =   15 * SIZE_MULTIPLIER;
int     Y_PADDING                   =   15 * SIZE_MULTIPLIER;
float   UI_STROKE_WEIGHT            =    1 * SIZE_MULTIPLIER;
float   SEPARATOR_STROKE_WEIGHT     =    3 * SIZE_MULTIPLIER;
int     MAP_WIDTH                   =  830 * SIZE_MULTIPLIER;
int     MAP_HEIGH                   =  880 * SIZE_MULTIPLIER;
int     MINI_MAP_WIDTH              =  100 * SIZE_MULTIPLIER;
int     MINI_MAP_HEIGH              = int (MINI_MAP_WIDTH * (1f * MAP_HEIGH)/MAP_WIDTH);

// Parametrization - Text
int     FONT_SIZE                   =   20 * SIZE_MULTIPLIER;
int     FONT_SIZE_CITY              =   17 * SIZE_MULTIPLIER;

// Parametrization - Mouse
int     MAX_ZOOM_VALUE              =   10;
float   WHEEL_SPEED                 =  .5f;
float   DRAG_SPEED                  =   1f;

// Parametrization - Value Index
int     POSTAL_INDEX                =    0;
int     X_INDEX                     =    1;
int     Y_INDEX                     =    2;
int     ISEE_CODE_INDEX             =    3;
int     NAME_INDEX                  =    4;
int     POPULATION_INDEX            =    5;
int     SURFACE_INDEX               =    6;
int     ALTITUDE_INDEX              =    7;

// Parametrization - City
float MIN_CIRCLE_RADIUS             =    3 * SIZE_MULTIPLIER;
float MAX_CIRCLE_RADIUS             =   80 * SIZE_MULTIPLIER;
float CIRCLE_STROKE_WEIGHT          =    1 * SIZE_MULTIPLIER;
int   BOX_WIDTH_PADDING             =    3 * SIZE_MULTIPLIER;
int   BOX_HEIGH_PADDING             =    3 * SIZE_MULTIPLIER;
int   MAX_COLOR_VALUE               =  240;

// Parametrization - MiniMap
color MAP_SELECTION_VIEW_COLOR      = color(97, 224, 225);
float MAP_SELECTION_VIEW_CORNER     =  2.5f * SIZE_MULTIPLIER;

// Parametrization - Side Panel
int   SEPARATOR_MARGING             =    3 * SIZE_MULTIPLIER;
int   HEIGH_SELECTED_PANEL          =  200 * SIZE_MULTIPLIER;
int   HEIGH_ALTITUDE_LEGEND         =  200 * SIZE_MULTIPLIER;
int   WIDTH_ALTITUDE_LEGEND         =   50 * SIZE_MULTIPLIER;
int   HEIGH_POPULATION_LEGEND       =   50 * SIZE_MULTIPLIER;
int   HEIGH_DENSITY_SLIDER          =   20 * SIZE_MULTIPLIER;

// Parametrization - Altitude Scrollbar
int   TIMER_FOR_RESET_FILTER        = 1000;
int   ALTITUDE_BUTTON_SIZE          =   15 * SIZE_MULTIPLIER;
float ALTITUDE_BUTTON_CORNER        = 2.5f * SIZE_MULTIPLIER;


// Parametrization - Population Scrollbar
int   POPULATION_BUTTON_SIZE        =   15 * SIZE_MULTIPLIER;
float POPULATION_BUTTON_CORNER      = 2.5f * SIZE_MULTIPLIER;


// Pre-computed data
float minX, maxX;
float minY, maxY;
int   totalCount;
int   minPopulation, maxPopulation;
int   minSurface, maxSurface;
int   minAltitude, maxAltitude;
float minDensity, maxDensity;

// Altitude data
float averageAltitude             = 0;
float medianAltitude              = 0;
float firstQuartileAltitude       = 0;
float thirdQuartileAltitude       = 0;

// Density data to draw
boolean drawDensityAsMin          = true;
float   densityToDraw             = minDensity;

// Population data to draw
boolean drawPopulationAsMax       = true;
int     populationToDisplay       = 2000;
int     maxPopulationCityCounter  = 0;
int     numberOfPopulationSet     = 55;

// Data
City[]                cityList;
List<Float>           altitudeList;
List<Integer>         populationList;
List<Integer>         populationCounterList;
Map<Integer, Integer> populationCount;

// Widgets
MapCanvas localView   = new MapCanvas();
MapCanvas globalView  = new MapCanvas();
PanelUI   rightPanel  = new PanelUI();


void setup()
{
  // Setup
//  size(1760, 1660);
//  size(880, 830);

  size(1230, 830);
//  size(2460, 1660);
  readData();
 
  // Local Map View Settings
  localView.isMiniMap            = false;
  localView.zoom                 = 1;
  localView.x0                   = 0;
  localView.y0                   = 0;
  localView.xFocus               = 0;
  localView.yFocus               = 0;
  localView.widgetWidth          = MAP_WIDTH;
  localView.widgetHeigh          = MAP_HEIGH;
  localView.xPadding             = X_PADDING;
  localView.yPadding             = Y_PADDING;
  localView.minCircleRadius      = MIN_CIRCLE_RADIUS;
  localView.maxCircleRadius      = MAX_CIRCLE_RADIUS;
  localView.circleStrokeWeight   = CIRCLE_STROKE_WEIGHT;
  
  // Global Map View Settings
  globalView.isMiniMap           = true;
  globalView.zoom                = 1;
  globalView.xFocus              = 0;
  globalView.yFocus              = 0;
  globalView.widgetWidth         = MINI_MAP_WIDTH;
  globalView.widgetHeigh         = MINI_MAP_HEIGH;
  globalView.xPadding            = 4 * SIZE_MULTIPLIER;
  globalView.yPadding            = 4 * SIZE_MULTIPLIER;
  globalView.x0                  = localView.x0 + localView.widgetWidth - globalView.widgetWidth;
  globalView.y0                  = 0;
  globalView.minCircleRadius     = 0 * SIZE_MULTIPLIER;
  globalView.maxCircleRadius     = 10 * SIZE_MULTIPLIER;
  
  // Right Side Panel
  rightPanel.x0                  = localView.widgetWidth;
  rightPanel.y0                  = 0; //<>//
  rightPanel.xPadding            = X_PADDING;
  rightPanel.yPadding            = Y_PADDING;
  rightPanel.widgetWidth         = 400 * SIZE_MULTIPLIER;
  rightPanel.widgetHeigh         = localView.widgetHeigh;
  rightPanel.setupWidget();
} //<>//

void draw()
{
  background(DARK_THEME ? DARK_COLOR : BRIGHT_COLOR);

  // Local Map View
  localView.drawWidget();
  if (lastHoveredCityIndex >= 0)
  {
    cityList[lastHoveredCityIndex].drawCity(localView);
    cityList[lastHoveredCityIndex].drawInfos(localView);
  }
  if (lastClickedCityIndex >= 0)
    cityList[lastClickedCityIndex].drawCity(localView);
  if (DRAW_ONLY_LOCAL_MAP)
    return;

  // Global Map View
  if (DRAW_GLOBAL_MAP)
  {
    fill(color(DARK_THEME ? BRIGHT_COLOR : DARK_COLOR));
    strokeWeight(UI_STROKE_WEIGHT);
    rect(globalView.x0, globalView.y0, globalView.widgetWidth, globalView.widgetHeigh,
         0, 0, PANEL_IS_AT_RIGHT ? 0 : 20, PANEL_IS_AT_RIGHT ? 20 : 0);
    globalView.drawWidget();
    if (localView.zoom > 1)
    {
      stroke(DARK_COLOR);
      strokeWeight(UI_STROKE_WEIGHT);
      fill(color(MAP_SELECTION_VIEW_COLOR, 150));
      float x = globalView.x0 - (localView.xFocus * globalView.widgetWidth) / (localView.widgetWidth * localView.zoom);
      float y = globalView.y0 - (localView.yFocus * globalView.widgetHeigh) / (localView.widgetHeigh * localView.zoom);
      float w = globalView.widgetWidth / localView.zoom;
      float h = globalView.widgetHeigh / localView.zoom;
      rect(x, y, w, h, MAP_SELECTION_VIEW_CORNER, MAP_SELECTION_VIEW_CORNER, MAP_SELECTION_VIEW_CORNER, MAP_SELECTION_VIEW_CORNER);
    }
    if (lastClickedCityIndex >= 0)
      cityList[lastClickedCityIndex].drawCity(globalView);
  }

  // Right Side Panel
  if (DRAW_RIGHT_PANEL_MAP)
    rightPanel.drawWidget();
}

void readData()
{
  // Load Data
  String[] lines = loadStrings("./villes.tsv");
  parseInfo(lines[0]);

  populationList  = new ArrayList<Integer>();
  populationCount  = new HashMap<Integer, Integer>();
  for (int i = minPopulation; i <= maxPopulation; i++)
    populationCount.put(i, 0);

  altitudeList     = new ArrayList<Float>();
  cityList         = new City[totalCount-2];
  City city;
  for (int i = 2 ; i < totalCount ; ++i)
  {
    // Create New City
    String[] columns  = split(lines[i], TAB);
    city              = new City();
    city.name         =        columns[NAME_INDEX];
    city.iseeCode     = int   (columns[ISEE_CODE_INDEX]);
    city.postalcode   = int   (columns[POSTAL_INDEX]);
    city.x            = float (columns[X_INDEX]);
    city.y            = float (columns[Y_INDEX]);
    city.population   = int   (columns[POPULATION_INDEX]);
    city.surface      = float (columns[SURFACE_INDEX]);
    city.altitude     = float (columns[ALTITUDE_INDEX]);
    city.density      = city.surface == 0 ? 0 : 1f * city.population / city.surface;
    cityList[i-2]     = city;

    altitudeList.add(city.altitude);
    populationList.add(city.population);
    populationCount.put(city.population / numberOfPopulationSet, populationCount.get(city.population / numberOfPopulationSet) + 1);
    if (populationCount.get(city.population / numberOfPopulationSet) > maxPopulationCityCounter)
      maxPopulationCityCounter = populationCount.get(city.population / numberOfPopulationSet);

    // Search Min & Max Density
    if (city.density < minDensity)
      minDensity = city.density;
    else if (city.density > maxDensity)
      maxDensity = city.density;
  }

  // Compute Average Altitude
  float tmp = 0;
  int nbElement = altitudeList.size();
  for (float altitude : altitudeList)
      tmp += altitude;
  averageAltitude = tmp / nbElement;

  // Compute Quartiles/Median Altitude
  Collections.sort(altitudeList);
  if (nbElement % 2 == 0)
      medianAltitude = (altitudeList.get(nbElement/2) + altitudeList.get(nbElement/2 - 1))/2f;
  else
      medianAltitude = altitudeList.get(nbElement/2);
  int n = int (Math.round(nbElement * .25f));
  firstQuartileAltitude = altitudeList.get(n);
  
  n = int (Math.round(nbElement * .75f));
  thirdQuartileAltitude = altitudeList.get(n);
}

void parseInfo(String line)
{
  String   infoString = line.substring(2);
  String[] infoPieces = split(infoString, ',');

  totalCount     = int   (infoPieces[0]);
  minX           = float (infoPieces[1]);
  maxX           = float (infoPieces[2]);
  minY           = float (infoPieces[3]);
  maxY           = float (infoPieces[4]);
  minPopulation  = int   (infoPieces[5]);
  maxPopulation  = int   (infoPieces[6]);
  minSurface     = int   (infoPieces[7]);
  maxSurface     = int   (infoPieces[8]);
  minAltitude    = int   (infoPieces[9]);
  maxAltitude    = int   (infoPieces[10]);
  minDensity     = maxPopulation;
  maxDensity     = 0;
}

public static float clamp(float val, float min, float max)
{
    return Math.max(min, Math.min(max, val));
}
