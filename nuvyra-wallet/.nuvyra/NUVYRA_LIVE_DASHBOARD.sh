#!/bin/bash

BASE=".nuvyra"
DATA="$BASE/logs/live_audit_history.csv"
OUT="$BASE/reports/NUVYRA_LIVE_DASHBOARD.html"

mkdir -p "$BASE/reports"

if [ ! -f "$DATA" ]; then
echo "Aucun historique trouvé."
exit 1
fi

SCORE=$(tail -1 "$DATA" | cut -d',' -f2)
BUILD=$(tail -1 "$DATA" | cut -d',' -f3)
SECURITY=$(tail -1 "$DATA" | cut -d',' -f4)

PREVIOUS=$(tail -2 "$DATA" | head -1 | cut -d',' -f2)

ALERT="Aucune alerte"

if [ "$SCORE" -lt "$PREVIOUS" ] 2>/dev/null
then
ALERT="⚠️ Dégradation détectée"
fi


cat > "$OUT" <<HTML
<!DOCTYPE html>
<html>
<head>
<title>NUVYRA LIVE DASHBOARD</title>

<style>
body{
font-family:Arial;
background:#0b0f14;
color:white;
padding:30px;
}

.card{
background:#151b23;
padding:20px;
border-radius:15px;
margin:15px;
}

.good{
color:#00ff88;
}

.warn{
color:#ffaa00;
}

.bar{
height:25px;
background:#222;
border-radius:20px;
overflow:hidden;
}

.fill{
height:100%;
width:${SCORE}%;
background:#00ff88;
}

</style>

</head>

<body>

<h1>NUVYRA LIVE DASHBOARD</h1>

<div class="card">
<h2>Status</h2>

<h1 class="good">
${SCORE}/100
</h1>

<div class="bar">
<div class="fill"></div>
</div>

</div>


<div class="card">

<h2>Système</h2>

<p>Build:
<b>${BUILD}</b>
</p>

<p>
Security:
<b>${SECURITY}</b>
</p>

</div>


<div class="card">

<h2>Alertes</h2>

<p>
${ALERT}
</p>

</div>


<div class="card">

<h2>Historique</h2>

<table border="1" cellpadding="8">

<tr>
<th>Date</th>
<th>Score</th>
<th>Build</th>
<th>Security</th>
</tr>

HTML

tail -20 "$DATA" | while IFS=',' read DATE SCORE BUILD SECURITY FILES SIZE
do

echo "
<tr>
<td>$DATE</td>
<td>$SCORE</td>
<td>$BUILD</td>
<td>$SECURITY</td>
</tr>
" >> "$OUT"

done


cat >> "$OUT" <<HTML

</table>

</div>


<div class="card">

<h2>Graphique évolution</h2>

<pre>

HTML

tail -20 "$DATA" | awk -F',' '
{
printf "%s | ",$2
for(i=0;i<$2/5;i++) printf "█"
printf "\n"
}
' >> "$OUT"


cat >> "$OUT" <<HTML

</pre>

</div>


</body>
</html>

HTML


echo "================================"
echo " NUVYRA DASHBOARD CREATED"
echo "================================"

echo "$OUT"

