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
				
				<p>Description: <xsl:value-of select="description/text()"/></p>
				
				<div style="width:600px; resize:horizontal; overflow:auto">
					<xsl:call-template name="structure"/>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="structure">
		<h3>Schema structure</h3><input type = "button" value="Show/hide structure" onclick = "toggle_structure_table()" />
		
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
							<td><xsl:value-of select="description/text()"/></td>
						</tr>
						</xsl:if>
						<xsl:if test="child::enum">
							<tr>
								<td>
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
							<td><xsl:value-of select="description/text()"/></td>
						</tr>
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
	
	<xsl:template match="enum" mode="structure">
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
