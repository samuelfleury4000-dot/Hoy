import { NETWORKS } from "../lib/config";

export default function NetworkSelector({network,setNetwork}){

return (

<select
className="network-badge"
value={network}
onChange={(e)=>setNetwork(e.target.value)}
>

{Object.entries(NETWORKS).map(([key,value])=>(

<option key={key} value={key}>
{value.name}
</option>

))}

</select>

);

}
