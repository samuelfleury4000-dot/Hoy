const EMPTY = {
  ethereum: { cad: 0, change: 0 },
  bitcoin: { cad: 0, change: 0 },
  usdc: { cad: 0, change: 0 },
};

async function coinGecko() {
  const r = await fetch(
    "https://api.coingecko.com/api/v3/simple/price?ids=ethereum,bitcoin,usd-coin&vs_currencies=cad&include_24hr_change=true",
    {
      cache: "no-store",
    },
  );

  if (!r.ok) throw new Error("CoinGecko bloqué");

  const d = await r.json();

  return {
    ethereum: {
      cad: Number(d.ethereum.cad),
      change: Number(d.ethereum.cad_24h_change),
    },
    bitcoin: {
      cad: Number(d.bitcoin.cad),
      change: Number(d.bitcoin.cad_24h_change),
    },
    usdc: {
      cad: Number(d["usd-coin"].cad),
      change: Number(d["usd-coin"].cad_24h_change),
    },
  };
}

async function coinCap() {
  const r = await fetch(
    "https://api.coincap.io/v2/assets?ids=ethereum,bitcoin,usd-coin",
    {
      cache: "no-store",
    },
  );

  if (!r.ok) throw new Error("CoinCap bloqué");

  const d = await r.json();

  const cad = 1.38;

  const get = (id) => {
    const x = d.data.find((a) => a.id === id);
    return {
      cad: Number(x.priceUsd) * cad,
      change: Number(x.changePercent24Hr),
    };
  };

  return {
    ethereum: get("ethereum"),
    bitcoin: get("bitcoin"),
    usdc: get("usd-coin"),
  };
}

export async function getCryptoPrices() {
  try {
    return await coinGecko();
  } catch (e) {
    console.warn("CoinGecko indisponible, essai CoinCap");
  }

  try {
    return await coinCap();
  } catch (e) {
    console.error("Toutes les API prix échouent", e);
    return EMPTY;
  }
}
