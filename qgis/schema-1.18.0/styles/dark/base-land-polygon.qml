<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{dc8c7d7e-e9ba-5f99-b613-ab4be0bc050e}">
      <rule key="{ac2e955f-89ca-5af0-a39f-0c597b8a8904}" label="Crater" symbol="0" filter="attribute(@feature, 'subtype') = 'crater'" scalemaxdenom="250000" />
      <rule key="{20412ff2-3c7f-52db-a23e-0fdd09525d02}" label="Desert" symbol="1" filter="attribute(@feature, 'subtype') = 'desert'" scalemaxdenom="2000000" />
      <rule key="{46fea61d-573c-594a-8a26-768eb542c74d}" label="Forest" symbol="2" filter="attribute(@feature, 'subtype') = 'forest'" scalemaxdenom="2000000" />
      <rule key="{84b05946-59c6-5b76-963e-028ea4adbe61}" label="Glacier" symbol="3" filter="attribute(@feature, 'subtype') = 'glacier'" scalemaxdenom="2000000" />
      <rule key="{3e8c1523-7bc1-5de1-a32a-5e3d8452d34c}" label="Grass" symbol="4" filter="attribute(@feature, 'subtype') = 'grass'" scalemaxdenom="250000" />
      <rule key="{89c70775-03d8-54a8-8b39-85de7a1008da}" label="Land" symbol="5" filter="attribute(@feature, 'subtype') = 'land'" scalemaxdenom="2000000" />
      <rule key="{a3414584-57f3-5e56-9336-3cd203c94633}" label="Physical" symbol="6" filter="attribute(@feature, 'subtype') = 'physical'" scalemaxdenom="2000000" />
      <rule key="{8e4382e7-b5d2-572d-b5ff-bf5c2f2dcc3f}" label="Reef" symbol="7" filter="attribute(@feature, 'subtype') = 'reef'" scalemaxdenom="250000" />
      <rule key="{9aa5380e-8423-5482-b10b-975a21e07f5b}" label="Rock" symbol="8" filter="attribute(@feature, 'subtype') = 'rock'" scalemaxdenom="250000" />
      <rule key="{086fb26b-cf14-599b-adb4-add1c0fdabd5}" label="Sand" symbol="9" filter="attribute(@feature, 'subtype') = 'sand'" scalemaxdenom="250000" />
      <rule key="{eafa3a9f-0a99-553a-9719-e86dddd4b098}" label="Shrub" symbol="10" filter="attribute(@feature, 'subtype') = 'shrub'" scalemaxdenom="250000" />
      <rule key="{d97757ca-28cf-5680-8ae4-900e881aa7fc}" label="Tree" symbol="11" filter="attribute(@feature, 'subtype') = 'tree'" scalemaxdenom="250000" />
      <rule key="{f6a651ab-d3c0-5efa-810d-fe81c324a105}" label="Wetland" symbol="12" filter="attribute(@feature, 'subtype') = 'wetland'" scalemaxdenom="250000" />
      <rule key="{2bca1ab4-58b1-5ee5-a067-7e64d7973c23}" label="Other or missing value" symbol="13" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" id="{d2d7eb3c-3262-5f63-9360-dc7dc4c1e68d}" locked="0" pass="0">
          <prop k="color" v="118,91,72,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="fill">
        <layer class="SimpleFill" enabled="1" id="{2f5548b2-aed2-57ed-8ea6-1d26ddbc819d}" locked="0" pass="0">
          <prop k="color" v="139,121,84,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="fill">
        <layer class="SimpleFill" enabled="1" id="{a5f425b4-8b52-53b9-bf98-aca3a070be4b}" locked="0" pass="0">
          <prop k="color" v="47,86,60,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="fill">
        <layer class="SimpleFill" enabled="1" id="{3842d4f6-c8f1-54f7-94d7-68abd5bf889a}" locked="0" pass="0">
          <prop k="color" v="17,21,26,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="fill">
        <layer class="SimpleFill" enabled="1" id="{47342c01-71a9-5e79-adfe-aab582854d9d}" locked="0" pass="0">
          <prop k="color" v="66,107,77,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="fill">
        <layer class="SimpleFill" enabled="1" id="{5949d7e0-8e36-5594-9994-e541accd28a0}" locked="0" pass="0">
          <prop k="color" v="77,80,86,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="fill">
        <layer class="SimpleFill" enabled="1" id="{8c9f3255-497a-5f8d-86df-c14a86511175}" locked="0" pass="0">
          <prop k="color" v="118,91,72,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="fill">
        <layer class="SimpleFill" enabled="1" id="{38adc53d-7812-51b8-9ae7-fa631ebeb601}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="fill">
        <layer class="SimpleFill" enabled="1" id="{1bbb917a-51a6-5c50-a290-0c0d05646f8a}" locked="0" pass="0">
          <prop k="color" v="118,91,72,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="fill">
        <layer class="SimpleFill" enabled="1" id="{60c82d2d-d72c-5ca5-867b-5918b687e7d4}" locked="0" pass="0">
          <prop k="color" v="139,121,84,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="fill">
        <layer class="SimpleFill" enabled="1" id="{52633b0e-0b22-502d-b9d3-66c2058a19a2}" locked="0" pass="0">
          <prop k="color" v="66,107,77,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="fill">
        <layer class="SimpleFill" enabled="1" id="{264ba52e-dbfb-5d0b-ad6f-ba60cce495f6}" locked="0" pass="0">
          <prop k="color" v="47,86,60,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="fill">
        <layer class="SimpleFill" enabled="1" id="{e1b41e86-9abc-56a1-aecf-2b30ca054e8b}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="fill">
        <layer class="SimpleFill" enabled="1" id="{188ee3d1-c748-53ba-aabf-8665a9ac7499}" locked="0" pass="0">
          <prop k="color" v="125,135,144,190" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,190" />
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
    <property key="overture/style_id" value="base-land-polygon" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-land-polygon dark style bound to Overture schema 1.18.0" />
    <property key="overture/compatibility" value="Bound to Overture schema 1.18.0; other versions are unverified" />
  </customproperties>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style allowHtml="0" blendMode="0" capitalization="0" fieldName="coalesce(map_get(attribute(@feature, 'names.common'), left(@qgis_locale, 2)), map_get(attribute(@feature, 'names.common'), 'en'), attribute(@feature, 'names.primary'))" fontFamily="Noto Sans" fontItalic="0" fontKerning="1" fontLetterSpacing="0" fontSize="9" fontSizeUnit="Point" fontStrikeout="0" fontUnderline="0" fontWeight="400" fontWordSpacing="0" forcedBold="0" forcedItalic="0" isExpression="1" multilineHeight="1" namedStyle="Regular" textColor="233,237,241,255" textOpacity="1" textOrientation="horizontal">
        <families />
        <text-buffer bufferBlendMode="0" bufferColor="17,21,26,255" bufferDraw="1" bufferJoinStyle="128" bufferNoFill="1" bufferOpacity="0.92" bufferSize="1.1" bufferSizeUnits="MM" />
        <text-mask maskEnabled="0" />
        <background shapeDraw="0" />
        <shadow shadowDraw="0" />
        <substitutions />
      </text-style>
      <text-format autoWrapLength="0" multilineAlign="0" wrapChar="" />
      <placement allowDegraded="0" centroidInside="1" dist="1" distUnits="MM" fitInPolygonOnly="0" layerType="PolygonGeometry" maxCurvedCharAngleIn="25" maxCurvedCharAngleOut="-25" offsetType="0" overlapHandling="PreventOverlap" placement="1" placementFlags="10" predefinedPositionOrder="TR,TL,BR,BL,R,L" priority="5" quadOffset="4" repeatDistance="40" repeatDistanceUnits="MM" />
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="0" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="250000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>2</layerGeometryType>
</qgis>
