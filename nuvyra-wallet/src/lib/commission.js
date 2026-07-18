import { FEE_CONFIG, SERVICE_FEE_PERCENT } from "./fees.js";

export function calculateServiceFee(amount) {
  const value = Number(amount);

  if (!value || value <= 0) {
    throw new Error("Montant invalide");
  }

  return (value * SERVICE_FEE_PERCENT) / 100;
}

export function getFeeAddress(symbol) {
  const address = FEE_CONFIG[symbol];

  if (!address) {
    throw new Error("Adresse commission introuvable");
  }

  return address;
}

export function getFeeDetails(amount, symbol) {
  return {
    percent: SERVICE_FEE_PERCENT,
    amount: calculateServiceFee(amount),
    address: getFeeAddress(symbol),
  };
}
