# pykalshi (arshka) — captured 2026-06-26

> Captured from https://github.com/arshka/pykalshi.
> Real-time streaming focus, pandas integration. Refresh via `scripts/kalshi/fetch_docs.sh`.

## Summary

**PyKalshi** is an unofficial Python client for Kalshi prediction markets that
provides WebSocket streaming, automatic retries, pandas integration, and clean
interfaces for building trading systems.

## Key Features

- Real-time data streaming via WebSocket for orderbooks, tickers, and trades.
- Automatic retry logic with exponential backoff for rate limiting.
- Object-oriented abstractions like `Market`, `Order`, and `Event` with built-in methods.
- DataFrame conversion for data analysis workflows.
- Rich display support in Jupyter notebooks.
- Local orderbook state management from WebSocket updates.
- Type-safe code using Pydantic models.

## Core Functionality

Users can browse markets, execute trades, and manage portfolios through a
clean API. The library handles authentication via API credentials and private
keys stored in environment variables.

## Comparison to Official SDK

`pykalshi` emphasizes production trading infrastructure — streaming, error
handling, ergonomic interfaces. The official auto-generated `kalshi-python`
SDK has more comprehensive raw endpoint coverage but a less ergonomic
interface; for real-time and trading-system-building, pykalshi is more
practical.

The project includes example notebooks, sample trading bots, and an optional
web dashboard for real-time market monitoring.
