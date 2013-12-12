<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output version="4.0" method="html" indent="yes" encoding="UTF-8"/>

	<!-- turn-off built-in text template -->
	<xsl:template match="text()" mode="structure"/>
	
	<xsl:template match="/JSON">
		<html>
			<style type="text/css">
				.object-entry {
					background-color:#FFD493;
				}
				
				.array-entry {
					background-color:#7FA5FF;
				}

				.simple-entry {
					background-color:#BAFFD2;
				}
				
				.table-std {
					width:100%;
					border: 10px white;
				}
			</style>
			
			<body>
				<h2>JSON Schema Documentation</h2>
				
				<p>Description: <xsl:value-of select="description/text()"/></p>
				
				<div style="width:500px">
					<xsl:call-template name="structure"/>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="structure">
		<h3>Schema structure</h3>
		
		<table class="table-std">
			<xsl:for-each select="child::*">
				<xsl:apply-templates  select="." mode="structure"/>
			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template match="*" mode="structure">
		<!-- <xsl:if test="child::type/text() = 'object'">
			<p>Object: <xsl:value-of select="name(.)"/></p>
		</xsl:if> -->
	</xsl:template>
	
	<xsl:template match="properties" mode="structure">
		<xsl:for-each select="child::*">
			<tr>
				<td>
					<xsl:choose>
						<xsl:when test="child::type and child::type/text() = 'object'">
							<xsl:attribute name="class">object-entry</xsl:attribute>
						</xsl:when>
						<xsl:when test="child::type and child::type/text() = 'array'">
							<xsl:attribute name="class">array-entry</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">simple-entry</xsl:attribute>
						</xsl:otherwise>					
					</xsl:choose>
					
					<table border="0" width="100%">
						<tr>
							<td>
								<div style="float: left;">
									<xsl:value-of select="name(.)"/>
								</div>
					
								<div style="float: right;">
									<xsl:choose>
										<xsl:when test="child::type">
											<xsl:value-of select="type/text()"/>
										</xsl:when>
										<xsl:otherwise>
											Type not specified
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</td>
						</tr>
						<xsl:if test="child::description">
						<tr>
							<td>Description: <xsl:value-of select="description/text()"/></td>
						</tr>
						</xsl:if>
					</table>
					
					<xsl:if test="./*">
						<xsl:if test="child::type and ((child::type/text() = 'object') or (child::type/text() = 'array'))">
							<table class="table-std">
								<xsl:apply-templates  select="child::*" mode="structure"/>
							</table>
						</xsl:if>
					</xsl:if>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="items" mode="structure">
		<tr>
			<td>
				<xsl:if test="./*">
					<xsl:choose>
						<xsl:when test="child::type and child::type/text() ='object'">
							<xsl:attribute name="class">object-entry</xsl:attribute>
						</xsl:when>
						<xsl:when test="child::type and child::type/text() ='array'">
							<xsl:attribute name="class">array-entry</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">simple-entry</xsl:attribute>
						</xsl:otherwise>					
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="child::type">
							<p><xsl:value-of select="type/text()"/></p>
						</xsl:when>
						<xsl:otherwise>
							<p>Type not specified</p>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="child::description">
						<p>Description: <xsl:value-of select="description/text()"/></p>
					</xsl:if>
				
					<xsl:if test="child::type and ((child::type/text() = 'object') or (child::type/text() = 'array'))">
						<table class="table-std">
							<xsl:apply-templates  select="child::*" mode="structure"/>
						</table>
					</xsl:if>
				</xsl:if>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="properties" mode="definition">
		<tr>
			<td colspan="2">Properties</td>
		</tr>
		<tr>
			<td>Name</td><td>Schema</td>
		</tr>
		
		<xsl:for-each select="child::*">
		<tr>
			<td>
				<xsl:value-of select="name(.)"/>
			</td>
			<td>
				<table border="0">
					<xsl:for-each select="child::*">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</table>
			</td>
		</tr>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="definitions" mode="definition">
		<tr>
			<td>
				<h3>Definitions</h3>
				<table border="0">
					<xsl:for-each select="child::*">
						<xsl:apply-templates  select="."/>
					</xsl:for-each>
				</table>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="title">
		<tr>
			<td>
				<p>Title: <xsl:value-of select="text()"/></p>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="description">
		<tr>
			<td>
				<p>Description: <xsl:value-of select="text()"/></p>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="type" mode="definition">
		<tr>
			<td>
				<p>Type: <xsl:value-of select="text()"/></p>
			</td>
		</tr>
	</xsl:template>	
</xsl:stylesheet>
