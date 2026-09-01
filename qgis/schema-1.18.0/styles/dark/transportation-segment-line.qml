<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{c823186d-38f5-5e4b-85b1-5a4ac8fd3ce8}">
      <rule key="{9d195bd2-7d79-50d9-a30e-2a7eba9a0c0a}" label="Road — motorway" symbol="0" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'motorway'" scalemaxdenom="10000000" />
      <rule key="{dbbe8e63-2f2a-5d2a-8626-219d46239234}" label="Road — primary" symbol="1" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'primary'" scalemaxdenom="2000000" />
      <rule key="{a1a6cd89-6223-5509-9f6d-bed0713149a0}" label="Road — secondary" symbol="2" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'secondary'" scalemaxdenom="1000000" />
      <rule key="{d9ece3b0-9f1d-5c7e-9382-e6d710e171d6}" label="Road — tertiary" symbol="3" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'tertiary'" scalemaxdenom="500000" />
      <rule key="{31d70f73-b68f-544b-b1de-9f4db9b9a04b}" label="Road — residential" symbol="4" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'residential'" scalemaxdenom="100000" />
      <rule key="{683b2b14-883a-5f26-ad2f-da1b02ddb99a}" label="Road — living_street" symbol="5" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'living_street'" scalemaxdenom="100000" />
      <rule key="{688c2da8-da1a-5699-bf0e-ba28caaa5313}" label="Road — trunk" symbol="6" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'trunk'" scalemaxdenom="5000000" />
      <rule key="{83fa401f-af5c-5488-9197-d4f8e38a7881}" label="Road — unclassified" symbol="7" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'unclassified'" scalemaxdenom="100000" />
      <rule key="{20e55243-9a2a-507d-b419-78c2af613e30}" label="Road — service" symbol="8" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'service'" scalemaxdenom="50000" />
      <rule key="{cd0a2d6b-a298-5d2c-8c02-a2f6600ed7dd}" label="Road — pedestrian" symbol="9" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'pedestrian'" scalemaxdenom="25000" />
      <rule key="{773de2b3-3472-541d-87ca-bedca97b2047}" label="Road — footway" symbol="10" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'footway'" scalemaxdenom="25000" />
      <rule key="{2528f629-d2b3-5133-beff-23e081e6ab8d}" label="Road — steps" symbol="11" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'steps'" scalemaxdenom="10000" />
      <rule key="{4fbee20a-2d85-558d-8221-983da4a7848c}" label="Road — path" symbol="12" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'path'" scalemaxdenom="25000" />
      <rule key="{a84a696a-0f92-5b9f-bc9e-0fc88d549269}" label="Road — track" symbol="13" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'track'" scalemaxdenom="50000" />
      <rule key="{793b271d-1104-531d-abee-f8cffe24c989}" label="Road — cycleway" symbol="14" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'cycleway'" scalemaxdenom="50000" />
      <rule key="{495f0b2c-8339-5982-b20f-b4f9d6dd1fe4}" label="Road — bridleway" symbol="15" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'bridleway'" scalemaxdenom="25000" />
      <rule key="{b49d12bc-77a9-51df-9fa9-429a552af07c}" label="Road — unknown" symbol="16" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'unknown'" scalemaxdenom="50000" />
      <rule key="{8df0f269-f7f7-5baa-80dd-ff3da46ed549}" label="Rail — funicular" symbol="17" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'funicular'" scalemaxdenom="250000" />
      <rule key="{53461ba4-b6ac-5a53-8a2d-b6e3cdad542c}" label="Rail — light_rail" symbol="18" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'light_rail'" scalemaxdenom="250000" />
      <rule key="{6b0c2d26-4dd0-5165-ac7d-ee43a5c60384}" label="Rail — monorail" symbol="19" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'monorail'" scalemaxdenom="250000" />
      <rule key="{c0a66805-70a3-52fa-aefd-39d1cbe70a64}" label="Rail — narrow_gauge" symbol="20" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'narrow_gauge'" scalemaxdenom="250000" />
      <rule key="{b35f79fd-a041-5cd0-b49e-e316ca20f781}" label="Rail — standard_gauge" symbol="21" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'standard_gauge'" scalemaxdenom="2000000" />
      <rule key="{d686f4a5-49ec-5d3f-83b4-c445d3bf6bbb}" label="Rail — subway" symbol="22" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'subway'" scalemaxdenom="2000000" />
      <rule key="{fe7c817a-f6f0-588e-8413-12b51ed4e3c0}" label="Rail — tram" symbol="23" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'tram'" scalemaxdenom="250000" />
      <rule key="{b5d37592-ce64-59e7-8193-dfb4ec7e6a66}" label="Rail — unknown" symbol="24" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'unknown'" scalemaxdenom="250000" />
      <rule key="{cb275cfc-ec15-5515-8cc8-b447f14e7c93}" label="Water route" symbol="25" filter="attribute(@feature, 'subtype') = 'water'" scalemaxdenom="2000000" />
      <rule key="{28679584-5688-5be8-b36a-5ae906e153d2}" label="Other segment" symbol="26" filter="ELSE" scalemaxdenom="50000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="line">
        <layer class="SimpleLine" enabled="1" id="{d7bda9df-224c-5ce9-a87a-b09bfb06ea31}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.82" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{68722871-6013-5f66-9dbd-86e41d5a6f2c}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="209,132,88,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.5" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="line">
        <layer class="SimpleLine" enabled="1" id="{dd1abe4b-1558-5eb1-ba5a-d9ae3dfe105c}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.42" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{8080e62e-8008-5e53-9766-01b1e948e3b9}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="240,107,99,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.1" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="line">
        <layer class="SimpleLine" enabled="1" id="{2961754e-212c-5c3e-8a9b-54361170127c}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.27" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{5e901f16-6723-50f9-ac03-2474f63f36f6}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="139,121,84,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.95" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="line">
        <layer class="SimpleLine" enabled="1" id="{47bd5970-807b-5f08-8901-3af9da57e90a}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.12" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{f0ae77bd-b7e9-5564-8b41-ba5edf9fe278}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="129,89,79,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.8" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="line">
        <layer class="SimpleLine" enabled="1" id="{e5064fc3-bdcc-526d-b60e-5aee55200fcb}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.94" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{2289e17c-44ec-54dc-a9ef-ecbbb353b97f}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="77,80,86,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.62" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="line">
        <layer class="SimpleLine" enabled="1" id="{17b2f7d5-bd9a-5fc4-ab6b-710510ccd70d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.9" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{3910fa77-5903-5196-b68a-b4dcbdda4ee6}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="77,80,86,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.58" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="line">
        <layer class="SimpleLine" enabled="1" id="{df3d1641-58c9-54ad-866f-074f2f89f19d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.62" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{28fccda7-4a6d-5618-b678-a507572deb2a}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="209,132,88,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.3" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="line">
        <layer class="SimpleLine" enabled="1" id="{f36ffd84-c24b-56be-ba60-d25096f2f679}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.87" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{fcb01dd6-a014-590f-9dc9-a31a3bbeccc2}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="77,80,86,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="line">
        <layer class="SimpleLine" enabled="1" id="{f4349115-b441-5d83-a532-c6023e71fc44}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.8" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{7c8de2b8-60cd-5e10-9c6e-db2ec0068da9}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="85,90,97,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.48" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="line">
        <layer class="SimpleLine" enabled="1" id="{b52e33bb-869f-5268-b69b-34625f64382f}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.74" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{b5194825-3abe-54c5-a8a6-9a079c62afc0}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="173,146,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.42" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="line">
        <layer class="SimpleLine" enabled="1" id="{6a18f043-b75e-51c5-aa49-0e5516e487e1}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.68" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{d1ad3f91-ad42-5998-899e-26e16d55025e}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="173,146,120,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.36" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="line">
        <layer class="SimpleLine" enabled="1" id="{36bc6203-e976-526a-97ef-6174f5de6c3b}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.68" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{7722c8d8-9a69-523d-af0f-3e65c8b808af}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="173,146,120,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.36" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="line">
        <layer class="SimpleLine" enabled="1" id="{f13eddeb-1953-59e8-81d2-43a6d14525d7}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.66" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{029aaa3f-ad0e-59f8-9414-5ffff49f1a61}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="173,146,120,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.34" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="line">
        <layer class="SimpleLine" enabled="1" id="{fe8c2c28-695a-5e7c-925f-e93ba3785919}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.74" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{bb9c73bb-23bd-50a6-be09-8fdf725cb2ba}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="173,146,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.42" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="line">
        <layer class="SimpleLine" enabled="1" id="{5c8a8c6e-5573-50c2-9a5d-86194b7e637f}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.74" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{88c0a5ff-dfa7-552b-a3ee-0bd546359dc4}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="111,195,144,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.42" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="line">
        <layer class="SimpleLine" enabled="1" id="{b94812d4-f0cf-5ea5-b71d-8fccc5e04b6e}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.68" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{e9f2c15e-bc67-5b34-ae96-3089b610f8c0}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="118,91,72,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.36" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="line">
        <layer class="SimpleLine" enabled="1" id="{9c882a68-35fd-55e8-b171-679e73e5b576}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.72" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{16da63c6-0f22-55fd-9ff6-2c99a8aae9b9}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="125,135,144,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.4" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="line">
        <layer class="SimpleLine" enabled="1" id="{bd7337d6-2f99-5215-b866-2d55582c1bff}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{344714c8-868b-5efd-990c-d48b12ad78e6}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,167,173,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="18" type="line">
        <layer class="SimpleLine" enabled="1" id="{ecfb7266-b959-5a85-97b7-83428b311ecf}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{03aafac5-b748-5024-ab34-416d5210dac0}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,167,173,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="19" type="line">
        <layer class="SimpleLine" enabled="1" id="{d385a9ad-591e-5c3b-b7de-23ffd9021c1f}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{4ed065f1-cf84-5b26-b90d-a1107726931d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,167,173,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="20" type="line">
        <layer class="SimpleLine" enabled="1" id="{6e640edc-f1e5-50b8-83a7-f5b819928ada}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{5d644650-385e-5c73-83a1-f8fcb71f293f}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,167,173,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="21" type="line">
        <layer class="SimpleLine" enabled="1" id="{15c967e0-0fe8-5864-82db-c987e4348b2d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{3bcb83ab-b9d9-5491-9678-38b2504b199b}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,167,173,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="22" type="line">
        <layer class="SimpleLine" enabled="1" id="{c0e2ae47-472b-5c56-8dae-2de888d3db6c}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{45337961-423e-565c-9325-4398d952875d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,167,173,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="23" type="line">
        <layer class="SimpleLine" enabled="1" id="{43f64194-dae9-5895-8649-40042880313e}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{ec0de7a7-e74c-5c51-b8fc-c0f0f9e1af59}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,167,173,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="24" type="line">
        <layer class="SimpleLine" enabled="1" id="{509c3a97-a9b2-57a8-b693-c59287e0ca39}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{121b8e3e-68d2-5067-8562-17d2566d75cb}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,167,173,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="25" type="line">
        <layer class="SimpleLine" enabled="1" id="{8e62bc1f-2968-5583-bc7d-c16cb3de6e04}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{d00b5bf5-0c4b-5cc1-9a84-ab101a501d9a}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="53,111,145,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="26" type="line">
        <layer class="SimpleLine" enabled="1" id="{c2848892-01da-5bf4-bf5f-7b7b14134119}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.72" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{013e046b-f997-569b-8ce5-2aafb3828a7a}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="125,135,144,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.4" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <customproperties>
    <property key="overture/schema_version" value="1.18.0" />
    <property key="overture/style_id" value="transportation-segment-line" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="transportation-segment-line dark style bound to Overture schema 1.18.0" />
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
      <placement allowDegraded="0" centroidInside="1" dist="1" distUnits="MM" fitInPolygonOnly="0" layerType="LineGeometry" maxCurvedCharAngleIn="25" maxCurvedCharAngleOut="-25" offsetType="0" overlapHandling="PreventOverlap" placement="2" placementFlags="10" predefinedPositionOrder="TR,TL,BR,BL,R,L" priority="5" quadOffset="4" repeatDistance="40" repeatDistanceUnits="MM" />
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="1" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="250000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>1</layerGeometryType>
</qgis>
