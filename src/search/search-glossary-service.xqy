xquery version "1.0-ml";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

import module namespace style = "http://danmccreary.com/style" at "/modules/style.xqy";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace skos="http://www.w3.org/2004/02/skos/core#";
declare option xdmp:output "method=html";

let $title := "Glossary Search"

let $q := xdmp:get-request-field('q')

return
  if (not($q)) then
    <error><message>q is a required parameter</message></error>
  else (: continue :)
  
let $start := xs:positiveInteger(xdmp:get-request-field('start', '1'))
let $page-length := xs:positiveInteger(xdmp:get-request-field('page-length', '10'))
let $debug := xs:boolean(xdmp:get-request-field('debug', 'false'))
let $filter := xdmp:get-request-field("filter", 'none')
let $end := $start + $page-length - 1

(:
<return-facets>true</return-facets>
    <constraint name="cloud">
      <range type="xs:string">
        <facet-option>frequency-order</facet-option>
        <facet-option>descending</facet-option>
        <facet-option>limit=20</facet-option>
        <element ns="http://optum.com/odm/canonical-data-element" name="canonical-name"/>
        <element ns="http://optum.com/odm/canonical-data-element" name="representation-term"/>
        <element ns="http://optum.com/odm/canonical-data-element" name="subject-area"/>
        <element ns="http://optum.com/odm/canonical-data-element" name="xml-schema-type"/>
      </range>
    </constraint>
    
    <constraint name="representation-term">
      <range type="xs:string">
        <facet-option>frequency-order</facet-option>
        <facet-option>descending</facet-option>
        <facet-option>limit=20</facet-option>
        <element ns="http://optum.com/odm/canonical-data-element" name="representation-term"/>>
      </range>
    </constraint>
:)

let $options :=
  <options xmlns="http://marklogic.com/appservices/search">
    <additional-query>
      <cts:directory-query depth="infinity" xmlns:cts="http://marklogic.com/cts">
        <cts:uri>/glossary/</cts:uri>
      </cts:directory-query>
    </additional-query>
    <constraint name="Entity">
      <range type="xs:string">
        <facet-option>frequency-order</facet-option>
        <facet-option>descending</facet-option>
        <facet-option>limit=20</facet-option>
        <element ns="http://www.w3.org/2004/02/skos/core#" name="entity"/>>
      </range>
    </constraint>
    <constraint name="Property">
      <range type="xs:string">
        <facet-option>frequency-order</facet-option>
        <facet-option>descending</facet-option>
        <facet-option>limit=20</facet-option>
        <element ns="http://www.w3.org/2004/02/skos/core#" name="property-of"/>>
      </range>
    </constraint>
    <constraint name="Property">
      <range type="xs:string">
        <facet-option>frequency-order</facet-option>
        <facet-option>descending</facet-option>
        <facet-option>limit=20</facet-option>
        <element ns="http://www.w3.org/2004/02/skos/core#" name="relationship"/>>
      </range>
    </constraint>
    <operator name="sort">
      <state name="relevance">
        <sort-order direction="descending">
          <score/>
        </sort-order>
      </state>
      <state name='prefLabel'>
        <sort-order direction="ascending">
          <element ns="http://www.w3.org/2004/02/skos/core#" name="prefLabel"/>
        </sort-order>
        <sort-order direction="descending">
          <score/>
        </sort-order>
      </state>
    </operator>
  </options>

let $search-results := search:search($q, $options, $start, $page-length)

(:
<search:response total="1234"
:)
let $count := xs:nonNegativeInteger($search-results/@total)

return
  if ($debug) then
    <debug-results>
       <q>{$q}</q>
       <count>{$search-results/@total/string()}</count>
       {$search-results}
    </debug-results>
  else (: continue :)

(:
 {style:prev-next-pagination-links-query($start, $page-length, $count)}

 <search:facet name="subject-area" type="xs:string">
    <search:facet-value name="claimadjudicated" count="5">claimadjudicated</search:facet-value>
 :)
let $content :=
<div class="content white-background">
  <div class="row">
  <div class="col-md-2 col-left facets">
  {
    for $facet in $search-results/search:facet
      let $facet-count := fn:count($facet/search:facet-value/@count)
      let $facet-name := fn:data($facet/@name)
    return
      if ($facet-count > 0 ) then
        <div>
        <h4>{$facet-name}</h4>
        {
        let $facet-items :=
          for $val in $facet/search:facet-value
            let $print := if ($val/text()) then
              $val/text()
            else
              'Unknown'
        let $qtext := ($search-results/search:qtext)
        let $this :=
              if ( fn:matches($val/@name/string(), '\W') ) then (:are there any non-word characters :)
                '"' || $val/@name/string() || '"' (:if so, quote it :)
              else if ( $val/@name eq "" ) then (:blank?:)
                '""'
              else  (:apparently, just a single word:)
                $val/@name/string()
        let $this := $facet/@name || ':' || $this
        let $selected := fn:matches($qtext, $this, 'i')
        let $icon :=
              if ( $selected ) then
                <img src="/resources/images/red-x.png"/>
              else
                <img src="/resources/images/green-check.png"/>
        let $link :=
              if ( $selected ) then
                search:remove-constraint($qtext, $this, $options)
              else if ( string-length($qtext) gt 0 ) then
                "(" || $qtext || ")" || " AND " || $this
              else
                $this
        let $link := fn:encode-for-uri($link)
        return
            <div>{$icon}<a href="{xdmp:get-invoked-path()}?q={$link}">{fn:lower-case($print)}</a> ({$val/@count/string()})</div>
        return (
          <div>{$facet-items}</div>
        )
        }
        </div>
      else
        <div>&#160;</div>
      }
  
  </div>
  <div class="col-md-10">
    {if ($search-results) then
      <div class="search-results">
        <h4>{$title} Search Results</h4>
        
        { if ($start gt 1)
        then
           <span><span class="field-label">Start:</span> {$start}</span>
        else ()
        }
        
      { (: only show a non-default page length :)
      if ($page-length = 10) then
        ()
      else
        (concat('Page length: ', $page-length), <br/>)
      }
      
        <span class="field-label">Found:</span> {format-number($count, '#,###')} of {format-number(xdmp:estimate(/skos:concept), '#,###')} 
        concepts in
        {xdmp:elapsed-time() div xs:dayTimeDuration('PT1S') } seconds.<br/>

        
        <span class="field-label">Query:</span>"{$q}"<br/>
        <a href="{xdmp:get-request-path()}?debug=true&amp;q={$q}">View Debug</a><br/>
      {
      style:prev-next-pagination-links($start, $page-length, $count, 'q=' || $q)
      }
      {
      for $result at $count in $search-results/search:result
        let $uri := $result/@uri/string()
        let $concept := doc($uri)/skos:concept
        let $prefLabel := string($concept/skos:prefLabel)
        let $altLabel := $concept/skos:altLabel/text()
        let $definition := $concept/skos:definition/text()
        let $broader := $concept/skos:broader/text()
        return
        <div class="glossary-hit">
          
          <div class="skos-concept">
            {$count + $start - 1}.
            {'' (:<span class="green-uri">{$uri}</span><br/>:) }
            <span class="field-label">Concept: </span> <a href="/views/view-concept.xqy?uri={$uri}"><b>{$prefLabel}</b></a> <br/>
            
            {'' (:<span class="field-label">Definition:</span> {$definition}<br/>:) }
            {if ($altLabel)
               then
                 <div>
                    <span class="field-label">Alternate Label: </span> {$altLabel}
                 </div>
               else ()
            }
            
            {if ($broader)
               then
                 <div>
                    <span class="field-label">Broader: </span> {$broader}
                 </div>
               else ()
            }
          </div>

        { (: each of these is match somewhere in the concept :)
        for $snippet in $result/search:snippet
        let $match-count := count($snippet/search:match)
        return
          <div class="snippit">
          {
                for $match in $snippet/search:match
                  let $path := $match/@path
                  (: convert the path to get the last element
                   the last() does not work when there are emphaisis elements.
                   let $para-num := substring-after(tokenize($path, '/')[last()], '*:')
                  :)
                  let $definition-indicator := ends-with($path, 'definition')
                  let $preferred-label-indicator := ends-with($path, 'prefLabel')
                return
                  <div class="match">
                    
                    
                    
                     {
                     if ($preferred-label-indicator) then
                       ()
                     else
                       for $text-or-highlight in $match/node()
                       return
                         if ($text-or-highlight instance of element()) then
                           <span class="highlight">{$text-or-highlight/text()}</span>
                         else
                           $text-or-highlight
                     }
                  </div>
          }
          </div>
        }
          <div class="green-url"><a href="/views/view-xml.xqy?uri={$uri}">{$uri}</a></div>
          <div class="action-buttons">
            <span class="field-label">Actions:</span>
            
            
            <a class="btn btn-info" role="button" href="/services/make-entity.xqy?uri={$uri}">Make Entity</a>
            <a class="btn btn-info" role="button" href="/services/make-property.xqy?uri={$uri}">Make Property</a>
            <a class="btn btn-info" role="button" href="/services/make-relationship.xqy?uri={$uri}">Make Relationship</a>
            
            <!-- <a class="btn btn-info" role="button" href="/forms/add-to-term-list.xqy?uri={$uri}">Add to Term List</a> -->

         </div>
       </div>
      }
</div>
else
  <div>Your search returned no results. </div>
}
        </div>
    </div>
</div>

return style:assemble-page($title, $content)
