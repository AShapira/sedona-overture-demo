<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{83ca8560-db72-5c31-aed4-827c707b8ddb}">
      <rule key="{67db870f-e7fd-5e5b-b021-4544f8eca0a8}" label="Agriculture" symbol="0" filter="attribute(@feature, 'subtype') = 'agriculture'" scalemaxdenom="250000" />
      <rule key="{29be01be-7a61-5af2-9f6b-c721f56799c6}" label="Aquaculture" symbol="1" filter="attribute(@feature, 'subtype') = 'aquaculture'" scalemaxdenom="250000" />
      <rule key="{4ce02716-c180-5d94-99dc-8fe0a8937781}" label="Campground" symbol="2" filter="attribute(@feature, 'subtype') = 'campground'" scalemaxdenom="250000" />
      <rule key="{83fa4789-b287-59d8-a401-7fb80e57d14a}" label="Cemetery" symbol="3" filter="attribute(@feature, 'subtype') = 'cemetery'" scalemaxdenom="250000" />
      <rule key="{0815c965-dabc-5350-9965-fe3f2f78fb76}" label="Construction" symbol="4" filter="attribute(@feature, 'subtype') = 'construction'" scalemaxdenom="250000" />
      <rule key="{92b97d11-577e-5d66-98e0-222b43d12e3e}" label="Developed" symbol="5" filter="attribute(@feature, 'subtype') = 'developed'" scalemaxdenom="250000" />
      <rule key="{90e7b7cf-52d4-52fb-af57-a1b88baa5f21}" label="Education" symbol="6" filter="attribute(@feature, 'subtype') = 'education'" scalemaxdenom="250000" />
      <rule key="{3a83781a-7510-5bac-aba8-f6f67e7a08cb}" label="Entertainment" symbol="7" filter="attribute(@feature, 'subtype') = 'entertainment'" scalemaxdenom="250000" />
      <rule key="{930be102-58cf-5a8e-8f58-d8c73b79b319}" label="Golf" symbol="8" filter="attribute(@feature, 'subtype') = 'golf'" scalemaxdenom="250000" />
      <rule key="{50e12e8b-d91f-5da1-918e-eee1bb4d3694}" label="Grass" symbol="9" filter="attribute(@feature, 'subtype') = 'grass'" scalemaxdenom="250000" />
      <rule key="{7283d0c6-8c4b-5d95-85a8-2b0284bff75e}" label="Horticulture" symbol="10" filter="attribute(@feature, 'subtype') = 'horticulture'" scalemaxdenom="250000" />
      <rule key="{89fb284f-a5a1-571b-81af-e2fa6df202fc}" label="Landfill" symbol="11" filter="attribute(@feature, 'subtype') = 'landfill'" scalemaxdenom="250000" />
      <rule key="{0f9ebbb6-85b7-5bc0-9dfa-bc6d9d070068}" label="Managed" symbol="12" filter="attribute(@feature, 'subtype') = 'managed'" scalemaxdenom="250000" />
      <rule key="{32a0ba9f-6107-5683-9646-a23c69851972}" label="Medical" symbol="13" filter="attribute(@feature, 'subtype') = 'medical'" scalemaxdenom="250000" />
      <rule key="{9ef935eb-7c07-53c2-bf03-763cf7c382b1}" label="Military" symbol="14" filter="attribute(@feature, 'subtype') = 'military'" scalemaxdenom="2000000" />
      <rule key="{028a725d-44ae-5c6d-ac4d-636cb489ba80}" label="Park" symbol="15" filter="attribute(@feature, 'subtype') = 'park'" scalemaxdenom="250000" />
      <rule key="{dea9252e-345e-5058-b4cd-47c2f1b4cbec}" label="Pedestrian" symbol="16" filter="attribute(@feature, 'subtype') = 'pedestrian'" scalemaxdenom="250000" />
      <rule key="{9ae3a2d6-cf7a-5314-9043-2d713f5cd6b3}" label="Protected" symbol="17" filter="attribute(@feature, 'subtype') = 'protected'" scalemaxdenom="2000000" />
      <rule key="{c4d17777-f416-567f-97cc-d432e9929c37}" label="Recreation" symbol="18" filter="attribute(@feature, 'subtype') = 'recreation'" scalemaxdenom="250000" />
      <rule key="{ce8ed9b9-2ca8-5486-9b5a-e3e93c0b69f4}" label="Religious" symbol="19" filter="attribute(@feature, 'subtype') = 'religious'" scalemaxdenom="250000" />
      <rule key="{ba855c29-711f-5286-a740-6e3514ea6595}" label="Residential" symbol="20" filter="attribute(@feature, 'subtype') = 'residential'" scalemaxdenom="250000" />
      <rule key="{0dcafa53-efa7-5791-82dc-02d641b2cc0c}" label="Resource Extraction" symbol="21" filter="attribute(@feature, 'subtype') = 'resource_extraction'" scalemaxdenom="250000" />
      <rule key="{59710b57-3a8d-564c-b088-adeed0335bfb}" label="Transportation" symbol="22" filter="attribute(@feature, 'subtype') = 'transportation'" scalemaxdenom="2000000" />
      <rule key="{b832ee6d-5bc1-5c21-b99a-47d7f60b5ced}" label="Winter Sports" symbol="23" filter="attribute(@feature, 'subtype') = 'winter_sports'" scalemaxdenom="250000" />
      <rule key="{eaf8a161-d884-5d7f-9e82-adcc19a75bed}" label="Other or missing value" symbol="24" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" id="{74464f88-5ec8-5959-8f80-8c66d3c050c5}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="fill">
        <layer class="SimpleFill" enabled="1" id="{3ccfa58d-6ec6-5617-8fe9-e5bf368db7bd}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="fill">
        <layer class="SimpleFill" enabled="1" id="{641fed06-502c-575e-abde-28153d085771}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="fill">
        <layer class="SimpleFill" enabled="1" id="{839d2d1c-2e0a-5b34-968e-73c6a87117ca}" locked="0" pass="0">
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
        <layer class="SimpleFill" enabled="1" id="{14e4cacf-ba76-5e04-9433-42ea5863cfb2}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="fill">
        <layer class="SimpleFill" enabled="1" id="{26d4585b-8dbf-5b8b-a598-1948723db2c9}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="fill">
        <layer class="SimpleFill" enabled="1" id="{58c9a395-547e-55c2-9cc3-716d345d3619}" locked="0" pass="0">
          <prop k="color" v="112,182,165,205" />
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
        <layer class="SimpleFill" enabled="1" id="{48f42044-21bb-5f13-8600-a377371169de}" locked="0" pass="0">
          <prop k="color" v="195,154,114,205" />
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
        <layer class="SimpleFill" enabled="1" id="{48e42ad4-4e8a-5cc1-a6f7-6ef6c7cb85d6}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="fill">
        <layer class="SimpleFill" enabled="1" id="{a873fcd2-8f3c-5448-8b7d-922e0cb558f0}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="fill">
        <layer class="SimpleFill" enabled="1" id="{d2a8da45-07e5-55cd-93f2-da3062cd62b5}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="fill">
        <layer class="SimpleFill" enabled="1" id="{6cb22391-5e88-5bfd-832d-23d372d045c3}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="fill">
        <layer class="SimpleFill" enabled="1" id="{b0918215-8196-5fcd-a5f2-7bafea9688cd}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="fill">
        <layer class="SimpleFill" enabled="1" id="{01991a55-3022-5dcf-a741-a5060762b82a}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="fill">
        <layer class="SimpleFill" enabled="1" id="{88ab770f-39a9-5411-86c2-8cf67c65eb4f}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="fill">
        <layer class="SimpleFill" enabled="1" id="{7da45afb-8eaa-5c8b-a9e0-78f91d500a21}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="fill">
        <layer class="SimpleFill" enabled="1" id="{53c0e158-8713-59db-87d5-9666811d70ec}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="fill">
        <layer class="SimpleFill" enabled="1" id="{6504adde-a963-5cb9-87fb-89c798784efe}" locked="0" pass="0">
          <prop k="color" v="70,106,73,205" />
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
        <layer class="SimpleFill" enabled="1" id="{01658f44-b4ad-55e4-a51a-8c775f5eb246}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="19" type="fill">
        <layer class="SimpleFill" enabled="1" id="{82809284-ab6b-50c9-b8c0-124bbf7a052a}" locked="0" pass="0">
          <prop k="color" v="195,154,114,205" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="20" type="fill">
        <layer class="SimpleFill" enabled="1" id="{747f389f-10dc-5efc-977f-1145bf0c0f88}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="21" type="fill">
        <layer class="SimpleFill" enabled="1" id="{65092226-aa4c-5a90-823b-494a6cee99a8}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="22" type="fill">
        <layer class="SimpleFill" enabled="1" id="{c219f3ed-4bdb-5cdb-8ade-f08c1e93e285}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="23" type="fill">
        <layer class="SimpleFill" enabled="1" id="{fc99acc2-3931-53bf-abdb-31c7cfcc0b6a}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="24" type="fill">
        <layer class="SimpleFill" enabled="1" id="{fdf92b33-ab24-5c52-8a42-989f065f47b0}" locked="0" pass="0">
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
    <property key="overture/style_id" value="base-land-use-polygon" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-land-use-polygon dark style bound to Overture schema 1.18.0" />
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
