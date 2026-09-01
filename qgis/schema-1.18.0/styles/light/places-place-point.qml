<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="4.2.0-Belém do Pará" styleCategories="Symbology|Labeling|Rendering" labelsEnabled="1" layerType="Vector" hasScaleBasedVisibilityFlag="0" maxScale="0" minScale="100000000" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <renderer-v2 type="RuleRenderer" symbollevels="1" enableorderby="0" forceraster="0">
    <rules key="{9314337b-c5df-5d06-ad9c-6f9e6a7454e5}">
      <rule key="{fde3436e-4bf0-5995-b4cc-358d4c3256bd}" label="Airport" symbol="0" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'airport'" scalemaxdenom="250000" />
      <rule key="{9eaf349b-6477-53aa-ae89-d76ecc3dd1ec}" label="Atm" symbol="1" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'atm'" scalemaxdenom="50000" />
      <rule key="{5577176a-0be8-5926-a96c-c6c54efa4a14}" label="Bakery" symbol="2" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'bakery'" scalemaxdenom="50000" />
      <rule key="{c3ae51db-51ba-556c-bbac-b63fc9077d99}" label="Bank" symbol="3" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'bank'" scalemaxdenom="50000" />
      <rule key="{f90b8565-2e35-50f8-89a8-e758e2dab5f8}" label="Bar" symbol="4" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'bar'" scalemaxdenom="50000" />
      <rule key="{6ff72324-01cd-57b0-8f3b-e616482180dd}" label="Beach" symbol="5" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'beach'" scalemaxdenom="50000" />
      <rule key="{a9115a82-7323-5dfb-963d-b2fdf9b08356}" label="Bus Station" symbol="6" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'bus_station'" scalemaxdenom="50000" />
      <rule key="{dfe9d967-19c6-57bb-be29-0839db097673}" label="Cafe" symbol="7" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'cafe'" scalemaxdenom="50000" />
      <rule key="{5ff4c0e9-2708-571d-9643-67aaefbc3262}" label="Casual Eatery" symbol="8" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'casual_eatery'" scalemaxdenom="50000" />
      <rule key="{610a6dfe-d521-5663-8f51-210572148bc1}" label="Charging Station" symbol="9" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'charging_station'" scalemaxdenom="50000" />
      <rule key="{7f377d8b-dbe5-5b41-ba91-bb1e6e0a9413}" label="Cinema" symbol="10" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'cinema'" scalemaxdenom="50000" />
      <rule key="{4ad8d972-8a00-5fcd-8d20-0daf7ccbad22}" label="Clinic" symbol="11" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'clinic'" scalemaxdenom="50000" />
      <rule key="{674779fc-3ed4-5212-933d-33a258d04c12}" label="Ferry Terminal" symbol="12" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'ferry_terminal'" scalemaxdenom="50000" />
      <rule key="{a0327ae4-fea9-50f6-b4fb-520e90ddfb96}" label="Fire Station" symbol="13" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'fire_station'" scalemaxdenom="50000" />
      <rule key="{cd410065-72a1-5167-8a16-b2cf00c9a02b}" label="Fuel" symbol="14" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'fuel'" scalemaxdenom="50000" />
      <rule key="{942ec3d5-9005-555f-9e09-42bdc8acfd1b}" label="Hospital" symbol="15" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'hospital'" scalemaxdenom="250000" />
      <rule key="{3496ca7e-3544-5547-800d-9317b67be4ce}" label="Hotel" symbol="16" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'hotel'" scalemaxdenom="50000" />
      <rule key="{79442dc2-89a1-5e3f-88a1-fdb2866eaf2d}" label="Library" symbol="17" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'library'" scalemaxdenom="50000" />
      <rule key="{fe322956-d27b-5002-a1ca-cf6852b086c4}" label="Museum" symbol="18" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'museum'" scalemaxdenom="50000" />
      <rule key="{39e1985f-14b8-5f9b-afcf-c71fbbe694fc}" label="Park" symbol="19" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'park'" scalemaxdenom="50000" />
      <rule key="{201154b3-535c-5e3b-a2ca-c292b44c63ab}" label="Parking" symbol="20" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'parking'" scalemaxdenom="50000" />
      <rule key="{25506e1f-8599-5b6a-a0d7-2994172055d5}" label="Peak" symbol="21" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'peak'" scalemaxdenom="250000" />
      <rule key="{798ba10f-532b-5006-bbb9-51693f542241}" label="Pharmacy" symbol="22" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'pharmacy'" scalemaxdenom="50000" />
      <rule key="{3c387e8b-14dc-5bb3-8675-bc222c8f4d19}" label="Place Of Worship" symbol="23" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'place_of_worship'" scalemaxdenom="50000" />
      <rule key="{8537dd74-7f5d-507d-b6f9-68e8cb5a7484}" label="Playground" symbol="24" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'playground'" scalemaxdenom="50000" />
      <rule key="{5cc2e170-491b-5f72-9f1d-a46a58649060}" label="Police" symbol="25" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'police'" scalemaxdenom="50000" />
      <rule key="{bbf7348d-32e1-5e1a-acb7-d36e08009684}" label="Post Office" symbol="26" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'post_office'" scalemaxdenom="50000" />
      <rule key="{8cbeac4e-d0b8-5b95-b447-dcca12ac2c8a}" label="Railway Station" symbol="27" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'railway_station'" scalemaxdenom="50000" />
      <rule key="{157eacf5-26e3-5ad2-aff3-af23eeb75f49}" label="Restaurant" symbol="28" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'restaurant'" scalemaxdenom="50000" />
      <rule key="{129bf4fc-8a48-503a-90c1-3aec20e82c0b}" label="School" symbol="29" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'school'" scalemaxdenom="50000" />
      <rule key="{edce65a8-6b07-5f1f-aba7-89bd4671e887}" label="Shopping Mall" symbol="30" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'shopping_mall'" scalemaxdenom="50000" />
      <rule key="{8ff1f1ba-f0b9-5229-807e-207bb8f4cf59}" label="Stadium" symbol="31" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'stadium'" scalemaxdenom="250000" />
      <rule key="{cd531abd-9dfe-5ebf-bf52-8bfa71943aa4}" label="Supermarket" symbol="32" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'supermarket'" scalemaxdenom="50000" />
      <rule key="{f589abe6-f147-5be9-a7b9-6129c0ad2c66}" label="Theater" symbol="33" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'theater'" scalemaxdenom="50000" />
      <rule key="{81b3e583-a635-5e52-97f7-f4a976457f52}" label="University" symbol="34" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) = 'university'" scalemaxdenom="250000" />
      <rule key="{e65d9ecb-c6d1-5def-bed7-87ad59726562}" label="Services And Business" symbol="35" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'services_and_business' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{7913e212-bf71-5c94-a298-8177a1886f04}" label="Shopping" symbol="36" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'shopping' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{13678131-51f2-59dd-90ae-3216d5f9ddec}" label="Food And Drink" symbol="37" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'food_and_drink' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{ba6f7d40-493f-5783-8c19-72cd946e337b}" label="Lifestyle Services" symbol="38" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'lifestyle_services' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{44e9a88c-33dc-589c-879d-7359b5bedb9a}" label="Travel And Transportation" symbol="39" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'travel_and_transportation' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="250000" />
      <rule key="{03e1ed6b-b647-5569-9875-0d099dea94a7}" label="Health Care" symbol="40" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'health_care' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{1d68f256-59cc-5e21-a52a-bf9c82cad7ea}" label="Education" symbol="41" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'education' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{f2d3c866-d395-5a91-a197-723d19480a92}" label="Cultural And Historic" symbol="42" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'cultural_and_historic' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{995148af-51eb-54d7-a36d-b9eb276c7397}" label="Sports And Recreation" symbol="43" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'sports_and_recreation' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{0fea934f-40c7-503d-a69c-502ec9087dd7}" label="Community And Government" symbol="44" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'community_and_government' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{b944f56e-4c02-524f-8420-c4f927b04c20}" label="Lodging" symbol="45" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'lodging' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{e0f99ec1-e579-5344-885a-a9520fe3479a}" label="Arts And Entertainment" symbol="46" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'arts_and_entertainment' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="50000" />
      <rule key="{229f434b-0dd5-52f9-bf49-0b92e52d5622}" label="Geographic Entities" symbol="47" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) = 'geographic_entities' AND (coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) IS NULL OR coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary')) NOT IN ('airport','atm','bakery','bank','bar','beach','bus_station','cafe','casual_eatery','charging_station','cinema','clinic','ferry_terminal','fire_station','fuel','hospital','hotel','library','museum','park','parking','peak','pharmacy','place_of_worship','playground','police','post_office','railway_station','restaurant','school','shopping_mall','stadium','supermarket','theater','university'))" scalemaxdenom="250000" />
      <rule key="{e1b47113-5e25-5cd2-b53e-744ee490052f}" label="Unclassified open place" symbol="48" filter="coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND array_first(attribute(@feature, 'taxonomy.hierarchy')) IS NULL" scalemaxdenom="10000" />
      <rule key="{f7778314-d7cc-58b1-a37e-ccedb61c956b}" label="Suppressed closed place" symbol="49" filter="ELSE" scalemaxdenom="10000" />
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="0" type="marker">
        <layer class="SvgMarker" enabled="1" id="{f0784f72-8f3d-5089-a0fd-87cd6a5bd203}" locked="0" pass="0">
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
        <layer class="SvgMarker" enabled="1" id="{085f11ac-ba9d-5900-ab49-41ca7f2f0e2e}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDlsMTAtNiAxMCA2ek00IDEwaDE2TTUgMTB2OE05IDEwdjhNMTUgMTB2OE0xOSAxMHY4TTMgMTloMTh2MkgzeiIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IGJhbms8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{41ea3975-5919-57f7-af8b-4d835daef097}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="213,107,71,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZsMiA2YTQgNCAwIDAxLTUgMyA0IDQgMCAwMS01IDAgNCA0IDAgMDEtNSAwIDQgNCAwIDAxLTUtM3pNNCAxMnY5aDE2di05Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2hvcDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{f9109a85-62cc-5b3b-875b-213d87b592e3}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="85,125,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDlsMTAtNiAxMCA2ek00IDEwaDE2TTUgMTB2OE05IDEwdjhNMTUgMTB2OE0xOSAxMHY4TTMgMTloMTh2MkgzeiIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IGJhbms8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{358f16e4-35a8-5df5-92c1-1db26bf15e51}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="213,107,71,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDRoMTZsLTcgOHY2aDR2Mkg3di0yaDR2LTZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYmFyPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
        <layer class="SvgMarker" enabled="1" id="{4f2e6e5a-e0f8-5ca3-b763-86b746a9d7b8}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="143,189,120,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDIwTDkgN2wzIDQgMy02IDcgMTV6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogcGVhazwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{97737c7d-cf4a-5f45-ac66-47c32e4cabc3}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="7" type="marker">
        <layer class="SvgMarker" enabled="1" id="{dfe06c5c-88ea-5fd9-b1fd-9f37de725b4b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="213,107,71,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDdoMTN2OGE1IDUgMCAwMS01IDVIOWE1IDUgMCAwMS01LTV6TTE3IDloMmEzIDMgMCAwMTAgNmgtMiIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IGNhZmU8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{98acd9e4-beeb-5304-b907-db7ff9e842f3}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="213,107,71,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik02IDJ2OE0zIDJ2NWEzIDMgMCAwMDYgMFYyTTYgMTB2MTJNMTUgMnYyME0xNSAyYTUgOCAwIDAxMCAxMiIgZmlsbD0ibm9uZSIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHJlc3RhdXJhbnQ8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{9f5a4d3b-4753-52c7-8614-8f146f2d9730}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="10" type="marker">
        <layer class="SvgMarker" enabled="1" id="{4fad3dab-e422-5eaf-9945-a2fb19541567}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="155,118,83,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZ2MTRINHoiLz48cGF0aCBkPSJNOCAyMWg4TTEyIDE3djQiIGZpbGw9Im5vbmUiLz48Y2lyY2xlIGN4PSI5IiBjeT0iOSIgcj0iMiIvPjxwYXRoIGQ9Ik0xMyAxM2wzLTQgMyA1IiBmaWxsPSJub25lIi8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYXJ0czwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{f6586b5e-4266-5b6f-9fa8-8a4e65ceb2a1}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="216,77,91,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik05IDNoNnY2aDZ2NmgtNnY2SDl2LTZIM1Y5aDZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogaG9zcGl0YWw8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{de7b95c8-5b56-5371-8271-5dc7c70a46fc}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="13" type="marker">
        <layer class="SvgMarker" enabled="1" id="{19973061-a1d9-55f4-9f77-13a4eaf838e0}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="213,184,200,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="14" type="marker">
        <layer class="SvgMarker" enabled="1" id="{56a5ebf5-c9ab-5c2b-9d26-770a3d09960f}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="72,121,168,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="15" type="marker">
        <layer class="SvgMarker" enabled="1" id="{360d47b4-bb35-5ee6-bc0c-961132378346}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="216,77,91,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik05IDNoNnY2aDZ2NmgtNnY2SDl2LTZIM1Y5aDZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogaG9zcGl0YWw8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{2092fb3d-05dc-5859-96a0-79238756e6a0}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="231,198,183,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDVoMTh2MTVIM3pNNiA4aDR2NEg2ek0xNCA4aDR2NGgtNHpNNSAxNmgxNCIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IGhvdGVsPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
        <layer class="SvgMarker" enabled="1" id="{58ce2ef5-3c5e-5b4e-a5c9-62fbe24358db}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="79,142,128,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1LTEwIDV6TTYgMTF2NmM0IDMgOCAzIDEyIDB2LTZNMjEgOXY4Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2Nob29sPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
        <layer class="SvgMarker" enabled="1" id="{a42dd263-d063-585b-bb57-f69659fc253b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="155,118,83,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1ek00IDloMTZNNSAxMHY4TTkgMTB2OE0xNSAxMHY4TTE5IDEwdjhNMyAxOWgxOCIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IG11c2V1bTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{9cfed649-572e-5c2f-9ed9-11285dc52d53}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="79,153,112,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMiAybDUgN2gtM2w1IDdoLTZ2NmgtMnYtNkg1bDUtN0g3eiIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHBhcms8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{9cc6bdf5-1e83-501d-b557-5750df4f9392}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="21" type="marker">
        <layer class="SvgMarker" enabled="1" id="{ef08a14f-db24-5f60-8a34-f97102dfbe47}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="143,189,120,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDIwTDkgN2wzIDQgMy02IDcgMTV6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogcGVhazwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{d1ab54c8-22c4-5a91-ae6f-cefc996fcd6a}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="216,77,91,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik05IDNoNnY2aDZ2NmgtNnY2SDl2LTZIM1Y5aDZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogaG9zcGl0YWw8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{d24ba53c-96e6-5e12-bfe0-5793614e3ba8}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="155,118,83,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMiAydjIwTTcgN2gxME01IDEybDctNSA3IDV2OUg1eiIgZmlsbD0ibm9uZSIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHdvcnNoaXA8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{d36771af-261a-5728-b95e-aadcfa18d5b5}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="79,153,112,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xMiAybDUgN2gtM2w1IDdoLTZ2NmgtMnYtNkg1bDUtN0g3eiIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHBhcms8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{346a3c6d-1c96-5234-b5bd-3a35fc03abf3}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="213,184,200,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="26" type="marker">
        <layer class="SvgMarker" enabled="1" id="{844336b0-c767-5a9d-9757-b9690112c01c}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="213,184,200,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="27" type="marker">
        <layer class="SvgMarker" enabled="1" id="{845c8ea7-c6ed-5018-98ea-c13b3f57382a}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="28" type="marker">
        <layer class="SvgMarker" enabled="1" id="{81b769e1-0866-58cf-bdf3-af3ef4a84799}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="213,107,71,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik02IDJ2OE0zIDJ2NWEzIDMgMCAwMDYgMFYyTTYgMTB2MTJNMTUgMnYyME0xNSAyYTUgOCAwIDAxMCAxMiIgZmlsbD0ibm9uZSIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHJlc3RhdXJhbnQ8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
        <layer class="SvgMarker" enabled="1" id="{308d0f07-ffd5-5455-82d6-67e03d193ef0}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="79,142,128,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1LTEwIDV6TTYgMTF2NmM0IDMgOCAzIDEyIDB2LTZNMjEgOXY4Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2Nob29sPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
        <layer class="SvgMarker" enabled="1" id="{a2a24e1f-b84c-5fbe-881f-a9221718d883}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="154,99,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZsMiA2YTQgNCAwIDAxLTUgMyA0IDQgMCAwMS01IDAgNCA0IDAgMDEtNSAwIDQgNCAwIDAxLTUtM3pNNCAxMnY5aDE2di05Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2hvcDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{4ddb243e-190e-500c-ad8b-6611f7a11980}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="79,153,112,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxjaXJjbGUgY3g9IjEyIiBjeT0iMTIiIHI9IjkiLz48cGF0aCBkPSJNNSA3bDE0IDEwTTcgMTlsMTAtMTQiIGZpbGw9Im5vbmUiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiBzcG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{a5f015da-a560-51d9-9ad8-4e2725e4ed5a}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="154,99,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZsMiA2YTQgNCAwIDAxLTUgMyA0IDQgMCAwMS01IDAgNCA0IDAgMDEtNSAwIDQgNCAwIDAxLTUtM3pNNCAxMnY5aDE2di05Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2hvcDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{74eeb02d-43c1-5f59-9b09-ffab2a6ea164}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="155,118,83,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZ2MTRINHoiLz48cGF0aCBkPSJNOCAyMWg4TTEyIDE3djQiIGZpbGw9Im5vbmUiLz48Y2lyY2xlIGN4PSI5IiBjeT0iOSIgcj0iMiIvPjxwYXRoIGQ9Ik0xMyAxM2wzLTQgMyA1IiBmaWxsPSJub25lIi8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYXJ0czwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
        <layer class="SvgMarker" enabled="1" id="{5482805e-1ad9-5745-8438-b2cc9c50a050}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="79,142,128,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1LTEwIDV6TTYgMTF2NmM0IDMgOCAzIDEyIDB2LTZNMjEgOXY4Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2Nob29sPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
        <layer class="SvgMarker" enabled="1" id="{8041425a-9a30-5d7c-9351-ef1fd0c6b5e1}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="36" type="marker">
        <layer class="SvgMarker" enabled="1" id="{447f321b-b875-5059-ab27-949ee51b15f5}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="154,99,168,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZsMiA2YTQgNCAwIDAxLTUgMyA0IDQgMCAwMS01IDAgNCA0IDAgMDEtNSAwIDQgNCAwIDAxLTUtM3pNNCAxMnY5aDE2di05Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2hvcDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="37" type="marker">
        <layer class="SvgMarker" enabled="1" id="{6d9bdc01-7e30-5464-9161-5cd13ae11d79}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="213,107,71,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik02IDJ2OE0zIDJ2NWEzIDMgMCAwMDYgMFYyTTYgMTB2MTJNMTUgMnYyME0xNSAyYTUgOCAwIDAxMCAxMiIgZmlsbD0ibm9uZSIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IHJlc3RhdXJhbnQ8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="38" type="marker">
        <layer class="SvgMarker" enabled="1" id="{dd04bc94-d04e-57ba-bf0f-b7a458704564}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="39" type="marker">
        <layer class="SvgMarker" enabled="1" id="{ddbf9958-ff0b-525f-b03d-ea194ec6e9de}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="40" type="marker">
        <layer class="SvgMarker" enabled="1" id="{16bf0afd-646d-5012-89bb-7c314afbd1f7}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="216,77,91,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik05IDNoNnY2aDZ2NmgtNnY2SDl2LTZIM1Y5aDZ6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogaG9zcGl0YWw8L21ldGFkYXRhPgo8L3N2Zz4K" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="41" type="marker">
        <layer class="SvgMarker" enabled="1" id="{6eaf50eb-6dda-5cf0-8dca-7fb92d6c14aa}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="79,142,128,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1LTEwIDV6TTYgMTF2NmM0IDMgOCAzIDEyIDB2LTZNMjEgOXY4Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2Nob29sPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="42" type="marker">
        <layer class="SvgMarker" enabled="1" id="{2912ee0f-4537-5e50-b4f4-eebf74781d46}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="155,118,83,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDhsMTAtNSAxMCA1ek00IDloMTZNNSAxMHY4TTkgMTB2OE0xNSAxMHY4TTE5IDEwdjhNMyAxOWgxOCIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IG11c2V1bTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="43" type="marker">
        <layer class="SvgMarker" enabled="1" id="{7e964a8a-0db6-5929-bbe9-bb4d6f631d42}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="79,153,112,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxjaXJjbGUgY3g9IjEyIiBjeT0iMTIiIHI9IjkiLz48cGF0aCBkPSJNNSA3bDE0IDEwTTcgMTlsMTAtMTQiIGZpbGw9Im5vbmUiLz4KICA8L2c+CiAgPG1ldGFkYXRhPk9yaWdpbmFsIG9mZmxpbmUgc3ltYm9sIGZvciBPdmVydHVyZSBzY2hlbWEgMS4xOC4wOiBzcG9ydDwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="44" type="marker">
        <layer class="SvgMarker" enabled="1" id="{e9ded1dd-302e-5d10-b526-cef9afb5d0a4}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="213,184,200,255" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="45" type="marker">
        <layer class="SvgMarker" enabled="1" id="{4bb425b6-b6b0-5485-85b2-e560bbea0e38}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="231,198,183,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0zIDVoMTh2MTVIM3pNNiA4aDR2NEg2ek0xNCA4aDR2NGgtNHpNNSAxNmgxNCIvPgogIDwvZz4KICA8bWV0YWRhdGE+T3JpZ2luYWwgb2ZmbGluZSBzeW1ib2wgZm9yIE92ZXJ0dXJlIHNjaGVtYSAxLjE4LjA6IGhvdGVsPC9tZXRhZGF0YT4KPC9zdmc+Cg==" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="46" type="marker">
        <layer class="SvgMarker" enabled="1" id="{e58545ae-a3df-5b3e-ab8d-88223aaad0e9}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="155,118,83,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik00IDNoMTZ2MTRINHoiLz48cGF0aCBkPSJNOCAyMWg4TTEyIDE3djQiIGZpbGw9Im5vbmUiLz48Y2lyY2xlIGN4PSI5IiBjeT0iOSIgcj0iMiIvPjxwYXRoIGQ9Ik0xMyAxM2wzLTQgMyA1IiBmaWxsPSJub25lIi8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogYXJ0czwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="47" type="marker">
        <layer class="SvgMarker" enabled="1" id="{9af0fa32-9b1f-5624-a5ff-ca93f0f22e23}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="143,189,120,255" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0yIDIwTDkgN2wzIDQgMy02IDcgMTV6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogcGVhazwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="48" type="marker">
        <layer class="SvgMarker" enabled="1" id="{34249392-a177-5ddb-bc69-4ab3996c9191}" locked="0" pass="0">
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
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" frame_rate="10" is_animated="0" name="49" type="marker">
        <layer class="SvgMarker" enabled="1" id="{4434a8d0-258a-5b1f-b085-46bdf5c9262b}" locked="0" pass="0">
          <prop k="angle" v="0" />
          <prop k="color" v="154,160,166,0" />
          <prop k="fixedAspectRatio" v="0" />
          <prop k="horizontal_anchor_point" v="1" />
          <prop k="name" v="base64:PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij4KICA8ZyBmaWxsPSJwYXJhbShmaWxsKSAjNGY3ZWE4IiBzdHJva2U9InBhcmFtKG91dGxpbmUpICNmZmZmZmYiIHN0cm9rZS13aWR0aD0icGFyYW0ob3V0bGluZS13aWR0aCkgMSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj4KICAgIDxwYXRoIGQ9Ik0xNCAzYTUgNSAwIDAxLTUgN0w0IDIxbC0yLTIgOS05YTUgNSAwIDAxNy02bC0zIDMgMiAyIDMtM2E1IDUgMCAwMS02IDd6Ii8+CiAgPC9nPgogIDxtZXRhZGF0YT5PcmlnaW5hbCBvZmZsaW5lIHN5bWJvbCBmb3IgT3ZlcnR1cmUgc2NoZW1hIDEuMTguMDogc2VydmljZTwvbWV0YWRhdGE+Cjwvc3ZnPgo=" />
          <prop k="offset" v="0,0" />
          <prop k="offset_unit" v="MM" />
          <prop k="outline_color" v="102,112,120,0" />
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
    <property key="overture/palette" value="light" />
    <property key="overture/description" value="places-place-point light style bound to Overture schema 1.18.0" />
    <property key="overture/compatibility" value="Bound to Overture schema 1.18.0; other versions are unverified" />
  </customproperties>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style allowHtml="0" blendMode="0" capitalization="0" fieldName="CASE WHEN coalesce(attribute(@feature, 'operating_status'), 'open') &lt;&gt; 'permanently_closed' AND (attribute(@feature, 'confidence') IS NULL OR attribute(@feature, 'confidence') &gt;= 0.5) THEN coalesce(map_get(attribute(@feature, 'names.common'), left(@qgis_locale, 2)), map_get(attribute(@feature, 'names.common'), 'en'), attribute(@feature, 'names.primary')) END" fontFamily="Noto Sans" fontItalic="0" fontKerning="1" fontLetterSpacing="0" fontSize="9" fontSizeUnit="Point" fontStrikeout="0" fontUnderline="0" fontWeight="400" fontWordSpacing="0" forcedBold="0" forcedItalic="0" isExpression="1" multilineHeight="1" namedStyle="Regular" textColor="38,50,56,255" textOpacity="1" textOrientation="horizontal">
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
