<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{85430094-d0d5-5e6b-b6f8-cee66151d5bb}">
      <rule key="{95ebd893-116a-57c4-9905-4b5c050d0f46}" label="Airport" symbol="0" filter="attribute(@feature, 'class') = 'airport'" scalemaxdenom="10000000" />
      <rule key="{38537625-2356-5e95-b878-94cd8531f1e3}" label="Bus Station" symbol="1" filter="attribute(@feature, 'class') = 'bus_station'" scalemaxdenom="250000" />
      <rule key="{f740e851-b915-5a17-8c2c-7658938ab835}" label="Bus Stop" symbol="2" filter="attribute(@feature, 'class') = 'bus_stop'" scalemaxdenom="250000" />
      <rule key="{d17db914-c099-5d50-b88a-65779c64e1f1}" label="Charging Station" symbol="3" filter="attribute(@feature, 'class') = 'charging_station'" scalemaxdenom="250000" />
      <rule key="{a6d0287d-dd27-54af-b8b3-277bb772e5a8}" label="Communication Tower" symbol="4" filter="attribute(@feature, 'class') = 'communication_tower'" scalemaxdenom="250000" />
      <rule key="{cca3447a-56fd-56cf-b360-8222fa86c0fa}" label="Ferry Terminal" symbol="5" filter="attribute(@feature, 'class') = 'ferry_terminal'" scalemaxdenom="250000" />
      <rule key="{4b90f326-e2fd-5434-a0b4-4c386a3b5cfc}" label="Fire Hydrant" symbol="6" filter="attribute(@feature, 'class') = 'fire_hydrant'" scalemaxdenom="250000" />
      <rule key="{fcee7eca-6590-5922-aa7a-3b65d96d100b}" label="International Airport" symbol="7" filter="attribute(@feature, 'class') = 'international_airport'" scalemaxdenom="10000000" />
      <rule key="{7135b96a-504f-53c6-b37e-036fdb67f137}" label="Parking" symbol="8" filter="attribute(@feature, 'class') = 'parking'" scalemaxdenom="250000" />
      <rule key="{91737172-8242-5922-b101-10860ab7eb52}" label="Power Tower" symbol="9" filter="attribute(@feature, 'class') = 'power_tower'" scalemaxdenom="250000" />
      <rule key="{a6970f12-ca22-5a4e-a1e4-36bbb381c34e}" label="Railway Station" symbol="10" filter="attribute(@feature, 'class') = 'railway_station'" scalemaxdenom="250000" />
      <rule key="{2d4563e9-765b-55de-b285-766defd4e31b}" label="Recycling" symbol="11" filter="attribute(@feature, 'class') = 'recycling'" scalemaxdenom="250000" />
      <rule key="{118adbd5-055f-57c5-9e9b-144191b97ced}" label="Regional Airport" symbol="12" filter="attribute(@feature, 'class') = 'regional_airport'" scalemaxdenom="10000000" />
      <rule key="{bbfe9665-d546-544b-9c74-a3045b4d8168}" label="Runway" symbol="13" filter="attribute(@feature, 'class') = 'runway'" scalemaxdenom="250000" />
      <rule key="{0e6e1f83-a40c-5789-a7ea-132ee60db606}" label="Subway Station" symbol="14" filter="attribute(@feature, 'class') = 'subway_station'" scalemaxdenom="250000" />
      <rule key="{d8807c07-e6ae-5a73-9195-2f365b1d57fc}" label="Toilets" symbol="15" filter="attribute(@feature, 'class') = 'toilets'" scalemaxdenom="250000" />
      <rule key="{19244b48-1a97-51b6-8152-3e08455b13b7}" label="Water Tower" symbol="16" filter="attribute(@feature, 'class') = 'water_tower'" scalemaxdenom="250000" />
      <rule key="{aee72ddf-7a8d-522e-9561-de85a176ec82}" label="Aerialway" symbol="17" filter="attribute(@feature, 'subtype') = 'aerialway' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{7e7ae66a-923d-57a8-a719-cfde6ce37c3a}" label="Airport" symbol="18" filter="attribute(@feature, 'subtype') = 'airport' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="10000000" />
      <rule key="{4ebcf4ff-81d0-55b7-87d3-18d1df63e217}" label="Barrier" symbol="19" filter="attribute(@feature, 'subtype') = 'barrier' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{59dc1981-7487-53ba-89a7-ad31176593d8}" label="Bridge" symbol="20" filter="attribute(@feature, 'subtype') = 'bridge' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="250000" />
      <rule key="{399e583b-dfe4-57d0-9f00-c35a80559867}" label="Communication" symbol="21" filter="attribute(@feature, 'subtype') = 'communication' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="250000" />
      <rule key="{2bdb467a-c54d-5bb4-a8ef-3c616f79eee9}" label="Emergency" symbol="22" filter="attribute(@feature, 'subtype') = 'emergency' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{61a68638-7333-57b5-94de-68491a947d7b}" label="Manhole" symbol="23" filter="attribute(@feature, 'subtype') = 'manhole' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{7a4111ad-1bcd-50d3-b294-ca03a6cfbd1e}" label="Pedestrian" symbol="24" filter="attribute(@feature, 'subtype') = 'pedestrian' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{ce02083a-1267-519f-b8ab-0f4fec6d7ad4}" label="Pier" symbol="25" filter="attribute(@feature, 'subtype') = 'pier' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{a96b112e-d0f3-5cff-8048-5fab6ceb74e3}" label="Power" symbol="26" filter="attribute(@feature, 'subtype') = 'power' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="250000" />
      <rule key="{bcfacd83-f03a-5771-9025-e5f901599081}" label="Quay" symbol="27" filter="attribute(@feature, 'subtype') = 'quay' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{246b86e1-daba-59d7-9086-255a17581554}" label="Recreation" symbol="28" filter="attribute(@feature, 'subtype') = 'recreation' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{30fc8d7e-e4ae-5fd5-99c6-11c84e365803}" label="Tower" symbol="29" filter="attribute(@feature, 'subtype') = 'tower' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{121c8e66-d16b-51c0-813b-50ad0e6923fa}" label="Transit" symbol="30" filter="attribute(@feature, 'subtype') = 'transit' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="250000" />
      <rule key="{f8511f54-e522-5272-9a58-fdc88677fc77}" label="Transportation" symbol="31" filter="attribute(@feature, 'subtype') = 'transportation' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{b169ee1c-3db9-5b86-8ba3-59379cf81174}" label="Utility" symbol="32" filter="attribute(@feature, 'subtype') = 'utility' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{ad060dd3-e2ce-5a40-b58f-43c88e6fc864}" label="Waste Management" symbol="33" filter="attribute(@feature, 'subtype') = 'waste_management' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{5a71dfc8-0850-57c8-8590-0212e06f5f6b}" label="Water" symbol="34" filter="attribute(@feature, 'subtype') = 'water' AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ('airport','bus_station','bus_stop','charging_station','communication_tower','ferry_terminal','fire_hydrant','international_airport','parking','power_tower','railway_station','recycling','regional_airport','runway','subway_station','toilets','water_tower'))" scalemaxdenom="50000" />
      <rule key="{3b824350-369a-5599-a63c-2709f1327261}" label="Other infrastructure" symbol="35" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="marker">
        <layer class="SvgMarker" enabled="1" id="{b976320f-4633-55dc-bdfb-af92b35ce926}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDEzbDctM1YzYzAtMSAxLTIgMi0yczIgMSAyIDJ2N2w3IDN2M2wtNy0xdjVsMyAydjJsLTUtMS01IDF2LTJsMy0ydi01bC03IDF6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYWlycG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="marker">
        <layer class="SvgMarker" enabled="1" id="{24c9817a-5cbc-5cb9-8c8f-7f8cae5bbe63}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="marker">
        <layer class="SvgMarker" enabled="1" id="{e1162da9-3377-561b-a294-f162452a671c}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="marker">
        <layer class="SvgMarker" enabled="1" id="{4aec3406-3019-50ae-ae98-1b6e2389738c}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik01IDNoMTB2MThINXpNNyA2aDZ2NUg3ek0xNSA3bDMgM3Y3YTIgMiAwIDAwNCAwdi02bC0zLTMiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiBmdWVsPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="marker">
        <layer class="SvgMarker" enabled="1" id="{d1c1cd50-6fa5-55ce-9500-169e7be4311d}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMCAzaDRsMiAxOEg4ek03IDhoMTBNNiAxNGgxMk0zIDIxaDE4IiBmaWxsPSJub25lIi8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogdG93ZXI8L21ldGFkYXRhPgo8L3N2Zz4K" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="marker">
        <layer class="SvgMarker" enabled="1" id="{38851c23-33c6-5db9-9f7f-7550821c2762}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="marker">
        <layer class="SvgMarker" enabled="1" id="{23b1085b-074d-51ee-9bb0-57d348c58a53}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDlsOS02IDkgNnpNNSAxMGgxNHYySDV6TTYgMTJ2N00xMCAxMnY3TTE0IDEydjdNMTggMTJ2N000IDIwaDE2Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogZ292ZXJubWVudDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="marker">
        <layer class="SvgMarker" enabled="1" id="{9165c707-a1aa-5ad0-9fc0-7ec2ac8d7b05}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDEzbDctM1YzYzAtMSAxLTIgMi0yczIgMSAyIDJ2N2w3IDN2M2wtNy0xdjVsMyAydjJsLTUtMS01IDF2LTJsMy0ydi01bC03IDF6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYWlycG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="marker">
        <layer class="SvgMarker" enabled="1" id="{11d207f5-6369-5377-bae3-d8f4f13806f6}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik01IDNoOGE2IDYgMCAwMTAgMTJIOXY2SDV6TTkgN3Y0aDRhMiAyIDAgMDAwLTR6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogcGFya2luZzwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="marker">
        <layer class="SvgMarker" enabled="1" id="{a6ab923f-8d01-516b-be9a-96ee3cf0d542}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMyAyTDUgMTRoNmwtMSA4IDktMTNoLTZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogcG93ZXI8L21ldGFkYXRhPgo8L3N2Zz4K" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="marker">
        <layer class="SvgMarker" enabled="1" id="{c5cfcc67-49a9-5d93-ae5e-6f93cf0bdcb5}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="marker">
        <layer class="SvgMarker" enabled="1" id="{bf8e22f0-8768-51c1-be05-edf42902308c}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="marker">
        <layer class="SvgMarker" enabled="1" id="{92c83e67-8a1d-5f0a-b9c4-7e41acd59671}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDEzbDctM1YzYzAtMSAxLTIgMi0yczIgMSAyIDJ2N2w3IDN2M2wtNy0xdjVsMyAydjJsLTUtMS01IDF2LTJsMy0ydi01bC03IDF6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYWlycG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="marker">
        <layer class="SvgMarker" enabled="1" id="{2e462894-f050-518c-8454-e9c06853fd09}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDEzbDctM1YzYzAtMSAxLTIgMi0yczIgMSAyIDJ2N2w3IDN2M2wtNy0xdjVsMyAydjJsLTUtMS01IDF2LTJsMy0ydi01bC03IDF6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYWlycG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="marker">
        <layer class="SvgMarker" enabled="1" id="{dc893a09-56f1-58d5-830c-94ef3181f393}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="marker">
        <layer class="SvgMarker" enabled="1" id="{a926106b-d959-598e-b378-8d87e1439ebc}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="marker">
        <layer class="SvgMarker" enabled="1" id="{9a9b3bdd-78c1-5f68-984b-ab3658e111e3}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMCAzaDRsMiAxOEg4ek03IDhoMTBNNiAxNGgxMk0zIDIxaDE4IiBmaWxsPSJub25lIi8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogdG93ZXI8L21ldGFkYXRhPgo8L3N2Zz4K" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="marker">
        <layer class="SvgMarker" enabled="1" id="{d96e8ce0-6019-5019-8c29-6a435a3d4806}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="227,151,98,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="18" type="marker">
        <layer class="SvgMarker" enabled="1" id="{2974340d-aa9d-5192-bb21-287a05e99995}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="19" type="marker">
        <layer class="SvgMarker" enabled="1" id="{a4580cad-9dfc-53e6-bf25-b04a0a72d73b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="102,112,120,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="20" type="marker">
        <layer class="SvgMarker" enabled="1" id="{d92069c7-11fd-51d7-8c54-8909e15c7585}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="169,130,98,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="21" type="marker">
        <layer class="SvgMarker" enabled="1" id="{66c429a2-bc00-5ea3-99bd-6187fe372e8f}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="22" type="marker">
        <layer class="SvgMarker" enabled="1" id="{980c85e2-59f9-5a58-95e0-bfcc52020376}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="216,77,91,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="23" type="marker">
        <layer class="SvgMarker" enabled="1" id="{d5c7c07b-0d62-51ba-bcbe-7b743d73f895}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="154,160,166,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="24" type="marker">
        <layer class="SvgMarker" enabled="1" id="{3ed185bf-4464-53bd-8584-c69028a0db1a}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="154,128,104,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="25" type="marker">
        <layer class="SvgMarker" enabled="1" id="{e6b44bd2-958d-5ada-a1df-e7db852e22a6}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="169,130,98,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="26" type="marker">
        <layer class="SvgMarker" enabled="1" id="{925c2b8b-e2f6-5e1c-be50-9758610e90f4}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="215,88,79,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="27" type="marker">
        <layer class="SvgMarker" enabled="1" id="{2805834b-2031-5569-926f-7558cd427987}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="169,130,98,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="28" type="marker">
        <layer class="SvgMarker" enabled="1" id="{49df94ca-b9cb-5c27-90c7-b6e95a3fa2ee}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="79,153,112,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="29" type="marker">
        <layer class="SvgMarker" enabled="1" id="{10213df8-9cd0-5246-832c-13c622bb2d41}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="30" type="marker">
        <layer class="SvgMarker" enabled="1" id="{fbed1e26-d91e-5f5e-afa5-ea0cef542d84}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="31" type="marker">
        <layer class="SvgMarker" enabled="1" id="{10ed8278-dd1b-51c9-bcf1-b14a31477c78}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="227,151,98,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNNyA3aDEwdjZIN3pNOCAxOWwtMiAzTTE2IDE5bDIgMyIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjgiIGN5PSIxNiIgcj0iMSIvPjxjaXJjbGUgY3g9IjE2IiBjeT0iMTYiIHI9IjEiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiB0cmFuc2l0PC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="32" type="marker">
        <layer class="SvgMarker" enabled="1" id="{9e75d6ef-d99e-5bf3-8e7d-29851b5cd5d2}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="33" type="marker">
        <layer class="SvgMarker" enabled="1" id="{9463fe96-671c-5dd3-84eb-d2d3bc41c76c}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="199,189,207,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="34" type="marker">
        <layer class="SvgMarker" enabled="1" id="{4b0add72-65cc-56bf-b4ef-d6a8b6234a8a}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="size" v="3.3" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="35" type="marker">
        <layer class="SvgMarker" enabled="1" id="{5571d42d-9493-5d3c-ae0a-69f7dd61ad15}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="154,160,166,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
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
    <property key="overture/palette" value="light" />
    <property key="overture/description" value="base-infrastructure-point light style bound to Overture schema 1.18.0" />
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
      <placement allowDegraded="0" centroidInside="1" dist="1" distUnits="MM" fitInPolygonOnly="0" layerType="PointGeometry" maxCurvedCharAngleIn="25" maxCurvedCharAngleOut="-25" offsetType="0" overlapHandling="PreventOverlap" placement="6" placementFlags="10" predefinedPositionOrder="TR,TL,BR,BL,R,L" priority="5" quadOffset="4" repeatDistance="40" repeatDistanceUnits="MM" />
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="0" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="100000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>0</layerGeometryType>
</qgis>
