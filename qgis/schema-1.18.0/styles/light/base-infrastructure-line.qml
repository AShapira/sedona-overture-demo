<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{1f62ae06-b33d-5eb2-a02f-92f12a2aa0af}">
      <rule key="{ef5efacb-4b7e-59ba-9846-0346b58030f4}" label="Aerialway" symbol="0" filter="attribute(@feature, 'subtype') = 'aerialway'" scalemaxdenom="50000" />
      <rule key="{9b4ebff9-7ab3-569f-901f-c289f6b649ed}" label="Airport" symbol="1" filter="attribute(@feature, 'subtype') = 'airport'" scalemaxdenom="10000000" />
      <rule key="{61f07e0e-1135-54a8-8f7d-588736f4c8a1}" label="Barrier" symbol="2" filter="attribute(@feature, 'subtype') = 'barrier'" scalemaxdenom="50000" />
      <rule key="{b5841053-4447-501d-9b21-c4ce7f95afdc}" label="Bridge" symbol="3" filter="attribute(@feature, 'subtype') = 'bridge'" scalemaxdenom="250000" />
      <rule key="{516fd72e-bd1b-5dcd-9733-8dcdeb6d3ec7}" label="Communication" symbol="4" filter="attribute(@feature, 'subtype') = 'communication'" scalemaxdenom="250000" />
      <rule key="{9c49f3cf-4e75-550a-98cc-be1a88cf1f21}" label="Emergency" symbol="5" filter="attribute(@feature, 'subtype') = 'emergency'" scalemaxdenom="50000" />
      <rule key="{0646c1d4-3b2b-5b5c-84be-7ff62a14bf41}" label="Manhole" symbol="6" filter="attribute(@feature, 'subtype') = 'manhole'" scalemaxdenom="50000" />
      <rule key="{b7e4e113-a957-5ac6-81a2-a4410feda0ea}" label="Pedestrian" symbol="7" filter="attribute(@feature, 'subtype') = 'pedestrian'" scalemaxdenom="50000" />
      <rule key="{cdeb3888-12b2-581e-8f8a-4f8c081e417c}" label="Pier" symbol="8" filter="attribute(@feature, 'subtype') = 'pier'" scalemaxdenom="50000" />
      <rule key="{cdd9d0e8-3052-5b8d-942a-0ab75a844833}" label="Power" symbol="9" filter="attribute(@feature, 'subtype') = 'power'" scalemaxdenom="250000" />
      <rule key="{004174dd-ab58-52c3-9eee-5164e3b5267d}" label="Quay" symbol="10" filter="attribute(@feature, 'subtype') = 'quay'" scalemaxdenom="50000" />
      <rule key="{94f4e145-29d1-5b05-8f14-59ac8b180d8f}" label="Recreation" symbol="11" filter="attribute(@feature, 'subtype') = 'recreation'" scalemaxdenom="50000" />
      <rule key="{60a67205-f0d9-5af0-aae2-39500aa740f1}" label="Tower" symbol="12" filter="attribute(@feature, 'subtype') = 'tower'" scalemaxdenom="50000" />
      <rule key="{945a85e2-db7c-564a-a774-ea2b489ab35a}" label="Transit" symbol="13" filter="attribute(@feature, 'subtype') = 'transit'" scalemaxdenom="250000" />
      <rule key="{cf9b6c07-ab3c-53e8-97be-646983c1c207}" label="Transportation" symbol="14" filter="attribute(@feature, 'subtype') = 'transportation'" scalemaxdenom="50000" />
      <rule key="{6e168ce3-c9a1-5eef-beb5-660185fa2b53}" label="Utility" symbol="15" filter="attribute(@feature, 'subtype') = 'utility'" scalemaxdenom="50000" />
      <rule key="{85910867-0eed-5742-a22c-4b15ecda7fff}" label="Waste Management" symbol="16" filter="attribute(@feature, 'subtype') = 'waste_management'" scalemaxdenom="50000" />
      <rule key="{bef51085-9825-583a-b8b2-01ad4550c0f2}" label="Water" symbol="17" filter="attribute(@feature, 'subtype') = 'water'" scalemaxdenom="50000" />
      <rule key="{003656e8-f759-52b4-bd63-ba9ae4b4e386}" label="Other or missing value" symbol="18" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="line">
        <layer class="SimpleLine" enabled="1" id="{a64ef342-1297-54b2-bee6-224ed627dade}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{608ffded-81b8-502f-8fd0-5fa1d8b8d9c2}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="227,151,98,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="line">
        <layer class="SimpleLine" enabled="1" id="{f7a43d97-4061-5984-b553-efbe13f02115}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{dc96eb85-f9c7-56bc-bf42-92c75e98039d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="72,121,168,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="line">
        <layer class="SimpleLine" enabled="1" id="{ae1c85ac-46dc-577c-a559-9a9079fc6598}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{88b60875-8599-5172-b315-e145e8ca6a50}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="line">
        <layer class="SimpleLine" enabled="1" id="{525a970e-7fcd-5e68-923b-e72c6710e4bc}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{e46c3202-af89-5c05-a638-c49b4bd625b0}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,130,98,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="line">
        <layer class="SimpleLine" enabled="1" id="{3b3c5349-95bd-55b7-a87c-79f60c739408}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{39116d33-0d62-50d0-a3ae-189b0474cd2a}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="85,125,168,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="line">
        <layer class="SimpleLine" enabled="1" id="{a683863b-6f40-5b5a-aece-40a8dc44b973}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{b5c52006-6fe0-5e74-97ac-a5925eb1ba13}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="216,77,91,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="line">
        <layer class="SimpleLine" enabled="1" id="{1bd687b8-aa8f-5e62-88a3-cb5db73cb636}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{676d5525-e6c2-5a6a-9a05-da6964950bbc}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="154,160,166,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="line">
        <layer class="SimpleLine" enabled="1" id="{d1d96de1-70d2-5436-9212-cbee471214f2}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{0e12d087-2f52-58c1-921e-483329d612dd}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="154,128,104,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="line">
        <layer class="SimpleLine" enabled="1" id="{b4c7248d-3a87-5c11-8c6c-8bdb22ebe922}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{7a01f3ba-80fb-5923-a37e-13131b8036e5}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,130,98,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="line">
        <layer class="SimpleLine" enabled="1" id="{5c7ca154-57aa-58bc-9cc1-8098f7ad7912}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{9a6c7b71-cb9d-5e5f-9f39-bdf60ee1782d}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="215,88,79,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="line">
        <layer class="SimpleLine" enabled="1" id="{129a39a4-db7e-5544-8302-75b6e6d4647f}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{a8cb9fac-c9d2-500b-bbff-3dbf37d0bd73}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="169,130,98,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="line">
        <layer class="SimpleLine" enabled="1" id="{d287e5fa-47c5-5ce3-b072-23be6d5bf77a}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{9828437a-0548-5778-9cec-2891116069d4}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="79,153,112,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="line">
        <layer class="SimpleLine" enabled="1" id="{5c8b0abd-7692-5d15-8fba-df4e904b89e2}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{9f7fd1f3-d8c2-503e-a5a4-cfd3341c8fcc}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="85,125,168,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="line">
        <layer class="SimpleLine" enabled="1" id="{343688b7-862d-5cdb-b385-01bdc26fe2c7}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{016e7bac-6a3a-51e6-9418-280637bfe6d6}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="72,121,168,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="line">
        <layer class="SimpleLine" enabled="1" id="{e4cff417-c2c6-5275-9c7a-a7a89f33367e}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{5d936239-10b9-5558-a7e1-8480eb5872c0}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="227,151,98,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="line">
        <layer class="SimpleLine" enabled="1" id="{d2b33bda-5c40-5187-a537-0e8c5eb5c311}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{4902a0ad-8ae0-5378-97f7-3b7d856202cd}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="85,125,168,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="line">
        <layer class="SimpleLine" enabled="1" id="{14ee1dd3-7b87-5221-9233-6bef5bb3af1f}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{d132094f-6a4d-55f1-8c39-c857848ec8dd}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="199,189,207,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="line">
        <layer class="SimpleLine" enabled="1" id="{55804725-6b89-5167-8558-8650660e974c}" locked="0" pass="0">
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
        <layer class="SimpleLine" enabled="1" id="{8bf61fd0-59d8-5e26-83fb-52e490d91f5f}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="120,183,216,255" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.55" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="18" type="line">
        <layer class="SimpleLine" enabled="1" id="{78475d7a-2b18-5c56-9adb-f083a0a243a4}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="102,112,120,190" />
          <prop k="line_style" v="solid" />
          <prop k="line_width" v="0.77" />
          <prop k="line_width_unit" v="MM" />
          <prop k="offset" v="0" />
          <prop k="offset_unit" v="MM" />
          <prop k="use_custom_dash" v="0" />
        </layer>
        <layer class="SimpleLine" enabled="1" id="{1e5a47ce-0636-5c48-84b3-3756e511dee9}" locked="0" pass="0">
          <prop k="capstyle" v="round" />
          <prop k="customdash" v="3;2" />
          <prop k="customdash_unit" v="MM" />
          <prop k="joinstyle" v="round" />
          <prop k="line_color" v="154,160,166,190" />
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
    <property key="overture/palette" value="light" />
    <property key="overture/description" value="base-infrastructure-line light style bound to Overture schema 1.18.0" />
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
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="1" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="50000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>1</layerGeometryType>
</qgis>
