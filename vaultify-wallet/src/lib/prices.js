export async function getCryptoPrices(){

  try {

    const [eth, btc, usdc] = await Promise.all([
      fetch("https://api.coincap.io/v2/assets/ethereum").then(r => r.json()),
      fetch("https://api.coincap.io/v2/assets/bitcoin").then(r => r.json()),
      fetch("https://api.coincap.io/v2/assets/usdc").then(r => r.json())
    ]);


    console.log("PRIX COINCAP:", {
      eth,
      btc,
      usdc
    });


    return {

      ethereum:{
        cad: Number(eth.data.priceUsd) * 1.38,
        change: Number(eth.data.changePercent24Hr)
      },

      bitcoin:{
        cad: Number(btc.data.priceUsd) * 1.38,
        change: Number(btc.data.changePercent24Hr)
      },

      usdc:{
        cad: Number(usdc.data.priceUsd) * 1.38,
        change: Number(usdc.data.changePercent24Hr)
      }

    };


  } catch(error){

    console.error("Erreur prix:", error);

    return {
      ethereum:{cad:0,change:0},
      bitcoin:{cad:0,change:0},
      usdc:{cad:0,change:0}
    };

  }

}
