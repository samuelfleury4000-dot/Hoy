let timer=null;

const TIMEOUT=5*60*1000;

export function startSecurityTimer(callback){

clearTimeout(timer);

timer=setTimeout(()=>{
callback();
},TIMEOUT);

}


export function resetSecurityTimer(callback){

clearTimeout(timer);

timer=setTimeout(()=>{
callback();
},TIMEOUT);

}


export function clearSecurityTimer(){

clearTimeout(timer);
timer=null;

}
