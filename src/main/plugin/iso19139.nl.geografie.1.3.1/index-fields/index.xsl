<?xml version="1.0" encoding="UTF-8" ?>
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
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gmi="http://www.isotc211.org/2005/gmi"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:daobs="http://daobs.org"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:import href="../../iso19139/index-fields/index.xsl" />


  <xsl:template match="*" mode="index-extra-fields">
    <xsl:variable name="licenseMap">
      <license value="http://creativecommons.org/publicdomain/mark/1.0/deed.nl">Public Domain</license>
      <license value="http://creativecommons.org/licenses/publicdomain/deed.nl">Public Domain</license>
    </xsl:variable>

    <xsl:for-each select="gmd:identificationInfo[1]/*[1]">
      <xsl:for-each select="gmd:resourceConstraints">
        <xsl:for-each select="*/gmd:otherConstraints/gco:CharacterString">

          <xsl:variable name="otherConstraint" select="."/>

          <xsl:choose>
            <xsl:when test=".='Public Domain'
							or .='http://creativecommons.org/publicdomain/mark/1.0/deed.nl'
							or .='http://creativecommons.org/licenses/publicdomain/deed.nl'
							or .='Open Database License (ODbL)'">
              <license><xsl:value-of select="if ($licenseMap/license[@value=$otherConstraint])
								then $licenseMap/license[@value=$otherConstraint]
								else $otherConstraint" /></license>
            </xsl:when>

            <xsl:when test="contains(.,'Geo Gedeeld licentie')">
              <license>Geo Gedeeld licentie</license>
            </xsl:when>

            <xsl:when test="starts-with($otherConstraint, 'http://creativecommons.org/publicdomain/zero/')
							or .='Creative Commons CC0'">
              <license>CC0</license>
            </xsl:when>

            <xsl:when test="starts-with($otherConstraint, 'http://creativecommons.org/licenses/by/')">
              <license>CC-BY</license>
            </xsl:when>

            <xsl:when test=".='Geen beperkingen'"></xsl:when>

            <xsl:otherwise>
              <!-- 14-11 JB: OtherConstraints no longer needed -->
              <!--Field name="license" string="OtherConstraints" store="true" index="true"/-->
            </xsl:otherwise>
          </xsl:choose>

        </xsl:for-each>
      </xsl:for-each>

    </xsl:for-each>

  </xsl:template>
</xsl:stylesheet>
