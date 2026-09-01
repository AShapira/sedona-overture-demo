<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="0" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{de612fb9-7b18-5de8-9bbf-51d352dc1296}">
      <rule key="{2aef8077-800f-5ba7-8fdc-e6a652261cba}" label="Barren" symbol="0" filter="attribute(@feature, 'subtype') = 'barren' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{55615aa3-fc7e-551e-a0c0-f328e3af2a90}" label="Crop" symbol="1" filter="attribute(@feature, 'subtype') = 'crop' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{06ce3ef0-cc9b-5cf7-b2ef-8218361e07e9}" label="Forest" symbol="2" filter="attribute(@feature, 'subtype') = 'forest' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{06acf1bf-169d-5770-ab87-c5847ec9f75b}" label="Grass" symbol="3" filter="attribute(@feature, 'subtype') = 'grass' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{d843a257-4955-5af9-951a-8e2b7d6b64c6}" label="Mangrove" symbol="4" filter="attribute(@feature, 'subtype') = 'mangrove' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{bd822d9e-2046-5e02-bdf3-b2912a68f133}" label="Moss" symbol="5" filter="attribute(@feature, 'subtype') = 'moss' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{6282269c-8782-5557-adf0-360b325a1dfd}" label="Shrub" symbol="6" filter="attribute(@feature, 'subtype') = 'shrub' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{5afccc0f-e7bc-51bf-b5d4-665651a078c1}" label="Snow" symbol="7" filter="attribute(@feature, 'subtype') = 'snow' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{fd1a5ec9-f793-50a8-8b19-ded7a1fe6cce}" label="Urban" symbol="8" filter="attribute(@feature, 'subtype') = 'urban' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{bfbd0950-0b74-574e-90c3-fb329e363ac5}" label="Wetland" symbol="9" filter="attribute(@feature, 'subtype') = 'wetland' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{0901296b-095b-5251-8292-8278ba3a8297}" label="Other or missing value" symbol="10" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" id="{5ca3eedd-45d7-5c0e-8488-cdd75020da17}" locked="0" pass="0">
          <prop k="color" v="231,215,170,205" />
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
        <layer class="SimpleFill" enabled="1" id="{9d7ca165-f964-52cd-849f-4059ccb6c0f1}" locked="0" pass="0">
          <prop k="color" v="215,215,154,205" />
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
        <layer class="SimpleFill" enabled="1" id="{56dac6e4-e157-5758-9780-55129ed5ea53}" locked="0" pass="0">
          <prop k="color" v="71,122,84,205" />
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
        <layer class="SimpleFill" enabled="1" id="{1358ecf3-0565-56d6-b591-0ac15a785634}" locked="0" pass="0">
          <prop k="color" v="143,189,120,205" />
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
        <layer class="SimpleFill" enabled="1" id="{585d3871-e45d-589b-8078-6e685e27b26c}" locked="0" pass="0">
          <prop k="color" v="71,122,84,205" />
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
        <layer class="SimpleFill" enabled="1" id="{5a726784-270e-5781-8971-a33836c8e066}" locked="0" pass="0">
          <prop k="color" v="215,215,154,205" />
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
        <layer class="SimpleFill" enabled="1" id="{77c940eb-e61a-51a0-b88a-98ea95f7cee9}" locked="0" pass="0">
          <prop k="color" v="143,189,120,205" />
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
        <layer class="SimpleFill" enabled="1" id="{efe88211-cee3-5f93-afe3-7d4d64c7d37c}" locked="0" pass="0">
          <prop k="color" v="255,255,255,205" />
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
        <layer class="SimpleFill" enabled="1" id="{7cbe6b0d-dfb9-55f4-b912-4552a61c90f4}" locked="0" pass="0">
          <prop k="color" v="201,195,198,205" />
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
        <layer class="SimpleFill" enabled="1" id="{c0443bc1-3d6a-510a-96b6-cee101cc9c81}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="fill">
        <layer class="SimpleFill" enabled="1" id="{c4330bdc-53e0-5f22-b0fa-77fec29849bd}" locked="0" pass="0">
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
    <property key="overture/style_id" value="base-land-cover-polygon" />
    <property key="overture/palette" value="light" />
    <property key="overture/description" value="base-land-cover-polygon light style bound to Overture schema 1.18.0" />
    <property key="overture/compatibility" value="Bound to Overture schema 1.18.0; other versions are unverified" />
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>2</layerGeometryType>
</qgis>
