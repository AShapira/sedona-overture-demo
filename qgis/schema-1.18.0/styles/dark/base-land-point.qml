<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{0a5da0cd-cd91-5b12-b7b2-3dd2503e3b25}">
      <rule key="{98b365da-7ef0-53af-9e7c-a5557851f789}" label="Crater" symbol="0" filter="attribute(@feature, 'subtype') = 'crater'" scalemaxdenom="250000" />
      <rule key="{a39b7f1a-42e0-5179-b65f-0cc016cbe306}" label="Desert" symbol="1" filter="attribute(@feature, 'subtype') = 'desert'" scalemaxdenom="2000000" />
      <rule key="{851ec804-53aa-5bde-b7ec-9cd3d99fc0c4}" label="Forest" symbol="2" filter="attribute(@feature, 'subtype') = 'forest'" scalemaxdenom="2000000" />
      <rule key="{9ff6d2da-5267-5ed1-9771-f8bce65beba5}" label="Glacier" symbol="3" filter="attribute(@feature, 'subtype') = 'glacier'" scalemaxdenom="2000000" />
      <rule key="{65e645b2-273c-58e8-b98f-abe9042eb361}" label="Grass" symbol="4" filter="attribute(@feature, 'subtype') = 'grass'" scalemaxdenom="250000" />
      <rule key="{4b1c1297-6ff8-5c7f-9655-74945357471c}" label="Land" symbol="5" filter="attribute(@feature, 'subtype') = 'land'" scalemaxdenom="2000000" />
      <rule key="{bbd3dea2-e0d9-5aed-840a-9203e9a991ce}" label="Physical" symbol="6" filter="attribute(@feature, 'subtype') = 'physical'" scalemaxdenom="2000000" />
      <rule key="{5e4cbbe4-f177-5683-8227-a11b0d2ff98b}" label="Reef" symbol="7" filter="attribute(@feature, 'subtype') = 'reef'" scalemaxdenom="250000" />
      <rule key="{9d62295e-caff-561a-89ba-ca4585254987}" label="Rock" symbol="8" filter="attribute(@feature, 'subtype') = 'rock'" scalemaxdenom="250000" />
      <rule key="{05aeca4a-5955-500b-8a63-9f605b6333cb}" label="Sand" symbol="9" filter="attribute(@feature, 'subtype') = 'sand'" scalemaxdenom="250000" />
      <rule key="{953c1c23-f172-5b96-9626-27c543905c07}" label="Shrub" symbol="10" filter="attribute(@feature, 'subtype') = 'shrub'" scalemaxdenom="250000" />
      <rule key="{236944cf-dc26-58fb-8628-a13e489aa6ba}" label="Tree" symbol="11" filter="attribute(@feature, 'subtype') = 'tree'" scalemaxdenom="250000" />
      <rule key="{f4482d54-82c9-5e94-8492-f1fd18629f8e}" label="Wetland" symbol="12" filter="attribute(@feature, 'subtype') = 'wetland'" scalemaxdenom="250000" />
      <rule key="{dda3ed63-5df0-5708-8eb2-a502075f88ba}" label="Other or missing value" symbol="13" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{643fb22a-5f0b-56cb-addd-63ee512ff2d4}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="118,91,72,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{9df62dac-fe23-5068-ade3-6a5a8401bcd4}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="139,121,84,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{2f2eb3fd-f4e2-5d72-9434-5bc4ef33ffb9}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="47,86,60,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{90a1be19-a60c-5e4c-b800-45f5c239648e}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="17,21,26,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{15ca2e11-ca47-52a8-ba56-68cd03fd2175}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="66,107,77,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{6097b03b-3f1b-5e33-a65b-f68bb22759e8}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="77,80,86,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{759bf413-ab8f-587c-8131-4c68d4f7f3ec}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="118,91,72,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{4a609330-5368-529b-98c5-9b01b152b704}" locked="0" pass="0">
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
        <layer class="SimpleMarker" enabled="1" id="{7ce46a5e-0d64-56a7-bf06-61b17aef8430}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="118,91,72,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{d15ded95-84ba-5f47-823a-ecf2b2c44aea}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="139,121,84,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{7ff93b73-d915-573a-829c-98a14d1441f9}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="66,107,77,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{bab1001f-3757-568f-b1f1-10563b0641be}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="47,86,60,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{762941c0-2a77-5c67-a889-a59b3fa1b27e}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{6a538217-f33b-5467-b04f-3eb764594db9}" locked="0" pass="0">
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
    <property key="overture/style_id" value="base-land-point" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-land-point dark style bound to Overture schema 1.18.0" />
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
