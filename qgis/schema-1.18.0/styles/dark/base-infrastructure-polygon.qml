<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{89a6b9ec-f2e6-52e5-ba91-58553b8f2278}">
      <rule key="{d9e725bc-a06b-5934-a87f-e269efb58ea9}" label="Aerialway" symbol="0" filter="attribute(@feature, 'subtype') = 'aerialway'" scalemaxdenom="50000" />
      <rule key="{53058c00-120b-533b-9f50-b83f18a2bfa3}" label="Airport" symbol="1" filter="attribute(@feature, 'subtype') = 'airport'" scalemaxdenom="10000000" />
      <rule key="{27c222fd-4e1c-5a9e-bdba-e9a6e7b23a64}" label="Barrier" symbol="2" filter="attribute(@feature, 'subtype') = 'barrier'" scalemaxdenom="50000" />
      <rule key="{bd249058-15fb-567b-9ca2-0c5d0209e849}" label="Bridge" symbol="3" filter="attribute(@feature, 'subtype') = 'bridge'" scalemaxdenom="250000" />
      <rule key="{31eb7fb8-7bc1-5879-bb5f-cb68a10f9893}" label="Communication" symbol="4" filter="attribute(@feature, 'subtype') = 'communication'" scalemaxdenom="250000" />
      <rule key="{d557be82-7e7e-5c55-8b42-f9a67219bbd8}" label="Emergency" symbol="5" filter="attribute(@feature, 'subtype') = 'emergency'" scalemaxdenom="50000" />
      <rule key="{b8382d33-60a7-5afb-8afd-ea380cc2fab5}" label="Manhole" symbol="6" filter="attribute(@feature, 'subtype') = 'manhole'" scalemaxdenom="50000" />
      <rule key="{a6027874-31db-5a28-a06f-3c059bebfacf}" label="Pedestrian" symbol="7" filter="attribute(@feature, 'subtype') = 'pedestrian'" scalemaxdenom="50000" />
      <rule key="{4a1edcc7-764f-525a-ae76-aa1a4ec81725}" label="Pier" symbol="8" filter="attribute(@feature, 'subtype') = 'pier'" scalemaxdenom="50000" />
      <rule key="{be120287-9cca-5fd0-87b7-b0558c704abf}" label="Power" symbol="9" filter="attribute(@feature, 'subtype') = 'power'" scalemaxdenom="250000" />
      <rule key="{c5f4ae93-a976-550a-90b3-38cf3b135d07}" label="Quay" symbol="10" filter="attribute(@feature, 'subtype') = 'quay'" scalemaxdenom="50000" />
      <rule key="{5d61e253-c459-59dc-b87e-0fe0eff97484}" label="Recreation" symbol="11" filter="attribute(@feature, 'subtype') = 'recreation'" scalemaxdenom="50000" />
      <rule key="{1cd42568-dcc1-5257-9105-42c4a6c722e8}" label="Tower" symbol="12" filter="attribute(@feature, 'subtype') = 'tower'" scalemaxdenom="50000" />
      <rule key="{48689ee0-e204-50e2-a9d6-1d0194d10dbe}" label="Transit" symbol="13" filter="attribute(@feature, 'subtype') = 'transit'" scalemaxdenom="250000" />
      <rule key="{5a0ce442-780b-5852-9741-18763e263e5f}" label="Transportation" symbol="14" filter="attribute(@feature, 'subtype') = 'transportation'" scalemaxdenom="50000" />
      <rule key="{517d062d-38a8-50cb-a272-ec2d273bf4b3}" label="Utility" symbol="15" filter="attribute(@feature, 'subtype') = 'utility'" scalemaxdenom="50000" />
      <rule key="{25abcc1e-e0d8-52d6-9fae-db2f314a42eb}" label="Waste Management" symbol="16" filter="attribute(@feature, 'subtype') = 'waste_management'" scalemaxdenom="50000" />
      <rule key="{d82d3e2a-66e9-5213-bfff-7d9a58659fb8}" label="Water" symbol="17" filter="attribute(@feature, 'subtype') = 'water'" scalemaxdenom="50000" />
      <rule key="{7478a33e-93d7-5bf6-ba19-ae6c2f126244}" label="Other or missing value" symbol="18" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" id="{c1127030-1a35-595e-9c16-5cf70c7e330f}" locked="0" pass="0">
          <prop k="color" v="209,132,88,205" />
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
        <layer class="SimpleFill" enabled="1" id="{e670d934-a956-5ce9-b7cc-722a8bb26877}" locked="0" pass="0">
          <prop k="color" v="112,166,215,205" />
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
        <layer class="SimpleFill" enabled="1" id="{5c414662-0527-59c4-bf24-8d541ab22f65}" locked="0" pass="0">
          <prop k="color" v="137,148,158,205" />
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
        <layer class="SimpleFill" enabled="1" id="{559720f3-8832-5d44-8eb2-303c3a06f4cd}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="fill">
        <layer class="SimpleFill" enabled="1" id="{afbc6c2e-62df-58d3-a955-433f3ce6cd7e}" locked="0" pass="0">
          <prop k="color" v="119,164,211,205" />
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
        <layer class="SimpleFill" enabled="1" id="{8720467d-4be1-56f8-bb24-4ecea5cab072}" locked="0" pass="0">
          <prop k="color" v="241,110,121,205" />
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
        <layer class="SimpleFill" enabled="1" id="{eb77a7fa-116e-51ca-9613-46da8d736a59}" locked="0" pass="0">
          <prop k="color" v="125,135,144,205" />
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
        <layer class="SimpleFill" enabled="1" id="{afcc5c7e-d0b6-5bb4-92ce-2d30252e2468}" locked="0" pass="0">
          <prop k="color" v="173,146,120,205" />
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
        <layer class="SimpleFill" enabled="1" id="{4873f999-fbeb-5b64-b493-685dd7dad81d}" locked="0" pass="0">
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
        <layer class="SimpleFill" enabled="1" id="{1c1e9bcd-79f6-51ff-ba3b-c88fc2877e70}" locked="0" pass="0">
          <prop k="color" v="240,107,99,205" />
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
        <layer class="SimpleFill" enabled="1" id="{8c58f9c6-d11d-5ae8-9009-9be51106f8cb}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="fill">
        <layer class="SimpleFill" enabled="1" id="{1af97b44-7e62-5352-8061-ef0db935df00}" locked="0" pass="0">
          <prop k="color" v="111,195,144,205" />
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
        <layer class="SimpleFill" enabled="1" id="{e2dde9b8-861a-5479-883c-8cd5fa998069}" locked="0" pass="0">
          <prop k="color" v="119,164,211,205" />
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
        <layer class="SimpleFill" enabled="1" id="{6ebc2360-d7dd-5343-85e6-ea4b6826dc48}" locked="0" pass="0">
          <prop k="color" v="112,166,215,205" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="fill">
        <layer class="SimpleFill" enabled="1" id="{d67824da-9671-5f77-ae12-8c35e9ea1e81}" locked="0" pass="0">
          <prop k="color" v="209,132,88,205" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="fill">
        <layer class="SimpleFill" enabled="1" id="{cdcd457e-8eb1-5cc7-9c77-054a493e2f22}" locked="0" pass="0">
          <prop k="color" v="119,164,211,205" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="fill">
        <layer class="SimpleFill" enabled="1" id="{b5e37214-4ec8-5bc1-9c2c-a889b54926ce}" locked="0" pass="0">
          <prop k="color" v="98,85,110,205" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="fill">
        <layer class="SimpleFill" enabled="1" id="{af9f8138-ef67-5e78-be3a-4a3982fef663}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="18" type="fill">
        <layer class="SimpleFill" enabled="1" id="{fc3ce07c-a6a5-5342-aa8d-f19e086d3922}" locked="0" pass="0">
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
    <property key="overture/style_id" value="base-infrastructure-polygon" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-infrastructure-polygon dark style bound to Overture schema 1.18.0" />
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
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="0" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="50000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>2</layerGeometryType>
</qgis>
