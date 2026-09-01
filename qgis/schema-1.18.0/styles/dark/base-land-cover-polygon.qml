<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="0" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{e28599e4-6f88-5f93-b917-dab45ca9f3a5}">
      <rule key="{1c590ab7-6394-51bf-9ab6-1901659c558f}" label="Barren" symbol="0" filter="attribute(@feature, 'subtype') = 'barren' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{18e14d85-a5f0-50ff-b73f-d6ffd76b1b29}" label="Crop" symbol="1" filter="attribute(@feature, 'subtype') = 'crop' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{30a6f8a4-f99c-5353-a538-c644199252af}" label="Forest" symbol="2" filter="attribute(@feature, 'subtype') = 'forest' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{0d7e9078-4308-5c89-a5b0-51ad1158ce21}" label="Grass" symbol="3" filter="attribute(@feature, 'subtype') = 'grass' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{a2f92284-ee32-5790-8be4-dbf9b7a30be4}" label="Mangrove" symbol="4" filter="attribute(@feature, 'subtype') = 'mangrove' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{4b23bba2-a2b4-5e97-992a-d1fda69e7675}" label="Moss" symbol="5" filter="attribute(@feature, 'subtype') = 'moss' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{f73af160-b5d5-5a27-b0a4-5a3df09a8491}" label="Shrub" symbol="6" filter="attribute(@feature, 'subtype') = 'shrub' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{d566bc26-73c6-5980-9e81-2c7460bef9a6}" label="Snow" symbol="7" filter="attribute(@feature, 'subtype') = 'snow' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{d7ecccc2-a4e0-5783-9bd6-5262cc7c0867}" label="Urban" symbol="8" filter="attribute(@feature, 'subtype') = 'urban' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{bba140ac-d3de-5ae6-9c4d-46b8d701c4ff}" label="Wetland" symbol="9" filter="attribute(@feature, 'subtype') = 'wetland' AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &gt;= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR (ln(559082264.028 / @map_scale) / ln(2)) &lt;= attribute(@feature, 'cartography.max_zoom'))" scalemaxdenom="100000000" />
      <rule key="{6b34af39-9e0c-5a57-96a8-f2c3fe0d692d}" label="Other or missing value" symbol="10" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" id="{a0766249-22b6-5b99-8cf7-482e4c8f5678}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="fill">
        <layer class="SimpleFill" enabled="1" id="{5aad434a-a99f-53c8-a66a-09b60ac86713}" locked="0" pass="0">
          <prop k="color" v="102,104,63,205" />
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
        <layer class="SimpleFill" enabled="1" id="{21527d37-381d-5b2b-bf87-44f3d44d0445}" locked="0" pass="0">
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
        <layer class="SimpleFill" enabled="1" id="{24d2ce58-3c55-5e9e-bb9a-dd95208b8fea}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="fill">
        <layer class="SimpleFill" enabled="1" id="{221765da-385f-5de1-b8fd-36390cd68a4a}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="fill">
        <layer class="SimpleFill" enabled="1" id="{6379009d-d06f-5bec-8f9e-83d71c268950}" locked="0" pass="0">
          <prop k="color" v="102,104,63,205" />
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
        <layer class="SimpleFill" enabled="1" id="{d690af30-b67e-570c-bc3f-0e0810a49a50}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="fill">
        <layer class="SimpleFill" enabled="1" id="{3dd9d511-3e98-5033-8f1c-4e920dae38e9}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="fill">
        <layer class="SimpleFill" enabled="1" id="{e429dd88-aaa2-53f2-9be8-98a9eaf83f25}" locked="0" pass="0">
          <prop k="color" v="85,90,97,205" />
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
        <layer class="SimpleFill" enabled="1" id="{b8a050b3-071a-59db-b190-7a8d44d704f0}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="fill">
        <layer class="SimpleFill" enabled="1" id="{eb9a91d3-20c6-5395-b798-1c0747407f1a}" locked="0" pass="0">
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
    <property key="overture/style_id" value="base-land-cover-polygon" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-land-cover-polygon dark style bound to Overture schema 1.18.0" />
    <property key="overture/compatibility" value="Bound to Overture schema 1.18.0; other versions are unverified" />
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>2</layerGeometryType>
</qgis>
