import { useState, useEffect } from "react";
import { getBalance } from "../lib/wallet";
import { getCryptoPrices } from "../lib/prices";
import { openMoonPay } from "../lib/moonpay";
import { getProvider } from "../lib/wallet";
import { getTokenBalance } from "../lib/tokens";
import { TOKENS } from "../lib/tokenList";
import { getTransactionHistory } from "../lib/history";
import PriceCard from "./PriceCard";
import SendCrypto from "./SendCrypto";
import { QRCodeSVG } from "qrcode.react";

export default function Dashboard({ wallet, onLogout }) {

  const [ethBalance, setEthBalance] = useState("0");
  const [prices, setPrices] = useState(null);
  const [updated, setUpdated] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [sendMode, setSendMode] = useState(false);
  const [copied, setCopied] = useState(false);
  const [tokens, setTokens] = useState([]);
  const [transactions, setTransactions] = useState([]);


  async function refresh() {

    if (loading) return;

    try {

      setLoading(true);
      setError("");

      const [balance, priceData] = await Promise.all([
        getBalance(wallet.address),
        getCryptoPrices()
      ]);

      setEthBalance(balance);
      setPrices(priceData);


      const provider = getProvider();

      const tokenResults = await Promise.all(
        (TOKENS.sepolia || []).map(token =>
          getTokenBalance(
            token,
            wallet.address,
            provider
          )
        )
      );

      setTokens(tokenResults);


      const history =
        await getTransactionHistory(
          wallet.address
        );

      setTransactions(history);

      setUpdated(
        new Date().toLocaleTimeString("fr-CA")
      );

    } catch (e) {

      console.error("Dashboard:", e);

      setError(
        "Impossible de charger les données réseau."
      );

    } finally {

      setLoading(false);

    }

  }


  async function copyAddress(){

    await navigator.clipboard.writeText(
      wallet.address
    );

    setCopied(true);

    setTimeout(()=>{
      setCopied(false);
    },2000);

  }


  useEffect(()=>{

    refresh();

    const timer = setInterval(
      refresh,
      60000
    );

    return ()=>clearInterval(timer);

  },[]);



  if(sendMode){

    return (
      <SendCrypto
        wallet={wallet}
        onBack={()=>setSendMode(false)}
      />
    );

  }



  const ethValue = prices
    ? Number(ethBalance) * Number(prices.ethereum.cad)
    : 0;


  const tokenValue =
    prices
      ? tokens.reduce((total, token) => {

          if(token.symbol === "USDC"){
            return total + Number(token.balance) * Number(prices.usdc.cad);
          }

          return total;

        },0)
      : 0;


  const totalValue =
    ethValue +
    tokenValue;



  return (

    <div className="main-container">

      <h1>
        Nuvyra Wallet
      </h1>


      <div className="info-box">

        <h3>
          Valeur totale
        </h3>

        <p>
          {totalValue.toLocaleString(
            "fr-CA",
            {
              minimumFractionDigits:2,
              maximumFractionDigits:2
            }
          )}
          {" CAD"}
        </p>

      </div>


      <div className="info-box">

        <strong>
          Adresse du wallet
        </strong>

        <p style={{wordBreak:"break-all"}}>
          {wallet.address}
        </p>

        <button
          className="btn-secondary"
          onClick={copyAddress}
        >
          {copied ? "Copié !" : "Copier l'adresse"}
        </button>

      </div>


      {error && (

        <div className="error-box">
          {error}
        </div>

      )}



      <div className="info-box">

        <h3>
          Solde du wallet
        </h3>


        <p>
          ETH :
          {" "}
          {Number(ethBalance).toFixed(6)}
        </p>


        <p>
          Valeur totale :
          {" "}
          {totalValue.toLocaleString(
            "fr-CA",
            {
              minimumFractionDigits:2,
              maximumFractionDigits:2
            }
          )}
          CAD
        </p>


        <small>
          Dernière mise à jour :
          {" "}
          {updated || "en cours..."}
        </small>


      </div>




      {tokens.length > 0 && (

        <div className="info-box">

          <h3>
            Tokens
          </h3>

          {tokens.map((token,index)=>(

            <p key={index}>
              {token.symbol} :
              {" "}
              {Number(token.balance).toFixed(4)}

              {" | "}

              {token.symbol === "USDC"
                ? (
                    Number(token.balance) *
                    Number(prices?.usdc?.cad || 0)
                  ).toLocaleString(
                    "fr-CA",
                    {
                      minimumFractionDigits:2,
                      maximumFractionDigits:2
                    }
                  ) + " CAD"
                : "0 CAD"
              }

            </p>

          ))}

        </div>

      )}


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




      {transactions.length > 0 && (

        <div className="info-box">

          <h3>
            Activité récente
          </h3>


          {transactions.map((tx,index)=>(

            <div key={index}>

              <p>
                {tx.from.toLowerCase() === wallet.address.toLowerCase()
                  ? "Sortie"
                  : "Entrée"}

                {" : "}

                {Number(tx.value).toFixed(6)}
                {" ETH"}

              </p>


              <small>
                {tx.date}
              </small>

              <hr />

            </div>

          ))}

        </div>

      )}


      <button
        className="btn-primary"
        onClick={()=>openMoonPay(wallet.address,"ETH")}
      >
        Acheter crypto
      </button>



      <button
        className="btn-primary"
        onClick={()=>setSendMode(true)}
      >
        Envoyer ETH
      </button>



      <button
        className="btn-secondary"
        onClick={refresh}
        disabled={loading}
      >
        {loading ? "Actualisation..." : "Actualiser"}
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