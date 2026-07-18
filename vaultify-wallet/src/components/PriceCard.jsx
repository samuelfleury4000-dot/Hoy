export default function PriceCard({name, amount, price, change}) {
  return (
    <div className="info-box">
      <h3>{name}</h3>

      <p>
        Quantité : {amount || "0"}
      </p>

      <p>
        Prix : {Number(price || 0).toLocaleString("fr-CA", {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        })} CAD
      </p>

      <p>
        24h : {Number(change || 0).toFixed(2)}%
      </p>
    </div>
  );
}
