const FALLBACK = {
  ethereum:{cad:0,change:0},
  bitcoin:{cad:0,change:0},
  usdc:{cad:0,change:0}
};

export async function getCryptoPrices(){

  try {

    const response = await fetch(
      "https://api.coingecko.com/api/v3/simple/price?ids=ethereum,bitcoin,usd-coin&vs_currencies=cad&include_24hr_change=true",
      {
        cache:"no-store"
      }
    );

    if(!response.ok){
      throw new Error("API prix indisponible");
    }

    const data = await response.json();

    return {
      ethereum:{
        cad:Number(data.ethereum?.cad || 0),
        change:Number(data.ethereum?.cad_24h_change || 0)
      },

      bitcoin:{
        cad:Number(data.bitcoin?.cad || 0),
        change:Number(data.bitcoin?.cad_24h_change || 0)
      },

      usdc:{
        cad:Number(data["usd-coin"]?.cad || 0),
        change:Number(data["usd-coin"]?.cad_24h_change || 0)
      }
    };

  } catch(error){

    console.error("Prix erreur:",error);

    return FALLBACK;

  }

}
