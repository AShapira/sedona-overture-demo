<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{851df60f-f79a-5e80-9346-d616a661ca2b}">
      <rule key="{0f442687-e376-525d-bbd3-d27851635cc7}" label="Canal" symbol="0" filter="attribute(@feature, 'subtype') = 'canal'" scalemaxdenom="250000" />
      <rule key="{24a341ca-f189-57d4-ad95-0ae74d83723a}" label="Human Made" symbol="1" filter="attribute(@feature, 'subtype') = 'human_made'" scalemaxdenom="250000" />
      <rule key="{52ad91d4-f17a-5c16-8b9e-badaad17cf74}" label="Lake" symbol="2" filter="attribute(@feature, 'subtype') = 'lake'" scalemaxdenom="2000000" />
      <rule key="{e0eaf757-81e5-50e4-9563-c44abd382987}" label="Ocean" symbol="3" filter="attribute(@feature, 'subtype') = 'ocean'" scalemaxdenom="100000000" />
      <rule key="{cc991ea7-4ed8-5e64-98af-3fb5c6c706e4}" label="Physical" symbol="4" filter="attribute(@feature, 'subtype') = 'physical'" scalemaxdenom="250000" />
      <rule key="{08943506-fae0-54f1-9a52-e0409111a39f}" label="Pond" symbol="5" filter="attribute(@feature, 'subtype') = 'pond'" scalemaxdenom="250000" />
      <rule key="{b2c23833-5dfb-59b9-90e0-d74448e930af}" label="Reservoir" symbol="6" filter="attribute(@feature, 'subtype') = 'reservoir'" scalemaxdenom="2000000" />
      <rule key="{afb3d52f-5c21-5a2d-9ca7-27c9765aa8a0}" label="River" symbol="7" filter="attribute(@feature, 'subtype') = 'river'" scalemaxdenom="2000000" />
      <rule key="{504269b1-a860-5f88-87ba-66937f4fcc1b}" label="Spring" symbol="8" filter="attribute(@feature, 'subtype') = 'spring'" scalemaxdenom="250000" />
      <rule key="{b5398d71-db71-5913-9698-5c355608f456}" label="Stream" symbol="9" filter="attribute(@feature, 'subtype') = 'stream'" scalemaxdenom="250000" />
      <rule key="{12983bf8-ac3f-5f03-8314-01dbd105664c}" label="Wastewater" symbol="10" filter="attribute(@feature, 'subtype') = 'wastewater'" scalemaxdenom="250000" />
      <rule key="{0d1f9a79-ff13-5479-8435-5215493f9ce9}" label="Water" symbol="11" filter="attribute(@feature, 'subtype') = 'water'" scalemaxdenom="250000" />
      <rule key="{9f8b5825-d3f4-5ee6-b51b-f4dd62bee7f3}" label="Other or missing value" symbol="12" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{d1905ea0-ada1-55c8-861c-16967e9b29eb}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{e5ac3347-f1a7-5b18-a696-1d6eff485a26}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{dc0a648a-a5b9-5887-8149-11abc167b357}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{e959614e-d21d-5898-b23f-d483036c9acd}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{335da758-d556-58c8-8bee-ba5b587c8964}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{5d005d73-4631-5080-8203-cbc1e1b99c4f}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{a08f2061-59a2-5f1d-af53-eb256b3f3f72}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{223f8344-9ec2-576d-b33b-db29e92bbfaa}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{091365c6-8ea9-5d94-a4c6-8ae72f7f7568}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{399ac571-5055-5c67-a4db-145668c8ca79}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{536dce56-7633-5af0-802a-4896914e4676}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{fbbb26ad-aa25-54a4-92be-dd17eb8ce971}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{f9151a32-713c-54b0-b842-373bf94b8cab}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="125,135,144,190" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,190" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <customproperties>
    <property key="overture/schema_version" value="1.18.0" />
    <property key="overture/style_id" value="base-water-point" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-water-point dark style bound to Overture schema 1.18.0" />
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
      <placement allowDegraded="0" centroidInside="1" dist="1" distUnits="MM" fitInPolygonOnly="0" layerType="PointGeometry" maxCurvedCharAngleIn="25" maxCurvedCharAngleOut="-25" offsetType="0" overlapHandling="PreventOverlap" placement="6" placementFlags="10" predefinedPositionOrder="TR,TL,BR,BL,R,L" priority="5" quadOffset="4" repeatDistance="40" repeatDistanceUnits="MM" />
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="0" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="250000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>0</layerGeometryType>
</qgis>
