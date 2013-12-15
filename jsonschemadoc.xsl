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
					padding-left: 10px;
					padding-right: 4px;
					padding-bottom: 4px;
				}
				
				.table-defs {
					width:100%;
					padding-left: 10px;
					padding-right: 4px;
					padding-bottom: 4px;
				}
				
				.prop-info {
					font-size: small
				}
			</style>
			
			<head>
				<script type="text/javascript">
				function hide_structure_table()
				{
					var x = document.getElementById("structure_table");
					x.style.display = "none";
				}
				function show_structure_table()
				{
					var x = document.getElementById('structure_table');
					x.style.display = "";
				}
				function toggle_structure_table()
				{
					var x = document.getElementById('structure_table');
					
					if(x.style.display == "")
						x.style.display = "none";
					else
						x.style.display = "";
				}				
				</script>
			</head>
			
			<body>
				<h2>JSON Schema Documentation</h2>
				
				<table border="0">
					<tr><td>Description: <xsl:value-of select="description/text()"/></td></tr>
					<tr><td>id: <xsl:value-of select="id/text()"/></td></tr>
					<tr><td>$schema: <xsl:value-of select="schema/text()"/></td></tr>
				</table>
				
				<p></p>
				
				<div style="width:700px; resize:horizontal; overflow:auto">
					<xsl:call-template name="structure"/>
				</div>
				
				<div style="width:500px; resize:horizontal; overflow:auto">
					<xsl:call-template name="definitions"/>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="structure">
		<h3>Schema structure</h3>
		<!-- <input type = "button" value="Show/hide structure" onclick = "toggle_structure_table()" /> -->
		
		<table class="table-std" id="structure_table">
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
									<xsl:variable name="curr_name" select="name(.)"/>
									<xsl:choose>
										<xsl:when test="parent::*/parent::*/required and (parent::*/parent::*/required[text() = $curr_name])">
											<strong><xsl:value-of select="name(.)"/></strong>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="name(.)"/>
										</xsl:otherwise>
									</xsl:choose>
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
								<td class="prop-info"><xsl:value-of select="description/text()"/></td>
							</tr>
						</xsl:if>
						
						<xsl:if test="child::pattern">
							<tr>
								<td class="prop-info">
									<div style="float: left;">
										Pattern:
									</div>
						
									<div style="float: right;">
										<xsl:value-of select="pattern/text()"/>
									</div>
								</td>
							</tr>
						</xsl:if>
						
						<xsl:if test="child::enum">
							<tr>
								<td class="prop-info">
								Enumeration:
								<xsl:for-each select="child::enum">
									<xsl:choose>
										<xsl:when test="position() = last()">
											<xsl:value-of select="text()"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="text()"/>,
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
								</td>
							</tr>
						</xsl:if>
						
						<xsl:if test="child::oneOf">
							<xsl:call-template name="oneOf"/>
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
					
					<table border="0" width="100%">
						<tr>
							<td>
								<div style="float: left;">
									<xsl:if test="child::title">
										<xsl:value-of select="title/text()"/>
									</xsl:if>
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
							<td class="prop-info"><xsl:value-of select="description/text()"/></td>
						</tr>
						</xsl:if>

						<xsl:if test="child::oneOf">
							<xsl:call-template name="oneOf"/>
						</xsl:if>
					</table>
					
					<xsl:if test="child::type and ((child::type/text() = 'object') or (child::type/text() = 'array'))">
						<table class="table-std">
							<xsl:apply-templates  select="child::*" mode="structure"/>
						</table>
					</xsl:if>
				</xsl:if>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template name="oneOf">
		<tr><td>One of:</td></tr>
		<tr>
			<td>
				<table border="0" width="100%">
					<tr>
						<xsl:for-each select="child::oneOf">
							<td>
								<table class="table-std" id="structure_table">
									<xsl:for-each select="child::*">
										<xsl:apply-templates  select="." mode="structure"/>
									</xsl:for-each>
								</table>
							</td>
						</xsl:for-each>
					</tr>
				</table>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="ref" mode="structure">
		<tr>
			<td class="prop-info">
				<a>
					<xsl:attribute name="href">#<xsl:value-of select="substring(text(), 3)"/>/<xsl:value-of select="count(ancestor::*) - 3"/></xsl:attribute>
					<xsl:value-of select="text()"/>
				</a>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="format" mode="structure">
		<tr>
			<td class="prop-info">
				Format: <xsl:value-of select="text()"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="enum" mode="structure">
	</xsl:template>
	
	<xsl:template name="definitions">
		<h3>Definitions</h3>
		
		<table class="table-defs">
			<xsl:for-each select="child::*">
				<xsl:apply-templates  select="." mode="definitions"/>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template match="*" mode="definitions">
		<xsl:for-each select="child::*">
			<xsl:apply-templates select="." mode="definitions"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="definitions" mode="definitions">
		<xsl:for-each select="child::*">
		<!-- Each child in the definitions element is a single definition-->
		<tr>
			<xsl:attribute name="id">definitions/<xsl:value-of select="name(.)"/>/<xsl:value-of select="count(ancestor::*) - 1"/></xsl:attribute>
			<td>
				<xsl:value-of select="name(.)"/>
			</td>
		</tr>
		<tr>
			<td>
				<table class="table-std" id="structure_table">
					<xsl:for-each select="child::*">
						<xsl:apply-templates  select="." mode="structure"/>
					</xsl:for-each>
				</table>
			</td>
		</tr>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
