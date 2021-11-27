<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://schemas.microsoft.com/wix/2006/wi"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wix="http://schemas.microsoft.com/wix/2006/wi">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="wix:Wix">
    <xsl:copy>
      <xsl:text>&#10;  </xsl:text>
      <xsl:text disable-output-escaping="yes">&lt;?include Includes.wxi ?&gt;</xsl:text>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="wix:DirectoryRef[@Id='TARGETDIR']">
    <xsl:text disable-output-escaping="yes">&lt;!-- &lt;DirectoryRef Id="TARGETDIR%&gt; --&gt;</xsl:text>
    <xsl:apply-templates />
    <xsl:text disable-output-escaping="yes">&lt;!-- &lt;/DirectoryRef&gt; --&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="wix:Directory[@Id='app']">
    <DirectoryRef Id="INSTALLDIR" >
      <xsl:apply-templates />
	</DirectoryRef>
  </xsl:template>

</xsl:stylesheet>

