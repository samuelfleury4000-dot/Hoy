import { useState } from 'react';
import WalletSetup from './components/WalletSetup';
import Dashboard from './components/Dashboard';
import { hasStoredWallet, unlockWallet, wipeWallet } from './lib/wallet';

export default function App() {
  const [wallet, setWallet] = useState(null);
  const [isLocked, setIsLocked] = useState(hasStoredWallet());
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const attemptUnlock = async () => {
    try {
      const w = await unlockWallet(password);
      setWallet(w);
      setIsLocked(false);
      setError('');
    } catch (e) { 
      setError('Mot de passe incorrect ou erreur de déchiffrement.'); 
    }
  };

  const handleLogout = () => {
    wipeWallet();
    window.location.reload();
  };

  return (
    <div>
      {/* HEADER GLOBAL COMPRIS SUR TOUTES LES PAGES */}
      <header className="app-header">
        <div className="logo-container">
          <div className="status-dot"></div>
          VAULTIFY
        </div>
        <div className="network-badge">
          Sepolia (testnet)
        </div>
      </header>

      {/* LOGIQUE DE ROUTAGE */}
      {hasStoredWallet() && isLocked ? (
        <div className="main-container">
          <h1>Bon retour</h1>
          <p className="description">Entre ton mot de passe pour déverrouiller ton portefeuille local.</p>
          
          {error && <div className="error-box">{error}</div>}
          
          <div className="input-group">
            <label className="input-label">MOT DE PASSE</label>
            <input type="password" className="input-field" onChange={(e) => setPassword(e.target.value)} />
          </div>
          
          <button className="btn-primary" onClick={attemptUnlock}>Déverrouiller</button>
          <button className="btn-secondary" style={{ marginTop: '1rem', borderColor: '#ef4444', color: '#ef4444' }} onClick={handleLogout}>Effacer le wallet de cet appareil</button>
        </div>
      ) : !wallet ? (
        <WalletSetup onWalletCreated={() => window.location.reload()} />
      ) : (
        <Dashboard wallet={wallet} onLogout={() => window.location.reload()} />
      )}
    </div>
  );
}
