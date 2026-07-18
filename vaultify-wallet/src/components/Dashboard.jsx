import { useState, useEffect } from 'react';
import { getBalance, sendTransaction } from '../lib/wallet';

export default function Dashboard({ wallet, onLogout }) {
  const [balance, setBalance] = useState('0');
  const [toAddress, setToAddress] = useState('');
  const [amount, setAmount] = useState('');

  useEffect(() => {
    if (wallet) {
      getBalance(wallet.address).then(setBalance);
    }
  }, [wallet]);

  const handleSend = async () => {
    try {
      const result = await sendTransaction({ wallet, toAddress, amountEth: amount });
      alert(`Transaction réussie !\nHash: ${result.mainTxHash}`);
      getBalance(wallet.address).then(setBalance);
    } catch (e) { 
      alert(e.message); 
    }
  };

  return (
    <div className="container">
      <h2>Votre Portefeuille</h2>
      <p className="mono" style={{ fontSize: '0.9rem', color: '#94a3b8' }}>{wallet.address}</p>
      <h3 style={{ fontSize: '2rem', margin: '1rem 0' }}>{balance} ETH</h3>
      
      <div style={{ marginTop: '20px', borderTop: '1px solid #334155', paddingTop: '20px' }}>
        <input placeholder="Adresse destinataire (0x...)" onChange={(e) => setToAddress(e.target.value)} />
        <input type="number" placeholder="Montant ETH" onChange={(e) => setAmount(e.target.value)} />
        <button onClick={handleSend} style={{ marginTop: '10px' }}>Envoyer (inclut frais de service)</button>
      </div>
      
      <button style={{ background: '#ef4444', marginTop: '20px' }} onClick={onLogout}>Verrouiller / Quitter</button>
    </div>
  );
}
