<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="0" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{eeaf3116-ca04-5a06-ab4f-e534e1dae174}">
      <rule key="{48bde8f2-bd4b-5644-9bea-9e30551f4e6b}" label="Deeper than 0 m" symbol="0" filter="attribute(@feature, 'depth') = '0'" scalemaxdenom="100000000" />
      <rule key="{b52075c7-d4bc-55f0-8ff5-6dc7a3bb8e33}" label="Deeper than 10 m" symbol="1" filter="attribute(@feature, 'depth') = '10'" scalemaxdenom="100000000" />
      <rule key="{0a0ee65a-739e-5fe8-9d8e-042d35f65ccb}" label="Deeper than 50 m" symbol="2" filter="attribute(@feature, 'depth') = '50'" scalemaxdenom="100000000" />
      <rule key="{25cdca75-a218-5430-bb70-5d3571d9966b}" label="Deeper than 100 m" symbol="3" filter="attribute(@feature, 'depth') = '100'" scalemaxdenom="100000000" />
      <rule key="{6aa97a95-335c-5f27-953e-b65ff7a4de7f}" label="Deeper than 500 m" symbol="4" filter="attribute(@feature, 'depth') = '500'" scalemaxdenom="100000000" />
      <rule key="{a64b9bee-3b52-5ef5-aa86-2d90b5db0f3f}" label="Deeper than 1000 m" symbol="5" filter="attribute(@feature, 'depth') = '1000'" scalemaxdenom="100000000" />
      <rule key="{24353ee9-5f04-56c3-909c-45f097451319}" label="Deeper than 1500 m" symbol="6" filter="attribute(@feature, 'depth') = '1500'" scalemaxdenom="100000000" />
      <rule key="{256d49dd-c342-5a84-a737-b7e8bb876569}" label="Deeper than 2000 m" symbol="7" filter="attribute(@feature, 'depth') = '2000'" scalemaxdenom="100000000" />
      <rule key="{fd99607a-4444-5335-aba8-152f7fc113f3}" label="Deeper than 2500 m" symbol="8" filter="attribute(@feature, 'depth') = '2500'" scalemaxdenom="100000000" />
      <rule key="{c8fcbff9-8be8-57e0-bc32-b82072db0c60}" label="Deeper than 3000 m" symbol="9" filter="attribute(@feature, 'depth') = '3000'" scalemaxdenom="100000000" />
      <rule key="{93a00366-0e98-591c-a555-eeaf5c614b74}" label="Other depth" symbol="10" filter="ELSE" scalemaxdenom="100000000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" id="{a24d2647-4bcd-5e69-a14a-bf42fb2a0e24}" locked="0" pass="0">
          <prop k="color" v="71,127,158,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="fill">
        <layer class="SimpleFill" enabled="1" id="{39419551-686e-518d-9e56-c9e97890b06c}" locked="0" pass="1">
          <prop k="color" v="63,117,149,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="fill">
        <layer class="SimpleFill" enabled="1" id="{45cf7720-aa9f-5e2e-a955-3cec4c537545}" locked="0" pass="2">
          <prop k="color" v="55,107,140,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="fill">
        <layer class="SimpleFill" enabled="1" id="{0a52fe64-de97-56f4-a65c-971f6f20e8aa}" locked="0" pass="3">
          <prop k="color" v="48,97,129,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="fill">
        <layer class="SimpleFill" enabled="1" id="{0f18fb90-9cef-5f97-858f-9872f66a1488}" locked="0" pass="4">
          <prop k="color" v="41,88,119,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="fill">
        <layer class="SimpleFill" enabled="1" id="{9cf43465-7288-57d4-9272-057f3afb6e4c}" locked="0" pass="5">
          <prop k="color" v="35,79,109,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="fill">
        <layer class="SimpleFill" enabled="1" id="{a1884c69-5e0f-55c1-91b0-2fc1d3f3b8a5}" locked="0" pass="6">
          <prop k="color" v="31,72,102,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="fill">
        <layer class="SimpleFill" enabled="1" id="{8019410d-c491-5434-9aab-393e28a33c2a}" locked="0" pass="7">
          <prop k="color" v="27,65,94,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="fill">
        <layer class="SimpleFill" enabled="1" id="{e7e3357f-9d36-5fbe-97f7-8a422d416105}" locked="0" pass="8">
          <prop k="color" v="23,57,87,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="fill">
        <layer class="SimpleFill" enabled="1" id="{ed2f01c0-ca41-5462-9862-b3fd4a892c18}" locked="0" pass="9">
          <prop k="color" v="18,50,79,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="fill">
        <layer class="SimpleFill" enabled="1" id="{a2ddefc9-3f17-517d-b309-1c35ed6dd377}" locked="0" pass="10">
          <prop k="color" v="23,61,99,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <customproperties>
    <property key="overture/schema_version" value="1.18.0" />
    <property key="overture/style_id" value="base-bathymetry-polygon" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-bathymetry-polygon dark style bound to Overture schema 1.18.0" />
    <property key="overture/compatibility" value="Bound to Overture schema 1.18.0; other versions are unverified" />
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>2</layerGeometryType>
</qgis>
