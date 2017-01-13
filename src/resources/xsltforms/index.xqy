
xquery version "1.0-ml";

(: Site Landing Page :)

import module namespace style="http://danmccreary.com/style" at "/modules/style.xqy";
declare option xdmp:output "method=html";

let $title := 'MarkLogic Business Glossary'

let $content := 
<div class="content">
		<h1>XSLTForms 1.0 Release Candidate 2</h1>
		<p><a href="http://sourceforge.net/projects/xsltforms">XSLTForms</a> can convert <a href="http://www.w3.org/TR/xforms11/">XForms</a> to XHTML+Javascript (AJAX) on any browser or web-server (PHP, ASP, J2EE,...) with an XSLT 1.0 engine.</p>
		<p>Just add a stylesheet at the beginning of your XForms XML document!</p>
		<p>Supported by Internet Explorer, Mozilla Firefox, Opera, Safari and Chrome.</p>
		<p>This is an open source project with a LGPL licence.</p>
		<table>
			<tr>
				<td valign="top">
					<p>Beginners examples:</p>
					<ul>
						<li><a href="hello.xml">Hello World</a></li>
						<li><a href="input.xml">Input</a></li>
						<li><a href="incremental.xml">Incremental</a></li>
						<li><a href="xpath.xml">XPath</a></li>
						<li><a href="bind.xml">Bind</a></li>
						<li><a href="input-width.xml">Input Width</a></li>
						<li><a href="secret.xml">Secret</a></li>
						<li><a href="textarea.xml">Textarea</a></li>
						<li><a href="checkbox.xml">Checkbox</a></li>
						<li><a href="select1.xml">Select1</a></li>
						<li><a href="select1-drop.xml">Select1 drop</a></li>
						<li><a href="select.xml">Select</a></li>
						<li><a href="select-model.xml">Select model</a></li>
						<li><a href="select-multi-col.xml">Select multi column</a></li>
						<li><a href="select-from-file.xml">Select from file</a></li>
						<li><a href="date.xml">Date</a></li>
						<li><a href="button.xml">Button</a></li>
						<li><a href="deep-copy.xml">Deep copy</a></li>
						<li><a href="first-field.xml">Setting initial cursor</a></li>
					</ul>
				</td>
				<td valign="top">
					<p>Advanced Examples:</p>
					<ul>
						<li><a href="spreadsheet.xml">Spreadsheet</a></li>
						<li><a href="address.xml">Address</a></li>
						<li><a href="balance.xml">Balance</a></li>
						<li><a href="calculator.xml">Calculator</a></li>
						<li><a href="colors.xml">Background Colors</a></li>
						<li><a href="bookmarks.xml">Bookmarks</a></li>
						<li><a href="writers.xml">Writers (Subforms)</a></li>
						<li><a href="xf.xml">Contact</a></li>
						<li><a href="tinymce.xml">TinyMCE</a></li>
					</ul>
					<p>SVG Examples (only for recent browsers):</p>
					<ul>
						<li><a href="flags.xml">Colored Flags</a></li>
						<li><a href="piechart.xml">Pie Chart</a></li>
					</ul>
				</td>
			</tr>
			<tr>
			   <td>
			   <p>Metadata Examples:</p>
			       <ul>
						<li><a href="code-table.xml">Code Table</a></li>
						
					</ul>
			   </td>
			</tr>
		</table>
		<p><a href="http://www.agencexml.com/xforms-tests/testsuite/XForms1.1/Edition1/driverPages/forms/XF11_TestSuite.xhtml">W3C Test Suite Report for XSLTForms</a></p>
		<p>XSLTForms support list: <a href="https://lists.sourceforge.net/lists/listinfo/xsltforms-support">https://lists.sourceforge.net/lists/listinfo/xsltforms-support</a></p>
		<p>Contact information : <a href="http://www.agencexml.com">&lt;agenceXML&gt;</a>, Bordeaux, France</p>
		<p><a href="mailto:xsltforms@agencexml.com">xsltforms@agencexml.com</a></p>
		<a href="http://sourceforge.net"><img src="http://sflogo.sourceforge.net/sflogo.php?group_id=242651&amp;type=5" width="210" height="62" border="0" alt="SourceForge.net Logo" /></a>
		<p>Copyright &#169; 2008-2014 agenceXML - Alain COUTHURES</p>
		
		</div>

return style:assemble-page($title, $content)