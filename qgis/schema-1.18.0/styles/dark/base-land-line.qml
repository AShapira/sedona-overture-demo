<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{6d13f02e-3936-56b6-8204-ceb42877e0a4}">
      <rule key="{b3e144d9-1252-54b4-9e73-c9a9039a9ece}" label="Crater" symbol="0" filter="attribute(@feature, 'subtype') = 'crater'" scalemaxdenom="250000" />
      <rule key="{a1f633ee-cfe0-5c11-9a40-11daccd407d5}" label="Desert" symbol="1" filter="attribute(@feature, 'subtype') = 'desert'" scalemaxdenom="2000000" />
      <rule key="{adf68582-f283-5418-9334-e26ff4c4a936}" label="Forest" symbol="2" filter="attribute(@feature, 'subtype') = 'forest'" scalemaxdenom="2000000" />
      <rule key="{5c80b49c-80c5-5f4b-b03a-1191d875419b}" label="Glacier" symbol="3" filter="attribute(@feature, 'subtype') = 'glacier'" scalemaxdenom="2000000" />
      <rule key="{d1dddffc-205c-5d92-adc7-06e184867b45}" label="Grass" symbol="4" filter="attribute(@feature, 'subtype') = 'grass'" scalemaxdenom="250000" />
      <rule key="{3c220eec-dfe0-5c20-a3ec-7d7bdacead2f}" label="Land" symbol="5" filter="attribute(@feature, 'subtype') = 'land'" scalemaxdenom="2000000" />
      <rule key="{25a2aa60-b868-5733-9696-ceb41431119e}" label="Physical" symbol="6" filter="attribute(@feature, 'subtype') = 'physical'" scalemaxdenom="2000000" />
      <rule key="{db17839b-954f-5d24-884c-36d9cf703f84}" label="Reef" symbol="7" filter="attribute(@feature, 'subtype') = 'reef'" scalemaxdenom="250000" />
      <rule key="{fed02709-e1ea-5002-8aee-80b1f95e8f93}" label="Rock" symbol="8" filter="attribute(@feature, 'subtype') = 'rock'" scalemaxdenom="250000" />
      <rule key="{f3512012-8668-5ddf-9980-051eee8d4e85}" label="Sand" symbol="9" filter="attribute(@feature, 'subtype') = 'sand'" scalemaxdenom="250000" />
      <rule key="{ab15e1c8-67c0-5451-a1d0-fb13e22d9c61}" label="Shrub" symbol="10" filter="attribute(@feature, 'subtype') = 'shrub'" scalemaxdenom="250000" />
      <rule key="{52410375-5bff-500c-9db2-2a53d936ec37}" label="Tree" symbol="11" filter="attribute(@feature, 'subtype') = 'tree'" scalemaxdenom="250000" />
      <rule key="{b62cde20-f692-517e-856b-340311162506}" label="Wetland" symbol="12" filter="attribute(@feature, 'subtype') = 'wetland'" scalemaxdenom="250000" />
      <rule key="{a3f520db-4434-59c0-9f99-e11b543b6a89}" label="Other or missing value" symbol="13" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="line">
        <layer class="SimpleLine" enabled="1" id="{d77971f3-e497-57c6-a63f-954e72c43f18}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{003cc081-f1ea-5578-bcec-e488cdfb7ee5}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="118,91,72,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="line">
        <layer class="SimpleLine" enabled="1" id="{a629af63-bd8e-5407-b97b-2d0e92cb9a4c}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{f12205ce-7c4b-545b-89a3-6a07a78cde9d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="139,121,84,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="line">
        <layer class="SimpleLine" enabled="1" id="{e75d969c-4a66-553d-ad92-6d1c1e1adffd}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{b8fcb6f7-a172-5f41-bfd8-d78a35a0c1f2}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="47,86,60,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="line">
        <layer class="SimpleLine" enabled="1" id="{4e042a97-b7b9-5992-ae73-e3d30ebf8c28}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{df617eb0-0d3a-5483-b61f-2aa70dcb586d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="17,21,26,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="line">
        <layer class="SimpleLine" enabled="1" id="{36345377-330e-5947-b55d-5d4af7b8fb3c}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{9ccbd480-f157-5d00-bddf-19c72af8efe3}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="66,107,77,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="line">
        <layer class="SimpleLine" enabled="1" id="{b5009402-1b14-52ec-b323-56344bc9db5f}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{75eca548-f2f1-53cf-a23f-440495e81c17}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="line">
        <layer class="SimpleLine" enabled="1" id="{27ec9bf5-3fb2-5619-80d5-f2f6ddecc8e9}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{9c846ea1-b165-5837-941e-68cef0208814}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="118,91,72,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="line">
        <layer class="SimpleLine" enabled="1" id="{9a07e2dd-daf7-5f5d-85b2-ceabefae95f5}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{6367a032-1193-51ff-ae18-b817cf1baed3}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="53,111,145,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="line">
        <layer class="SimpleLine" enabled="1" id="{23742470-27e3-54fd-842e-dc548b5900eb}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{0f9efb4c-456e-5f58-b0d2-156ca4100658}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="118,91,72,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="line">
        <layer class="SimpleLine" enabled="1" id="{ebbfc2ba-9940-5edf-8c55-aac32089c32e}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{50ee9550-9e33-5730-9b8d-d9b8ff3a4e20}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="139,121,84,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="line">
        <layer class="SimpleLine" enabled="1" id="{86652343-16b3-548e-be45-87c9e819c804}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{cd7319db-cd16-5d06-84a8-4194d9e8368c}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="66,107,77,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="line">
        <layer class="SimpleLine" enabled="1" id="{4f40596c-4806-5443-9404-8f883dfa9fd7}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{6be01e49-daa8-5116-aa0d-0ac8ab921f8c}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="47,86,60,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="line">
        <layer class="SimpleLine" enabled="1" id="{5de37caa-409d-5bb8-98d9-071706b99893}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{f8152732-73b4-5f40-8ec1-e9a2c651cf39}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="53,111,145,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="line">
        <layer class="SimpleLine" enabled="1" id="{11f6641a-9c33-5213-ab11-94ab85fa3513}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,190" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.77" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{586e7761-cf17-5d77-866a-2d3fded7ea76}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="125,135,144,190" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.45" />
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
    <property key="overture/style_id" value="base-land-line" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-land-line dark style bound to Overture schema 1.18.0" />
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
