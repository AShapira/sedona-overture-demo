<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{71d5a9b1-41a3-5640-89b5-90f63e859761}">
      <rule key="{9be236fc-5b1b-5e23-9562-92cd28d6a996}" label="Agriculture" symbol="0" filter="attribute(@feature, 'subtype') = 'agriculture'" scalemaxdenom="250000" />
      <rule key="{e1d09701-2a54-5aec-b51e-766e0182c269}" label="Aquaculture" symbol="1" filter="attribute(@feature, 'subtype') = 'aquaculture'" scalemaxdenom="250000" />
      <rule key="{2e28f823-ce29-5814-bc0d-ec2341e9721c}" label="Campground" symbol="2" filter="attribute(@feature, 'subtype') = 'campground'" scalemaxdenom="250000" />
      <rule key="{f5e765e2-5e8d-58c1-a8b3-9d41b47a6113}" label="Cemetery" symbol="3" filter="attribute(@feature, 'subtype') = 'cemetery'" scalemaxdenom="250000" />
      <rule key="{c4aef1cf-85ee-5f17-a4da-9d1b4789f507}" label="Construction" symbol="4" filter="attribute(@feature, 'subtype') = 'construction'" scalemaxdenom="250000" />
      <rule key="{85c938f5-db0f-5e4a-a06c-1e982957d5ef}" label="Developed" symbol="5" filter="attribute(@feature, 'subtype') = 'developed'" scalemaxdenom="250000" />
      <rule key="{91d243f0-c66e-5921-bd26-bc15d5afaa5b}" label="Education" symbol="6" filter="attribute(@feature, 'subtype') = 'education'" scalemaxdenom="250000" />
      <rule key="{d0645880-4087-55bf-af89-41deab8b29db}" label="Entertainment" symbol="7" filter="attribute(@feature, 'subtype') = 'entertainment'" scalemaxdenom="250000" />
      <rule key="{1e719225-e443-511e-9851-3016b5ae187e}" label="Golf" symbol="8" filter="attribute(@feature, 'subtype') = 'golf'" scalemaxdenom="250000" />
      <rule key="{72a58700-870e-5e46-bb5a-aef122331fdc}" label="Grass" symbol="9" filter="attribute(@feature, 'subtype') = 'grass'" scalemaxdenom="250000" />
      <rule key="{3ce7e1dc-ff6f-5b79-81bc-3b835c35e82f}" label="Horticulture" symbol="10" filter="attribute(@feature, 'subtype') = 'horticulture'" scalemaxdenom="250000" />
      <rule key="{c9741858-a183-5295-9f00-be07fb2b2246}" label="Landfill" symbol="11" filter="attribute(@feature, 'subtype') = 'landfill'" scalemaxdenom="250000" />
      <rule key="{ad385dcc-32b0-53c8-ae28-11d3a5fe329c}" label="Managed" symbol="12" filter="attribute(@feature, 'subtype') = 'managed'" scalemaxdenom="250000" />
      <rule key="{6162fd90-e41e-57e6-9d7a-481e69204758}" label="Medical" symbol="13" filter="attribute(@feature, 'subtype') = 'medical'" scalemaxdenom="250000" />
      <rule key="{c45586e9-27f9-5f36-a954-202afd3608b2}" label="Military" symbol="14" filter="attribute(@feature, 'subtype') = 'military'" scalemaxdenom="2000000" />
      <rule key="{f40be1ca-396f-540c-bf17-ccf0264a03e2}" label="Park" symbol="15" filter="attribute(@feature, 'subtype') = 'park'" scalemaxdenom="250000" />
      <rule key="{177f63e7-4c3f-5cd9-aa39-9bac4fe7202d}" label="Pedestrian" symbol="16" filter="attribute(@feature, 'subtype') = 'pedestrian'" scalemaxdenom="250000" />
      <rule key="{781e7edf-21ab-5cae-bebf-0f93f453b613}" label="Protected" symbol="17" filter="attribute(@feature, 'subtype') = 'protected'" scalemaxdenom="2000000" />
      <rule key="{831605bb-a692-5128-9efc-15d9fd77f620}" label="Recreation" symbol="18" filter="attribute(@feature, 'subtype') = 'recreation'" scalemaxdenom="250000" />
      <rule key="{cea8df84-fc5a-56cd-b89f-9434efdf45b2}" label="Religious" symbol="19" filter="attribute(@feature, 'subtype') = 'religious'" scalemaxdenom="250000" />
      <rule key="{191f8ecf-38eb-51c8-93c2-b2014bfbf82a}" label="Residential" symbol="20" filter="attribute(@feature, 'subtype') = 'residential'" scalemaxdenom="250000" />
      <rule key="{3972691d-5e75-539d-a907-d96db849c4de}" label="Resource Extraction" symbol="21" filter="attribute(@feature, 'subtype') = 'resource_extraction'" scalemaxdenom="250000" />
      <rule key="{3d1edba9-9f53-55a1-91c6-24aa7a1de2ce}" label="Transportation" symbol="22" filter="attribute(@feature, 'subtype') = 'transportation'" scalemaxdenom="2000000" />
      <rule key="{8353dc6f-b626-58e3-9d4e-71b45fc8a22b}" label="Winter Sports" symbol="23" filter="attribute(@feature, 'subtype') = 'winter_sports'" scalemaxdenom="250000" />
      <rule key="{fc7fd059-34c0-5ebd-9514-75b5b87d6119}" label="Other or missing value" symbol="24" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{72090ae5-f4cc-5867-9ac2-a546739522e1}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="102,104,63,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{51c7d0d5-b9bf-5761-8267-ae35ab46590e}" locked="0" pass="0">
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
        <layer class="SimpleMarker" enabled="1" id="{5a062fa5-0cd4-5462-9bca-a1b36a75e292}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{5bfbdf33-fcc5-5cf5-acf1-cc20ffe23f58}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{7cc306ba-5acd-5622-b749-41a004ba9460}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{6fe105d3-5987-5873-a22b-63efad8f39ec}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,90,97,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{400cedef-8896-5882-b4c7-463b368d8f0b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,182,165,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{fbb69945-31c2-5c6d-9ef7-76d72ea73c21}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="195,154,114,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{f722f65f-6c10-513b-be46-b9988d333ea2}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{09211f8a-f6cb-5468-82fd-b091797c90be}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{cac5ee0c-fff2-52db-b796-52e150f91296}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="102,104,63,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{9fca1282-40c8-5137-a98c-a398ad1e5367}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="98,85,110,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{202e32cf-481c-5799-a48c-530a0c3aaab6}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="102,104,63,255" />
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
        <layer class="SimpleMarker" enabled="1" id="{05df6f68-3a27-511b-9d1c-20a6fe1f9fbf}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="241,110,121,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{28a28847-e158-5c06-8113-29fe1b427982}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{819c85a6-0942-5271-854f-463d1683da9a}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{dfcc8b49-fc65-5ea3-9c11-4b8f6e14a5cb}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="173,146,120,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{087eec97-8203-5a4b-af7e-dced48c5edbe}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="70,106,73,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="18" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{bca2573c-f980-59c6-b0ef-b45c8634d728}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="111,195,144,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="19" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{626c2cab-6d1d-578a-a68e-3d89c7c847fb}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="195,154,114,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="20" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{a5f0fb01-97d0-5407-bbfa-fb0256b61b00}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="21" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{1cdf99d9-1537-509c-ae4c-8b2067dddaa0}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="22" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{715a21a6-5c70-58c5-a105-3a22a5e7e438}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="209,132,88,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="23" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{9a8b444b-b415-5b34-bb88-591aef900dc2}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="24" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{b257dc5a-2ed7-5b2f-abbc-1fbbba771fa1}" locked="0" pass="0">
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
    <property key="overture/style_id" value="base-land-use-point" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-land-use-point dark style bound to Overture schema 1.18.0" />
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
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="0" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="50000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>0</layerGeometryType>
</qgis>
