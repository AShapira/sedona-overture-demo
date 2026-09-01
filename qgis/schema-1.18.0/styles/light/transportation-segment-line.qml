<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{7e62374e-fc47-5296-912f-25e697f8246e}">
      <rule key="{e6990b37-6951-504b-9c4a-b99d4051a486}" label="Road — motorway" symbol="0" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'motorway'" scalemaxdenom="10000000" />
      <rule key="{911b1ccb-4e90-5716-a746-1b8bf84c32d8}" label="Road — primary" symbol="1" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'primary'" scalemaxdenom="2000000" />
      <rule key="{b27c1b72-0699-5f60-8781-3e77a23f67c0}" label="Road — secondary" symbol="2" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'secondary'" scalemaxdenom="1000000" />
      <rule key="{81fad0b9-f1dc-5fbe-8894-c4adc585b73c}" label="Road — tertiary" symbol="3" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'tertiary'" scalemaxdenom="500000" />
      <rule key="{329f64ff-1b07-5eed-911b-e521aeedc244}" label="Road — residential" symbol="4" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'residential'" scalemaxdenom="100000" />
      <rule key="{167ec955-07fc-52ab-b0ef-1675ed8cb3d6}" label="Road — living_street" symbol="5" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'living_street'" scalemaxdenom="100000" />
      <rule key="{6a5e8efc-acf6-5333-a917-be2c62b8148a}" label="Road — trunk" symbol="6" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'trunk'" scalemaxdenom="5000000" />
      <rule key="{c82ad1fb-2887-5f83-bff7-d5e801526281}" label="Road — unclassified" symbol="7" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'unclassified'" scalemaxdenom="100000" />
      <rule key="{7515444f-c558-58a3-9468-200f40bb2f6b}" label="Road — service" symbol="8" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'service'" scalemaxdenom="50000" />
      <rule key="{5743ab50-a995-5aa9-b415-8f4c12209c92}" label="Road — pedestrian" symbol="9" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'pedestrian'" scalemaxdenom="25000" />
      <rule key="{f3d520d9-b486-5d98-a098-fe9de0241a4f}" label="Road — footway" symbol="10" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'footway'" scalemaxdenom="25000" />
      <rule key="{030dbfd5-b72f-5311-a6e0-ea3248b68a57}" label="Road — steps" symbol="11" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'steps'" scalemaxdenom="10000" />
      <rule key="{a193184e-3711-5ce6-8d3d-ec662d7d29b0}" label="Road — path" symbol="12" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'path'" scalemaxdenom="25000" />
      <rule key="{010363ca-6998-5a98-bbdb-f6d65282da41}" label="Road — track" symbol="13" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'track'" scalemaxdenom="50000" />
      <rule key="{6e2ab502-464f-5c94-84ca-99ef2afc727e}" label="Road — cycleway" symbol="14" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'cycleway'" scalemaxdenom="50000" />
      <rule key="{515585e3-c5e5-58a3-ae69-f871022e7587}" label="Road — bridleway" symbol="15" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'bridleway'" scalemaxdenom="25000" />
      <rule key="{434f4d4d-94a1-5d0a-8f16-08027ab70a7d}" label="Road — unknown" symbol="16" filter="attribute(@feature, 'subtype') = 'road' AND attribute(@feature, 'class') = 'unknown'" scalemaxdenom="50000" />
      <rule key="{4729e6e9-957d-535e-8b4b-f2e1ab135902}" label="Rail — funicular" symbol="17" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'funicular'" scalemaxdenom="250000" />
      <rule key="{d3b66e05-e8bd-5c28-af02-0e0514c30909}" label="Rail — light_rail" symbol="18" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'light_rail'" scalemaxdenom="250000" />
      <rule key="{0c7c87be-a7b2-5df6-9c9b-4d75f9851de9}" label="Rail — monorail" symbol="19" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'monorail'" scalemaxdenom="250000" />
      <rule key="{c4ba978f-e22a-5055-87ab-88c8281f3a2c}" label="Rail — narrow_gauge" symbol="20" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'narrow_gauge'" scalemaxdenom="250000" />
      <rule key="{5fdc3f2a-714c-5664-9857-03dbef027d62}" label="Rail — standard_gauge" symbol="21" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'standard_gauge'" scalemaxdenom="2000000" />
      <rule key="{bdfd478f-d89a-56a2-88e7-ea48dde4059e}" label="Rail — subway" symbol="22" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'subway'" scalemaxdenom="2000000" />
      <rule key="{332ea85f-84d1-5d85-a8f8-236ffe529c7f}" label="Rail — tram" symbol="23" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'tram'" scalemaxdenom="250000" />
      <rule key="{c30ab5f8-644e-5685-a216-d83346a927c4}" label="Rail — unknown" symbol="24" filter="attribute(@feature, 'subtype') = 'rail' AND attribute(@feature, 'class') = 'unknown'" scalemaxdenom="250000" />
      <rule key="{dcc7504a-c293-5691-8f05-44fe6c0ab047}" label="Water route" symbol="25" filter="attribute(@feature, 'subtype') = 'water'" scalemaxdenom="2000000" />
      <rule key="{f3d56a55-c37c-5d88-8e4d-2bf732925e98}" label="Other segment" symbol="26" filter="ELSE" scalemaxdenom="50000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="line">
        <layer class="SimpleLine" enabled="1" id="{81b117a7-33e5-561c-9bd9-b76318b7e75d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.82" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{157d1461-356f-502d-9667-34dd25d4f7cb}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="227,151,98,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.5" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="line">
        <layer class="SimpleLine" enabled="1" id="{a8af004f-a96f-5c0b-bd24-753799a9abd7}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.42" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{309dd792-7b60-5c64-a260-556b4eca6684}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="215,88,79,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.1" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="line">
        <layer class="SimpleLine" enabled="1" id="{301c2fbc-fd06-5923-a599-d562cb813bdb}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.27" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{d4146704-05bf-5685-809b-4ee5d64413b8}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="231,215,170,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.95" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="line">
        <layer class="SimpleLine" enabled="1" id="{22788a86-8b20-5452-96ea-dbaa14f495f8}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.12" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{509984ab-dcc1-5754-877b-8c2f931d0999}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="231,198,183,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.8" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="line">
        <layer class="SimpleLine" enabled="1" id="{ac0c3585-427f-5d25-b4f0-d4c7e5692f90}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.94" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{0423b377-0a27-58a5-b000-d3dd28867ed8}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="217,211,203,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.62" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="line">
        <layer class="SimpleLine" enabled="1" id="{43b6e2b8-24fa-58f6-ab43-ea11aed0ea8a}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.9" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{20efbde3-d002-555e-b92c-7b632e4ad586}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="217,211,203,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.58" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="line">
        <layer class="SimpleLine" enabled="1" id="{dbaf62f7-faed-510c-aa9e-3d9b840b661a}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.62" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{5ebbcc2a-7cea-5cb6-bded-7af94882ce59}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="227,151,98,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="1.3" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="line">
        <layer class="SimpleLine" enabled="1" id="{df766059-90c6-5faa-9a36-4f8a97120b86}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.87" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{108da12c-0f7c-5b80-9b28-82e4cb96b5d9}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="217,211,203,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="line">
        <layer class="SimpleLine" enabled="1" id="{7deab14e-acd5-5090-8451-ee4ecda7b2ff}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.8" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{a8a3c5fc-e847-5e00-9913-a7e1d9c251e0}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="201,195,198,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.48" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="line">
        <layer class="SimpleLine" enabled="1" id="{869004f2-4e6e-533f-a11c-288c8703ca29}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.74" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{904fc945-f7f3-5732-9496-a70314a907b3}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="154,128,104,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.42" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="line">
        <layer class="SimpleLine" enabled="1" id="{c4d870f4-1035-52c7-a847-5d4f74f1b209}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.68" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{3c951bf0-132e-5432-a255-7db589263ec1}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="154,128,104,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.36" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="line">
        <layer class="SimpleLine" enabled="1" id="{3534865f-2463-5c81-a11b-298f64d68deb}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.68" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{977d6eee-9dbd-54a6-b9c5-404c010bf3e5}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="154,128,104,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.36" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="line">
        <layer class="SimpleLine" enabled="1" id="{1407a40a-b94e-5996-a23a-a52bff502488}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.66" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{5ddb44c1-31c4-5fdd-bfdf-91153b6d7b1a}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="154,128,104,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.34" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="line">
        <layer class="SimpleLine" enabled="1" id="{4d2f09b6-f150-5792-be6b-7e802021f139}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.74" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{791338a3-48f8-5fd0-98d8-5584fcabb981}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="154,128,104,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.42" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="line">
        <layer class="SimpleLine" enabled="1" id="{ab5f0d7a-aebc-5123-aceb-95270fa3b571}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.74" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{ac62645e-d409-5f69-ad27-0c83c3188467}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="79,153,112,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.42" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="line">
        <layer class="SimpleLine" enabled="1" id="{7dc9e0bf-0050-5947-85ca-8a4373b97b09}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.68" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{cd4d6360-8f0b-518e-bbd3-a248fb3b5fcb}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,130,98,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.36" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="line">
        <layer class="SimpleLine" enabled="1" id="{02b152cb-ce30-510f-8254-9332f7705b10}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.72" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{cf48e4ba-1e98-5feb-8aeb-b7030525d1a9}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="154,160,166,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.4" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="line">
        <layer class="SimpleLine" enabled="1" id="{96596680-09cc-5ac1-a045-219ecb52b3af}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{2729fef2-f391-578e-a5d3-7beda7cbca05}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="110,107,115,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="18" type="line">
        <layer class="SimpleLine" enabled="1" id="{e3e3b0f7-30c4-5590-8d13-aa25f08c1d55}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{9d0217c1-ac05-5ff8-bc9e-68bf7c06c048}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="110,107,115,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="19" type="line">
        <layer class="SimpleLine" enabled="1" id="{7987c71e-5126-5885-b40d-a7792e7fb656}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{d19709eb-571f-5da4-95ca-64a62a485e8f}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="110,107,115,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="20" type="line">
        <layer class="SimpleLine" enabled="1" id="{08a2df12-54d7-5bf3-9b5b-e01271783f79}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{4aa668e1-86aa-5811-9f12-a409dcdbe73e}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="110,107,115,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="21" type="line">
        <layer class="SimpleLine" enabled="1" id="{b53e5ab4-7d0c-55d5-8433-c417eb87f039}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{260cf2fe-a737-5c58-afcd-7de0b26f1161}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="110,107,115,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="22" type="line">
        <layer class="SimpleLine" enabled="1" id="{c1ab3b24-129e-5cc3-8aee-3a9393fc944d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{4646b47f-6c97-5b12-be72-e3875f88dc78}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="110,107,115,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="23" type="line">
        <layer class="SimpleLine" enabled="1" id="{4c304969-1388-5ff1-bc86-584264cb6158}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{88957d60-b61c-5cc8-8b47-5fd486a658c6}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="110,107,115,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="24" type="line">
        <layer class="SimpleLine" enabled="1" id="{9c436bf5-dd70-54e3-b232-d7928d62f202}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{d8430e35-5925-52ea-a7b7-c86d7e9c4772}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="110,107,115,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="25" type="line">
        <layer class="SimpleLine" enabled="1" id="{ce5b7a27-91a7-5b9a-9b73-173adfc66bd4}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.97" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{1541081e-9cf1-5fcb-a769-0a76d7bbe2f2}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="120,183,216,255" />
          <prop k="line_style" v="dash" />
          <prop k="line_width" v="0.65" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="26" type="line">
        <layer class="SimpleLine" enabled="1" id="{8f277dc1-5d25-5719-8e0c-21ff1d0fc32f}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.72" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{79095e8d-29e4-5a89-8f8e-c6619b7ebac9}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="154,160,166,255" />
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
    <property key="overture/palette" value="light" />
    <property key="overture/description" value="transportation-segment-line light style bound to Overture schema 1.18.0" />
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
      <placement allowDegraded="0" centroidInside="1" dist="1" distUnits="MM" fitInPolygonOnly="0" layerType="LineGeometry" maxCurvedCharAngleIn="25" maxCurvedCharAngleOut="-25" offsetType="0" overlapHandling="PreventOverlap" placement="2" placementFlags="10" predefinedPositionOrder="TR,TL,BR,BL,R,L" priority="5" quadOffset="4" repeatDistance="40" repeatDistanceUnits="MM" />
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="1" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="250000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>1</layerGeometryType>
</qgis>
