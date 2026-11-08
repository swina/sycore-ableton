// Packs the device patches into ready Max MIDI Effect devices (drag them into Live):
//   sycore-link.maxpat → sycore-link.amxd, sycore-link-receive.maxpat → sycore-link-receive.amxd
// .amxd layout: "ampf" <u32 4> "mmmm" (MIDI effect) "meta" <u32 4> <4 bytes> "ptch" <u32 len> <patcher JSON + NUL>
import { readFileSync, writeFileSync } from 'node:fs';
const u32 = n => { const b = Buffer.alloc(4); b.writeUInt32LE(n); return b; };
for (const name of ['sycore-link', 'sycore-link-receive']) {
  const json = Buffer.from(readFileSync(new URL(`./${name}.maxpat`, import.meta.url), 'utf8') + '\n\0', 'utf8');
  const out = Buffer.concat([
    Buffer.from('ampf'), u32(4), Buffer.from('mmmm'),
    Buffer.from('meta'), u32(4), Buffer.alloc(4),
    Buffer.from('ptch'), u32(json.length), json,
  ]);
  writeFileSync(new URL(`./${name}.amxd`, import.meta.url), out);
  console.log(`wrote ${name}.amxd`, out.length, 'bytes');
}
