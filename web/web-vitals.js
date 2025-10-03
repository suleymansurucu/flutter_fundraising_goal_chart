// Web Vitals monitoring for SEO performance
(function() {
  function getCLS(onPerfEntry) {
    let clsValue = 0;
    let clsEntries = [];
    let sessionValue = 0;
    let sessionEntries = [];

    new PerformanceObserver((entryList) => {
      for (const entry of entryList.getEntries()) {
        if (!entry.hadRecentInput) {
          const firstSessionEntry = sessionEntries[0];
          const lastSessionEntry = sessionEntries[sessionEntries.length - 1];

          if (sessionValue && entry.startTime - lastSessionEntry.startTime < 1000 && entry.startTime - firstSessionEntry.startTime < 5000) {
            sessionValue += entry.value;
            sessionEntries.push(entry);
          } else {
            sessionValue = entry.value;
            sessionEntries = [entry];
          }

          if (sessionValue > clsValue) {
            clsValue = sessionValue;
            clsEntries = [...sessionEntries];
            onPerfEntry({ name: 'CLS', value: clsValue, entries: clsEntries });
          }
        }
      }
    }).observe({ type: 'layout-shift', buffered: true });
  }

  function getFID(onPerfEntry) {
    new PerformanceObserver((entryList) => {
      for (const entry of entryList.getEntries()) {
        onPerfEntry({ name: 'FID', value: entry.processingStart - entry.startTime, entries: [entry] });
      }
    }).observe({ type: 'first-input', buffered: true });
  }

  function getFCP(onPerfEntry) {
    new PerformanceObserver((entryList) => {
      for (const entry of entryList.getEntries()) {
        if (entry.name === 'first-contentful-paint') {
          onPerfEntry({ name: 'FCP', value: entry.startTime, entries: [entry] });
        }
      }
    }).observe({ type: 'paint', buffered: true });
  }

  function getLCP(onPerfEntry) {
    new PerformanceObserver((entryList) => {
      const entries = entryList.getEntries();
      const lastEntry = entries[entries.length - 1];
      onPerfEntry({ name: 'LCP', value: lastEntry.startTime, entries: [lastEntry] });
    }).observe({ type: 'largest-contentful-paint', buffered: true });
  }

  function getTTFB(onPerfEntry) {
    new PerformanceObserver((entryList) => {
      for (const entry of entryList.getEntries()) {
        if (entry.responseStart > 0) {
          onPerfEntry({ name: 'TTFB', value: entry.responseStart - entry.requestStart, entries: [entry] });
        }
      }
    }).observe({ type: 'navigation', buffered: true });
  }

  // Send metrics to Google Analytics
  function sendToAnalytics(metric) {
    if (typeof gtag !== 'undefined') {
      gtag('event', metric.name, {
        event_category: 'Web Vitals',
        event_label: metric.id,
        value: Math.round(metric.name === 'CLS' ? metric.value * 1000 : metric.value),
        non_interaction: true,
      });
    }
  }

  // Initialize Web Vitals monitoring
  getCLS(sendToAnalytics);
  getFID(sendToAnalytics);
  getFCP(sendToAnalytics);
  getLCP(sendToAnalytics);
  getTTFB(sendToAnalytics);
})();

