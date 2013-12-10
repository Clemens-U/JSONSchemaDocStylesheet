<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output version="4.0" method="html" indent="yes" encoding="UTF-8"/>
	<xsl:template match="/">
	
	<html>
	<body>
	<h2>JSON Schema Documentation</h2>
		<xsl:apply-templates/>
	</body>
	</html>
	</xsl:template>
	
	<!-- turn-off built-in text template -->
	<xsl:template match="text()"/>

	<!--<xsl:template match="*[(count(child::type) > 0) and (count(child::type[text() = 'object']) = 0)]">
		<xsl:value-of select="child::type/text()"/>
	</xsl:template> -->
	
	<xsl:template match="*">
		<p>Any node, name: <xsl:value-of select="name(.)"/></p>
		<xsl:apply-templates  select="child::*"/>
	</xsl:template>
	
	<!--<xsl:template match="*[count(child::type) = 1]">
		<p>xsl_template match="*[count(child::type) = 1]</p>
		
		<xsl:if test="count(child::title) = 1">
			<p>Title: <xsl:value-of select="title"/></p>
		</xsl:if>
		
		<xsl:if test="count(child::description) = 1">
			<p>Description: <xsl:value-of select="description"/></p>
		</xsl:if>
		
		<xsl:if test="count(child::description) = 1">
			<p>Type: <xsl:value-of select="child::type/text()"/></p>
		</xsl:if>
		
		<xsl:apply-templates/>
	</xsl:template>-->
	
	<xsl:template match="properties">
		<table border="1">
			<tr>
				<td colspan="2">Properties</td>
			</tr>
			<tr>
				<td>Name</td><td>Schema</td>
			</tr>
			<xsl:for-each select="*">
				<tr>
					<td>
						<xsl:value-of select="name(.)"/>
					</td>
					<td>
						<xsl:for-each select="child::*">
							<xsl:if test="count(child::title) = 1">
								<p>Title: <xsl:value-of select="title"/></p>
							</xsl:if>
							
							<xsl:if test="count(child::description) = 1">
								<p>Description: <xsl:value-of select="description"/></p>
							</xsl:if>
							
							<xsl:if test="count(child::description) = 1">
								<p>Type: <xsl:value-of select="child::type/text()"/></p>
							</xsl:if>
							
							<xsl:apply-templates/>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template match="definitions">
		<h3>Definitions</h3>
		<xsl:for-each select="child::*">
			<p>Name: <xsl:value-of select="name(.)"/></p>
			<xsl:apply-templates  select="."/>
		</xsl:for-each>
	</xsl:template>	
</xsl:stylesheet>
