<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>surfaces_full</Name>
    <UserStyle>
      <Name>surfaces_full</Name>
      <Title>Physical landmass and ocean: full</Title>
      <Abstract>EPSG:4326 surface export; fill only to avoid drawing tile boundaries.</Abstract>
      <FeatureTypeStyle>
      <Rule>
        <Name>ocean_full</Name>
        <Title>ocean (full)</Title>
        <ogc:Filter><ogc:PropertyIsEqualTo>
          <ogc:PropertyName>surface</ogc:PropertyName><ogc:Literal>ocean</ogc:Literal>
        </ogc:PropertyIsEqualTo></ogc:Filter>
        <MaxScaleDenominator>500000</MaxScaleDenominator>
        <PolygonSymbolizer><Fill>
          <CssParameter name="fill">#78bce0</CssParameter>
          <CssParameter name="fill-opacity">1.0</CssParameter>
        </Fill></PolygonSymbolizer>
      </Rule>
      <Rule>
        <Name>landmass_full</Name>
        <Title>landmass (full)</Title>
        <ogc:Filter><ogc:PropertyIsEqualTo>
          <ogc:PropertyName>surface</ogc:PropertyName><ogc:Literal>landmass</ogc:Literal>
        </ogc:PropertyIsEqualTo></ogc:Filter>
        <MaxScaleDenominator>500000</MaxScaleDenominator>
        <PolygonSymbolizer><Fill>
          <CssParameter name="fill">#cfbd8a</CssParameter>
          <CssParameter name="fill-opacity">1.0</CssParameter>
        </Fill></PolygonSymbolizer>
      </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
