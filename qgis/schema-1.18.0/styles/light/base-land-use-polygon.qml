<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{34eb3667-60da-58ad-ab0d-b1da50b870fd}">
      <rule key="{90530d01-18e1-55a0-9441-c13bc4f28a95}" label="Agriculture" symbol="0" filter="attribute(@feature, 'subtype') = 'agriculture'" scalemaxdenom="250000" />
      <rule key="{0a77dbed-ec39-5388-a540-0fc50e8dc65f}" label="Aquaculture" symbol="1" filter="attribute(@feature, 'subtype') = 'aquaculture'" scalemaxdenom="250000" />
      <rule key="{24925a16-ec4d-50aa-bc24-ab203a68b40f}" label="Campground" symbol="2" filter="attribute(@feature, 'subtype') = 'campground'" scalemaxdenom="250000" />
      <rule key="{4952a893-4f58-5d16-9f4d-ea72dd80ad47}" label="Cemetery" symbol="3" filter="attribute(@feature, 'subtype') = 'cemetery'" scalemaxdenom="250000" />
      <rule key="{48d30944-58dc-5663-8ed0-2dd6b75993a9}" label="Construction" symbol="4" filter="attribute(@feature, 'subtype') = 'construction'" scalemaxdenom="250000" />
      <rule key="{19775ab7-86b7-5109-b448-cd8707b6b71c}" label="Developed" symbol="5" filter="attribute(@feature, 'subtype') = 'developed'" scalemaxdenom="250000" />
      <rule key="{0f35ae2e-badc-5783-ba3d-296543ef6088}" label="Education" symbol="6" filter="attribute(@feature, 'subtype') = 'education'" scalemaxdenom="250000" />
      <rule key="{ae9c2555-056e-520e-bcf8-101f90cdff33}" label="Entertainment" symbol="7" filter="attribute(@feature, 'subtype') = 'entertainment'" scalemaxdenom="250000" />
      <rule key="{e66f8bdf-ecc7-5a35-b940-4ea05ef6e6a9}" label="Golf" symbol="8" filter="attribute(@feature, 'subtype') = 'golf'" scalemaxdenom="250000" />
      <rule key="{0f16c9b6-da67-58a6-8f7e-907f1efdce9d}" label="Grass" symbol="9" filter="attribute(@feature, 'subtype') = 'grass'" scalemaxdenom="250000" />
      <rule key="{9c012abb-abe1-5d1e-bacc-20b453538b41}" label="Horticulture" symbol="10" filter="attribute(@feature, 'subtype') = 'horticulture'" scalemaxdenom="250000" />
      <rule key="{7411b3b6-c7a3-5d3d-9b00-c8e4280a63e3}" label="Landfill" symbol="11" filter="attribute(@feature, 'subtype') = 'landfill'" scalemaxdenom="250000" />
      <rule key="{835e1db4-f2f8-51c9-9ffd-1510e67d4411}" label="Managed" symbol="12" filter="attribute(@feature, 'subtype') = 'managed'" scalemaxdenom="250000" />
      <rule key="{f6377c4b-de4b-5c28-8638-fa2a7fe9c9b3}" label="Medical" symbol="13" filter="attribute(@feature, 'subtype') = 'medical'" scalemaxdenom="250000" />
      <rule key="{41d8b9db-9b55-534c-b545-047908d6dc47}" label="Military" symbol="14" filter="attribute(@feature, 'subtype') = 'military'" scalemaxdenom="2000000" />
      <rule key="{40c23426-f464-5830-b2ed-bea46dbb00b3}" label="Park" symbol="15" filter="attribute(@feature, 'subtype') = 'park'" scalemaxdenom="250000" />
      <rule key="{cee654cd-1f8d-58fa-a4cf-86cb53efa4cb}" label="Pedestrian" symbol="16" filter="attribute(@feature, 'subtype') = 'pedestrian'" scalemaxdenom="250000" />
      <rule key="{a2b6d1e1-2f75-52af-b6f8-8c6d1ac527c1}" label="Protected" symbol="17" filter="attribute(@feature, 'subtype') = 'protected'" scalemaxdenom="2000000" />
      <rule key="{a0308ef4-7c57-587f-b215-9b8f7ed874cc}" label="Recreation" symbol="18" filter="attribute(@feature, 'subtype') = 'recreation'" scalemaxdenom="250000" />
      <rule key="{0cb5d10c-2d5e-53de-9d43-a885a99b4283}" label="Religious" symbol="19" filter="attribute(@feature, 'subtype') = 'religious'" scalemaxdenom="250000" />
      <rule key="{20ca883e-fa1c-5be6-915f-7abc49372533}" label="Residential" symbol="20" filter="attribute(@feature, 'subtype') = 'residential'" scalemaxdenom="250000" />
      <rule key="{3c64840d-011e-5ddc-81d0-6b51c6338947}" label="Resource Extraction" symbol="21" filter="attribute(@feature, 'subtype') = 'resource_extraction'" scalemaxdenom="250000" />
      <rule key="{0bdc35bf-40d4-5e37-a3a3-d2dc5c16caa9}" label="Transportation" symbol="22" filter="attribute(@feature, 'subtype') = 'transportation'" scalemaxdenom="2000000" />
      <rule key="{f596e879-58c8-53db-a8db-ae810218e409}" label="Winter Sports" symbol="23" filter="attribute(@feature, 'subtype') = 'winter_sports'" scalemaxdenom="250000" />
      <rule key="{4393add1-dad0-5b7a-a6bb-7a1d2b22d260}" label="Other or missing value" symbol="24" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" id="{8b99aa21-622b-5af1-bd38-a49dc26d32fc}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="fill">
        <layer class="SimpleFill" enabled="1" id="{8cfb6ea3-65d4-5390-8c6a-53a676b1af0b}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="fill">
        <layer class="SimpleFill" enabled="1" id="{82a5c96d-e215-57d3-b6f0-6bc9853c1a0d}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="fill">
        <layer class="SimpleFill" enabled="1" id="{bf032930-b316-585a-804b-3dff592d75be}" locked="0" pass="0">
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
        <layer class="SimpleFill" enabled="1" id="{d202ff7a-595d-5edf-b115-aefcc22b4c27}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="fill">
        <layer class="SimpleFill" enabled="1" id="{3f630496-7d38-5cc0-a62e-4997c96655b6}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="fill">
        <layer class="SimpleFill" enabled="1" id="{6c1e0ea2-e452-55ea-8e9a-1abfcf7a4f62}" locked="0" pass="0">
          <prop k="color" v="79,142,128,205" />
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
        <layer class="SimpleFill" enabled="1" id="{41874072-719d-59fe-a82b-28be4862babe}" locked="0" pass="0">
          <prop k="color" v="155,118,83,205" />
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
        <layer class="SimpleFill" enabled="1" id="{a78307d1-747d-5dfd-ba8c-088afd481dd4}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="fill">
        <layer class="SimpleFill" enabled="1" id="{48c0cbcb-bab6-5897-b337-316a81872779}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="fill">
        <layer class="SimpleFill" enabled="1" id="{c3791ee4-2ce0-5418-96e1-67b03b7d58fe}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="fill">
        <layer class="SimpleFill" enabled="1" id="{d849ef71-3747-568d-95e3-e5783279df08}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="fill">
        <layer class="SimpleFill" enabled="1" id="{c40d3037-9dea-53c2-bf5f-172fc9abe883}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="fill">
        <layer class="SimpleFill" enabled="1" id="{af804e5b-b916-59bb-8af2-2b5e95ac137b}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="fill">
        <layer class="SimpleFill" enabled="1" id="{dd731436-b5cb-5778-bb3a-09a508949153}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="fill">
        <layer class="SimpleFill" enabled="1" id="{878ba121-709e-58e9-aa21-250bbce60592}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="fill">
        <layer class="SimpleFill" enabled="1" id="{e8de944f-fa41-5e1e-a6a1-9410c7a61a62}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="fill">
        <layer class="SimpleFill" enabled="1" id="{8224d7cd-a712-585f-9d93-fd41e988fd89}" locked="0" pass="0">
          <prop k="color" v="167,201,140,205" />
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
        <layer class="SimpleFill" enabled="1" id="{573b05a3-6dcb-5bb8-babc-581491c935b0}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="19" type="fill">
        <layer class="SimpleFill" enabled="1" id="{b69ae811-2954-51bd-8b87-454218cc5a05}" locked="0" pass="0">
          <prop k="color" v="155,118,83,205" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="20" type="fill">
        <layer class="SimpleFill" enabled="1" id="{24c3650a-ebe4-5073-9dd0-6744f171b9bd}" locked="0" pass="0">
          <prop k="color" v="217,211,203,205" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="21" type="fill">
        <layer class="SimpleFill" enabled="1" id="{89442494-80ac-5348-ab67-1bff26995941}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="22" type="fill">
        <layer class="SimpleFill" enabled="1" id="{0b4c2a1c-f2d9-511e-a8c5-b953f307a5b0}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="23" type="fill">
        <layer class="SimpleFill" enabled="1" id="{2b3f608d-1825-5831-a5c4-75a9dd7e172c}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="24" type="fill">
        <layer class="SimpleFill" enabled="1" id="{7ae2f16b-d17e-5cb1-9380-6d3351231038}" locked="0" pass="0">
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
    <property key="overture/style_id" value="base-land-use-polygon" />
    <property key="overture/palette" value="light" />
    <property key="overture/description" value="base-land-use-polygon light style bound to Overture schema 1.18.0" />
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
