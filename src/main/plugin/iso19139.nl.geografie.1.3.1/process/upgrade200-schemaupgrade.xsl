<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:java="java:org.fao.geonet.util.XslUtil" version="2.0"
                exclude-result-prefixes="#all">

  <xsl:import href="process-utility.xsl"/>

  <!-- See WEB-INF/oasis-catalog.xml -->
  <xsl:import href="../../../xsl/utils-fn.xsl"/>

  <xsl:variable name="thesauriDir" select="java:getThesaurusDir()"/>

  <xsl:variable name="inspire-thesaurus"
    select="document(concat('file:///', replace($thesauriDir, '\\', '/'), '/external/thesauri/theme/httpinspireeceuropaeutheme-theme.rdf'))"/>
  <xsl:variable name="inspire-theme" select="$inspire-thesaurus//skos:Concept"/>
  
  <!-- i18n information -->
  <xsl:variable name="upgrade-schema-version-loc">
    <msg id="a" xml:lang="eng">Update metadata to Nederlandse metadata profiel op ISO 19115 voor geografie 2.0</msg>
    <msg id="a" xml:lang="dut">Update metadata to Nederlandse metadata profiel op ISO 19115 voor geografie 2.0</msg>
  </xsl:variable>

  <xsl:template name="list-upgrade200-schemaupgrade">
    <suggestion process="upgrade-schema-version"/>
  </xsl:template>

  <!-- Analyze the metadata record and return available suggestion
    for that process -->
  <xsl:template name="analyze-upgrade200-schemaupgrade">
    <xsl:param name="root"/>
      <suggestion process="upgrade200-schemaupgrade" id="{generate-id()}" category="keyword"
                  target="keyword">
        <name xml:lang="en">
          <xsl:value-of select="geonet:i18n($upgrade-schema-version-loc, 'a', $guiLang)"/>
        </name>
        <operational>true</operational>
        <form/>
      </suggestion>

  </xsl:template>

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Always remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>


  <!-- Update metadataStandardVersion -->
  <xsl:template match="gmd:metadataStandardVersion" priority="2">
    <gmd:metadataStandardVersion>
      <gco:CharacterString>Nederlandse metadata profiel op ISO 19115 voor geografie 2.0</gco:CharacterString>
    </gmd:metadataStandardVersion>
  </xsl:template>
  
  
  <!-- Use Anchor for gmd:MD_Identifier/gmd:code -->
  <!-- Keep xlink:href empty so users can fill the proper value -->
  <xsl:template match="gmd:identifier/gmd:MD_Identifier/gmd:code" priority="2">
    <xsl:copy>
      <xsl:copy-of select="@*" />
     <xsl:choose>
       <xsl:when test="gmx:Anchor">
         <xsl:apply-templates select="gmx:Anchor" />
       </xsl:when>
       <xsl:otherwise>
         <xsl:variable name="code" select="gco:CharacterString" />
         <gmx:Anchor
           xlink:href="">
           <xsl:value-of select="$code"/></gmx:Anchor>
       </xsl:otherwise>
     </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  
  <!-- Online resources description: accessPoint, endPoint -->
  <xsl:template match="gmd:onLine/gmd:CI_OnlineResource" priority="2">
    
    <xsl:copy>
      <xsl:copy-of select="@*" />
      
      <xsl:variable name="protocol" select="gmd:protocol/*/text()" />
    
      <xsl:apply-templates select="gmd:linkage" />
      <xsl:apply-templates select="gmd:protocol" />
      <xsl:apply-templates select="gmd:applicationProfile" />
      <xsl:apply-templates select="gmd:name" />
      
      <!-- gmd:description -->
      <xsl:choose>
        <!-- Access points -->
        <xsl:when test="geonet:contains-any-of($protocol, ('OGC:WMS', 'OGC:WMTS', 'OGC:WFS', 'OGC:WCS', 'INSPIRE Atom', 
          'landingpage', 'application', 'dataset', 'OGC:WPS', 'OGC:SOS', 
          'OGC:SensorThings', 'OAS', 'W3C:SPARQL', 'OASIS:OData', 'OGC:CSW',
          'OGC:WCTS', 'OGC:WFS-G', 'OGC:SPS', 'OGC:SAS', 'OGC:WNS', 'OGC:ODS', 'OGC:OGS', 'OGC:OUS', 'OGC:OPS', 'OGC:ORS', 'UKST'))">
                      
          <gmd:description>
            <gmx:Anchor
              xlink:href="http://inspire.ec.europa.eu/metadata-codelist/OnLineDescriptionCode/accessPoint">
              accessPoint</gmx:Anchor>
          </gmd:description>
        </xsl:when>
        
        <!-- End points -->
        <xsl:when test="geonet:contains-any-of($protocol, ('gml', 'geojson', 'gpkg', 'tiff', 'kml', 'csv', 'zip', 
          'wmc', 'json', 'jsonld', 'rdf-xml', 'xml', 'png', 'gif', 'jp2', 'mapbox-vector-tile', 'UKMT'))">
          <gmd:description>
            <gmx:Anchor
              xlink:href="http://inspire.ec.europa.eu/metadata-codelist/OnLineDescriptionCode/endPoint">
              endPoint</gmx:Anchor>
          </gmd:description>
        </xsl:when>
        
        <!-- Other cases: copy current gmd:description element -->
        <xsl:otherwise>
          <xsl:apply-templates select="gmd:description" />          
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:apply-templates select="gmd:function" />
    </xsl:copy>
  </xsl:template>
  
  
  <!-- Temporal element --> 
  <xsl:template match="gmd:extent/gml:TimePeriod[gml:begin]" priority="2">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      
      <gml:beginPosition><xsl:value-of select="gml:begin/gml:TimeInstant/gml:timePosition"/></gml:beginPosition> 
      <gml:endPosition><xsl:value-of select="gml:end/gml:TimeInstant/gml:timePosition"/></gml:endPosition> 
    </xsl:copy>
  </xsl:template>
  
  
  <!-- INSPIRE Theme thesaurus name -->
  <xsl:template match="gmd:thesaurusName/gmd:CI_Citation[gmd:title/gco:CharacterString = 'GEMET - INSPIRE themes, version 1.0']" priority="2">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      
      <gmd:title>
        <gmx:Anchor
          xlink:href="http://www.eionet.europa.eu/gemet/nl/inspire-themes/">GEMET - INSPIRE themes, version 1.0</gmx:Anchor>
      </gmd:title>
 
      <xsl:apply-templates select="gmd:alternateTitle" />
      <xsl:apply-templates select="gmd:date" />
      <xsl:apply-templates select="gmd:edition" />
      <xsl:apply-templates select="gmd:editionDate" />
      <xsl:apply-templates select="gmd:identifier" />
      <xsl:apply-templates select="gmd:citedResponsibleParty" />
      <xsl:apply-templates select="gmd:presentationForm" />
      <xsl:apply-templates select="gmd:series" />
      <xsl:apply-templates select="gmd:otherCitationDetails" />
      <xsl:apply-templates select="gmd:collectiveTitle" />
      <xsl:apply-templates select="gmd:otherCitationDetails" />
      <xsl:apply-templates select="gmd:ISBN" />
      <xsl:apply-templates select="gmd:ISSN" />
    </xsl:copy>
  </xsl:template>
  
  <!-- INSPIRE Theme keywords -->
  <xsl:template match="gmd:keyword[../gmd:thesaurusName/*/gmd:title/gco:CharacterString = 'GEMET - INSPIRE themes, version 1.0']" priority="2">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      
      <xsl:choose>
        <xsl:when test="gmx:Anchor">
          <xsl:apply-templates select="gmx:Anchor" />
        </xsl:when>
        
        <xsl:otherwise>                   
          <xsl:variable name="keyword" select="gco:CharacterString" />
          <xsl:variable name="inspireThemeURI" select="$inspire-theme[skos:prefLabel = $keyword]/@rdf:about"/>
          
          <gmx:Anchor
            xlink:href="{$inspireThemeURI}">
            <xsl:value-of select="$keyword" />
          </gmx:Anchor>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>