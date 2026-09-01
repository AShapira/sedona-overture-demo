<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="0" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{c271e955-4171-5dd5-ae36-f3acf7907406}">
      <rule key="{32cd6be8-ec06-5e11-85a3-a91b43028ef7}" label="Deeper than 0 m" symbol="0" filter="attribute(@feature, 'depth') = '0'" scalemaxdenom="100000000" />
      <rule key="{d87ad96e-0f7f-5563-808d-978e2d210156}" label="Deeper than 10 m" symbol="1" filter="attribute(@feature, 'depth') = '10'" scalemaxdenom="100000000" />
      <rule key="{8f81fa3c-d348-5a8a-9a2c-784181c8e648}" label="Deeper than 50 m" symbol="2" filter="attribute(@feature, 'depth') = '50'" scalemaxdenom="100000000" />
      <rule key="{f62c73ef-2bf5-5ecc-ab32-c927619e5ce3}" label="Deeper than 100 m" symbol="3" filter="attribute(@feature, 'depth') = '100'" scalemaxdenom="100000000" />
      <rule key="{152ea116-f851-539f-9940-e2c0c59dc6fa}" label="Deeper than 500 m" symbol="4" filter="attribute(@feature, 'depth') = '500'" scalemaxdenom="100000000" />
      <rule key="{5e2bfc15-eea0-5659-8bcc-8050bb85c515}" label="Deeper than 1000 m" symbol="5" filter="attribute(@feature, 'depth') = '1000'" scalemaxdenom="100000000" />
      <rule key="{34f0d0f0-7da6-5f26-af61-02e4e1e73ab6}" label="Deeper than 1500 m" symbol="6" filter="attribute(@feature, 'depth') = '1500'" scalemaxdenom="100000000" />
      <rule key="{9bcaa0bf-3fe0-5c26-a87f-0e64e0007482}" label="Deeper than 2000 m" symbol="7" filter="attribute(@feature, 'depth') = '2000'" scalemaxdenom="100000000" />
      <rule key="{9b46639f-ac20-5f8d-b6e2-deafa4da9477}" label="Deeper than 2500 m" symbol="8" filter="attribute(@feature, 'depth') = '2500'" scalemaxdenom="100000000" />
      <rule key="{1307a9be-9f3a-5116-b9d0-903e135e2f44}" label="Deeper than 3000 m" symbol="9" filter="attribute(@feature, 'depth') = '3000'" scalemaxdenom="100000000" />
      <rule key="{31d52137-17cf-5289-8c21-ac65ab0c0dc7}" label="Other depth" symbol="10" filter="ELSE" scalemaxdenom="100000000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" id="{0ba3d303-4809-5535-af89-0c16ebf25238}" locked="0" pass="0">
          <prop k="color" v="201,230,242,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="fill">
        <layer class="SimpleFill" enabled="1" id="{169f89e4-6ecc-569c-a9ff-c8dcc106d8e0}" locked="0" pass="1">
          <prop k="color" v="180,220,234,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="fill">
        <layer class="SimpleFill" enabled="1" id="{2b66ff99-e34e-5793-be69-38423de7fe8c}" locked="0" pass="2">
          <prop k="color" v="155,208,228,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="fill">
        <layer class="SimpleFill" enabled="1" id="{8bd4e77a-6ee1-5d5d-910c-a21dc5b5e0b9}" locked="0" pass="3">
          <prop k="color" v="131,193,220,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="fill">
        <layer class="SimpleFill" enabled="1" id="{e5ccc46f-3034-5f0c-97ab-dee0190e846e}" locked="0" pass="4">
          <prop k="color" v="105,172,208,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="fill">
        <layer class="SimpleFill" enabled="1" id="{a330855d-ad21-5a4d-9334-0737c2407f5c}" locked="0" pass="5">
          <prop k="color" v="82,143,192,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="fill">
        <layer class="SimpleFill" enabled="1" id="{649852b6-dfd4-55e5-9bad-89e4161b3896}" locked="0" pass="6">
          <prop k="color" v="63,121,174,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="fill">
        <layer class="SimpleFill" enabled="1" id="{aa8db68c-cb0a-56be-8197-2f03df096504}" locked="0" pass="7">
          <prop k="color" v="50,106,158,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="fill">
        <layer class="SimpleFill" enabled="1" id="{eeeeebb0-937b-5d50-aa2b-2b2b28fc5ad2}" locked="0" pass="8">
          <prop k="color" v="40,93,144,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="fill">
        <layer class="SimpleFill" enabled="1" id="{5366a05b-d5d2-52c9-adc1-d49bf7c64aba}" locked="0" pass="9">
          <prop k="color" v="30,79,128,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,245" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="fill">
        <layer class="SimpleFill" enabled="1" id="{43030a40-86d5-5bd1-a12e-850ec531f654}" locked="0" pass="10">
          <prop k="color" v="37,95,145,245" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,245" />
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
    <property key="overture/palette" value="light" />
    <property key="overture/description" value="base-bathymetry-polygon light style bound to Overture schema 1.18.0" />
    <property key="overture/compatibility" value="Bound to Overture schema 1.18.0; other versions are unverified" />
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>2</layerGeometryType>
</qgis>
