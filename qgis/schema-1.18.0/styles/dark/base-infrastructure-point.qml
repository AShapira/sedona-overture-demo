<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{8cbe626d-a5bd-5fdb-9eaf-7f1258150fe0}">
      <rule key="{6f7a6fd6-79fb-5429-b5da-47bd51e4425c}" label="Airport" symbol="0" filter="attribute(@feature, 'class') = 'airport'" scalemaxdenom="10000000" />
      <rule key="{eeb811d3-59ee-5eef-9d44-16de9fb04639}" label="Bus Station" symbol="1" filter="attribute(@feature, 'class') = 'bus_station'" scalemaxdenom="250000" />
      <rule key="{818823a6-b144-5c28-8eb9-809e41741fc7}" label="Bus Stop" symbol="2" filter="attribute(@feature, 'class') = 'bus_stop'" scalemaxdenom="250000" />
      <rule key="{ab124804-a3d3-5396-ab76-b4ab21159bc7}" label="Charging Station" symbol="3" filter="attribute(@feature, 'class') = 'charging_station'" scalemaxdenom="250000" />
      <rule key="{ad723c14-3b83-513d-af76-6df8f58b8dcf}" label="Communication Tower" symbol="4" filter="attribute(@feature, 'class') = 'communication_tower'" scalemaxdenom="250000" />
      <rule key="{dcb5f30f-7e5b-5768-a0c2-c08b3d16b848}" label="Ferry Terminal" symbol="5" filter="attribute(@feature, 'class') = 'ferry_terminal'" scalemaxdenom="250000" />
      <rule key="{91f1ad48-5f0d-5525-8144-5d1c08ca46d2}" label="Fire Hydrant" symbol="6" filter="attribute(@feature, 'class') = 'fire_hydrant'" scalemaxdenom="250000" />
      <rule key="{ce0c76a1-514b-5493-ba96-4adebccf60d5}" label="International Airport" symbol="7" filter="attribute(@feature, 'class') = 'international_airport'" scalemaxdenom="10000000" />
      <rule key="{e14d1f06-7a03-599f-b760-0bc77b01ec57}" label="Parking" symbol="8" filter="attribute(@feature, 'class') = 'parking'" scalemaxdenom="250000" />
      <rule key="{60fd8d8e-c72e-584d-99cf-a221103ea3df}" label="Power Tower" symbol="9" filter="attribute(@feature, 'class') = 'power_tower'" scalemaxdenom="250000" />
      <rule key="{b9a02d47-6783-5c85-8dec-d01eed4bda65}" label="Railway Station" symbol="10" filter="attribute(@feature, 'class') = 'railway_station'" scalemaxdenom="250000" />
      <rule key="{0e5fa4de-664a-5a5b-bbc2-a650fe0b8729}" label="Recycling" symbol="11" filter="attribute(@feature, 'class') = 'recycling'" scalemaxdenom="250000" />
      <rule key="{03082126-b525-5900-9c7e-1de749e81658}" label="Regional Airport" symbol="12" filter="attribute(@feature, 'class') = 'regional_airport'" scalemaxdenom="10000000" />
      <rule key="{1f10f0ec-3771-510b-9b0c-b4073d9935d3}" label="Runway" symbol="13" filter="attribute(@feature, 'class') = 'runway'" scalemaxdenom="250000" />
      <rule key="{80326417-2b97-579e-8a2b-3e60c3ecdce3}" label="Subway Station" symbol="14" filter="attribute(@feature, 'class') = 'subway_station'" scalemaxdenom="250000" />
      <rule key="{9a7659f3-96d2-53b8-af1f-872ca51fc889}" label="Toilets" symbol="15" filter="attribute(@feature, 'class') = 'toilets'" scalemaxdenom="250000" />
      <rule key="{b753e5e1-f63c-5c6c-a870-2f57c7d559a7}" label="Water Tower" symbol="16" filter="attribute(@feature, 'class') = 'water_tower'" scalemaxdenom="250000" />
      <rule key="{263e9d8b-5987-5aa5-bb2f-a6e17082f73a}" label="Aerialway" symbol="17" filter="attribute(@feature, 'subtype') = 'aerialway' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{0a767c1b-dd2a-573b-9e15-268872cf4b8d}" label="Airport" symbol="18" filter="attribute(@feature, 'subtype') = 'airport' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="10000000" />
      <rule key="{317aef83-2fc2-5182-86af-bf20cc42ac54}" label="Barrier" symbol="19" filter="attribute(@feature, 'subtype') = 'barrier' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{6e9f088e-fef4-5b49-b37b-b51b7dc74d37}" label="Bridge" symbol="20" filter="attribute(@feature, 'subtype') = 'bridge' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="250000" />
      <rule key="{49c1916c-6ddb-5bac-abdb-de9c0362c684}" label="Communication" symbol="21" filter="attribute(@feature, 'subtype') = 'communication' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="250000" />
      <rule key="{d5e6ff58-0c2b-5744-87af-af9ddf5d0d8e}" label="Emergency" symbol="22" filter="attribute(@feature, 'subtype') = 'emergency' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{26171535-1b25-53dd-8108-6c59890a8e19}" label="Manhole" symbol="23" filter="attribute(@feature, 'subtype') = 'manhole' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{93a86700-a0b0-5bef-a27c-929fe5ebcc8a}" label="Pedestrian" symbol="24" filter="attribute(@feature, 'subtype') = 'pedestrian' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{04986348-c06d-5700-95ac-89302287521c}" label="Pier" symbol="25" filter="attribute(@feature, 'subtype') = 'pier' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{43787526-7f21-55d8-b4d9-6e228c00aa0e}" label="Power" symbol="26" filter="attribute(@feature, 'subtype') = 'power' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="250000" />
      <rule key="{d0992a0b-d181-5240-8867-5908263dbf2f}" label="Quay" symbol="27" filter="attribute(@feature, 'subtype') = 'quay' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{a93c844f-26b5-5f98-8fa0-781d2613a77b}" label="Recreation" symbol="28" filter="attribute(@feature, 'subtype') = 'recreation' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{5caa890c-8c77-5712-a1f4-8e6074a0ca5b}" label="Tower" symbol="29" filter="attribute(@feature, 'subtype') = 'tower' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{ceea3448-1d51-5247-985f-623c6b463846}" label="Transit" symbol="30" filter="attribute(@feature, 'subtype') = 'transit' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="250000" />
      <rule key="{a64975dc-440d-5867-a12f-2e4c70bc8904}" label="Transportation" symbol="31" filter="attribute(@feature, 'subtype') = 'transportation' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{1d1c9841-66d3-5a03-a7ff-6e2d53e2b89c}" label="Utility" symbol="32" filter="attribute(@feature, 'subtype') = 'utility' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{90f31001-5471-509f-9cbe-fb44c41b95d7}" label="Waste Management" symbol="33" filter="attribute(@feature, 'subtype') = 'waste_management' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{bb9a68ac-fe4f-5a7d-938c-296d76f02f07}" label="Water" symbol="34" filter="attribute(@feature, 'subtype') = 'water' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{0a3ced1c-18fe-52e5-bb39-84a0148c7d8a}" label="Other infrastructure" symbol="35" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="marker">
        <layer class="SvgMarker" enabled="1" id="{609d2821-2bab-514a-bcbb-9140319a47b3}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDEzbDctM1YzYzAtMSAxLTIgMi0yczIgMSAyIDJ2N2w3IDN2M2wtNy0xdjVsMyAydjJsLTUtMS01IDF2LTJsMy0ydi01bC03IDF6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYWlycG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="marker">
        <layer class="SvgMarker" enabled="1" id="{24b0da00-94e2-5727-88a3-97dd8a241ef0}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="marker">
        <layer class="SvgMarker" enabled="1" id="{1a0c5944-7c3d-566f-bd11-b6c74bf8e546}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="marker">
        <layer class="SvgMarker" enabled="1" id="{9222af79-4cfc-57c6-8665-667f4d016ad8}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik01IDNoMTB2MThINXpNNyA2aDZ2NUg3ek0xNSA3bDMgM3Y3YTIgMiAwIDAwNCAwdi02bC0zLTMiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiBmdWVsPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="marker">
        <layer class="SvgMarker" enabled="1" id="{e05b208b-555a-5b8f-bca6-61e45ddbf2e8}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMCAzaDRsMiAxOEg4ek03IDhoMTBNNiAxNGgxMk0zIDIxaDE4IiBmaWxsPSJub25lIi8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogdG93ZXI8L21ldGFkYXRhPgo8L3N2Zz4K" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="marker">
        <layer class="SvgMarker" enabled="1" id="{7721dd40-de98-5772-89e7-71702b98e007}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="marker">
        <layer class="SvgMarker" enabled="1" id="{0c8e5214-5497-538e-99c8-167d60981cff}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDlsOS02IDkgNnpNNSAxMGgxNHYySDV6TTYgMTJ2N00xMCAxMnY3TTE0IDEydjdNMTggMTJ2N000IDIwaDE2Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogZ292ZXJubWVudDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="marker">
        <layer class="SvgMarker" enabled="1" id="{77de8692-eb65-5e3d-808b-55a5562ccab9}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDEzbDctM1YzYzAtMSAxLTIgMi0yczIgMSAyIDJ2N2w3IDN2M2wtNy0xdjVsMyAydjJsLTUtMS01IDF2LTJsMy0ydi01bC03IDF6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYWlycG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="marker">
        <layer class="SvgMarker" enabled="1" id="{3a8aa72e-4c4a-588b-b312-c91031074618}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik01IDNoOGE2IDYgMCAwMTAgMTJIOXY2SDV6TTkgN3Y0aDRhMiAyIDAgMDAwLTR6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogcGFya2luZzwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="marker">
        <layer class="SvgMarker" enabled="1" id="{0b9e2573-e728-5036-b6e7-bf76cb4c9747}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMyAyTDUgMTRoNmwtMSA4IDktMTNoLTZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogcG93ZXI8L21ldGFkYXRhPgo8L3N2Zz4K" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="marker">
        <layer class="SvgMarker" enabled="1" id="{c9e46c2d-1963-56c4-ae25-8748ca9c824e}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="marker">
        <layer class="SvgMarker" enabled="1" id="{9cb4f901-bb22-50db-a399-9069774f310e}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="marker">
        <layer class="SvgMarker" enabled="1" id="{66837d55-f209-52bd-bdf9-4b9e8f62ed14}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDEzbDctM1YzYzAtMSAxLTIgMi0yczIgMSAyIDJ2N2w3IDN2M2wtNy0xdjVsMyAydjJsLTUtMS01IDF2LTJsMy0ydi01bC03IDF6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYWlycG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="marker">
        <layer class="SvgMarker" enabled="1" id="{b42d7d84-beee-5dcc-9bdc-4fff5aaa7e6c}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDEzbDctM1YzYzAtMSAxLTIgMi0yczIgMSAyIDJ2N2w3IDN2M2wtNy0xdjVsMyAydjJsLTUtMS01IDF2LTJsMy0ydi01bC03IDF6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYWlycG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="marker">
        <layer class="SvgMarker" enabled="1" id="{82eb05a8-4f27-52e2-89a1-f4e876e40760}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="marker">
        <layer class="SvgMarker" enabled="1" id="{4bef4420-75fc-5605-95e6-d128e5bb7143}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="marker">
        <layer class="SvgMarker" enabled="1" id="{a30fa693-28b3-5329-8bf4-d2ea1c25149e}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMCAzaDRsMiAxOEg4ek03IDhoMTBNNiAxNGgxMk0zIDIxaDE4IiBmaWxsPSJub25lIi8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogdG93ZXI8L21ldGFkYXRhPgo8L3N2Zz4K" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="marker">
        <layer class="SvgMarker" enabled="1" id="{d48843aa-f215-5e42-ada9-971336b6b609}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="209,132,88,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="18" type="marker">
        <layer class="SvgMarker" enabled="1" id="{b75674ea-995f-557a-b103-763af2501423}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="19" type="marker">
        <layer class="SvgMarker" enabled="1" id="{7bc0b1f2-b4b2-5bc7-9c09-8c623a4d82b9}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="137,148,158,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="20" type="marker">
        <layer class="SvgMarker" enabled="1" id="{5b640d57-7929-528c-8ab2-dfdfe23ae872}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="118,91,72,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="21" type="marker">
        <layer class="SvgMarker" enabled="1" id="{e95b7c5d-c920-5762-9fb8-8550e14a2b24}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="22" type="marker">
        <layer class="SvgMarker" enabled="1" id="{a3ea844a-5e5a-5d62-bf7b-240287add76f}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="241,110,121,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="23" type="marker">
        <layer class="SvgMarker" enabled="1" id="{9787567a-8ce1-5fb8-b499-2205ac8f6f96}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="125,135,144,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="24" type="marker">
        <layer class="SvgMarker" enabled="1" id="{5edfb749-0606-5ee0-bb16-0be30b4ba29f}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="173,146,120,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="25" type="marker">
        <layer class="SvgMarker" enabled="1" id="{4fc37c2c-dcd7-5035-b16b-a7a5526c1674}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="118,91,72,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="26" type="marker">
        <layer class="SvgMarker" enabled="1" id="{6572fc35-9bb3-5fa5-b5b5-36e31a1f322c}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="240,107,99,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="27" type="marker">
        <layer class="SvgMarker" enabled="1" id="{39307156-0535-54af-a090-819f21c55dd3}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="118,91,72,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="28" type="marker">
        <layer class="SvgMarker" enabled="1" id="{e54f5bb5-65ed-58bc-bc54-fac2038b0132}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="111,195,144,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="29" type="marker">
        <layer class="SvgMarker" enabled="1" id="{dd23b6ca-c9c6-5536-8cec-8ee662a439e7}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="30" type="marker">
        <layer class="SvgMarker" enabled="1" id="{ba1f07ce-59af-56e0-a2eb-a11cb27e9f31}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="31" type="marker">
        <layer class="SvgMarker" enabled="1" id="{5bc62d1d-75c8-5457-86ac-693c99baeb68}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="209,132,88,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="32" type="marker">
        <layer class="SvgMarker" enabled="1" id="{7244332a-995b-5bef-8637-b2e465605adb}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="33" type="marker">
        <layer class="SvgMarker" enabled="1" id="{34e2fbda-9439-5f07-a981-806fa3948270}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="98,85,110,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="34" type="marker">
        <layer class="SvgMarker" enabled="1" id="{5506c46b-2cf6-52d3-b3b5-2d011a999042}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="53,111,145,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="35" type="marker">
        <layer class="SvgMarker" enabled="1" id="{94d2e1ea-5498-5f94-8de0-8a5d95e5f1a3}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="125,135,144,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <customproperties>
    <property key="overture/schema_version" value="1.18.0" />
    <property key="overture/style_id" value="base-infrastructure-point" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-infrastructure-point dark style bound to Overture schema 1.18.0" />
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
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="0" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="100000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>0</layerGeometryType>
</qgis>
