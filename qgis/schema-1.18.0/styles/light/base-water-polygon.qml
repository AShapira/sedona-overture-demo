<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{8ac3a996-6d89-5f20-a642-5137e2dabc41}">
      <rule key="{43c32a59-6570-5a35-9db7-040a788e03b0}" label="canal — salt" symbol="0" filter="attribute(@feature, 'subtype') = 'canal' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{5a1cbae5-0595-50ae-b511-a95c51dcf911}" label="Canal" symbol="1" filter="attribute(@feature, 'subtype') = 'canal' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{6c7c0c4c-2917-584e-9b66-acc71492fc26}" label="human_made — salt" symbol="2" filter="attribute(@feature, 'subtype') = 'human_made' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{047d4f0c-c07e-56d1-8b14-a3f249ecfc0e}" label="Human Made" symbol="3" filter="attribute(@feature, 'subtype') = 'human_made' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{8b7b4cd2-2bc6-56e6-ab9f-09dda07aa465}" label="lake — salt" symbol="4" filter="attribute(@feature, 'subtype') = 'lake' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{dee76bb4-90ca-5f5e-84d0-0dcd14272a81}" label="Lake" symbol="5" filter="attribute(@feature, 'subtype') = 'lake' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{a7fe22c3-7972-5556-b0a9-d1d1aea068c2}" label="ocean — salt" symbol="6" filter="attribute(@feature, 'subtype') = 'ocean' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="100000000" />
      <rule key="{b4c13e3b-9721-5a13-8ac4-bbe35b6d0c48}" label="Ocean" symbol="7" filter="attribute(@feature, 'subtype') = 'ocean' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="100000000" />
      <rule key="{0c592e10-8a67-5e8b-865a-9ae2c00e6475}" label="physical — salt" symbol="8" filter="attribute(@feature, 'subtype') = 'physical' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{21ba217c-e6ba-5ce3-b89e-d85e54eb904c}" label="Physical" symbol="9" filter="attribute(@feature, 'subtype') = 'physical' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{b5847f23-4444-5d68-b958-717581d94bc4}" label="pond — salt" symbol="10" filter="attribute(@feature, 'subtype') = 'pond' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{c4570f12-b1e1-5b7f-9f5d-56b7796e9231}" label="Pond" symbol="11" filter="attribute(@feature, 'subtype') = 'pond' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{4d5d84bf-3393-54e7-a0ee-b3c3b7faded9}" label="reservoir — salt" symbol="12" filter="attribute(@feature, 'subtype') = 'reservoir' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{817587fa-47ed-5c52-b5ce-cd2b44eb3bbb}" label="Reservoir" symbol="13" filter="attribute(@feature, 'subtype') = 'reservoir' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{c64a6eb7-4fbe-5ae5-a02f-a91e27b30c40}" label="river — salt" symbol="14" filter="attribute(@feature, 'subtype') = 'river' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{38a123ef-0c46-531f-898b-e5ab461b8f43}" label="River" symbol="15" filter="attribute(@feature, 'subtype') = 'river' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{2cd9b125-3452-5cb3-a830-9e3ede3ad8b7}" label="spring — salt" symbol="16" filter="attribute(@feature, 'subtype') = 'spring' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{0c96c6bf-ef50-5dc0-9b4b-bb259d6fe9b3}" label="Spring" symbol="17" filter="attribute(@feature, 'subtype') = 'spring' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{f60e2bfd-750b-5b19-a3f6-ccde69e3c664}" label="stream — salt" symbol="18" filter="attribute(@feature, 'subtype') = 'stream' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{05bb7d13-c6a1-5c5f-84ba-08220b92146f}" label="Stream" symbol="19" filter="attribute(@feature, 'subtype') = 'stream' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{d4149ec8-ab80-52f5-912b-0b027a0edb33}" label="wastewater — salt" symbol="20" filter="attribute(@feature, 'subtype') = 'wastewater' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{177f607b-b211-5b47-8f3b-f9583cd736a2}" label="Wastewater" symbol="21" filter="attribute(@feature, 'subtype') = 'wastewater' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{9fed8e68-46db-5ce6-b996-978079336cbe}" label="water — salt" symbol="22" filter="attribute(@feature, 'subtype') = 'water' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{9f155ecb-fd81-5775-9ed9-98a08e4b986a}" label="Water" symbol="23" filter="attribute(@feature, 'subtype') = 'water' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{5a3d5796-da05-5311-8288-816e32b6cd54}" label="Other or missing value" symbol="24" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" id="{5a3d7ba5-8f17-5a39-8fc7-219b70b71e3d}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{325c7f71-549e-53e7-809f-86082994ba47}" locked="0" pass="0">
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
        <layer class="SimpleFill" enabled="1" id="{193dffb2-68f9-5358-b373-68ff2e4636cb}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{716ce2b2-e088-5e9e-928b-10818bb65a72}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="fill">
        <layer class="SimpleFill" enabled="1" id="{8d852a53-bd9b-51b3-a0ad-b65747e20d1f}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{34714ee5-1938-582c-b4d9-5633eb926469}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="fill">
        <layer class="SimpleFill" enabled="1" id="{5882e6a5-ab10-5157-8e2d-dc17937ae50b}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{de545cfc-45c5-5062-a2fe-582de83d2469}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="fill">
        <layer class="SimpleFill" enabled="1" id="{1b0a25dd-585e-5235-9947-79f07a6e13af}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{24639f1f-bcea-54ff-b49c-b15aa0cbf9af}" locked="0" pass="0">
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
        <layer class="SimpleFill" enabled="1" id="{446796ec-a6a7-5ca7-9652-602c219cc7a7}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{6777b72f-10ad-5e63-8477-af67c4f0271e}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="fill">
        <layer class="SimpleFill" enabled="1" id="{b7f059a2-a27b-51ee-b4b4-fb5337065e3f}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{5b7e9681-beb2-5433-b0cb-81448761837e}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="fill">
        <layer class="SimpleFill" enabled="1" id="{763f3d00-4025-5d3d-86d2-c77350106bdf}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{056df954-a5e7-5ecc-b7ae-4da9795c59f1}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="fill">
        <layer class="SimpleFill" enabled="1" id="{41692f73-4326-5ef1-b45f-6d17342fdd38}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{26664a5f-b287-550d-bb83-377f55265c5d}" locked="0" pass="0">
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
        <layer class="SimpleFill" enabled="1" id="{ded9e33b-3c13-57df-8cba-1ceb6118e6d5}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{b4ca3d4e-f761-5f6b-bf0d-a2547189ed6e}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="20" type="fill">
        <layer class="SimpleFill" enabled="1" id="{f22c4779-5108-5684-8c45-5ed6508e6be0}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{1b163352-b080-5517-964e-9101f9c66bae}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="22" type="fill">
        <layer class="SimpleFill" enabled="1" id="{23117623-3bad-5ea9-9b3b-65b264239d6c}" locked="0" pass="0">
          <prop k="color" v="37,95,145,205" />
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
        <layer class="SimpleFill" enabled="1" id="{409ad8a3-9bd0-5d7b-8d1c-76779206700a}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="24" type="fill">
        <layer class="SimpleFill" enabled="1" id="{4da6a88d-e93a-5eff-aa4d-a2dc3a5ace80}" locked="0" pass="0">
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
    <property key="overture/style_id" value="base-water-polygon" />
    <property key="overture/palette" value="light" />
    <property key="overture/description" value="base-water-polygon light style bound to Overture schema 1.18.0" />
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
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="0" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="250000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>2</layerGeometryType>
</qgis>
