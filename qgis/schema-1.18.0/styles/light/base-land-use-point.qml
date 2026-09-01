<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{bf9a11c0-822a-5657-a38f-26fd0ed8ed68}">
      <rule key="{c9f295e5-2dc4-55ef-b71d-e992355f8a01}" label="Agriculture" symbol="0" filter="attribute(@feature, 'subtype') = 'agriculture'" scalemaxdenom="250000" />
      <rule key="{58bf6bd4-af0c-5eeb-a563-d07190505b21}" label="Aquaculture" symbol="1" filter="attribute(@feature, 'subtype') = 'aquaculture'" scalemaxdenom="250000" />
      <rule key="{a656dd5d-07b9-57b5-993d-1e1b341f12c9}" label="Campground" symbol="2" filter="attribute(@feature, 'subtype') = 'campground'" scalemaxdenom="250000" />
      <rule key="{439dd009-4aa1-56fb-b792-314c3896cd00}" label="Cemetery" symbol="3" filter="attribute(@feature, 'subtype') = 'cemetery'" scalemaxdenom="250000" />
      <rule key="{7538a56b-529d-5aac-85b0-92adc36f949a}" label="Construction" symbol="4" filter="attribute(@feature, 'subtype') = 'construction'" scalemaxdenom="250000" />
      <rule key="{6f0ef622-e480-50e7-866b-426f45955da6}" label="Developed" symbol="5" filter="attribute(@feature, 'subtype') = 'developed'" scalemaxdenom="250000" />
      <rule key="{f995bb25-b9ec-56de-ac08-a9e37a43b750}" label="Education" symbol="6" filter="attribute(@feature, 'subtype') = 'education'" scalemaxdenom="250000" />
      <rule key="{4503b225-5d43-5119-9db2-27659c414fbf}" label="Entertainment" symbol="7" filter="attribute(@feature, 'subtype') = 'entertainment'" scalemaxdenom="250000" />
      <rule key="{1583f561-9793-53a8-9295-de53c69885dc}" label="Golf" symbol="8" filter="attribute(@feature, 'subtype') = 'golf'" scalemaxdenom="250000" />
      <rule key="{3203a658-ac28-5b69-b476-a438b33b4309}" label="Grass" symbol="9" filter="attribute(@feature, 'subtype') = 'grass'" scalemaxdenom="250000" />
      <rule key="{0c6e3480-916c-5ea1-bd2a-d0a8bf165e2a}" label="Horticulture" symbol="10" filter="attribute(@feature, 'subtype') = 'horticulture'" scalemaxdenom="250000" />
      <rule key="{1e1a3433-b155-520f-b0fc-2302feca4a17}" label="Landfill" symbol="11" filter="attribute(@feature, 'subtype') = 'landfill'" scalemaxdenom="250000" />
      <rule key="{c0ecf20d-fc2a-5588-9410-87fdbebe67ae}" label="Managed" symbol="12" filter="attribute(@feature, 'subtype') = 'managed'" scalemaxdenom="250000" />
      <rule key="{73a7da56-d43b-5b77-b6ef-03b409ed854b}" label="Medical" symbol="13" filter="attribute(@feature, 'subtype') = 'medical'" scalemaxdenom="250000" />
      <rule key="{acb8de39-7be7-52ac-bd1e-31f40dcc2863}" label="Military" symbol="14" filter="attribute(@feature, 'subtype') = 'military'" scalemaxdenom="2000000" />
      <rule key="{483599dd-1feb-5fda-a971-c7323bfc566a}" label="Park" symbol="15" filter="attribute(@feature, 'subtype') = 'park'" scalemaxdenom="250000" />
      <rule key="{d51e76d6-3621-5cb7-8533-12c1201062a6}" label="Pedestrian" symbol="16" filter="attribute(@feature, 'subtype') = 'pedestrian'" scalemaxdenom="250000" />
      <rule key="{30a07633-dbc7-5ed7-b97e-ee771986cf46}" label="Protected" symbol="17" filter="attribute(@feature, 'subtype') = 'protected'" scalemaxdenom="2000000" />
      <rule key="{38f8cd20-250d-5a56-9132-1eceb6bf6312}" label="Recreation" symbol="18" filter="attribute(@feature, 'subtype') = 'recreation'" scalemaxdenom="250000" />
      <rule key="{1255b5be-9623-5790-a709-41d3dda2ea27}" label="Religious" symbol="19" filter="attribute(@feature, 'subtype') = 'religious'" scalemaxdenom="250000" />
      <rule key="{1d7dbc68-496d-5427-9a14-bf60e6834d18}" label="Residential" symbol="20" filter="attribute(@feature, 'subtype') = 'residential'" scalemaxdenom="250000" />
      <rule key="{28c9468a-2466-5cb7-9d20-84d2baf45624}" label="Resource Extraction" symbol="21" filter="attribute(@feature, 'subtype') = 'resource_extraction'" scalemaxdenom="250000" />
      <rule key="{b45c8e66-c1c8-507f-a097-b60bab0ae31e}" label="Transportation" symbol="22" filter="attribute(@feature, 'subtype') = 'transportation'" scalemaxdenom="2000000" />
      <rule key="{7a18bd95-5109-51ec-a270-3e4a46dfd547}" label="Winter Sports" symbol="23" filter="attribute(@feature, 'subtype') = 'winter_sports'" scalemaxdenom="250000" />
      <rule key="{eb12502c-2510-5f1e-94eb-f99b957d2fc4}" label="Other or missing value" symbol="24" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{e62ac968-16e0-54cb-a31b-b225a2defb17}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="215,215,154,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{447df6f3-c4d1-51db-b5cb-546c3a4e2c3e}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="120,183,216,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{461c3651-44ee-5884-bac7-8e294301d8c8}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="143,189,120,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{c1657908-dedc-522c-abe2-37a15f62d290}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="143,189,120,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{4a0fa160-fc67-5489-8e95-5ecb5b1c0c3f}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="169,130,98,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{96cd1870-ff6b-5e31-b144-bd737f0235e3}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="201,195,198,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{fedbb90b-5ab0-5d85-afe1-25f3ce2925ee}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="79,142,128,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{cc50c5cf-2288-555e-a0c6-ecaf82d0f1dd}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="155,118,83,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{f882c31f-6b7b-518d-995f-d6a3fac4b39b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="143,189,120,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{5cece904-c138-500d-a22b-8d6bf7631c3c}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="143,189,120,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{59889947-a7e1-58dd-98a8-8aff5844a257}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="215,215,154,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{40d49a37-4454-5801-8b42-6588a02fafc4}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="199,189,207,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{5c68778f-9759-5c1d-be93-256f3e8a99b1}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="215,215,154,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{b10a29b6-b531-55b1-86b6-46ce0fa6ab4e}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="216,77,91,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{a110caf3-4c07-563f-9575-1a3e6356e90c}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="169,130,98,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{55e8529b-894c-5ccb-88d0-c359715a7175}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="143,189,120,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{16d92aa1-8f2a-59e6-b76b-d3d315ca6185}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="154,128,104,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{0084fbd2-5061-5d54-aa7e-200e1d9ee8f8}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="167,201,140,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="18" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{f108a330-f798-54e2-9f5d-42f25ba4eec0}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="79,153,112,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="19" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{0d8f8030-959f-5993-a0f4-3646b7de0c4f}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="155,118,83,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="20" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{96da919c-e248-568e-94c0-1d88b8e4288b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="217,211,203,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="21" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{cd2039fb-c52a-506b-9444-73dfdfe65874}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="169,130,98,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="22" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{4b56d666-d886-5530-baa0-68027ee8f4a6}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="227,151,98,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="23" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{7152055b-982d-5e9e-8545-b30f3bddabfa}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="255,255,255,255" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,255" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="24" type="marker">
        <layer class="SimpleMarker" enabled="1" id="{6ba3d4a0-2770-50a4-9d07-9114733d38e2}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="154,160,166,190" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="joinstyle" v="bevel" />
          <prop k="name" v="circle" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,190" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.25" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="scale_method" v="diameter" />
          <prop k="size" v="2.6" />
          <prop k="size_unit" v="MM" />
          <prop k="vertical_anchor_point" v="1" />
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <customproperties>
    <property key="overture/schema_version" value="1.18.0" />
    <property key="overture/style_id" value="base-land-use-point" />
    <property key="overture/palette" value="light" />
    <property key="overture/description" value="base-land-use-point light style bound to Overture schema 1.18.0" />
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
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="0" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="50000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>0</layerGeometryType>
</qgis>
