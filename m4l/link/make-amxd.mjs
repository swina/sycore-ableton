// Packs sycore-link.maxpat into a ready Max MIDI Effect device: sycore-link.amxd (drag it into Live).
// .amxd layout: "ampf" <u32 4> "mmmm" (MIDI effect) "meta" <u32 4> <4 bytes> "ptch" <u32 len> <patcher JSON + NUL>
import { readFileSync, writeFileSync } from 'node:fs';
const json = Buffer.from(readFileSync(new URL('./sycore-link.maxpat', import.meta.url), 'utf8') + '\n\0', 'utf8');
const u32 = n => { const b = Buffer.alloc(4); b.writeUInt32LE(n); return b; };
const out = Buffer.concat([
  Buffer.from('ampf'), u32(4), Buffer.from('mmmm'),
  Buffer.from('meta'), u32(4), Buffer.alloc(4),
  Buffer.from('ptch'), u32(json.length), json,
]);
writeFileSync(new URL('./sycore-link.amxd', import.meta.url), out);
console.log('wrote sycore-link.amxd', out.length, 'bytes');
