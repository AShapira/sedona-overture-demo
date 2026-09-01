<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{eacaafba-10b6-5687-873c-2bdc8445ffe4}">
      <rule key="{bb4c7095-95ad-530a-b9b1-96d12c5d178d}" label="Aerialway" symbol="0" filter="attribute(@feature, 'subtype') = 'aerialway'" scalemaxdenom="50000" />
      <rule key="{6bfd2c8d-6ea3-530c-811b-be683f2bce9b}" label="Airport" symbol="1" filter="attribute(@feature, 'subtype') = 'airport'" scalemaxdenom="10000000" />
      <rule key="{0dd67ae5-df0c-57ae-ac96-c18eecc37a03}" label="Barrier" symbol="2" filter="attribute(@feature, 'subtype') = 'barrier'" scalemaxdenom="50000" />
      <rule key="{07f5bee7-076e-560d-adeb-0b1004352dad}" label="Bridge" symbol="3" filter="attribute(@feature, 'subtype') = 'bridge'" scalemaxdenom="250000" />
      <rule key="{2da3c206-9bf0-5aa6-8a96-2f90357b531c}" label="Communication" symbol="4" filter="attribute(@feature, 'subtype') = 'communication'" scalemaxdenom="250000" />
      <rule key="{40a8567a-2246-5105-ae8f-ebce1645f1b1}" label="Emergency" symbol="5" filter="attribute(@feature, 'subtype') = 'emergency'" scalemaxdenom="50000" />
      <rule key="{ff6b9628-a256-5516-9d4f-a1ee7ebe9449}" label="Manhole" symbol="6" filter="attribute(@feature, 'subtype') = 'manhole'" scalemaxdenom="50000" />
      <rule key="{09bc08c3-923a-57bf-bf91-d6f4e043f7f5}" label="Pedestrian" symbol="7" filter="attribute(@feature, 'subtype') = 'pedestrian'" scalemaxdenom="50000" />
      <rule key="{3e40e4ad-905b-5b0e-b94e-ea06dd3bb547}" label="Pier" symbol="8" filter="attribute(@feature, 'subtype') = 'pier'" scalemaxdenom="50000" />
      <rule key="{929a603d-2b57-5aef-a2ec-6be89e1164f2}" label="Power" symbol="9" filter="attribute(@feature, 'subtype') = 'power'" scalemaxdenom="250000" />
      <rule key="{e2c41d19-5c7c-568c-853c-ccb88f345b4f}" label="Quay" symbol="10" filter="attribute(@feature, 'subtype') = 'quay'" scalemaxdenom="50000" />
      <rule key="{2f096961-3bfe-5a5f-8780-25c5146fe17a}" label="Recreation" symbol="11" filter="attribute(@feature, 'subtype') = 'recreation'" scalemaxdenom="50000" />
      <rule key="{1a1dd4ea-dca3-5a64-a776-fe8078aa87bb}" label="Tower" symbol="12" filter="attribute(@feature, 'subtype') = 'tower'" scalemaxdenom="50000" />
      <rule key="{1b026711-02f4-59ad-8b7a-09f68bbe2eb7}" label="Transit" symbol="13" filter="attribute(@feature, 'subtype') = 'transit'" scalemaxdenom="250000" />
      <rule key="{f7cb481a-4bc5-51a9-832f-a33c3a12427b}" label="Transportation" symbol="14" filter="attribute(@feature, 'subtype') = 'transportation'" scalemaxdenom="50000" />
      <rule key="{6fa039f9-728a-5a13-b10c-897a9b1de227}" label="Utility" symbol="15" filter="attribute(@feature, 'subtype') = 'utility'" scalemaxdenom="50000" />
      <rule key="{92f08cf4-3045-5d74-8cc0-e40357951b59}" label="Waste Management" symbol="16" filter="attribute(@feature, 'subtype') = 'waste_management'" scalemaxdenom="50000" />
      <rule key="{0dfea9ef-aa73-53db-a71f-f48e94fe2fb0}" label="Water" symbol="17" filter="attribute(@feature, 'subtype') = 'water'" scalemaxdenom="50000" />
      <rule key="{ea9d84e2-093a-5c0f-81c7-9931d9487e77}" label="Other or missing value" symbol="18" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="line">
        <layer class="SimpleLine" enabled="1" id="{02d8b9e8-64cf-586a-9450-91643fde6449}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{46d7dbce-5076-55a9-8998-c1912b5e24ad}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="209,132,88,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="line">
        <layer class="SimpleLine" enabled="1" id="{24ef82cb-3207-594f-af97-ff304338d7af}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{2fad1115-97cd-570a-ad6d-9d28fba2d8d3}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="112,166,215,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="line">
        <layer class="SimpleLine" enabled="1" id="{e7cb52b9-475a-5b29-9ab8-fcb3213fe40a}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{3761ab46-bfbb-5ef4-a8b8-9437aa2c1097}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="137,148,158,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="line">
        <layer class="SimpleLine" enabled="1" id="{eeeac014-32e5-550a-9cf2-b056d271e460}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{be13663f-9783-5312-aa65-9986c0444ef5}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="line">
        <layer class="SimpleLine" enabled="1" id="{30969f11-4b3f-5b15-9f03-bf39fc7ad10c}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{21dfb3f8-af8f-5312-bf6d-b7e8e005e3d8}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="119,164,211,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="line">
        <layer class="SimpleLine" enabled="1" id="{ce8069cd-9535-50ec-9907-7bbcc9743466}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{86c5cace-e5c3-59f7-bf19-ddbd09b5305e}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="241,110,121,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="line">
        <layer class="SimpleLine" enabled="1" id="{09a32921-4f87-5d2a-bc2b-8ccf36589b97}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{e4af3b3f-809d-5e92-ac8d-34269a099345}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="125,135,144,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="line">
        <layer class="SimpleLine" enabled="1" id="{3ae8ee67-0f76-5e9b-a22d-ffdbed2fa675}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{eb44f1f0-8029-5007-ae1a-cda4f6eb53c0}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="173,146,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="line">
        <layer class="SimpleLine" enabled="1" id="{512c3681-94de-520f-86cc-a3fa4cbacd9b}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{1b35170d-674d-51fe-8eec-7c0d9dfda6c0}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{ab12ceac-a067-56b3-a78c-8ee4552bfe0e}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{34229f0c-e8b4-5657-87bf-c894ded5aa19}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="240,107,99,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="line">
        <layer class="SimpleLine" enabled="1" id="{f2e3c775-5c77-55fa-a7e2-5421dea68868}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{4a93e5b2-4722-5e3e-9788-a4edc8f38c7e}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="line">
        <layer class="SimpleLine" enabled="1" id="{aa809360-a10e-5159-a663-ed8f84ee7d14}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{0d11ffb9-2ae7-5bb7-ad07-67bb3545d197}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="111,195,144,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="line">
        <layer class="SimpleLine" enabled="1" id="{d7987c6e-8bcc-509e-8b5a-5e3fe08ab912}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{b8d82bf1-1dba-51b2-8ece-b8f51c8abd8c}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="119,164,211,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="line">
        <layer class="SimpleLine" enabled="1" id="{06f8e0fc-b92d-52c0-b2ea-c083f0dfa605}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{2823641e-a6fb-521a-9de5-95df20a0c4c2}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="112,166,215,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="line">
        <layer class="SimpleLine" enabled="1" id="{629e342f-76de-59a5-ad0c-c9e3567a9ab4}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{c27419b0-2686-5764-bf50-310df54c55e9}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="209,132,88,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="line">
        <layer class="SimpleLine" enabled="1" id="{c4e92c33-78eb-55dc-9092-7c39a6abe8e0}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{6f378c0b-2df3-5841-b3e6-b2136bf4050b}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="119,164,211,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="line">
        <layer class="SimpleLine" enabled="1" id="{c2e229fb-0818-5a1e-962a-0987fa19bd8d}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{50737632-165f-5152-a9ae-41674d06bb0d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="98,85,110,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="line">
        <layer class="SimpleLine" enabled="1" id="{78eb12c8-691a-57e3-95dd-dc9f8ef2067d}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{90da5cfb-f531-5a57-b038-cf1c9190d419}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="18" type="line">
        <layer class="SimpleLine" enabled="1" id="{e8ec7dcc-cc9a-55df-be06-86d6371b50c2}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{a6b2f01d-6955-54cc-bf93-d997cb0b6485}" locked="0" pass="0">
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
    <property key="overture/style_id" value="base-infrastructure-line" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-infrastructure-line dark style bound to Overture schema 1.18.0" />
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
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="1" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="50000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>1</layerGeometryType>
</qgis>
