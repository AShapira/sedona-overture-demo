<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{17375314-60e7-5c00-9378-388c620d0097}">
      <rule key="{2cbe0c6c-9684-558a-a6dd-e90b77735364}" label="Aerialway" symbol="0" filter="attribute(@feature, 'subtype') = 'aerialway'" scalemaxdenom="50000" />
      <rule key="{1a509070-a09f-5d98-a894-71d4cc30f7dd}" label="Airport" symbol="1" filter="attribute(@feature, 'subtype') = 'airport'" scalemaxdenom="10000000" />
      <rule key="{96a47978-d711-5df4-a32b-0c1676e936f1}" label="Barrier" symbol="2" filter="attribute(@feature, 'subtype') = 'barrier'" scalemaxdenom="50000" />
      <rule key="{3a960042-dc8b-58f2-92ee-f7828d0191a6}" label="Bridge" symbol="3" filter="attribute(@feature, 'subtype') = 'bridge'" scalemaxdenom="250000" />
      <rule key="{46462709-2008-5360-a521-f333bc91a29b}" label="Communication" symbol="4" filter="attribute(@feature, 'subtype') = 'communication'" scalemaxdenom="250000" />
      <rule key="{c3b2ba9d-4648-5014-865c-e0311b259f63}" label="Emergency" symbol="5" filter="attribute(@feature, 'subtype') = 'emergency'" scalemaxdenom="50000" />
      <rule key="{2c548b65-2a6e-5b74-9ea3-8805343601fb}" label="Manhole" symbol="6" filter="attribute(@feature, 'subtype') = 'manhole'" scalemaxdenom="50000" />
      <rule key="{c5f1dd01-5812-558f-9d3a-f4e6fe6de3de}" label="Pedestrian" symbol="7" filter="attribute(@feature, 'subtype') = 'pedestrian'" scalemaxdenom="50000" />
      <rule key="{f7d0304a-d72b-5139-9a91-2afccd05898d}" label="Pier" symbol="8" filter="attribute(@feature, 'subtype') = 'pier'" scalemaxdenom="50000" />
      <rule key="{a0f3823f-66a7-58a5-abb2-2e578905e15f}" label="Power" symbol="9" filter="attribute(@feature, 'subtype') = 'power'" scalemaxdenom="250000" />
      <rule key="{9a5b66a2-d07b-53b3-9280-c3fa9d00a8c5}" label="Quay" symbol="10" filter="attribute(@feature, 'subtype') = 'quay'" scalemaxdenom="50000" />
      <rule key="{ef763c2f-5f67-593d-b753-34234272d589}" label="Recreation" symbol="11" filter="attribute(@feature, 'subtype') = 'recreation'" scalemaxdenom="50000" />
      <rule key="{f66803bc-3ebe-557c-9f10-dbe8cf0d107d}" label="Tower" symbol="12" filter="attribute(@feature, 'subtype') = 'tower'" scalemaxdenom="50000" />
      <rule key="{f3dcf727-3235-5ede-9c51-814988cf9278}" label="Transit" symbol="13" filter="attribute(@feature, 'subtype') = 'transit'" scalemaxdenom="250000" />
      <rule key="{f56e8b07-4d25-5f9c-a974-28f085087b70}" label="Transportation" symbol="14" filter="attribute(@feature, 'subtype') = 'transportation'" scalemaxdenom="50000" />
      <rule key="{e4567750-bfbd-54bc-bada-14d5ecd836cc}" label="Utility" symbol="15" filter="attribute(@feature, 'subtype') = 'utility'" scalemaxdenom="50000" />
      <rule key="{f750f6a2-4b7e-5ae1-99bd-4f47ceec745e}" label="Waste Management" symbol="16" filter="attribute(@feature, 'subtype') = 'waste_management'" scalemaxdenom="50000" />
      <rule key="{b4e21343-5b9d-5d2f-8fe3-961f1e8b09ab}" label="Water" symbol="17" filter="attribute(@feature, 'subtype') = 'water'" scalemaxdenom="50000" />
      <rule key="{bba6780d-a84d-546a-8eab-546b8b3682cc}" label="Other or missing value" symbol="18" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" id="{c196cf3f-66f7-5f23-9141-b6596cebe756}" locked="0" pass="0">
          <prop k="color" v="227,151,98,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="fill">
        <layer class="SimpleFill" enabled="1" id="{1456d2d5-b55b-5db6-84df-793e23ed7dc8}" locked="0" pass="0">
          <prop k="color" v="72,121,168,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="fill">
        <layer class="SimpleFill" enabled="1" id="{3b9bbae9-f597-528e-ac05-2d345fbe6d53}" locked="0" pass="0">
          <prop k="color" v="102,112,120,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="fill">
        <layer class="SimpleFill" enabled="1" id="{45fb15b6-7a80-5eaf-83d0-7f52efe8992a}" locked="0" pass="0">
          <prop k="color" v="169,130,98,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="fill">
        <layer class="SimpleFill" enabled="1" id="{6ddd90d4-f070-543b-abcf-1d4cf253afa7}" locked="0" pass="0">
          <prop k="color" v="85,125,168,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="fill">
        <layer class="SimpleFill" enabled="1" id="{f772e646-b42c-59ef-a2ed-c67c6ae4f4f1}" locked="0" pass="0">
          <prop k="color" v="216,77,91,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="fill">
        <layer class="SimpleFill" enabled="1" id="{47485506-3867-54d0-9b60-8df48862ef29}" locked="0" pass="0">
          <prop k="color" v="154,160,166,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="fill">
        <layer class="SimpleFill" enabled="1" id="{1ca679ef-3731-55cf-91af-c465bb055747}" locked="0" pass="0">
          <prop k="color" v="154,128,104,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="fill">
        <layer class="SimpleFill" enabled="1" id="{515222fe-f25b-55f0-8073-2e909aa1638c}" locked="0" pass="0">
          <prop k="color" v="169,130,98,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="fill">
        <layer class="SimpleFill" enabled="1" id="{2d5e36d1-3d3c-5b71-a7bc-bf4af5cacb14}" locked="0" pass="0">
          <prop k="color" v="215,88,79,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="fill">
        <layer class="SimpleFill" enabled="1" id="{3fc4bfa2-0542-5230-bfaa-115c2de6e7c8}" locked="0" pass="0">
          <prop k="color" v="169,130,98,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="fill">
        <layer class="SimpleFill" enabled="1" id="{99836707-a105-5b4b-85a8-aae78583ac90}" locked="0" pass="0">
          <prop k="color" v="79,153,112,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="fill">
        <layer class="SimpleFill" enabled="1" id="{6452c314-463f-5a0d-b8af-0be9a3a62f82}" locked="0" pass="0">
          <prop k="color" v="85,125,168,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="fill">
        <layer class="SimpleFill" enabled="1" id="{f2869c80-f2f6-5d7c-9cea-e7bc14142d32}" locked="0" pass="0">
          <prop k="color" v="72,121,168,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="fill">
        <layer class="SimpleFill" enabled="1" id="{76b3ab0d-4f48-5b10-9dd7-3ca11fdea97f}" locked="0" pass="0">
          <prop k="color" v="227,151,98,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="fill">
        <layer class="SimpleFill" enabled="1" id="{4a94ae7f-cf9f-5f21-a0b5-16b9f566acba}" locked="0" pass="0">
          <prop k="color" v="85,125,168,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="fill">
        <layer class="SimpleFill" enabled="1" id="{87771baa-a51d-51ef-9d66-760fa5e48df1}" locked="0" pass="0">
          <prop k="color" v="199,189,207,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="fill">
        <layer class="SimpleFill" enabled="1" id="{a5b2b16b-f7b7-5a8c-8211-dbec792c3204}" locked="0" pass="0">
          <prop k="color" v="120,183,216,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="18" type="fill">
        <layer class="SimpleFill" enabled="1" id="{abd80dc7-4e34-5421-a2f7-d8cf74a38f62}" locked="0" pass="0">
          <prop k="color" v="154,160,166,190" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,190" />
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
    <property key="overture/style_id" value="base-infrastructure-polygon" />
    <property key="overture/palette" value="light" />
    <property key="overture/description" value="base-infrastructure-polygon light style bound to Overture schema 1.18.0" />
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
      <placement allowDegraded="0" centroidInside="1" dist="1" distUnits="MM" fitInPolygonOnly="0" layerType="PolygonGeometry" maxCurvedCharAngleIn="25" maxCurvedCharAngleOut="-25" offsetType="0" overlapHandling="PreventOverlap" placement="1" placementFlags="10" predefinedPositionOrder="TR,TL,BR,BL,R,L" priority="5" quadOffset="4" repeatDistance="40" repeatDistanceUnits="MM" />
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="0" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="50000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>2</layerGeometryType>
</qgis>
