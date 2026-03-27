# Discord Post — Copy everything below the line into your channel

---

🦞 **Mortgage Rate Scanner — OpenClaw Integration**

Wake up to the best mortgage rates in the country, every morning, in your Discord. No tabs. No bank websites. No BS.

Your OpenClaw scrapes **10 lenders** + **2 national benchmarks** using stealth browser automation — the same tech that bypasses Cloudflare and bank anti-bot systems. Rates ranked lowest to highest. Day-over-day tracking built in.

**Here's what lands in your Discord every morning:**
```
📊 MORTGAGE RATES — Mar 26, 2026  |  9/9 lenders reporting

📊 30-YEAR FIXED
🏆 Navy Federal CU — 5.375% (6.875% APR)
▸ Wells Fargo — 5.875% (6.082% APR)
▸ Citi — 6.125% (6.259% APR)
▸ Mr. Cooper — 6.250% (6.550% APR)
▸ Guaranteed Rate — 6.325% (6.639% APR)
▸ SoFi — 6.351% (5.625% APR)
▸ US Bank — 6.375% (6.529% APR)
▸ Truist — 6.375% (6.565% APR)
▸ Freddie Mac natl avg — 6.380%  (benchmark)
▸ MND Index — 6.620%  (benchmark)
▸ Bank of America — 6.625% (6.846% APR)
📈 Avg: 6.186% | vs yesterday: ▲ 0.086%

📊 15-YEAR FIXED
🏆 Navy Federal CU — 5.375% (6.875% APR)
▸ US Bank — 5.490% (5.774% APR)
▸ Truist — 5.600% (5.892% APR)
▸ ...and more
📈 Avg: 5.632% | vs yesterday: ▲ 0.084%
```

**Lenders:** BofA • Wells Fargo • Chase • Citi • Navy Federal • SoFi • US Bank • Guaranteed Rate • Truist • Mr. Cooper
**Benchmarks:** Freddie Mac PMMS + Mortgage News Daily

🦞 **One-command install:**
```bash
bash <(curl -s https://raw.githubusercontent.com/seang1121/openclaw-mortgage-rates/main/install.sh) YOUR_ZIP
```
Replace `YOUR_ZIP` with your ZIP code. That's it. Takes 2 minutes.

**What happens:**
✅ Installs the scraper into your OpenClaw workspace
✅ Sets up stealth Chromium (bypasses anti-bot on all 10 banks)
✅ Registers a daily 8 AM cron job
✅ Report lands in your Discord every morning

**Customize everything:** ZIP code, schedule (weekdays, twice daily, whatever), delivery channel.

**Requirements:** OpenClaw + Python 3.10+

📎 Full docs + source: <https://github.com/seang1121/openclaw-mortgage-rates>

---
