public class CitySelectedPanel extends Widget
{
  
  public color fontColor = color(DARK_THEME ? DARK_COLOR : WHITE_COLOR);

  private TextWidget titleText            = new TextWidget();
  private TextWidget cityNameText         = new TextWidget();
  private TextWidget postalTitleCodeText  = new TextWidget();
  private TextWidget postalCodeText       = new TextWidget();
  private TextWidget populationTitleText  = new TextWidget();
  private TextWidget populationText       = new TextWidget();
  private TextWidget surfaceTitleText     = new TextWidget();
  private TextWidget surfaceText          = new TextWidget();
  private TextWidget iseeTitleText        = new TextWidget();
  private TextWidget iseeText             = new TextWidget();
  private TextWidget densityTitleText     = new TextWidget();
  private TextWidget densityText          = new TextWidget();
  private TextWidget altitudeTitleText    = new TextWidget();
  private TextWidget altitudeText         = new TextWidget();


  public void setupWidget()
  {
    float fontSize = (this.widgetHeigh - Y_PADDING / 2) / 12;
    
    // Left Side
    this.titleText.x0                 = this.x0;
    this.titleText.y0                 = this.y0;
    this.titleText.xPadding           = X_PADDING;
    this.titleText.yPadding           = Y_PADDING / 2;
    this.titleText.fontSize           = fontSize;

    this.initTextFields(this.cityNameText,         this.titleText,           .85f);
    this.initTextFields(this.postalTitleCodeText,  this.cityNameText,        1.15f);
    this.initTextFields(this.postalCodeText,       this.postalTitleCodeText,  .85f);
    this.initTextFields(this.populationTitleText,  this.postalCodeText,      1.15f);
    this.initTextFields(this.populationText,       this.populationTitleText,  .85f);
    this.initTextFields(this.populationTitleText,  this.postalCodeText,      1.15f);
    this.initTextFields(this.populationText,       this.populationTitleText,  .85f);
    this.initTextFields(this.surfaceTitleText,     this.populationText,      1.15f);
    this.initTextFields(this.surfaceText,          this.surfaceTitleText,     .85f);

    this.titleText.message            = "Ville selectionnée :";
    this.postalTitleCodeText.message  = "Code Postal :";
    this.populationTitleText.message  = "Population :";
    this.surfaceTitleText.message     = "Surface :";
    
    // Right Side
    this.initTextFields(this.iseeTitleText,        this.cityNameText,        1.15f);
    this.iseeTitleText.x0 = this.x0 + this.widgetWidth / 2;
    
    this.initTextFields(this.iseeText,             this.iseeTitleText,        .85f);
    this.initTextFields(this.densityTitleText,          this.iseeText,       1.15f);
    this.initTextFields(this.densityText,       this.densityTitleText,        .85f);
    this.initTextFields(this.altitudeTitleText,      this.densityText,       1.15f);
    this.initTextFields(this.altitudeText,     this.altitudeTitleText,        .85f);
    
    this.iseeTitleText.message        = "Code ISEE :";
    this.densityTitleText.message     = "Densité de population :";
    this.altitudeTitleText.message    = "Altitude :";
  }
  
  public void drawWidget()
  {
    this.titleText.fontColor     = fontColor;
    this.cityNameText.fontColor  = fontColor;
   
    // Checking if one city is selected
    this.titleText.drawWidget();
    if (lastClickedCityIndex < 0)
    {
      this.cityNameText.message = "None";
      this.cityNameText.drawWidget();
      return;
    }

    City selectedCity = cityList[lastClickedCityIndex];
    
    // Left Side    
    this.postalTitleCodeText.fontColor  = fontColor;
    this.postalCodeText.fontColor       = fontColor;
    this.populationTitleText.fontColor  = fontColor;
    this.populationText.fontColor       = fontColor;
    this.surfaceTitleText.fontColor     = fontColor;
    this.surfaceText.fontColor          = fontColor;

    this.cityNameText.message           = selectedCity.name;
    this.postalCodeText.message         = "" + selectedCity.postalcode;
    this.populationText.message         = int (selectedCity.population) + " ha";
    this.surfaceText.message            = selectedCity.surface + " km2";

    this.cityNameText.drawWidget();
    this.postalTitleCodeText.drawWidget();
    this.postalCodeText.drawWidget();
    this.populationTitleText.drawWidget();
    this.populationText.drawWidget();
    this.surfaceTitleText.drawWidget();
    this.surfaceText.drawWidget();
    
    // Right Side
    this.iseeTitleText.fontColor        = fontColor;
    this.iseeText.fontColor             = fontColor;
    this.densityTitleText.fontColor     = fontColor;
    this.densityText.fontColor          = fontColor;
    this.altitudeTitleText.fontColor    = fontColor;
    this.altitudeText.fontColor         = fontColor;
    
    this.iseeText.message               = "" + selectedCity.iseeCode;
    this.densityText.message            = selectedCity.density + " ha/km2";
    this.altitudeText.message           = selectedCity.altitude + " km";
    
    this.iseeTitleText.drawWidget();
    this.iseeText.drawWidget();
    this.densityTitleText.drawWidget();
    this.densityText.drawWidget();
    this.altitudeTitleText.drawWidget();
    this.altitudeText.drawWidget();

  }


  private void initTextFields(TextWidget text, TextWidget lastText, float fontSizeMultiplier)
  {
    text.x0        = lastText.x0;
    text.y0        = int (lastText.y0 + lastText.fontSize + lastText.yPadding);
    text.xPadding  = lastText.xPadding;
    text.yPadding  = lastText.yPadding;
    text.fontSize  = lastText.fontSize * fontSizeMultiplier;
  }

}
