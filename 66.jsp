<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>DDL</title>
	## <script type="module" src="js/md-block.js"></script>
	<style type="text/css">
	
	body {
		background-color: #1b2626;
		color: #1ace8a;
		font-family: monospace;
		font-size: 12px;
	}

	a {
		color: #07edf9;
	}

	a.repo {
		color: #ff7bf7;
	}

	#cves {
	  
	  margin: auto;
	  display: grid;
	  grid-template-columns:repeat(3, 1fr);
	  grid-gap:0.5em;
	  padding:0.5em;
	  counter-reset:divs
	  
	}

	div.cve {
	  
	  width: 30vw;
	  height: 30vw;
	  border: 2px solid #36c183;
/*	  background:teal;*/
/*	  counter-increment:divs;*/
	  min-height:10vw;
	  display:flex;
	  flex-direction: column;
	  padding: 0.3em;

/*	  align-items:center;*/
/*	  justify-content:center;*/
	}

	div.highlighted {
		border: 3px solid #ffdf00;
	}


	div.cveheader {
/*		height: 50%;*/
		min-height: 30%;
		overflow: scroll;
		border-bottom: 1px solid white;
/*		height: 15vw;*/
/*		padding*/
	}


	@media only screen and (max-width: 768px) {

		#cves {
	  
		  margin: auto;
		  display: grid;
		  
	/*	  grid-template-columns:repeat(3, 1fr);*/
		  grid-template-columns:repeat(1, 1fr);
		  grid-gap:0.5em;
		  padding:0.5em;
		  counter-reset:divs
		  
		}

	  div.cve {
		  width: 80vw;
		  height: 80vw;
		  border: 2px solid #36c183;
		  min-height:10vw;
		  display:flex;
		  flex-direction: column;
		  padding: 0.3em;
	/*	  align-items:center;*/
	/*	  justify-content:center;*/
		}
	}

	div.posts {
		min-height: 30%;
		height: 60%;
		counter-increment:divs;
		overflow: scroll;
		color: white;
		padding: 0.2em;
	}

	h3 {
		margin-bottom: 0.1em;
	}

	.CRITICAL {
		color: #ff0000;
	}

	.HIGH {
		color: #c66253;
	}

	.MEDIUM {
		color: #f9b60c;
	}

	.LOW {
		color: #33db27;
	}

	.None {
		color: grey;
	}

	span.cvss.UNKNOWN {
		color: grey;
	}

	p.description {
		font-size: 11px;
/*		border-bottom: 1px solid white;*/
		padding-bottom: 0.5em;
		margin-top: 0.2em;
/*		margin-bottom: 0.2em;*/
	}

	p {
		margin-bottom: 0.2em;
		margin-top: 0.2em;
	}

	a.posturl {
		color: white;
	}

	h4.epss {
		margin-top: 0.2em;
		margin-bottom: 0.2em;
	}

	#index {
/*		border: 2px solid #36c183;*/
/*		align-items:center;
		justify-content:center;
		margin-left: auto;
		margin-right: auto;*/

	}

	#filterbutton {
		background-color: #1b2626;
		color: #1ace8a;
	}

	#filterbox {
		background-color: #1b2626;
		color: lime;
	}

	.updated {
		color: #ccc;
	}

	th {
	  	cursor: pointer;
	  	text-decoration: underline;
	}

	td {
		padding: .2em;
	}

	</style>
</head>



<body>
Updated at UTC {{ updated }}


<p><input id=filterbox onkeypress="filterPress(event)" placeholder="keyword / year / .."> <button id=filterbutton onclick="filterBugs()">filter</button></p>

<section id=index>
	<table id=cvetable>
		<tr>
		    <th onclick="sortTable(0)" class=cvetable-entry>CVE</th>
		    <th onclick="sortTable(1)">CVSS</th>
		    <th onclick="sortTable(2)">EPSS</th>
		    <th onclick="sortTable(3)">Posts</th>
		    <th onclick="sortTable(4)">Repos</th>
		    <th onclick="sortTable(5)">Nuclei</th>
		    <th onclick="sortTable(6)">Updated</th>
		    <th onclick="sortTable(7)">Description</th>
		</tr>

		{% for cve in data %}
		<tr>
			<td><a class="{{ data[cve]['severity'] }}" href="#{{cve}}" onclick="highlight('{{cve}}')">{{cve}}</a></td>

			<td class={{ data[cve]['severity'] }}> {{ data[cve]['cvss3'] }} </td>

			{% if data[cve]['epss'] != None %}
				<td class={{ data[cve]['epss_severity'] }}>{{ "%.2f"|format(data[cve]['epss']) }}%</td>
			{% else %}
				<td>N/A</td>
			{% endif %}

			<td>{{ data[cve]['posts']|length  }}</td>
			<td>{{ data[cve]['repos']|length  }}</td>

			{% if data[cve]['nuclei'] %}
			<td><a target=_blank href={{data[cve]['nuclei']}}>template</a></td>
			{% else %}
				<td></td>
			{% endif %}

			{% if data[cve]['updated'] %}
			<td>{{data[cve]['updated']}}</td>
			{% else %}
				<td></td>
			{% endif %}

			{% if data[cve]['description'] %}
				<td>{{ escape(data[cve]['description'][0:80]) }}</td>
			{% else %}
				<td>N/A</td>
			{% endif %}

		</tr>


		{% endfor %}

	</table>
</section>

<section id=cves>
{% for cve in data %}
	<div class="cve" id="{{cve}}">

		<div class='cveheader'>
			
			
			{% if data[cve]['cvss3'] != None %}
			<h3 class={{ data[cve]['severity'] }}><a class="{{ data[cve]['severity'] }}" target=_blank href=https://nvd.nist.gov/vuln/detail/{{ cve }}>{{ cve }}</a><br>({{ data[cve]['cvss3'] }} {{ data[cve]['severity'] }})</h3>
			{% else %}
			<h3 class="UNKNOWN"><a a class="UNKNOWN" target=_blank href=https://nvd.nist.gov/vuln/detail/{{ cve }}>{{ cve }}</a><span class="UNKNOWN cvss">(CVSS UNKNOWN)</span></h3>
			{% endif %}

			{% if data[cve]['epss'] != None %}
			<h4 class=epss>EPSS: {{ "%.2f"|format(data[cve]['epss']) }}%</h4>
			{% endif %}

			{% if data[cve]['updated'] != None %}
			<p>updated <span class=updated>{{data[cve]['updated']}}</span></p>
			{% endif %}

			<p class=numposts>{{ data[cve]['posts']|length  }} posts</p>

			<p class=description>
			 {% if data[cve]['description'] %}
			 		<th>{{ escape(data[cve]['description'][0:400]) }}</th>
			 	{% else %}
			 		<th>N/A</th>
			 	{% endif %}

			</p>
			{% if data[cve]['nuclei'] %}
			<p><a target=_blank href={{data[cve]['nuclei']}}>Nuclei template</a></p>
			{% endif %}
			{% if data[cve]['repos']|length > 0 %}
				<p>{{ data[cve]['repos']|length  }} repos</p>
				{% for url in data[cve]['repos'] %}
					<p><a class=repo target=_blank href="{{url}}">{{ url }}</a></p>
				{% endfor %}
			{% endif %}
			
		
		</div>

		<div class="posts">

			{%  for post in data[cve]['posts'] %}
				<a target=_blank href={{post['account']['url']}}>{{ post['account']['acct'] }}</a>
				<a class=posturl target=_blank href={{post['url']}}>at {{post['created_at']}}</a>
## <md-block>
{{ post['content'] }}
## </md-block>
			<hr>
			{%  endfor %}

		</div>
	</div>
	
{% endfor %}

</section>
<script>

// change placeholder by year number
document.getElementById("filterbox").placeholder = new Date().getFullYear();

function filterBugs() {
	var keyword = document.getElementById("filterbox").value.toLowerCase();

	table = document.getElementById("cvetable");
	rows = table.rows;
	for (i = 1; i < (rows.length - 1); i++) {
			if (!rows[i].textContent.toLowerCase().includes(keyword)) {
				rows[i].style.display = 'none';
			} else {
				rows[i].style.display = '';
			}
	}

	// filter the info boxes as well
	var cveboxes = document.getElementsByClassName("cve");
	for (i = 0; i < (cveboxes.length - 1); i++) {
			// only filter via cveheader box, otherwise year numbers wont work nicely since timestamps of fedi posts include recent year number
			if (!cveboxes[i].children[0].textContent.toLowerCase().includes(keyword)) {
				cveboxes[i].style.display = 'none';
			} else {
				cveboxes[i].style.display = '';
			}
	}

}

function filterPress(event) {
    if (event.keyCode == 13) { // enter key
       filterBugs();
    }
}

function isNumber(element) {
  return /^(\d|\.)+$/.test(element.innerText);
}


function sortTable(n) {
  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
  table = document.getElementById("cvetable");
  switching = true;
  // Set the sorting direction to ascending:
  dir = "asc";
  /* Make a loop that will continue until
  no switching has been done: */
  while (switching) {
    // Start by saying: no switching is done:
    switching = false;
    rows = table.rows;
    /* Loop through all table rows (except the
    first, which contains table headers): */
    for (i = 1; i < (rows.length - 1); i++) {
      // Start by saying there should be no switching:
      shouldSwitch = false;
      /* Get the two elements you want to compare,
      one from current row and one from the next: */
      x = rows[i].getElementsByTagName("TD")[n];
      y = rows[i + 1].getElementsByTagName("TD")[n];
      /* Check if the two rows should switch place,
      based on the direction, asc or desc: */
      if (dir == "asc") {
      	if (n == 2) { // epss %
      		if (Number(x.innerText.split('%')[0]) > Number(y.innerText.split('%')[0])) {
	          // If so, mark as a switch and break the loop:
	          shouldSwitch = true;
	          break;
	        }
      	} else if (isNumber(x)) {
						if (Number(x.innerText) > Number(y.innerText)) {
	          // If so, mark as a switch and break the loop:
	          shouldSwitch = true;
	          break;
	        }
      	} else {
      		if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
	          // If so, mark as a switch and break the loop:
	          shouldSwitch = true;
	          break;
	        }

      	}
        
      } else if (dir == "desc") {
      	if (n == 2) {
      		if (Number(x.innerText.split('%')[0]) < Number(y.innerText.split('%')[0])) {
	          // If so, mark as a switch and break the loop:
	          shouldSwitch = true;
	          break;
	        }
      	} else if (isNumber(x)) { // posts and cvss
					if (Number(x.innerText) < Number(y.innerText)) {
	          // If so, mark as a switch and break the loop:
	          shouldSwitch = true;
	          break;
	        }
	    } else {
	    	if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
          // If so, mark as a switch and break the loop:
	          shouldSwitch = true;
	          break;
	        }
	    }
        
      }
    }
    if (shouldSwitch) {
      /* If a switch has been marked, make the switch
      and mark that a switch has been done: */
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      switching = true;
      // Each time a switch is done, increase this count by 1:
      switchcount ++;
    } else {
      /* If no switching has been done AND the direction is "asc",
      set the direction to "desc" and run the while loop again. */
      if (switchcount == 0 && dir == "asc") {
        dir = "desc";
        switching = true;
      }
    }
  }
}

function highlight(cve) {
	// remove all highlights
	for (var element of document.getElementsByClassName("highlighted")) {
		element.classList.remove("highlighted");
	}

	console.log(cve);
	// set chosen class
	document.getElementById(cve).classList.add("highlighted");

}

window.onload = function(e){
	   if (window.location.hash) {
			highlight(window.location.hash.slice(1));
		}
}

</script>

</body>

</html>
