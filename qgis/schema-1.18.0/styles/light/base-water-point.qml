<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{ffa44462-f662-5786-b2a2-224e5cd5caf4}">
      <rule key="{64419f59-c526-574a-a3fc-62f15257aef1}" label="Canal" symbol="0" filter="attribute(@feature, 'subtype') = 'canal'" scalemaxdenom="250000" />
      <rule key="{3b8dc5ba-c175-50ae-ac3e-8b298286256e}" label="Human Made" symbol="1" filter="attribute(@feature, 'subtype') = 'human_made'" scalemaxdenom="250000" />
      <rule key="{09226f16-68e0-5300-8757-8df024f30b59}" label="Lake" symbol="2" filter="attribute(@feature, 'subtype') = 'lake'" scalemaxdenom="2000000" />
      <rule key="{dc551ca3-eb9f-50ed-9a4f-ccbb63ab3470}" label="Ocean" symbol="3" filter="attribute(@feature, 'subtype') = 'ocean'" scalemaxdenom="100000000" />
      <rule key="{1ae4cc29-f9f7-5a12-af88-e22f77ba2297}" label="Physical" symbol="4" filter="attribute(@feature, 'subtype') = 'physical'" scalemaxdenom="250000" />
      <rule key="{a41d57c2-d8c3-51fd-a25c-96e9f7a8ff6f}" label="Pond" symbol="5" filter="attribute(@feature, 'subtype') = 'pond'" scalemaxdenom="250000" />
      <rule key="{de89b015-7002-5861-9934-0a296ecbd75d}" label="Reservoir" symbol="6" filter="attribute(@feature, 'subtype') = 'reservoir'" scalemaxdenom="2000000" />
      <rule key="{f8ac8c1b-415b-511e-a9d9-d0611f67cbc9}" label="River" symbol="7" filter="attribute(@feature, 'subtype') = 'river'" scalemaxdenom="2000000" />
      <rule key="{b10af549-0c09-552b-aec5-4cb6a21c0f72}" label="Spring" symbol="8" filter="attribute(@feature, 'subtype') = 'spring'" scalemaxdenom="250000" />
      <rule key="{6aff2702-cb0e-5dd4-863e-27d5324725a5}" label="Stream" symbol="9" filter="attribute(@feature, 'subtype') = 'stream'" scalemaxdenom="250000" />
      <rule key="{48c12cdd-6b17-5a49-84c2-3db4854514e7}" label="Wastewater" symbol="10" filter="attribute(@feature, 'subtype') = 'wastewater'" scalemaxdenom="250000" />
      <rule key="{f71d9bb5-f5c4-51bc-aad6-b3535bc94abf}" label="Water" symbol="11" filter="attribute(@feature, 'subtype') = 'water'" scalemaxdenom="250000" />
      <rule key="{5fa9d9b7-8ad0-5327-98bf-62b63ff7b1ef}" label="Other or missing value" symbol="12" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{80b4889d-19a3-56a0-97a0-96f0da5ffc32}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{b555ce25-72cb-53b9-8836-9f26f6294017}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{443c532d-ed0b-5691-8a2a-8606d2ea43d6}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{8486c183-c622-527d-94f7-3602c755138f}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{7c9c9f9b-57c5-56dc-8c64-8b8c4a307abd}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{6c1b2843-bc3b-5d04-b71e-94b35d94e0fa}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{2f9f29d1-521d-50ca-93f9-20c8d7ee8047}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{a0fd200c-5c89-5ad3-9df2-83529577837b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{a99a7b96-484e-5359-8b29-fd9e083ada37}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{6cda8381-db8c-5f19-9ddf-a1b85b937cb5}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{6a577ea1-412e-5e11-9491-688f8b9fbb13}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{fd8d5d15-927c-5a08-b38c-96adfacf8a81}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{c132c026-b3db-5925-b113-7ff6aba2f67a}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="154,160,166,190" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,190" />
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
    <property key="overture/palette" value="light" />
    <property key="overture/description" value="base-water-point light style bound to Overture schema 1.18.0" />
    <property key="overture/compatibility" value="Bound to Overture schema 1.18.0; other versions are unverified" />
  </customproperties>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style allowHtml="0" blendMode="0" capitalization="0" fieldName="coalesce(map_get(attribute(@feature, 'names.common'), left(@qgis_locale, 2)), map_get(attribute(@feature, 'names.common'), 'en'), attribute(@feature, 'names.primary'))" fontFamily="Noto Sans" fontItalic="0" fontKerning="1" fontLetterSpacing="0" fontSize="9" fontSizeUnit="Point" fontStrikeout="0" fontUnderline="0" fontWeight="400" fontWordSpacing="0" forcedBold="0" forcedItalic="0" isExpression="1" multilineHeight="1" namedStyle="Regular" textColor="38,50,56,255" textOpacity="1" textOrientation="horizontal">
        <families />
        <text-buffer bufferBlendMode="0" bufferColor="255,255,255,255" bufferDraw="1" bufferJoinStyle="128" bufferNoFill="1" bufferOpacity="0.92" bufferSize="1.1" bufferSizeUnits="MM" />
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
