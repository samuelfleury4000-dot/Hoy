import { useState } from "react";
import { useWallet } from "../context/WalletContext";

export default function UnlockWallet(){

  const { unlock, loading } = useWallet();

  const [password,setPassword] = useState("");
  const [error,setError] = useState("");

  async function submit(e){
    e.preventDefault();

    setError("");

    const ok = await unlock(password);

    if(!ok){
      setError("Mot de passe incorrect");
    }
  }


  return (
    <div className="wallet-box">

      <h2>🔐 Déverrouiller Nuvyra</h2>

      <form onSubmit={submit}>

        <input
          type="password"
          placeholder="Mot de passe"
          value={password}
          onChange={e=>setPassword(e.target.value)}
        />

        <button disabled={loading}>
          {loading ? "Déverrouillage..." : "Ouvrir Wallet"}
        </button>

      </form>

      {error &&
        <p className="error">
          {error}
        </p>
      }

    </div>
  );
}
