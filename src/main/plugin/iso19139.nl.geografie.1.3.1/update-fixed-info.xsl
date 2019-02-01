<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0" xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" >
	<xsl:import href="../iso19139/update-fixed-info.xsl" />

	<!-- Dutch profile uses gco:Date instead of gco:DateTime -->
	<xsl:template match="gmd:dateStamp" priority="99">
		<xsl:choose>
			<xsl:when test="/root/env/changeDate">
				<xsl:copy>
					<gco:Date>
						 <xsl:value-of select="tokenize(/root/env/changeDate,'T')[1]" />
					</gco:Date>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="." />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <xsl:template match="gmd:MD_DataIdentification" priority="200">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:apply-templates select="gmd:citation" />
      <xsl:apply-templates select="gmd:abstract" />
      <xsl:apply-templates select="gmd:purpose" />
      <xsl:apply-templates select="gmd:credit" />
      <xsl:apply-templates select="gmd:status" />
      <xsl:apply-templates select="gmd:pointOfContact" />
      <xsl:apply-templates select="gmd:resourceMaintenance" />
      <xsl:apply-templates select="gmd:graphicOverview" />
      <xsl:apply-templates select="gmd:resourceFormat" />
      <xsl:apply-templates select="gmd:descriptiveKeywords" />
      <xsl:apply-templates select="gmd:resourceSpecificUsage" />

      <!-- Order resource constraints. Related schematron validations depends on the order of the constraints
          - gmd:MD_Constraints
          - gmd:MD_LegalConstraints
          - gmd:MD_SecurityConstraints
      -->
      <xsl:apply-templates select="gmd:resourceConstraints[gmd:MD_Constraints]" />
      <xsl:apply-templates select="gmd:resourceConstraints[gmd:MD_LegalConstraints]" />
      <xsl:apply-templates select="gmd:resourceConstraints[gmd:MD_SecurityConstraints]" />

      <xsl:apply-templates select="gmd:aggregationInfo" />
      <xsl:apply-templates select="gmd:spatialRepresentationType" />
      <xsl:apply-templates select="gmd:spatialResolution" />
      <xsl:apply-templates select="gmd:language" />
      <xsl:apply-templates select="gmd:characterSet" />
      <xsl:apply-templates select="gmd:topicCategory" />
      <xsl:apply-templates select="gmd:environmentDescription" />
      <xsl:apply-templates select="gmd:extent" />
      <xsl:apply-templates select="gmd:supplementalInformation" />
    </xsl:copy>
  </xsl:template>

	<!-- remove gmd:identifier with gmx:Anchor inside gmd:code
    <xsl:template match="gmd:identifier[name(*/gmd:code/*) = 'gmx:Anchor']" />-->
    <!-- remove gmd:identifier in gmd:thesaurusName with gmx:Anchor inside gmd:code -->
    <!--<xsl:template match="gmd:thesaurusName/*/gmd:identifier[name(*/gmd:code/*) = 'gmx:Anchor']" />-->

    <!-- remove http://www.fao.org/geonetwork namespace
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:copy-of select="namespace::*[not(. = 'http://www.fao.org/geonetwork')]"/>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*[@xmlns:gn='http://www.fao.org/geonetwork']/@xmlns:gn|@xmlns:geonet='http://www.fao.org/geonetwork']/@xmlns:geonet" /> -->

</xsl:stylesheet>
