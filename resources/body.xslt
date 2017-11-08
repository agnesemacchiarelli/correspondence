<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:head">
        <h4>
            <xsl:apply-templates/>
        </h4>
    </xsl:template>
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:foreign">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>
    <xsl:template match="tei:persName">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
</xsl:stylesheet>