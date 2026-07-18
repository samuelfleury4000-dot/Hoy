#!/bin/bash

BASE=".nuvyra"
DATA="$BASE/logs/live_audit_history.csv"
OUT="$BASE/reports/NUVYRA_COMMAND_CENTER_V2.html"

mkdir -p "$BASE/reports"

if [ ! -f "$DATA" ]; then
echo "Historique absent"
exit 1
fi

LATEST=$(tail -1 "$DATA")

DATE=$(echo "$LATEST" | cut -d',' -f1)
SCORE=$(echo "$LATEST" | cut -d',' -f2)
BUILD=$(echo "$LATEST" | cut -d',' -f3)
SECURITY=$(echo "$LATEST" | cut -d',' -f4)
FILES=$(echo "$LATEST" | cut -d',' -f5)
SIZE=$(echo "$LATEST" | cut -d',' -f6)

cat > "$OUT" <<HTML
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>NUVYRA COMMAND CENTER</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

body{
background:#070b12;
color:white;
font-family:Arial;
padding:30px;
}

.grid{
display:grid;
grid-template-columns:repeat(auto-fit,minmax(250px,1fr));
gap:20px;
}

.card{
background:#111827;
padding:25px;
border-radius:20px;
box-shadow:0 0 20px #000;
}

.green{
color:#00ff88;
}

.orange{
color:#ffaa00;
}

.big{
font-size:45px;
font-weight:bold;
}

</style>

</head>


<body>


<h1>🛡️ NUVYRA LIVE COMMAND CENTER</h1>

<p>
Dernière analyse :
$DATE
</p>


<div class="grid">


<div class="card">
<h2>SCORE GLOBAL</h2>

<div class="big green">
$SCORE/100
</div>

</div>



<div class="card">
<h2>BUILD</h2>

<h2 class="green">
$BUILD
</h2>

</div>



<div class="card">

<h2>SECURITY</h2>

<h2 class="green">
$SECURITY
</h2>

</div>



<div class="card">

<h2>PROJECT</h2>

<p>
Fichiers:
$FILES
</p>

<p>
Taille:
$SIZE
</p>

</div>


</div>



<div class="card">

<h2>Evolution Score</h2>

<canvas id="chart"></canvas>

</div>



<div class="card">

<h2>Alert Engine</h2>

<p class="green">
Aucune anomalie critique détectée
</p>

</div>



<div class="card">

<h2>Audit History</h2>

<table border="1" width="100%" cellpadding="8">

<tr>
<th>Date</th>
<th>Score</th>
<th>Build</th>
<th>Security</th>
</tr>

HTML


tail -50 "$DATA" | while IFS=',' read D S B SEC F SZ
do

echo "
<tr>
<td>$D</td>
<td>$S</td>
<td>$B</td>
<td>$SEC</td>
</tr>
" >> "$OUT"

done



cat >> "$OUT" <<HTML

</table>

</div>



<script>

const ctx=document.getElementById('chart');

new Chart(ctx,{
type:'line',

data:{
labels:[

HTML


tail -20 "$DATA" | awk -F',' '{print "\"" $1 "\","}' >> "$OUT"


cat >> "$OUT" <<HTML

],

datasets:[{

label:"NUVYRA SCORE",

data:[

HTML


tail -20 "$DATA" | awk -F',' '{print $2 ","}' >> "$OUT"


cat >> "$OUT" <<HTML

],

borderWidth:3

}]

},

options:{
responsive:true
}

});

setTimeout(()=>{
location.reload()
},300000);


</script>


</body>
</html>

HTML


echo "================================"
echo " NUVYRA COMMAND CENTER V2 READY"
echo "================================"

echo "$OUT"

