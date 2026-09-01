<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{7d333ee8-6ead-5204-9ac9-8c45c0e7a206}">
      <rule key="{6e7eb3d0-26b0-58c6-953d-dadf6caf1e98}" label="canal — salt" symbol="0" filter="attribute(@feature, 'subtype') = 'canal' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{f429ff09-9c5c-57df-9c97-bfdc5902a32c}" label="Canal" symbol="1" filter="attribute(@feature, 'subtype') = 'canal' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{0be1ea03-e79b-5f92-afa3-0b33fb54e4ea}" label="human_made — salt" symbol="2" filter="attribute(@feature, 'subtype') = 'human_made' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{f3aaae9e-eb64-557a-92c9-0cbf0e428719}" label="Human Made" symbol="3" filter="attribute(@feature, 'subtype') = 'human_made' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{2ac6d078-0b05-5d18-af74-e421da99f463}" label="lake — salt" symbol="4" filter="attribute(@feature, 'subtype') = 'lake' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{86bdf50a-61d1-51ac-8676-bb72ca124077}" label="Lake" symbol="5" filter="attribute(@feature, 'subtype') = 'lake' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{7c5ba864-e42b-58df-a7eb-1483cfce78b2}" label="ocean — salt" symbol="6" filter="attribute(@feature, 'subtype') = 'ocean' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="100000000" />
      <rule key="{d62fad51-516e-545e-89ae-d717cd0ed38b}" label="Ocean" symbol="7" filter="attribute(@feature, 'subtype') = 'ocean' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="100000000" />
      <rule key="{6cd0fd8f-bee2-5f0b-8b7f-23cb957eb82f}" label="physical — salt" symbol="8" filter="attribute(@feature, 'subtype') = 'physical' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{911c8fdc-37c2-5dce-bb85-84d2ded2add3}" label="Physical" symbol="9" filter="attribute(@feature, 'subtype') = 'physical' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{0b526ca6-0833-5db6-a883-0dead4297ac9}" label="pond — salt" symbol="10" filter="attribute(@feature, 'subtype') = 'pond' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{6a925387-15bd-5a56-b42a-e9cf15e811c5}" label="Pond" symbol="11" filter="attribute(@feature, 'subtype') = 'pond' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{2658731c-74f0-5ebd-9537-23b409de7428}" label="reservoir — salt" symbol="12" filter="attribute(@feature, 'subtype') = 'reservoir' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{9260ff7b-891f-5fe0-85e5-72e2aef348f9}" label="Reservoir" symbol="13" filter="attribute(@feature, 'subtype') = 'reservoir' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{781880d7-5019-5df1-84c5-d464839bd1e6}" label="river — salt" symbol="14" filter="attribute(@feature, 'subtype') = 'river' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{ad1944b1-5dc2-5e8f-8d4b-7324692d9181}" label="River" symbol="15" filter="attribute(@feature, 'subtype') = 'river' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="2000000" />
      <rule key="{28812064-fd7a-5619-b40f-fa7c6a586ff8}" label="spring — salt" symbol="16" filter="attribute(@feature, 'subtype') = 'spring' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{a3df2eee-5bdc-5f23-bb0c-bdd675fd4f2b}" label="Spring" symbol="17" filter="attribute(@feature, 'subtype') = 'spring' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{e85e6cfd-fb2c-582f-a3d5-2d7e0ddd9c54}" label="stream — salt" symbol="18" filter="attribute(@feature, 'subtype') = 'stream' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{6960618b-8d7f-5403-91f3-68dbf79e459b}" label="Stream" symbol="19" filter="attribute(@feature, 'subtype') = 'stream' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{1c242ac1-9cc1-567a-a633-4507ffa8f93e}" label="wastewater — salt" symbol="20" filter="attribute(@feature, 'subtype') = 'wastewater' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{13354f50-c0bd-5ba8-986d-3303bc8037a5}" label="Wastewater" symbol="21" filter="attribute(@feature, 'subtype') = 'wastewater' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{a50f9523-d49b-5986-b6e9-67c9f70e5fbe}" label="water — salt" symbol="22" filter="attribute(@feature, 'subtype') = 'water' AND coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{b024b49c-d542-5eed-9cff-d0ba374c5279}" label="Water" symbol="23" filter="attribute(@feature, 'subtype') = 'water' AND NOT coalesce(attribute(@feature, 'is_salt'), false)" scalemaxdenom="250000" />
      <rule key="{566cfb33-9bd5-5cf6-a965-c6c0c1c4869c}" label="Other or missing value" symbol="24" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" id="{ee6f2d5c-8cd5-53d0-a9df-61e1356d1b35}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="1" type="fill">
        <layer class="SimpleFill" enabled="1" id="{8b633d54-5bb1-53e8-8ac6-4e7ce8901484}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="2" type="fill">
        <layer class="SimpleFill" enabled="1" id="{d82da87c-1d29-5f6c-b564-face172f310e}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="3" type="fill">
        <layer class="SimpleFill" enabled="1" id="{47365ae9-1763-5aea-a800-539a1a913389}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="4" type="fill">
        <layer class="SimpleFill" enabled="1" id="{59813414-e9d8-5b5c-ac39-3eac99ca62ef}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="5" type="fill">
        <layer class="SimpleFill" enabled="1" id="{44539ebd-3fae-51c9-92ff-15a53b10a1f6}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="6" type="fill">
        <layer class="SimpleFill" enabled="1" id="{d372f6c5-e147-5bd7-ae4e-e701550a0273}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="fill">
        <layer class="SimpleFill" enabled="1" id="{2dedf83a-db1e-58be-806e-3041bbde7280}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="8" type="fill">
        <layer class="SimpleFill" enabled="1" id="{7568b4e1-4c21-5355-a1b2-9be0913312dc}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="9" type="fill">
        <layer class="SimpleFill" enabled="1" id="{6b20fab6-1157-5102-9342-d8004685bf6d}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="fill">
        <layer class="SimpleFill" enabled="1" id="{79b8aed7-eb6c-5082-a7af-9db910c6354f}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="11" type="fill">
        <layer class="SimpleFill" enabled="1" id="{7e07a8bc-be9c-59e0-9cbd-7c8999dbf807}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="12" type="fill">
        <layer class="SimpleFill" enabled="1" id="{b0582d1f-0715-53e5-b0fc-edc5d0afd0b0}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="fill">
        <layer class="SimpleFill" enabled="1" id="{004c80b9-870c-56c1-9695-de29403a80cd}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="fill">
        <layer class="SimpleFill" enabled="1" id="{a3f338e5-a547-5ad6-9493-0137d183d385}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="fill">
        <layer class="SimpleFill" enabled="1" id="{8a055006-1825-521c-a0d7-6fb7357639a8}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="16" type="fill">
        <layer class="SimpleFill" enabled="1" id="{e19faaf0-a465-5fd5-b8fe-5176b5015418}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="17" type="fill">
        <layer class="SimpleFill" enabled="1" id="{156e7c3e-7b68-5579-8d87-52c3ac00b593}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="18" type="fill">
        <layer class="SimpleFill" enabled="1" id="{8eaec473-23c7-55f9-87ca-f05fc71227f1}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="19" type="fill">
        <layer class="SimpleFill" enabled="1" id="{1b63e1c6-e31e-57c0-957b-52b74d1ee738}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="20" type="fill">
        <layer class="SimpleFill" enabled="1" id="{3fd472cc-cc3b-5abf-89ef-8df98f37b778}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="21" type="fill">
        <layer class="SimpleFill" enabled="1" id="{f8db4cac-f53a-5f2e-862c-a543c52582cb}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="22" type="fill">
        <layer class="SimpleFill" enabled="1" id="{0360ef64-1a76-550a-a676-27d19bcd4432}" locked="0" pass="0">
          <prop k="color" v="23,61,99,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="23" type="fill">
        <layer class="SimpleFill" enabled="1" id="{82103694-5b0a-5bf9-9de3-64e03d3c3afe}" locked="0" pass="0">
          <prop k="color" v="53,111,145,205" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,205" />
          <prop k="outline_style" v="solid" />
          <prop k="outline_width" v="0.22" />
          <prop k="outline_width_unit" v="MM" />
          <prop k="style" v="solid" />
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="24" type="fill">
        <layer class="SimpleFill" enabled="1" id="{5df90774-3073-5f81-b507-9d15521c0a1d}" locked="0" pass="0">
          <prop k="color" v="125,135,144,190" />
          <prop k="joinstyle" v="round" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,190" />
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
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="base-water-polygon dark style bound to Overture schema 1.18.0" />
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
      <placement allowDegraded="0" centroidInside="1" dist="1" distUnits="MM" fitInPolygonOnly="0" layerType="PolygonGeometry" maxCurvedCharAngleIn="25" maxCurvedCharAngleOut="-25" offsetType="0" overlapHandling="PreventOverlap" placement="1" placementFlags="10" predefinedPositionOrder="TR,TL,BR,BL,R,L" priority="5" quadOffset="4" repeatDistance="40" repeatDistanceUnits="MM" />
      <rendering drawLabels="1" fontLimitPixelSize="0" fontMaxPixelSize="10000" fontMinPixelSize="3" limitNumLabels="1" maxNumLabels="2000" mergeLines="0" minFeatureSize="1" obstacle="1" obstacleFactor="1" obstacleType="1" scaleMax="250000" scaleMin="0" scaleVisibility="1" unplacedVisibility="0" />
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <layerGeometryType>2</layerGeometryType>
</qgis>
