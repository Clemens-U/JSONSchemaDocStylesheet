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
	
	<xsl:template match="//*[count(child::type[text() = 'object']) > 0]">
		<p>
			<h3>Description</h3>
			<xsl:value-of select="description"/>
		</p>
		
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="properties">
		<h3>Properties</h3>
		<table border="1">
			<tr>
				<td>Name</td><td>Schema</td>
			</tr>
			<xsl:for-each select="*">
				<tr>
					<td>
						<xsl:value-of select="name(.)"/>
					</td>
					<td>
						<xsl:apply-templates/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
</xsl:stylesheet>
