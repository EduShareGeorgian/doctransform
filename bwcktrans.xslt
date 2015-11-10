<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:core="urn:org:pesc:core:CoreMain:v1.10.0"
                xmlns:ColTrn="urn:org:pesc:message:CollegeTranscript:v1.3.0"
                xmlns:AcRec="urn:org:pesc:sector:AcademicRecord:v1.6.0"  
                xmlns:ext="urn:ca:ocas:useextensions">

    <!--
    Following variables used to format credit hours, when whole integers,
    to a said precision.  As of this writing, credit hour precision is
    not coming from Banner expanded credit hours.
-->
  <xsl:variable name="decfmt">####0.00</xsl:variable>
  <xsl:variable name="gpafmt">####0.00000</xsl:variable>
  <xsl:variable name="qpfmt">####0.000</xsl:variable>
  <!--
 AUDIT TRAIL: 7.3.1
 1. Initial Release                              LM  10AUG2006

 AUDIT TRAIL: 7.3.2
 1. RPE 1-K7QN5                                  LM  10NOV2006
    Support for General Product Release 7.4 of Immunizations.
    Code was added to display immunization CODE, STATUS CODE, and DATE.

 AUDIT TRAIL: 8.2.1                              AB  19JUNE2009
 1. Defect 1-3O312V
    Problem : Academic Standing not appearing correctly
	Fix : Changed tag for <AcademicSummary/Delinquencies> but not all records have Academic Standing set.
 2. Defect 1-5TTNYC
    Problem : Repeat Code not appearing
    Fix : added Repeat Code tag to Course desc	
 3. Defect 1-5UVP4B
    Problem : School Information for Transfer courses Not Visible in HTML output
	Fix : Added School tab in Academic Session

 AUDIT TRAIL: 8.3                                LM  26AUG2009
 1. Alter stylesheet to have two more variables that hold format masking;
    one for GPA and one for Quality Points.
 2. Added Note/Disclaimer to HTML output stating that this report is
    not the official document, please review the actual XML Transcript
    document.
 
 FILE NAME..: bwcktran.xsl
 RELEASE....: 8.3
 PRODUCT....: STUDENT
 USAGE......: This Formats the xml transcript.
 COPYRIGHT..: Copyright(C) 2009 SunGard. All rights reserved.

 Contains confidential and proprietary information of SunGard and its subsidiaries.
 Use of these materials is limited to SunGard Higher Education licensees, and is
 subject to the terms and conditions of one or more written license agreements
 between SunGard Higher Education and the licensee in question.
-->
  <!--

    7.3.1 :  This version of the stylesheet has the *.css embedded inside it.
    The style code, directly below, is coming straight from web_defaultapp.css
    found in $BANNER_HOME/wtlweb/htm/web_defaultapp.css.
    An alternate and better method to achieve this is to place a
    link rel=stylesheet href=path/to/web_defaultapp.css type=text/css
    between the head tags; this will then pick up your (modified?)version of the
    stylesheet instead of the SGHE canned stylesheet.

    Furthermore, you can strip out all code that may not be used to reduce file size/
    maintenance of variables.

    This file is being delivered as a template file to transform the XML Transcript
    file into a readable output.
-->
  <xsl:template match="/">
    <HTML>
      <HEAD>
        <STYLE TYPE="text/css">
          .centeraligntext {
          text-align: center;
          }
          .leftaligntext {
          text-align: left;
          }
          .rightaligntext {
          text-align: right;
          }
          .menulisttext {
          list-style: none;
          }
          .captiontext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: italic;
          text-align: left;
          margin-top: .5em;
          margin-bottom: .5em;
          }
          .skiplinks {
          display: none;
          }
          .pageheaderlinks {
          color: #FFFFFF;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: center;
          }
          .requirementnotmet {
          color: black;
          }
          .pageheaderlinks2 {
          color: #CED5EA;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-size: 90%;
          text-align: justify;
          }
          .pagebodylinks {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: center;
          }
          .gotoanchorlinks {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .pagefooterlinks {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: center;
          margin-left: 3px;
          }
          .backlinktext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: right;
          margin-bottom: 5px;
          }
          .menuheadertext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 100%;
          font-style: normal;
          text-align: left;
          }
          .menulinktext {
          color: #0F2167;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-style: normal;
          }
          .menulinkdesctext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .normaltext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .infotext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .errortext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .warningtext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .multipagemsgtext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .releasetext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          text-transform: uppercase;
          }
          .requiredmsgtext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .fieldlabeltext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .fieldlabeltextinvisible {
          display: none;
          }
          .fieldrequiredtext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .fieldformattext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .fieldformatboldtext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .fielderrortext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .fieldsmallboldtext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .fieldsmalltext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .fieldmediumtext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .fieldlargetext {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 110%;
          font-style: normal;
          text-align: left;
          }
          .fieldmediumtextbold {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          .fieldOrangetextbold {
          color: ORANGE;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          A:link{color:#0000ff;text-decoration:none;}
          A:visited{color:#660099;text-decoration:none;}
          A:active{color:#990000;}
          A:hover{color:#990000;text-decoration:underline;}
          A.menulinktext {
          font-family:  Verdana,Arial Narrow, helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          color:#0000ff;
          text-decoration: none;
          }
          A.submenulinktext {
          font-family:  Verdana,Arial Narrow, helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-transform: none;
          color:#0000ff;
          text-decoration: none;
          }
          A.submenulinktext:hover {
          background-color: #1E2B83;
          font-family:  verdana,Arial Narrow, helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: justify;
          text-transform: none;
          color: #FFFFFF;
          text-decoration: none;
          }
          A.submenulinktext:visited {
          font-family:  Verdana,Arial Narrow, helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-transform: none;
          color:#660099;
          text-decoration: none;
          }
          A.submenulinktext:visited:hover {
          background-color: #1E2B83;
          font-family:  Verdana,Arial Narrow, helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: justify;
          text-transform: none;
          color: #FFFFFF;
          text-decoration: none;
          }
          A.submenulinktext2 {
          font-weight: normal;
          font-size: 90%;
          color:#0000ff;
          text-decoration:none;
          }
          A.submenulinktext2:hover {
          font-weight: normal;
          font-size: 90%;
          color:#990000;
          text-decoration:underline;
          }
          A.submenulinktext2:visited {
          font-family:  Verdana,Arial Narrow, helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          color:#660099;;
          text-decoration: none;
          }
          A.submenulinktext2:visited:hover {
          font-family:  Verdana,Arial Narrow, helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          text-decoration:underline;
          color:#990000;
          }
          A.whitespacelink
          {
          line-height: 200%;
          COLOR: #1E2B83;
          text-decoration: underline;
          }
          A.largelinktext {
          font-family: Verdana,Arial,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 110%;
          font-style: normal;
          text-align: left;
          text-decoration: underline;
          }
          A.sitemaplevel1 {
          font-family:  Verdana,Arial, helvetica, sans-serif;
          font-weight: bold;
          font-size: 80%;
          font-style: normal;
          text-align: left;
          text-decoration: none;
          color:       #1E2B83;
          }
          A.sitemaplevel1:visited {
          font-family: Verdana,Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size  : 80%;
          font-style : normal;
          text-align : left;
          text-decoration: none;
          color:#660099;
          }
          A.sitemaplevel1:hover {
          font-family: Verdana,Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size  : 80%;
          font-style : normal;
          text-align : left;
          text-decoration:underline;
          color:#990000;
          }
          A.sitemaplevel2 {
          font-family: Verdana,Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 70%;
          font-style: normal;
          text-align: left;
          text-decoration: none;
          color:#0000ff;
          }
          a.sitemaplevel2:visited {
          font-family:  Verdana, Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size  : 70%;
          font-style : normal;
          text-align : left;
          text-decoration: none;
          color:#660099;
          }
          A.sitemaplevel2:hover {
          font-family: Verdana,Arial,  helvetica, sans-serif;
          font-weight: bold;
          font-size  : 70%;
          font-style : normal;
          text-align : left;
          text-decoration:underline;
          color:#990000;
          }
          A.sitemaplevel3 {
          font-family: Verdana,Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 60%;
          font-style: normal;
          text-align: left;
          text-decoration: none;
          color:#0000ff;
          }
          A.sitemaplevel3:visited {
          font-family: Verdana,Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size  : 60%;
          font-style : normal;
          text-align : left;
          text-decoration: none;
          color:#660099;
          }
          A.sitemaplevel3:hover {
          font-family: Verdana,Arial,  helvetica, sans-serif;
          font-weight: bold;
          font-size  : 70%;
          font-style : normal;
          text-align : left;
          color:#990000;
          text-decoration:underline;
          }
          A.whitespacelink
          {
          line-height: 200%;
          color: black;
          text-decoration: underline;
          }
          A.largelinktext {
          font-family: Verdana, Arial,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 120%;
          font-style: normal;
          text-align: left;
          text-decoration: underline;
          }
          A.sitemaplevel1 {
          font-family: Verdana, Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 80%;
          font-style: normal;
          text-align: left;
          text-decoration: none;
          color:#0000ff;
          }
          A.sitemaplevel1:visited {
          font-family: Verdana, Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size  : 80%;
          font-style : normal;
          text-align : left;
          text-decoration: none;
          color:#660099;
          }
          A.sitemaplevel1:hover {
          font-family: Verdana, Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size  : 80%;
          font-style : normal;
          text-align : left;
          text-decoration:underline;
          color:#990000;
          }
          A.sitemaplevel2 {
          font-family: Verdana, Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 80%;
          font-style: normal;
          text-align: left;
          text-decoration: none;
          color:#0000ff;
          }
          A.sitemaplevel2:visited {
          font-family: Verdana, Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size  : 80%;
          font-style : normal;
          text-align : left;
          text-decoration: none;
          color:#660099;
          }
          A.sitemaplevel2:hover {
          font-family: Verdana, Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size  : 80%;
          font-style : normal;
          text-align : left;
          text-decoration:underline;
          color:#990000;
          }
          A.sitemaplevel3 {
          font-family: Verdana, Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 60%;
          font-style: normal;
          text-align: left;
          text-decoration: none;
          color:#0000ff;
          }
          A.sitemaplevel3:visited {
          font-family: Verdana, Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size  : 60%;
          font-style : normal;
          text-align : left;
          text-decoration: none;
          color:#660099;
          }
          A.sitemaplevel3:hover {
          font-family: Verdana, Arial,  helvetica, sans-serif;
          font-weight: normal;
          font-size  : 60%;
          font-style : normal;
          text-align : left;
          text-decoration: none;
          text-decoration:underline;
          color:#990000;
          }
          .whitespace1{
          padding-top:0em;
          }
          .whitespace2{
          padding-top:1em;
          }
          .whitespace3{
          padding-top:2em;
          }
          .whitespace4{
          padding-top:3em;
          }
          BODY {
          background-color: #FFFFFF;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-style: normal;
          text-align: left;
          margin-top: 0px;
          margin-left: 1%;
          margin-right: 2%;
          background-image: url(web_bg_app.jpg);
          background-repeat: no-repeat;
          }
          BODY.campuspipeline {
          background-color: #FFFFFF;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-style: normal;
          text-align: left;
          margin-top: 6px;
          margin-left: 2%;
          background-image: none;
          background-repeat: no-repeat;
          }
          BODY.previewbody {
          background-color: #FFFFFF;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          margin-left: 2%;
          margin-right: 2%;
          background-image: none;
          }
          BODY.validationbody {
          background-color: #FFFFFF;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          margin-left: 0%;
          margin-right: 2%;
          background-image: none;
          }
          DIV.menulistdiv {
          text-align: left;
          }
          DIV.headerwrapperdiv {
          margin-left: 0px;
          margin-top: 0px;
          }
          DIV.pageheaderdiv1 {
          text-align: left;
          margin-top: 8%;
          margin-left: 0px;
          border-bottom: 0px solid;
          border-left: 0px solid;
          border-right: 0px solid;
          border-top: 0px solid;
          }
          DIV.pageheaderdiv2 {
          text-align: right;
          margin-top: 10px;
          margin-right: 10px;
          position: absolute;
          top: 0px;
          right: 0px;
          float: right;
          display: none;
          }
          DIV.headerlinksdiv {
          text-align: left;
          margin-right: 0%;
          }
          DIV.headerlinksdiv2 {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          text-transform: none;
          }
          DIV.bodylinksdiv {
          text-align: center;
          margin-top: 1%;
          }
          DIV.footerlinksdiv {
          text-align: center;
          }
          DIV.backlinkdiv {
          text-align: right;
          margin-top: -40px;
          }
          DIV.pagetitlediv {
          text-align: left;
          }
          DIV.infotextdiv {
          text-align: left;
          }
          DIV.pagebodydiv {
          text-align: left;
          }
          DIV.pagefooterdiv {
          text-align: left;
          border: 0px;
          margin-top: 0px;
          float: left;
          }
          DIV.poweredbydiv {
          text-align: right;
          margin-right: -1px;
          margin-top: 0px;
          border-bottom: 0px solid;
          border-left: 0px solid;
          border-right: 0px solid;
          border-top: 0px solid;
          float: right;
          }
          DIV.previewdiv {
          text-align: center;
          }
          DIV.validationdiv {
          text-align: center;
          }
          DIV.staticheaders {
          text-align: right;
          font-size:  90%;
          }
          H1 {
          color: #FFFFFF;
          font-family: verdana, Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-style: normal;
          font-size:0%;
          margin-top: 0px;
          }
          H2 {
          color	   : BLACK;
          font-family: verdana, Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-style : normal;
          }
          H3 {
          color	   : BLACK;
          font-family: verdana, Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-style : normal;
          }
          HR {
          color: #CCCC33;
          text-align: left;
          vertical-align: top;
          margin-top: -10px;
          HEIGHT="2"
          }
          HR.pageseprator {
          color: #003366;
          text-align: left;
          vertical-align: top;
          }
          INPUT {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          }
          TEXTAREA {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          }
          SELECT {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          }
          TABLE.dataentrytable {
          border-bottom: 0px solid;
          border-left: 0px solid;
          border-right: 0px solid;
          border-top: 0px solid;
          }
          TABLE.datadisplaytable {
          border-bottom: 0px solid;
          border-left: 0px solid;
          border-right: 0px solid;
          border-top: 0px solid;
          }
          TABLE.plaintable {
          border-bottom: 0px solid;
          border-left: 0px solid;
          border-right: 0px solid;
          border-top: 0px solid;
          }
          TABLE.menuplaintable {
          border-top: 1pt #707070 solid;
          }
          TABLE.pageheadertable {
          margin-top: 0px;
          }
          TABLE.colorsampletable {
          background-color: #FFFFFF;
          }
          TABLE.bordertable {
          border-collapse:collapse;
          border-bottom: 1px solid;
          border-left: 1px solid;
          border-right: 1px solid;
          border-top: 1px solid;
          }
          TABLE TH {
          vertical-align: top;
          color: black;
          }
          TABLE TD {
          vertical-align: top;
          color: black;
          }
          .pageheadertablecell {
          text-align: left;
          }
          .pageheadernavlinkstablecell {
          text-align: right;
          }
          TABLE TD.deheader {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TH.deheader {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.detitle {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          padding-bottom: 1em;
          }
          TABLE TH.detitle {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          padding-bottom: 1em;
          }
          TABLE TD.delabel {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TH.delabel {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.deseparator {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.dehighlight {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.dedead {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.dedefault {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.dewhite {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.deborder {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          border: 1px solid;
          }
          TABLE TD.ddheader {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TH.ddheader {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.ddtitle {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          padding-bottom: 1em;
          }
          TABLE TH.ddtitle {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          padding-bottom: 1em;
          }
          TABLE TD.ddlabel {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TH.ddlabel {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.ddseparator {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.ddhighlight {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.dddead {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.dddefault {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.ddnontabular {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.ddwhite {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.pltitle {
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-weight: bold;
          }
          TABLE TD.plheader {
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-size: 90%;
          font-weight: bold;
          }
          TABLE TH.pllabel {
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-size: 90%;
          font-weight: bold;
          }
          TABLE TD.plseparator {
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          }
          TABLE TD.plhighlight {
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          }
          TABLE TD.pldead {
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          }
          TABLE TD.pldefault {
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          }
          TABLE TD.plwhite {
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          }
          TABLE TD.plheaderlinks {
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          }
          TABLE TD.plheadermenulinks {
          font-weight: normal;
          }
          TABLE TD.mptitle {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.mpheader {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TH.mplabel {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.mpwhite {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.mpdefault {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.indefault {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          }
          TABLE TD.dbheader {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          border: 1px solid;
          }
          TABLE TH.dbheader {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          border: 1px solid;
          }
          TABLE TD.dbtitle {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          padding-bottom: 1em;
          border: 1px solid;
          }
          TABLE TH.dbtitle {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          padding-bottom: 1em;
          border: 1px solid;
          }
          TABLE TD.dblabel {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          border: 1px solid;
          }
          TABLE TH.dblabel {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          border: 1px solid;
          }
          TABLE TD.dbdefault {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          border: 1px solid;
          }
          TABLE TD.ntheader {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TH.ntheader {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.nttitle {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          padding-bottom: 1em;
          }
          TABLE TH.nttitle {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          padding-bottom: 1em;
          }
          TABLE TD.ntlabel {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TH.ntlabel {
          background-color: #E3E5EE;
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: bold;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.ntseparator {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.nthighlight {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.ntdead {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.ntdefault {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          TABLE TD.ntwhite {
          color: black;
          font-family: Verdana,Arial Narrow,  helvetica, sans-serif;
          font-weight: normal;
          font-size: 90%;
          font-style: normal;
          text-align: left;
          vertical-align: top;
          }
          .bgtabon {
          BACKGROUND-COLOR: #003366
          }
          .bgtaboff {
          BACKGROUND-COLOR: #cccccc
          }
          .texttabon {
          COLOR: #ffffff
          }
          .texttaboff {
          COLOR: #000000
          }
          .tabon {
          PADDING-LEFT: 8px; FONT-WEIGHT: bold; FONT-SIZE: 12px; BACKGROUND-IMAGE: url(/wtlgifs/web_tab_corner.gif); COLOR: #ffffff; BACKGROUND-REPEAT: no-repeat; BACKGROUND-COLOR: #003366
          }
          .tabon A:link {
          COLOR: #ffffff; TEXT-DECORATION: none
          }
          .tabon A:visited {
          COLOR: #ffffff; TEXT-DECORATION: none
          }
          .tabon A:active {
          COLOR: #ffffff; TEXT-DECORATION: none
          }
          .tabon A:hover {
          COLOR: #ffffff; TEXT-DECORATION: none
          }
          .taboff {
          PADDING-LEFT: 8px;
          FONT-WEIGHT: bold;
          FONT-SIZE: 12px;
          BACKGROUND-IMAGE: url(/wtlgifs/web_tab_corner.gif);
          COLOR: #000000;
          BACKGROUND-REPEAT: no-repeat;
          BACKGROUND-COLOR: #cccccc
          }
          .taboff A:link {
          COLOR: #000000; TEXT-DECORATION: none
          }
          .taboff A:visited {
          COLOR: #000000; TEXT-DECORATION: none
          }
          .taboff A:active {
          COLOR: #000000; TEXT-DECORATION: none
          }
          .taboff A:hover {
          COLOR: #000000; TEXT-DECORATION: none
          }
          .bg3 {
          BACKGROUND-COLOR: #cccc00
          }
        </STYLE>
        <!--
      <LINK REL="stylesheet" HREF="web_defaultapp.css" TYPE="text/css"/>
   -->
      </HEAD>
      <BR/>
      <BR/>
      <BODY>
        <div style="padding:20px;background: #004b87 url('http://www.georgiancollege.ca/wp-content/themes/georgian-college/images/headers/georgian-accelerator-header.png') 50% top no-repeat"><img style="height:50px" src="http://www.georgiancollege.ca/wp-content/themes/georgian-college/images/logos/georgian-college-logo-2014.svg" /></div>
        <xsl:apply-templates select="ColTrn:CollegeTranscript"/>
      </BODY>
    </HTML>
  </xsl:template>

  <xsl:template match="CollegeTranscript">
    <xsl:apply-templates select="TransmissionData"/>
    <xsl:apply-templates select="Student"/>
  </xsl:template>

  <xsl:template match="Student">
    <xsl:apply-templates select="Person"/>
    <br />
    <xsl:apply-templates select="AcademicRecord"/>
    <br />
    <xsl:apply-templates select="Health"/>
    <br />
    <xsl:apply-templates select="Tests"/>
    <br />
  </xsl:template>

  <!--
    Namespaces: Our XML has namespaces elements, thus our stylesheet requires namespaces
    for our XSLT elements.  If we use the default method of transformation :
    java org.apache.xalan.xslt.Process -IN abc.xml -XSL abc.xsl -OUT abc.html
    Namespaces are required.   If you use an alternate method of XSLT-ing it,
    more than likely namespaces will also be required.  However, depending on
    how your XSLT-ing it, they may not be required/used.  Therefore, depending
    on your XSLT method, if it produces a *.html file with just namespace information,
    then namespaces in the XSLT should be investigated/corrected to address the problem.
-->
  <xsl:template match="Person">
    <TABLE CLASS="datadisplaytable" SUMMARY="This table will display the
                                   user's Academic History in the following
                                   sections:  Degree Information, Transfer
                                   Credit By Institution, Institution
                                   Credit, Transcript Totals ,
                                   Courses In Progress." WIDTH="80%">
      <CAPTION class="captiontext">Transcript Data</CAPTION>
      <TR>
        <TH COLSPAN="12" CLASS="ddtitle" scope="colgroup" >Student Information</TH>
      </TR>
      <TR>
        <TH COLSPAN="12" CLASS="ddtitle" scope="colgroup" >Please review the actual XML Document to confirm accuracy.</TH>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Composite Name : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Name/CompositeName"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Full Name : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Name/NamePrefix"/><xsl:value-of select="Name/FirstName"/>&#160;<xsl:value-of select="Name/LastName"/>&#160;<xsl:value-of select="Name/NameSuffix"/>
        </TD>
      </TR>

      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >ID : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="SchoolAssignedPersonID"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Birth Date : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Birth/BirthDate"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >SSN : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="SSN"/>
        </TD>
      </TR>
      <TR>
        <TD/>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Address : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Contacts/Address/AddressLine"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" />
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Contacts/Address/City"/>&#160;<xsl:value-of select="Contacts/Address/StateProvinceCode"/>&#160;<xsl:value-of select="Contacts/Address/PostalCode"/>
        </TD>
      </TR>
      <TR>
        <TD/>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >High School :</TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="HighSchool/OrganizationName"/>
        </TD>
      </TR>

      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Email :</TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Contacts/Email/EmailAddress"/>
        </TD>
      </TR>
    </TABLE>
    <BR/>
    <xsl:apply-templates select="AcademicRecord"/>
  </xsl:template>

  <xsl:template match="AcademicRecord">
    <TABLE CLASS="datadisplaytable" SUMMARY="This table will display the
                                   user's Academic History in the following
                                   sections:  Degree Information, Transfer
                                   Credit By Institution, Institution
                                   Credit, Transcript Totals ,
                                   Courses In Progress." WIDTH="80%">
      <CAPTION class="captiontext">Academic Record Data</CAPTION>
      <TR>
        <TH COLSPAN="12" CLASS="ddtitle" scope="colgroup" >Academic Record</TH>
      </TR>
      <xsl:apply-templates select="AcademicAward"/>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Academic Summary Type : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="AcademicSummary/AcademicSummaryType"/>
        </TD>
      </TR>
      <xsl:for-each select="AcademicSummary/AcademicProgram">
        <xsl:sort select="AcademicProgramType"/>
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >
            <xsl:value-of select="AcademicProgramType"/> :
          </TH>
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="AcademicProgramName"/>
          </TD>
        </TR>
      </xsl:for-each>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Academic Summary Level : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="AcademicSummary/AcademicSummaryLevel"/>
        </TD>
      </TR>
      <xsl:if test="(AcademicSummary/AcademicHonors/HonorsTitle)">
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Academic Honors : </TH>
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="AcademicSummary/AcademicHonors/HonorsTitle"/>
          </TD>
        </TR>
      </xsl:if>
      <xsl:if test="(AcademicSummary/Delinquencies)">
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Academic Standing : </TH>
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="AcademicSummary/Delinquencies"/>
          </TD>
        </TR>
      </xsl:if>
      <TR>
        <TD/>
      </TR>
      <xsl:apply-templates select="AcademicSummary/GPA"/>
      <TR>
        <TD/>
      </TR>
      <xsl:apply-templates select="AcademicSummary/NoteMessage"/>
    </TABLE>
    <BR/>
    <xsl:apply-templates select="AcademicSession"/>
    <BR/>
  </xsl:template>

  <xsl:template match="AcademicSummary/GPA">
    <!--
   <TABLE CLASS="datadisplaytable" SUMMARY="This table will display the
                                   user's Academic History in the following
                                   sections:  Degree Information, Transfer
                                   Credit By Institution, Institution
                                   Credit, Transcript Totals ,
                                   Courses In Progress." WIDTH="80%">
   <CAPTION class="captiontext">GPA Data</CAPTION>
      <TR>
         <TH COLSPAN="12" CLASS="ddtitle" scope="colgroup" >GPA Data</TH>
      </TR>
-->
    <TR>
      <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Attempted Hours</TH>
      <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Earned Hours</TH>
      <TH COLSPAN="2" CLASS="ddlabel" scope="row" >GPA</TH>
      <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Total Points</TH>
      <TH COLSPAN="2" CLASS="ddlabel" scope="row" >GPA Hours</TH>
      <TH COLSPAN="2" CLASS="ddlabel" scope="row" />
    </TR>
    <TR>
      <xsl:choose>
        <xsl:when test="(CreditHoursAttempted)">
          <TD COLSPAN="2" CLASS="dddefault" >
            <xsl:value-of select="format-number(CreditHoursAttempted,$gpafmt)"/>
          </TD>
        </xsl:when>
        <xsl:otherwise>
          <TD COLSPAN="2" CLASS="dddefault" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="(CreditHoursEarned)">
          <TD COLSPAN="2" CLASS="dddefault" >
            <xsl:value-of select="format-number(CreditHoursEarned,$gpafmt)"/>
          </TD>
        </xsl:when>
        <xsl:otherwise>
          <TD COLSPAN="2" CLASS="dddefault" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="(GradePointAverage)">
          <TD COLSPAN="2" CLASS="dddefault" >
            <xsl:value-of select="format-number(GradePointAverage,$gpafmt)"/>
          </TD>
        </xsl:when>
        <xsl:otherwise>
          <TD COLSPAN="2" CLASS="dddefault" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="(TotalQualityPoints)">
          <TD COLSPAN="2" CLASS="dddefault" >
            <xsl:value-of select="format-number(TotalQualityPoints,$qpfmt)"/>
          </TD>
        </xsl:when>
        <xsl:otherwise>
          <TD COLSPAN="2" CLASS="dddefault" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="(CreditHoursforGPA)">
          <TD COLSPAN="2" CLASS="dddefault" >
            <xsl:value-of select="format-number(CreditHoursforGPA,$gpafmt)"/>
          </TD>
        </xsl:when>
        <xsl:otherwise>
          <TD COLSPAN="2" CLASS="dddefault" />
        </xsl:otherwise>
      </xsl:choose>
      <TD COLSPAN="2" CLASS="dddefault" />
    </TR>
    <TR>
      <TD/>
    </TR>
    <!--
      <TR>
         <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Credit Hours Attempted : </TH>
         <TD COLSPAN="10" CLASS="dddefault" ><xsl:value-of select="CreditHoursAttempted"/></TD>
      </TR>
      <TR>
         <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Credit Hours Earned : </TH>
         <TD COLSPAN="10" CLASS="dddefault" ><xsl:value-of select="CreditHoursEarned"/></TD>
      </TR>
      <TR>
         <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Grade Point Average : </TH>
         <TD COLSPAN="10" CLASS="dddefault" ><xsl:value-of select="GradePointAverage"/></TD>
      </TR>
      <TR>
         <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Total Quality Points : </TH>
         <TD COLSPAN="10" CLASS="dddefault" ><xsl:value-of select="TotalQualityPoints"/></TD>
      </TR>
      <TR>
         <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Credit Hours for GPA : </TH>
         <TD COLSPAN="10" CLASS="dddefault" ><xsl:value-of select="CreditHoursforGPA"/></TD>
      </TR>
   </TABLE>
-->
  </xsl:template>

  <xsl:template match="AcademicSession">
    <TABLE CLASS="datadisplaytable" SUMMARY="This table will display the
                                   user's Academic History in the following
                                   sections:  Degree Information, Transfer
                                   Credit By Institution, Institution
                                   Credit, Transcript Totals ,
                                   Courses In Progress." WIDTH="80%">
      <CAPTION class="captiontext">Academic Session</CAPTION>
      <TR>
        <TH COLSPAN="12" CLASS="ddtitle" scope="colgroup" >Academic Session</TH>
      </TR>
      <xsl:if test="(StudentLevel/StudentLevelCode)">
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Student Level : </TH>
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="StudentLevel/StudentLevelCode"/>
          </TD>
        </TR>
      </xsl:if>
      <xsl:if test="(School)">
        <!-- Added for Defect 1-5UVP4B    AB 19JUNE2009 -->
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >School Information</TH>
          <TD COLSPAN="8" CLASS="dddefault" ></TD>
        </TR>
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Name : </TH>
          <TD COLSPAN="8" CLASS="dddefault" >
            <xsl:value-of select="School/OrganizationName"/>
          </TD>
        </TR>
        <xsl:if test="(School/LocalOrganizationID)" >
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Local Organization ID :	</TH>
            <TD COLSPAN="8" CLASS="dddefault" >
              <xsl:value-of select="School/LocalOrganizationID/LocalOrganizationIDCode"/>
            </TD>
          </TR>
        </xsl:if>
        <xsl:if test="(School/LocalOrganizationID/LocalOrganizationIDQualifier)" >
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Qualifier :	</TH>
            <TD COLSPAN="8" CLASS="dddefault" >
              <xsl:value-of select="School/LocalOrganizationID/LocalOrganizationIDQualifier"/>
            </TD>
          </TR>
        </xsl:if>
        <xsl:if test="(School/ACT)" >
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >ACT :	</TH>
            <TD COLSPAN="8" CLASS="dddefault" >
              <xsl:value-of select="School/ACT"/>
            </TD>
          </TR>
        </xsl:if>
        <xsl:if test="(School/ATP)" >
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >ATP :	</TH>
            <TD COLSPAN="8" CLASS="dddefault" >
              <xsl:value-of select="School/ATP"/>
            </TD>
          </TR>
        </xsl:if>
        <xsl:if test="(School/IPEDS)" >
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >IPEDS :	</TH>
            <TD COLSPAN="8" CLASS="dddefault" >
              <xsl:value-of select="School/IPEDS"/>
            </TD>
          </TR>
        </xsl:if>
        <xsl:if test="(School/OPEID)" >
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >OPEID :	</TH>
            <TD COLSPAN="8" CLASS="dddefault" >
              <xsl:value-of select="School/OPEID"/>
            </TD>
          </TR>
        </xsl:if>
        <xsl:if test="(School/FICE)" >
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >FICE :	</TH>
            <TD COLSPAN="8" CLASS="dddefault" >
              <xsl:value-of select="School/FICE"/>
            </TD>
          </TR>
        </xsl:if>
        <xsl:if test="(School/SchoolOverrideCode)" >
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >School Override Code :	</TH>
            <TD COLSPAN="8" CLASS="dddefault" >
              <xsl:value-of select="School/SchoolOverrideCode"/>
            </TD>
          </TR>
        </xsl:if>
        <xsl:if test="(School/SchoolLevel)">
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >School Level :	</TH>
            <TD COLSPAN="8" CLASS="dddefault" >
              <xsl:value-of select="School/SchoolLevel"/>
            </TD>
          </TR>
        </xsl:if>
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Contact Information </TH>
          <TD COLSPAN="8" CLASS="dddefault" ></TD>
        </TR>
      </xsl:if>

      <xsl:for-each select="(School/Contacts/Address)">
        <xsl:for-each select="AddressLine">
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" />
            <TD COLSPAN="10" CLASS="dddefault" >
              <xsl:value-of select="."/>
            </TD>
          </TR>
        </xsl:for-each>
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" />
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="City"/>&#160;<xsl:value-of select="State"/>&#160;<xsl:value-of select="PostalCode"/>
          </TD>
        </TR>
        <xsl:if test="(CountryCode)" >
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Country : </TH>
            <TD COLSPAN="10" CLASS="dddefault" >
              <xsl:value-of select="CountryCode"/>
            </TD>
          </TR>
        </xsl:if>
      </xsl:for-each>

      <xsl:for-each select="Phone">
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Phone : </TH>
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="AreaCityCode"/>&#160;<xsl:value-of select="PhoneNumber"/>
          </TD>
        </TR>
      </xsl:for-each>
      <xsl:for-each select="Email">
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Email : </TH>
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="EmailAddress"/>
          </TD>
        </TR>
      </xsl:for-each>
      <xsl:for-each select="URL">
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >URL : </TH>
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="URLAddress"/>
          </TD>
        </TR>
      </xsl:for-each>


      <xsl:if test="(AcademicSessionDetail/SessionName)">
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Session : </TH>
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="AcademicSessionDetail/SessionName"/>
          </TD>
        </TR>
      </xsl:if>

      <TR>
        <TD COLSPAN="10" CLASS="dddefault" />
      </TR>
      <TR>
        <TD COLSPAN="10" CLASS="dddefault" />
      </TR>

      <xsl:for-each select="AcademicProgram">
        <xsl:sort select="AcademicProgramType"/>
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" >
            <xsl:value-of select="AcademicProgramType"/> :
          </TH>
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="AcademicProgramName"/>
          </TD>
        </TR>
      </xsl:for-each>
      <TR>
        <TD COLSPAN="10" CLASS="dddefault" />
      </TR>
      <xsl:apply-templates select="AcademicSummary/GPA"/>
      <TR>
        <TD COLSPAN="10" CLASS="dddefault" />
      </TR>
      <xsl:apply-templates select="AcademicSummary/NoteMessage"/>
      <TR>
        <TD COLSPAN="10" CLASS="dddefault" />
      </TR>
      <xsl:apply-templates select="AcademicSummary/Delinquencies"/>
      <TR>
        <TD COLSPAN="10" CLASS="dddefault" />
      </TR>
    </TABLE>
    <BR/>
    <xsl:if test="(Course)">
      <TABLE CLASS="datadisplaytable" SUMMARY="This table will display the
                                   user's Academic History in the following
                                   sections:  Degree Information, Transfer
                                   Credit By Institution, Institution
                                   Credit, Transcript Totals ,
                                   Courses In Progress." WIDTH="80%">
        <CAPTION class="captiontext">Courses</CAPTION>
        <TR>
          <TH CLASS="ddheader" scope="col" >Subject</TH>
          <TH COLSPAN="2" CLASS="ddheader" scope="col" >Course</TH>
          <TH COLSPAN="3" CLASS="ddheader" scope="col" >Title</TH>
          <TH CLASS="ddheader" scope="col" >Grade</TH>
          <TH CLASS="ddheader" scope="col" >Credit Hours</TH>
          <TH COLSPAN="4" CLASS="ddheader" scope="col" >Quality Points</TH>
          <TH class="ddheader" scope="col" >Repeat Code</TH>
        </TR>
        <xsl:apply-templates select="Course"/>
      </TABLE>
      <BR />
    </xsl:if>
  </xsl:template>

  <xsl:template match="Course">
    <TR>
      <TD CLASS="dddefault" >
        <xsl:value-of select="CourseSubjectAbbreviation"/>
      </TD>
      <TD COLSPAN="2" CLASS="dddefault" >
        <xsl:value-of select="CourseNumber"/>
      </TD>
      <TD COLSPAN="3" CLASS="dddefault" >
        <xsl:value-of select="CourseTitle"/>
      </TD>
      <TD CLASS="dddefault" >
        <xsl:value-of select="CourseAcademicGrade"/>
      </TD>
      <xsl:choose>
        <xsl:when test="(CourseCreditEarned)">
          <TD CLASS="dddefault" >
            <xsl:value-of select="format-number(CourseCreditEarned,$gpafmt)"/>
          </TD>
        </xsl:when>
        <xsl:otherwise>
          <TD CLASS="dddefault" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="(CourseQualityPointsEarned)">
          <TD COLSPAN="4" CLASS="dddefault" >
            <xsl:value-of select="format-number(CourseQualityPointsEarned,$qpfmt)"/>
          </TD>
        </xsl:when>
        <xsl:otherwise>
          <TD CLASS="dddefault" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="(CourseRepeatCode)">
          <TD CLASS="dddefault" >
            <xsl:value-of select="CourseRepeatCode"/>
          </TD>
        </xsl:when>
        <xsl:otherwise>
          <TD CLASS="dddefault" />
        </xsl:otherwise>
      </xsl:choose>
    </TR>
  </xsl:template>

  <xsl:template match="AcademicAward">
    <TR>
      <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Academic Award Type : </TH>
      <TD COLSPAN="5" CLASS="dddefault" >
        <xsl:value-of select="AcademicAwardTitle"/>
      </TD>
      <TD COLSPAN="5" CLASS="dddefault" >
        <xsl:value-of select="AcademicAwardDate"/>
      </TD>
    </TR>
    <xsl:for-each select="AcademicAwardProgram">
      <xsl:sort select="AcademicProgramType"/>
      <xsl:call-template name="AcademicAwardProgram"/>
    </xsl:for-each>
    <TR>
      <TD COLSPAN="12" CLASS="dddead">&#160;</TD>
    </TR>
    <xsl:apply-templates select="AcademicSummary/GPA"/>
    <TR>
      <TD/>
    </TR>
  </xsl:template>

  <xsl:template name="AcademicAwardProgram">
    <TR>
      <TH COLSPAN="2" CLASS="ddlabel" scope="row" >
        <xsl:value-of select="AcademicProgramType"/> :
      </TH>
      <TD COLSPAN="10" CLASS="dddefault" >
        <xsl:value-of select="AcademicProgramName"/>
      </TD>
    </TR>
  </xsl:template>

  <xsl:template match="AcademicSummary/NoteMessage">
    <TR>
      <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Additional Comments : </TH>
      <TD COLSPAN="10" CLASS="dddefault" >
        <xsl:value-of select="NoteMessage"/>
      </TD>
    </TR>
  </xsl:template>

  <xsl:template match="AcademicSummary/Delinquencies">
    <TR>
      <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Academic Standing : </TH>
      <TD COLSPAN="10" CLASS="dddefault" >
        <xsl:value-of select="."/>
      </TD>
    </TR>
  </xsl:template>

  <xsl:template match="TransmissionData">
    <TABLE CLASS="datadisplaytable" SUMMARY="This table will display the
                                   XML Transcript Transmission Data." WIDTH="80%">
      <CAPTION class="captiontext">Transmission Data</CAPTION>
      <TR>
        <TH COLSPAN="12" CLASS="ddtitle" scope="colgroup" >Transmission Data</TH>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Document ID : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="DocumentID"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Document Creation : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="CreatedDateTime"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Document Type : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="DocumentTypeCode"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Transmission Type : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="TransmissionType"/>
        </TD>
      </TR>
      <TR>
        <TD/>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Source : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Source/Organization/OrganizationName"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Contact Information : </TH>
        <TD COLSPAN="10" CLASS="dddefault" />
      </TR>
      <xsl:for-each select="Source/Organization/Contacts/Address/AddressLine">
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" />
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="."/>
          </TD>
        </TR>
      </xsl:for-each>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" />
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Source/Organization/Contacts/Address/City"/>&#160;<xsl:value-of select="Source/Organization/Contacts/Address/State"/>&#160;<xsl:value-of select="Source/Organization/Contacts/Address/PostalCod"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Phone : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Source/Organization/Contacts/Phone/AreaCityCode"/>&#160;<xsl:value-of select="Source/Organization/Contacts/Phone/PhoneNumber"/>
        </TD>
      </TR>
      <TR>
        <TD/>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Destination : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Destination/Organization/OrganizationName"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Contact Information : </TH>
        <TD COLSPAN="10" CLASS="dddefault" />
      </TR>
      <xsl:for-each select="Destination/Organization/Contacts/Address/AddressLine">
        <TR>
          <TH COLSPAN="2" CLASS="ddlabel" scope="row" />
          <TD COLSPAN="10" CLASS="dddefault" >
            <xsl:value-of select="."/>
          </TD>
        </TR>
      </xsl:for-each>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" />
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Destination/Organization/Contacts/Address/City"/>&#160;<xsl:value-of select="Destination/Organization/Contacts/Address/StateProvince"/>&#160;<xsl:value-of select="Destination/Organization/Contacts/Address/PostalCode"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Phone : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="Destination/Organization/Contacts/Phone/AreaCityCode"/>&#160;<xsl:value-of select="Destination/Organization/Contacts/Phone/PhoneNumber"/>
        </TD>
      </TR>
      <TR>
        <TD/>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Document Process Code : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="DocumentProcessCode"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Document Offical Code : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="DocumentOfficialCode"/>
        </TD>
      </TR>
      <TR>
        <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Document Complete Code : </TH>
        <TD COLSPAN="10" CLASS="dddefault" >
          <xsl:value-of select="DocumentCompleteCode"/>
        </TD>
      </TR>
    </TABLE>
    <BR/>
  </xsl:template>

  <xsl:template match="Health">
    <xsl:if test="(Immunizations)">
      <TABLE CLASS="datadisplaytable" SUMMARY="This table will display the
                                   XML Transcript Health Data." WIDTH="80%">
        <CAPTION class="captiontext">Health Data</CAPTION>
        <TR>
          <TH COLSPAN="12" CLASS="ddtitle" scope="colgroup" >Health Data</TH>
        </TR>
        <xsl:for-each select="Immunizations">
          <TR>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Immunization Code : </TH>
            <TD COLSPAN="2" CLASS="dddefault" >
              <xsl:value-of select="ImmunizationCode"/>
            </TD>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Immunization Status Code : </TH>
            <TD COLSPAN="2" CLASS="dddefault" >
              <xsl:value-of select="NoteMessage"/>
            </TD>
            <TH COLSPAN="2" CLASS="ddlabel" scope="row" >Immunization Date : </TH>
            <TD COLSPAN="2" CLASS="dddefault" >
              <xsl:value-of select="ImmunizationDate"/>
            </TD>
          </TR>
        </xsl:for-each>
      </TABLE>
      <BR/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Tests">
    <xsl:if test="(TestCode)">
      <!--
        If were on our first test record, draw the table header and such; otherwise,
        start listing remaining test after the first record has been handled.
   -->
      <xsl:if test="position() = 1">
        <TABLE CLASS="datadisplaytable" SUMMARY="This table will display the
                                   XML Transcript Test Data." WIDTH="80%">
          <CAPTION class="captiontext">Test Data</CAPTION>
          <TR>
            <TH COLSPAN="14" CLASS="ddtitle" scope="colgroup" >Test Data</TH>
          </TR>
          <TR>
            <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Test Code : </TH>
            <TD COLSPAN="1" CLASS="dddefault">
              <xsl:value-of select="TestCode"/>
            </TD>
            <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Test Date : </TH>
            <TD COLSPAN="1" CLASS="dddefault">
              <xsl:value-of select="TestDate"/>
            </TD>
          </TR>
          <xsl:for-each select="Subtest">
            <TR>
              <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Subtest Code : </TH>
              <TD COLSPAN="1" CLASS="dddefault" >
                <xsl:value-of select="SubtestCode"/>
              </TD>
              <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Subtest Name : </TH>
              <TD COLSPAN="1" CLASS="dddefault" >
                <xsl:value-of select="SubtestName"/>
              </TD>
              <xsl:if test="(TestScores)">
                <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Subtest Score : </TH>
                <TD COLSPAN="1" CLASS="dddefault" >
                  <xsl:value-of select="TestScores/ScoreValue"/>
                </TD>
                <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Score Revised : </TH>
                <TD COLSPAN="1" CLASS="dddefault" >
                  <xsl:value-of select="TestScores/ScoreRevisedIndicator"/>
                </TD>
                <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Self Reported: </TH>
                <TD COLSPAN="1" CLASS="dddefault" >
                  <xsl:value-of select="TestScores/ScoreSelfreportedIndicator"/>
                </TD>
              </xsl:if>
            </TR>
          </xsl:for-each>
        </TABLE>
        <BR/>
      </xsl:if>

      <xsl:if test="position() > 1">
        <TABLE CLASS="datadisplaytable" WIDTH="80%">
          <TR>
            <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Test Code : </TH>
            <TD COLSPAN="1" CLASS="dddefault">
              <xsl:value-of select="TestCode"/>
            </TD>
            <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Test Date : </TH>
            <TD COLSPAN="1" CLASS="dddefault">
              <xsl:value-of select="TestDate"/>
            </TD>
          </TR>
          <xsl:for-each select="Subtest">
            <TR>
              <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Subtest Code : </TH>
              <TD COLSPAN="1" CLASS="dddefault" >
                <xsl:value-of select="SubtestCode"/>
              </TD>
              <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Subtest Name : </TH>
              <TD COLSPAN="1" CLASS="dddefault" >
                <xsl:value-of select="SubtestName"/>
              </TD>
              <xsl:if test="(TestScores)">
                <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Subtest Score : </TH>
                <TD COLSPAN="1" CLASS="dddefault" >
                  <xsl:value-of select="TestScores/ScoreValue"/>
                </TD>
                <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Score Revised : </TH>
                <TD COLSPAN="1" CLASS="dddefault" >
                  <xsl:value-of select="TestScores/ScoreRevisedIndicator"/>
                </TD>
                <TH COLSPAN="1" CLASS="ddlabel" scope="row" >Self Reported: </TH>
                <TD COLSPAN="1" CLASS="dddefault" >
                  <xsl:value-of select="TestScores/ScoreSelfreportedIndicator"/>
                </TD>
              </xsl:if>
            </TR>
          </xsl:for-each>
        </TABLE>
        <BR/>
      </xsl:if>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>