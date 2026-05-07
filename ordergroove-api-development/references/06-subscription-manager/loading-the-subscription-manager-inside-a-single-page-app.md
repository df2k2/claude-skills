# Loading the Subscription Manager inside a Single-Page App

The Ordergroove Subscription Manager (SM) uses a singleton data store. When loading the SM inside a single-page app (e.g. built with React), you may notice odd behavior when navigating away from and back to the SM. For example, the order data may be stale, or previous toast notifications may re-fire. This is because the SM data store only reinitializes when the page does a full reload, not on client-side navigations. When you navigate back to the page it uses the same data as the initial load.

To reinitialize the SM data store without a full page reload and prevent issues with stale data, you can call `window.og.smi.reset()` whenever you navigate back to the page that loads the SM.

For example, this is what that could look like in a React component:

```jsx
import { useState, useEffect } from "react";

const MERCHANT_ID = "YOUR_MERCHANT_ID"

export default function SubscriptionManager() {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (window.og?.smi) {
      // if the script has already been loaded, we don't need to load it again, since the global objects have already been populated
      // reset the SM data store
      window.og.smi.reset();
      setLoading(false);
      return;
    }
    

    // load the OG SM script
    const script = document.createElement("script");
    script.src =
      `https://static.ordergroove.com/${MERCHANT_ID}/msi.js`;
    script.async = true;
    script.onload = () => setLoading(false);
    document.body.appendChild(script);

    return () => {
      document.body.removeChild(script);
    };
  }, []);

  return (
    <>
      <h1>SM</h1>
      {loading ? <p>Loading...</p> : <og-smi></og-smi>}
    </>
  );
}

```