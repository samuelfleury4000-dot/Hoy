import { ONRAMP_PROVIDER } from "./config.js";

export function openMoonPay(walletAddress, currency="ETH") {

  const url =
    `${ONRAMP_PROVIDER.widgetUrl}` +
    `?apiKey=${ONRAMP_PROVIDER.apiKey}` +
    `&walletAddress=${walletAddress}` +
    `&currencyCode=${currency}`;

  window.open(
    url,
    "_blank",
    "width=500,height=700"
  );
}
