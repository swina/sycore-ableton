// Local check without Live or a browser: start `npm run sim`, then `npm run bench`.
// Measures ping RTT and how early notes arrive before their beat (lookahead 100 ms).
const url = process.env.URL || 'ws://127.0.0.1:9400';
const ws = new WebSocket(url);
const tr = { playing: false, beat: 0, tempo: 120, at: 0 };
const beatNow = () => tr.playing ? tr.beat + (performance.now() - tr.at) * tr.tempo / 60000 : tr.beat;
const rtts = []; const pings = new Map(); const stats = [];
ws.onmessage = e => {
  const m = JSON.parse(e.data);
  if (m.type === 'transport') Object.assign(tr, { playing: m.playing, beat: m.beat, tempo: m.tempo, at: performance.now() });
  else if (m.type === 'pong') { rtts.push(performance.now() - pings.get(m.t)); }
  else if (m.type === 'stats') stats.push(m);
};
ws.onopen = async () => {
  for (let i = 1; i <= 200; i++) { pings.set(i, performance.now()); ws.send(JSON.stringify({ v: 1, type: 'ping', t: i })); await new Promise(r => setTimeout(r, 5)); }
  await new Promise(r => setTimeout(r, 200));
  const s = rtts.sort((a, b) => a - b);
  console.log(`ping ${s.length}/200 · avg ${(s.reduce((a, b) => a + b, 0) / s.length).toFixed(3)} · p99 ${s[Math.floor(.99 * s.length)].toFixed(3)} · max ${s.at(-1).toFixed(3)} ms`);
  let next = Math.ceil(beatNow() * 4) / 4 + 0.25; const end = next + 16;
  const look = 100 / (60000 / tr.tempo);
  const t = setInterval(() => {
    while (next < beatNow() + look && next < end) { ws.send(JSON.stringify({ v: 1, type: 'note', note: 60, vel: 100, beat: next, durBeats: 0.125 })); next += 0.25; }
    if (next >= end) { clearInterval(t); setTimeout(() => { console.log('device stats', stats); ws.close(); }, 2200); }
  }, 10);
};
