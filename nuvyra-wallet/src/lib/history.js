export async function getTransactionHistory(address) {
  try {
    const apiKey = import.meta.env.VITE_ETHERSCAN_KEY || "";

    if (!apiKey) {
      console.warn("Clé Etherscan absente");

      return [];
    }

    const url =
      `https://api-sepolia.etherscan.io/api` +
      `?module=account` +
      `&action=txlist` +
      `&address=${address}` +
      `&startblock=0` +
      `&endblock=99999999` +
      `&page=1` +
      `&offset=10` +
      `&sort=desc` +
      `&apikey=${apiKey}`;

    const response = await fetch(url);

    const data = await response.json();

    if (data.status !== "1") {
      return [];
    }

    return data.result.map((tx) => ({
      hash: tx.hash,

      from: tx.from,

      to: tx.to,

      value: Number(tx.value) / 1e18,

      date: new Date(Number(tx.timeStamp) * 1000).toLocaleString("fr-CA"),
    }));
  } catch (error) {
    console.error("Historique erreur:", error);

    return [];
  }
}
