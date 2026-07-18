import { createContext, useContext, useEffect, useState } from "react";
import {
  hasStoredWallet,
  unlockWallet,
  wipeWallet
} from "../lib/wallet";

const WalletContext = createContext(null);

export function WalletProvider({ children }) {

  const [wallet, setWallet] = useState(null);
  const [address, setAddress] = useState("");
  const [locked, setLocked] = useState(true);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (hasStoredWallet()) {
      setLocked(true);
    }
  }, []);

  async function unlock(password) {
    setLoading(true);

    try {
      const w = await unlockWallet(password);

      setWallet(w);
      setAddress(w.address);
      setLocked(false);

      return true;

    } catch (e) {
      console.error(e);
      return false;

    } finally {
      setLoading(false);
    }
  }


  function lock() {
    setWallet(null);
    setAddress("");
    setLocked(true);
  }


  function removeWallet() {
    wipeWallet();
    lock();
  }


  return (
    <WalletContext.Provider
      value={{
        wallet,
        address,
        locked,
        loading,
        unlock,
        lock,
        removeWallet
      }}
    >
      {children}
    </WalletContext.Provider>
  );
}


export function useWallet(){
  return useContext(WalletContext);
}
