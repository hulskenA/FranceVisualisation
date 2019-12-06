class PanelUI extends Widget
{

  private CitySelectedPanel    selectedCityPanel       = new CitySelectedPanel();
  private TextWidget           densityFilterOutput     = new TextWidget();
  private TextWidget           populationFilterOutput  = new TextWidget();
  private TextWidget           altitudeFilterOutput    = new TextWidget();
  private DensitySlider        densitySlider           = new DensitySlider();
  private AltitudeLegend       altitudeLegend          = new AltitudeLegend();
  private PopulationSelection  populationSelection     = new PopulationSelection();


  public void setupWidget()
  {
    this.updateWidget();
  }
  
  public void updateWidget()
  {
    // Setup Selected City Panel
    this.selectedCityPanel.x0              = this.x0;
    this.selectedCityPanel.y0              = this.y0;
    this.selectedCityPanel.widgetWidth     = this.widgetWidth;
    this.selectedCityPanel.widgetHeigh     = HEIGH_SELECTED_PANEL;
    this.selectedCityPanel.fontColor       = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);
    this.selectedCityPanel.setupWidget();

    // Setup Population Filter Text
    this.densityFilterOutput.x0            = this.x0;
    this.densityFilterOutput.y0            = this.selectedCityPanel.y0 + this.selectedCityPanel.widgetHeigh + SEPARATOR_MARGING;
    this.densityFilterOutput.xPadding      = X_PADDING;
    this.densityFilterOutput.yPadding      = 10;
    this.densityFilterOutput.fontSize      = FONT_SIZE;
    this.densityFilterOutput.fontColor     = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);

    // Setup PopulationSelection
    this.densitySlider.x0                  = this.x0 + X_PADDING;
    this.densitySlider.y0                  = int (this.densityFilterOutput.y0 + this.densityFilterOutput.fontSize * 4);
    this.densitySlider.widgetWidth         = int( this.widgetWidth - 2 * X_PADDING);
    this.densitySlider.widgetHeigh         = HEIGH_DENSITY_SLIDER;
    this.densitySlider.setupWidget();

    // Setup Population Filter Text
    this.populationFilterOutput.x0         = this.x0;
    this.populationFilterOutput.y0         = int (this.densitySlider.y0 + this.densitySlider.widgetHeigh);
    this.populationFilterOutput.xPadding   = X_PADDING;
    this.populationFilterOutput.yPadding   = 10;
    this.populationFilterOutput.fontSize   = FONT_SIZE;
    this.populationFilterOutput.fontColor  = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);

    // Setup PopulationSelection
    this.populationSelection.x0            = this.x0 + X_PADDING;
    this.populationSelection.y0            = int (this.populationFilterOutput.y0 + this.populationFilterOutput.fontSize * 4);
    this.populationSelection.widgetWidth   = int( this.widgetWidth - 2 * X_PADDING);
    this.populationSelection.widgetHeigh   = HEIGH_POPULATION_LEGEND;
    this.populationSelection.setupWidget();

    // Setup Altitude Filter Text
    this.altitudeFilterOutput.x0           = this.x0;
    this.altitudeFilterOutput.y0           = int (this.populationSelection.y0 + 2 * this.populationSelection.widgetHeigh + 2 * SEPARATOR_MARGING);
    this.altitudeFilterOutput.xPadding     = X_PADDING;
    this.altitudeFilterOutput.yPadding     = 10;
    this.altitudeFilterOutput.fontSize     = FONT_SIZE;
    this.altitudeFilterOutput.fontColor    = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);

    // Setup Altitude Legend
    this.altitudeLegend.x0                 = this.x0 + X_PADDING;
    this.altitudeLegend.y0                 = int (this.altitudeFilterOutput.y0 + 2 * this.altitudeFilterOutput.yPadding + this.altitudeFilterOutput.fontSize * 4);
    this.altitudeLegend.xPadding           = X_PADDING / 2;
    this.altitudeLegend.yPadding           = Y_PADDING;
    this.altitudeLegend.widgetWidth        = WIDTH_ALTITUDE_LEGEND;
    this.altitudeLegend.widgetHeigh        = HEIGH_ALTITUDE_LEGEND;
    this.altitudeLegend.setupWidget();
  }

  public void drawWidget()
  {
    // Background
    strokeWeight(0);
    fill(color(DARK_THEME ? BRIGHT_COLOR : DARK_COLOR + WHITE_COLOR - BRIGHT_COLOR));
    rect(this.x0, this.y0, this.widgetWidth, this.widgetHeigh);
    strokeWeight(SEPARATOR_STROKE_WEIGHT);

    // Selected City Infos
    this.selectedCityPanel.drawWidget();
    this.drawSeparator(this.selectedCityPanel.y0 + this.selectedCityPanel.widgetHeigh + SEPARATOR_MARGING);

    // Filter Density Text
    this.densityFilterOutput.message = "Afficher les densitées " + (drawDensityAsMin ? "supérieures" : "inférieures") + " à:\n" + densityToDraw;
    this.densityFilterOutput.drawWidget();

    // DensitySlider
    this.densitySlider.drawWidget();

    // Filter Population Text
    this.populationFilterOutput.message = "Afficher les populations " + (drawPopulationAsMax ? "inférieures" : "supérieures") + " à:\n" + populationToDisplay;
    this.populationFilterOutput.drawWidget();

    // Population Selection
    this.populationSelection.drawWidget();
    this.drawSeparator(this.populationSelection.y0 + 2 * this.populationSelection.widgetHeigh + SEPARATOR_MARGING);

    // Filter Altitude Text
    this.altitudeFilterOutput.message = "Afficher les altitudes " + (this.altitudeLegend.selectionAsInside ? "entre" : "excepté") + ":\n" + this.altitudeLegend.minAltitudeToDisplay + " et " + this.altitudeLegend.maxAltitudeToDisplay + " km";
    this.altitudeFilterOutput.drawWidget();

    // Altitude Legend
    this.altitudeLegend.drawWidget();

    // Separator With Map
    strokeWeight(SEPARATOR_STROKE_WEIGHT);
    stroke(DARK_THEME ? DARK_COLOR : BRIGHT_COLOR);
    line(this.x0, this.y0, this.x0, this.y0 + this.widgetHeigh);
  }

  private void drawSeparator(float yLine)
  {
    stroke(DARK_THEME ? DARK_COLOR : BRIGHT_COLOR);
    strokeWeight(SEPARATOR_STROKE_WEIGHT);
    line(this.x0, yLine, this.x0 + this.widgetWidth, yLine);
  }
}
