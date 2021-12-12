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

  <xsl:template match="wix:Directory[starts-with(@Id, 'scala3')]">
    <Directory Id="INSTALLDIR" Name="Scala 3" >
      <xsl:apply-templates />
    </Directory>
  </xsl:template>

  <xsl:template match="wix:Component[@Id='scala']">
    <Component Id="repl.bat" Guid="PUT-GUID-HERE">
      <xsl:text>&#10;            </xsl:text>
      <File Id="repl.bat" KeyPath="yes" Source="!(bindpath.rsrc)\repl.bat" />
      <xsl:text>&#10;          </xsl:text>
    </Component>
    <xsl:text>&#10;          </xsl:text>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="wix:ComponentGroup[@Id='PackFiles']">
    <ComponentGroup Id="PackFiles">
      <xsl:text>&#10;      </xsl:text>
      <ComponentRef Id="repl.bat" />
      <xsl:apply-templates />
    </ComponentGroup>
  </xsl:template>

</xsl:stylesheet>

