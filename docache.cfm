<cfsetting enablecfoutputonly=true>
<cfsetting showdebugoutput=false>

<cfset fileroot = "path:\to\feedcacher\dir"/>

<!--- Read the file and convert it to an XML document object --->  
<cffile action="read" file="#fileroot#\feeds.xml" variable="feedsfile"> 
<cfset feedsdoc = XmlParse(feedsfile)> 
 
<!--- get an array of feeds ---> 
<cfset feeds = feedsdoc.feeds.XmlChildren> 
<cfset size = ArrayLen(feeds)> 

<cfoutput> 
Number of feeds = #size# 
<br> 
</cfoutput> 

<!--- create a query object with the feed data ---> 
<cfset feedquery = QueryNew("title, url") > 
<cfset temp = QueryAddRow(feedquery, #size#)> 
<cfloop index="i" from = "1" to = #size#> 
    <cfset temp = QuerySetCell(feedquery, "title",  
        #feedsdoc.feeds.feed[i].Title.XmlText#, #i#)> 
    <cfset temp = QuerySetCell(feedquery, "url",  
        #feedsdoc.feeds.feed[i].URL.XmlText#, #i#)> 
</cfloop> 


<h3>Writing file(s)...</h3>

<cfloop query="feedquery">


<cfhttp url="#url#" result="result" timeout="600" />

<!--- remove spaces from the title string --->
<cfset titleNoSpace = ReReplace(title, "[[:space:]]","","ALL")>


<cffile action="write" file="#fileroot#/output/#titleNoSpace#.xml" output="#result.Filecontent#">

<cfoutput>Wrote #title# to /output/#titleNoSpace#.xml. <br/></cfoutput>
</cfloop>
