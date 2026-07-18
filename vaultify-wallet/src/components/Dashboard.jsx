import { useState, useEffect } from "react";
import { getBalance } from "../lib/wallet";
import { getCryptoPrices } from "../lib/prices";
import { openMoonPay } from "../lib/moonpay";
import PriceCard from "./PriceCard";
import SendCrypto from "./SendCrypto";

export default function Dashboard({ wallet, onLogout }) {

  const [ethBalance, setEthBalance] = useState("0");
  const [prices, setPrices] = useState(null);
  const [updated, setUpdated] = useState("");
  const [error, setError] = useState("");
  const [sendMode, setSendMode] = useState(false);

  async function refresh() {

    try {

      setError("");

      let balance = "0";

      try {
        balance = await getBalance(wallet.address);
      } catch(e) {
        console.error("Balance ETH erreur:", e);
      }

      setEthBalance(balance);

      const data = await getCryptoPrices();

      setPrices(data);

      setUpdated(
        new Date().toLocaleTimeString("fr-CA")
      );

    } catch (e) {

      console.error(e);
      setError(
        "Impossible de charger les données réseau."
      );

    }

  }


  useEffect(() => {

    refresh();

    const timer = setInterval(
      refresh,
      60000
    );

    return () => clearInterval(timer);

  }, []);


  if (sendMode) {
    return (
      <SendCrypto
        wallet={wallet}
        onBack={() => setSendMode(false)}
      />
    );
  }


  const ethValue =
    prices
      ? Number(ethBalance) * Number(prices.ethereum.cad)
      : 0;


  return (

    <div className="main-container">

      <h1>
        Vaultify Wallet
      </h1>


      <div className="info-box">

        <strong>
          Adresse du wallet
        </strong>

        <p style={{wordBreak:"break-all"}}>
          {wallet.address}
        </p>

      </div>


      


      <div className="info-box">

        <h3>
          Portfolio
        </h3>

        <p>
          ETH :
          {" "}
          {Number(ethBalance).toFixed(6)}
        </p>


        <p>
          Valeur estimée :
          {" "}
          {ethValue.toLocaleString(
            "fr-CA",
            {
              minimumFractionDigits:2,
              maximumFractionDigits:2
            }
          )}
          CAD
        </p>


        <small>
          Mise à jour : {updated || "en cours..."}
        </small>

      </div>


      {prices && (
        <>
          <PriceCard
            name="Ethereum"
            amount={ethBalance}
            price={prices.ethereum.cad}
            change={prices.ethereum.change}
          />


          <PriceCard
            name="Bitcoin"
            amount="0"
            price={prices.bitcoin.cad}
            change={prices.bitcoin.change}
          />


          <PriceCard
            name="USDC"
            amount="0"
            price={prices.usdc.cad}
            change={prices.usdc.change}
          />
        </>
      )}


      <button
        className="btn-primary"
        onClick={() =>
          openMoonPay(wallet.address,"ETH")
        }
      >
        Acheter crypto
      </button>


      <button
        className="btn-primary"
        onClick={() => setSendMode(true)}
      >
        Envoyer ETH
      </button>


      <button
        className="btn-secondary"
        onClick={refresh}
      >
        Actualiser
      </button>


      <button
        className="btn-secondary"
        onClick={onLogout}
      >
        Déconnexion
      </button>


    </div>

  );

}
