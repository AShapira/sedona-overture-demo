<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{561474f1-ccfa-5473-89f2-f2c627a0902a}">
      <rule key="{dc645ca4-0c76-53d9-bd2a-d7936b884df1}" label="Airport" symbol="0" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'airport'" scalemaxdenom="250000" />
      <rule key="{689ca268-230b-5bbe-8902-c3ca5f3f27b0}" label="Atm" symbol="1" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'atm'" scalemaxdenom="50000" />
      <rule key="{a1c6b508-e6bd-573a-bb35-f1f824c57330}" label="Bakery" symbol="2" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'bakery'" scalemaxdenom="50000" />
      <rule key="{989c1eba-8bec-58ab-92a0-7eb688477b82}" label="Bank" symbol="3" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'bank'" scalemaxdenom="50000" />
      <rule key="{1053c1af-c693-5d43-af74-8bdc29356e8c}" label="Bar" symbol="4" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'bar'" scalemaxdenom="50000" />
      <rule key="{c6e9b4e4-5d40-57d9-8a4a-c578fa813f43}" label="Beach" symbol="5" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'beach'" scalemaxdenom="50000" />
      <rule key="{0259726d-93d0-58fd-8f86-b381d9bf8fcb}" label="Bus Station" symbol="6" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'bus_station'" scalemaxdenom="50000" />
      <rule key="{4e5a48bd-b122-5f52-b4b0-6cb4e2cea927}" label="Cafe" symbol="7" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'cafe'" scalemaxdenom="50000" />
      <rule key="{5fe73339-fb77-56ac-b2b0-acd456f91c47}" label="Casual Eatery" symbol="8" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'casual_eatery'" scalemaxdenom="50000" />
      <rule key="{0ac80c20-fb7f-504f-9028-290ca620bd4c}" label="Charging Station" symbol="9" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'charging_station'" scalemaxdenom="50000" />
      <rule key="{45a06fca-6cd6-5b8b-ae54-0fdbedcba7bc}" label="Cinema" symbol="10" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'cinema'" scalemaxdenom="50000" />
      <rule key="{bcfd4c94-dd12-59f9-a0bc-cf8a09b97bff}" label="Clinic" symbol="11" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'clinic'" scalemaxdenom="50000" />
      <rule key="{ff63921a-0cfc-5aa2-b042-536db3bcbe4b}" label="Ferry Terminal" symbol="12" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'ferry_terminal'" scalemaxdenom="50000" />
      <rule key="{b522651f-8c6e-5105-a1dd-b91fff405631}" label="Fire Station" symbol="13" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'fire_station'" scalemaxdenom="50000" />
      <rule key="{8ddbb9cd-6176-5e6e-9500-486c6735afb8}" label="Fuel" symbol="14" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'fuel'" scalemaxdenom="50000" />
      <rule key="{891570d7-9714-577a-8b90-a5eb1b1f4c8a}" label="Hospital" symbol="15" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'hospital'" scalemaxdenom="250000" />
      <rule key="{74a9648a-0d24-5d9a-97ae-1eec43f17a07}" label="Hotel" symbol="16" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'hotel'" scalemaxdenom="50000" />
      <rule key="{9cabf82b-cd5a-5bb0-aec4-b1f9131c2917}" label="Library" symbol="17" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'library'" scalemaxdenom="50000" />
      <rule key="{666ff615-9fda-5382-aabd-6cfb49514dfc}" label="Museum" symbol="18" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'museum'" scalemaxdenom="50000" />
      <rule key="{e6912398-7a33-5333-9ac8-e3473203bee6}" label="Park" symbol="19" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'park'" scalemaxdenom="50000" />
      <rule key="{01625e18-475a-545a-94be-3ad2b262e98e}" label="Parking" symbol="20" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'parking'" scalemaxdenom="50000" />
      <rule key="{1e6947c1-7222-5400-b649-6e4231fed956}" label="Peak" symbol="21" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'peak'" scalemaxdenom="250000" />
      <rule key="{1d1b680b-68e6-5d04-bfad-c690262f187e}" label="Pharmacy" symbol="22" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'pharmacy'" scalemaxdenom="50000" />
      <rule key="{8b785c89-5008-5fd9-844d-5df0692fac1b}" label="Place Of Worship" symbol="23" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'place_of_worship'" scalemaxdenom="50000" />
      <rule key="{26374024-95d6-5ed6-8e52-853e7cf51bcb}" label="Playground" symbol="24" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'playground'" scalemaxdenom="50000" />
      <rule key="{4f52a1ba-defd-5881-9763-ca86db267de7}" label="Police" symbol="25" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'police'" scalemaxdenom="50000" />
      <rule key="{e4136c18-cafb-55f8-9985-724c441ce60f}" label="Post Office" symbol="26" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'post_office'" scalemaxdenom="50000" />
      <rule key="{beeaf600-2d6e-5a99-a87d-1e63036349c1}" label="Railway Station" symbol="27" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'railway_station'" scalemaxdenom="50000" />
      <rule key="{7330086f-e31f-53cb-9815-0c8905f677cc}" label="Restaurant" symbol="28" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'restaurant'" scalemaxdenom="50000" />
      <rule key="{f4273fb6-c6b2-5ef3-b1ee-ec9b7d4b6f6f}" label="School" symbol="29" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'school'" scalemaxdenom="50000" />
      <rule key="{472aba53-bacc-5f62-92d7-58605f09f31c}" label="Shopping Mall" symbol="30" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'shopping_mall'" scalemaxdenom="50000" />
      <rule key="{e4e79a2a-c280-59b5-abd5-0135ff201fec}" label="Stadium" symbol="31" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'stadium'" scalemaxdenom="250000" />
      <rule key="{25b8971c-2331-5f93-b188-2214549ed8ec}" label="Supermarket" symbol="32" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'supermarket'" scalemaxdenom="50000" />
      <rule key="{db436268-9f8f-56e5-a1f3-45916d8ad49f}" label="Theater" symbol="33" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'theater'" scalemaxdenom="50000" />
      <rule key="{4428f5f8-71c7-5a31-9cb6-c5ed4df7ca81}" label="University" symbol="34" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'university'" scalemaxdenom="250000" />
      <rule key="{6c11b227-524c-583b-92a6-8a492a567d3f}" label="Services And Business" symbol="35" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'services_and_business' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{0b8ef48a-e64a-5ccc-8a46-8136b4aff74c}" label="Shopping" symbol="36" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'shopping' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{4dbf23a0-eaaf-5115-8044-eef94f1e55d6}" label="Food And Drink" symbol="37" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'food_and_drink' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{db6f74ba-6ccb-5ce0-9698-32a7da1232d1}" label="Lifestyle Services" symbol="38" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'lifestyle_services' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{897744f2-ddb3-561b-819e-22cac171bc09}" label="Travel And Transportation" symbol="39" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'travel_and_transportation' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="250000" />
      <rule key="{72984450-e7d4-5c2a-a42a-8eac32575bf1}" label="Health Care" symbol="40" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'health_care' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{d0a80785-6826-554b-b55f-8dfb9bc00f53}" label="Education" symbol="41" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'education' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{a87e87a8-2081-5553-9a2f-4e493bff727d}" label="Cultural And Historic" symbol="42" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'cultural_and_historic' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{52ee53d5-be1d-5e45-b251-d4088c87bb9b}" label="Sports And Recreation" symbol="43" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'sports_and_recreation' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{b62b89f6-13e4-50f2-baf7-3f66d11a86cf}" label="Community And Government" symbol="44" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'community_and_government' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{d3086950-c4c8-5a2c-99d9-26f7a0f67da2}" label="Lodging" symbol="45" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'lodging' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{912d0f00-cd3a-5230-8b01-84127e3eac29}" label="Arts And Entertainment" symbol="46" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'arts_and_entertainment' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{eda5ff2b-bede-5ddf-a4b2-cdad1bea53e2}" label="Geographic Entities" symbol="47" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'geographic_entities' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="250000" />
      <rule key="{18d9c748-c9ed-57f0-920b-29dabcaf5386}" label="Unclassified open place" symbol="48" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) IS NULL" scalemaxdenom="10000" />
      <rule key="{06e6219f-92d9-54e4-ac38-d5dde877a6dc}" label="Suppressed closed place" symbol="49" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="marker">
        <layer class="SvgMarker" enabled="1" id="{15442bcc-637c-5965-aa79-56b037443258}" locked="0" pass="0">
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
        <layer class="SvgMarker" enabled="1" id="{1f8c6b08-e22c-54bf-b9c5-0c4b4d66b6a9}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDlsMTAtNiAxMCA2ek00IDEwaDE2TTUgMTB2OE05IDEwdjhNMTUgMTB2OE0xOSAxMHY4TTMgMTloMTh2MkgzeiIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IGJhbms8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{4b1baaea-fc78-5801-9115-e3d68ed3a206}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="239,133,95,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZsMiA2YTQgNCAwIDAxLTUgMyA0IDQgMCAwMS01IDAgNCA0IDAgMDEtNSAwIDQgNCAwIDAxLTUtM3pNNCAxMnY5aDE2di05Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2hvcDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{c43f616c-a6ab-52f6-9bb9-6f662eb7f351}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="119,164,211,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDlsMTAtNiAxMCA2ek00IDEwaDE2TTUgMTB2OE05IDEwdjhNMTUgMTB2OE0xOSAxMHY4TTMgMTloMTh2MkgzeiIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IGJhbms8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{957b360d-2506-5147-9ea7-61da41777f4b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="239,133,95,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDRoMTZsLTcgOHY2aDR2Mkg3di0yaDR2LTZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYmFyPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
        <layer class="SvgMarker" enabled="1" id="{44ef501f-6de7-5b5d-a8f5-cfe195f94477}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="66,107,77,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDIwTDkgN2wzIDQgMy02IDcgMTV6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogcGVhazwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{10041600-5267-515d-832a-63d977faeb93}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="marker">
        <layer class="SvgMarker" enabled="1" id="{1ceac7d1-ed22-59f8-b20b-bec59cd55d8b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="239,133,95,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDdoMTN2OGE1IDUgMCAwMS01IDVIOWE1IDUgMCAwMS01LTV6TTE3IDloMmEzIDMgMCAwMTAgNmgtMiIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IGNhZmU8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{4fbb9149-d672-5214-b9e4-6d38a53cbe5f}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="239,133,95,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik02IDJ2OE0zIDJ2NWEzIDMgMCAwMDYgMFYyTTYgMTB2MTJNMTUgMnYyME0xNSAyYTUgOCAwIDAxMCAxMiIgZmlsbD0ibm9uZSIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHJlc3RhdXJhbnQ8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{4815c369-04b9-5209-a26b-f5b5da4c8830}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="marker">
        <layer class="SvgMarker" enabled="1" id="{d89e685e-ca1e-5422-8c80-60a30bc2007f}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="195,154,114,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZ2MTRINHoiLz48cGF0aCBkPSJNOCAyMWg4TTEyIDE3djQiIGZpbGw9Im5vbmUiLz48Y2lyY2xlIGN4PSI5IiBjeT0iOSIgcj0iMiIvPjxwYXRoIGQ9Ik0xMyAxM2wzLTQgMyA1IiBmaWxsPSJub25lIi8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYXJ0czwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{cac9d768-ff6b-5934-8a90-70a57b167419}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="241,110,121,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik05IDNoNnY2aDZ2NmgtNnY2SDl2LTZIM1Y5aDZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogaG9zcGl0YWw8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{fbc7ced5-7911-5d67-bfa3-bb3751f43010}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="marker">
        <layer class="SvgMarker" enabled="1" id="{54be0ac4-d01f-5c43-afdc-3a439d235e3e}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="118,83,99,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="marker">
        <layer class="SvgMarker" enabled="1" id="{0839bf5c-0d72-503e-95c4-3912e5c7e802}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,166,215,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="marker">
        <layer class="SvgMarker" enabled="1" id="{1cc3d4e6-3421-5b6f-a621-c206076d8d1b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="241,110,121,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik05IDNoNnY2aDZ2NmgtNnY2SDl2LTZIM1Y5aDZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogaG9zcGl0YWw8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{e157fbee-41c5-51a7-8146-dd84670db7f9}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="129,89,79,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDVoMTh2MTVIM3pNNiA4aDR2NEg2ek0xNCA4aDR2NGgtNHpNNSAxNmgxNCIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IGhvdGVsPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
        <layer class="SvgMarker" enabled="1" id="{c77c5814-ba64-535f-b78b-4144d864bbb4}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,182,165,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1LTEwIDV6TTYgMTF2NmM0IDMgOCAzIDEyIDB2LTZNMjEgOXY4Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2Nob29sPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
        <layer class="SvgMarker" enabled="1" id="{2eedf3fc-37a4-56d1-82cd-2cdab3c99a84}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="195,154,114,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1ek00IDloMTZNNSAxMHY4TTkgMTB2OE0xNSAxMHY4TTE5IDEwdjhNMyAxOWgxOCIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IG11c2V1bTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{6d8b9170-8f57-5449-a72e-3acd0c09fc9b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="111,195,144,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMiAybDUgN2gtM2w1IDdoLTZ2NmgtMnYtNkg1bDUtN0g3eiIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHBhcms8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{ebe872bb-509d-56a7-9c89-334809e1491d}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="21" type="marker">
        <layer class="SvgMarker" enabled="1" id="{fba8d915-d336-54ff-851f-5ed042059926}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="66,107,77,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDIwTDkgN2wzIDQgMy02IDcgMTV6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogcGVhazwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{c851e9c2-3faf-556a-813d-682827a399fc}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="241,110,121,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik05IDNoNnY2aDZ2NmgtNnY2SDl2LTZIM1Y5aDZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogaG9zcGl0YWw8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{e0b8c793-03e2-570e-9835-f7d5cb4f9a17}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="195,154,114,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMiAydjIwTTcgN2gxME01IDEybDctNSA3IDV2OUg1eiIgZmlsbD0ibm9uZSIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHdvcnNoaXA8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{0470f5c4-3eae-538a-aee2-5ad9c0180888}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="111,195,144,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMiAybDUgN2gtM2w1IDdoLTZ2NmgtMnYtNkg1bDUtN0g3eiIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHBhcms8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{3295a60a-16d5-5ec5-8694-ef601ba5f6a9}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="118,83,99,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="26" type="marker">
        <layer class="SvgMarker" enabled="1" id="{fba67dab-8484-53a0-aac7-4017a56fe316}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="118,83,99,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="27" type="marker">
        <layer class="SvgMarker" enabled="1" id="{28644e54-45bb-567e-bf4b-59b448f89a73}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="28" type="marker">
        <layer class="SvgMarker" enabled="1" id="{cd4fbeae-2b67-5145-bd40-70875b2668bc}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="239,133,95,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik02IDJ2OE0zIDJ2NWEzIDMgMCAwMDYgMFYyTTYgMTB2MTJNMTUgMnYyME0xNSAyYTUgOCAwIDAxMCAxMiIgZmlsbD0ibm9uZSIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHJlc3RhdXJhbnQ8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{32a8434f-567b-511d-adc6-18cd9bfbc6fc}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,182,165,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1LTEwIDV6TTYgMTF2NmM0IDMgOCAzIDEyIDB2LTZNMjEgOXY4Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2Nob29sPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
        <layer class="SvgMarker" enabled="1" id="{92f96820-f0b6-59d0-b5ab-1794cd45248d}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="193,129,209,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZsMiA2YTQgNCAwIDAxLTUgMyA0IDQgMCAwMS01IDAgNCA0IDAgMDEtNSAwIDQgNCAwIDAxLTUtM3pNNCAxMnY5aDE2di05Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2hvcDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{ca0d7f5f-f784-5d45-8a91-fce07e730693}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="111,195,144,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxjaXJjbGUgY3g9IjEyIiBjeT0iMTIiIHI9IjkiLz48cGF0aCBkPSJNNSA3bDE0IDEwTTcgMTlsMTAtMTQiIGZpbGw9Im5vbmUiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiBzcG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{2d8fe28f-3239-58d5-aed2-4dbe342126bd}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="193,129,209,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZsMiA2YTQgNCAwIDAxLTUgMyA0IDQgMCAwMS01IDAgNCA0IDAgMDEtNSAwIDQgNCAwIDAxLTUtM3pNNCAxMnY5aDE2di05Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2hvcDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{308f4419-3483-525d-83a1-c86ec7b61eac}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="195,154,114,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZ2MTRINHoiLz48cGF0aCBkPSJNOCAyMWg4TTEyIDE3djQiIGZpbGw9Im5vbmUiLz48Y2lyY2xlIGN4PSI5IiBjeT0iOSIgcj0iMiIvPjxwYXRoIGQ9Ik0xMyAxM2wzLTQgMyA1IiBmaWxsPSJub25lIi8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYXJ0czwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{ffc2161e-0799-5d91-90ca-71bcaaa242f9}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,182,165,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1LTEwIDV6TTYgMTF2NmM0IDMgOCAzIDEyIDB2LTZNMjEgOXY4Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2Nob29sPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
        <layer class="SvgMarker" enabled="1" id="{31b30383-6b0a-5a40-9465-8a7bf6fda05a}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="36" type="marker">
        <layer class="SvgMarker" enabled="1" id="{97ffd9cb-eff4-5866-b8f3-b01482c8378a}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="193,129,209,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZsMiA2YTQgNCAwIDAxLTUgMyA0IDQgMCAwMS01IDAgNCA0IDAgMDEtNSAwIDQgNCAwIDAxLTUtM3pNNCAxMnY5aDE2di05Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2hvcDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="37" type="marker">
        <layer class="SvgMarker" enabled="1" id="{9aa67049-4439-587c-8b90-fb430111ef43}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="239,133,95,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik02IDJ2OE0zIDJ2NWEzIDMgMCAwMDYgMFYyTTYgMTB2MTJNMTUgMnYyME0xNSAyYTUgOCAwIDAxMCAxMiIgZmlsbD0ibm9uZSIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHJlc3RhdXJhbnQ8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="38" type="marker">
        <layer class="SvgMarker" enabled="1" id="{d65ab19b-5a7f-50cf-8125-2f6582d58c67}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="39" type="marker">
        <layer class="SvgMarker" enabled="1" id="{f75e1ed3-2c9e-544e-9e4e-0a074ad748a6}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="40" type="marker">
        <layer class="SvgMarker" enabled="1" id="{cf9595f4-3a5f-54af-8d4f-79c57be984dc}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="241,110,121,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik05IDNoNnY2aDZ2NmgtNnY2SDl2LTZIM1Y5aDZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogaG9zcGl0YWw8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="41" type="marker">
        <layer class="SvgMarker" enabled="1" id="{66170a14-23d6-5985-a41d-ac05bb17504f}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="112,182,165,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1LTEwIDV6TTYgMTF2NmM0IDMgOCAzIDEyIDB2LTZNMjEgOXY4Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2Nob29sPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="42" type="marker">
        <layer class="SvgMarker" enabled="1" id="{71f00a13-9aa7-577a-9d7a-c49092cbd6d9}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="195,154,114,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1ek00IDloMTZNNSAxMHY4TTkgMTB2OE0xNSAxMHY4TTE5IDEwdjhNMyAxOWgxOCIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IG11c2V1bTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="43" type="marker">
        <layer class="SvgMarker" enabled="1" id="{56bec951-ad52-5d3e-8c3e-acdad3836970}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="111,195,144,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxjaXJjbGUgY3g9IjEyIiBjeT0iMTIiIHI9IjkiLz48cGF0aCBkPSJNNSA3bDE0IDEwTTcgMTlsMTAtMTQiIGZpbGw9Im5vbmUiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiBzcG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="44" type="marker">
        <layer class="SvgMarker" enabled="1" id="{f3f1a1c2-9493-5354-8776-7e36760b6fc1}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="118,83,99,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="45" type="marker">
        <layer class="SvgMarker" enabled="1" id="{328e37e4-0d0e-5732-8388-addd0950af00}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="129,89,79,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDVoMTh2MTVIM3pNNiA4aDR2NEg2ek0xNCA4aDR2NGgtNHpNNSAxNmgxNCIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IGhvdGVsPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="46" type="marker">
        <layer class="SvgMarker" enabled="1" id="{5e3cae2e-64c2-573a-b2f2-a6412b8d813b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="195,154,114,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZ2MTRINHoiLz48cGF0aCBkPSJNOCAyMWg4TTEyIDE3djQiIGZpbGw9Im5vbmUiLz48Y2lyY2xlIGN4PSI5IiBjeT0iOSIgcj0iMiIvPjxwYXRoIGQ9Ik0xMyAxM2wzLTQgMyA1IiBmaWxsPSJub25lIi8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYXJ0czwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="47" type="marker">
        <layer class="SvgMarker" enabled="1" id="{7005f5fd-7e7f-5c4f-9c53-86662d23da72}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="66,107,77,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDIwTDkgN2wzIDQgMy02IDcgMTV6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogcGVhazwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="48" type="marker">
        <layer class="SvgMarker" enabled="1" id="{4f8bf932-c1bf-59c3-aee6-661c82e348e3}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="49" type="marker">
        <layer class="SvgMarker" enabled="1" id="{fe9a1737-b266-583b-91a4-ebb34b129a3a}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="125,135,144,0" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="137,148,158,0" />
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
    <property key="overture/style_id" value="places-place-point" />
    <property key="overture/palette" value="dark" />
    <property key="overture/description" value="places-place-point dark style bound to Overture schema 1.18.0" />
    <property key="overture/compatibility" value="Bound to Overture schema 1.18.0; other versions are unverified" />
  </customproperties>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style allowHtml="0" blendMode="0" capitalization="0" fieldName="CASE WHEN coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND (attribute(@feature, 'confidence') IS NULL OR attribute(@feature, 'confidence') &gt;= 0.5) THEN coalesce(map_get(attribute(@feature, 'names.common'), left(@qgis_locale, 2)), map_get(attribute(@feature, 'names.common'), 'en'), attribute(@feature, 'names.primary')) END" fontFamily="Noto Sans" fontItalic="0" fontKerning="1" fontLetterSpacing="0" fontSize="9" fontSizeUnit="Point" fontStrikeout="0" fontUnderline="0" fontWeight="400" fontWordSpacing="0" forcedBold="0" forcedItalic="0" isExpression="1" multilineHeight="1" namedStyle="Regular" textColor="233,237,241,255" textOpacity="1" textOrientation="horizontal">
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
