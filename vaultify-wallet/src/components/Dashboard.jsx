import { useState, useEffect } from 'react';
import { getBalance, sendTransaction } from '../lib/wallet';
import { ONRAMP_PROVIDER } from '../lib/config';

export default function Dashboard({ wallet, onLogout }) {
  const [balance, setBalance] = useState('0');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchBalance = async () => {
      try {
        const bal = await getBalance(wallet.address);
        setBalance(bal);
      } catch (e) {
        console.error(e);
      } finally {
        setLoading(false);
      }
    };
    fetchBalance();
  }, [wallet.address]);

  const openMoonPay = () => {
    // Construit l'URL avec ta clé API et l'adresse du wallet
    const url = `${ONRAMP_PROVIDER.widgetUrl}?apiKey=${ONRAMP_PROVIDER.apiKey}&walletAddress=${wallet.address}&currencyCode=ETH`;
    window.open(url, '_blank', 'width=500,height=700');
  };

  return (
    <div className="main-container">
      <h1>Ton Wallet</h1>
      
      <div className="info-box">
        <label className="input-label">ADRESSE</label>
        <p style={{ wordBreak: 'break-all', fontFamily: 'monospace' }}>{wallet.address}</p>
        
        <label className="input-label" style={{ marginTop: '1rem', display: 'block' }}>SOLDE</label>
        <p style={{ fontSize: '1.5rem', fontWeight: 'bold' }}>
          {loading ? '...' : `${balance} ETH`}
        </p>
      </div>

      {/* BOUTON MOONPAY - C'est ici que le point de vente est activé */}
      <button className="btn-primary" onClick={openMoonPay}>
        Acheter avec {ONRAMP_PROVIDER.name}
      </button>

      <button className="btn-secondary" onClick={onLogout} style={{ marginTop: '1rem' }}>
        Déconnexion
      </button>
    </div>
  );
}
