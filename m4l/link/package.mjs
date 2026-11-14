// Builds the distributable SY.CORE devices for Live: dist/SYCORE-Live-Devices-<version>/ and its .zip.
//   node package.mjs        (npm run package)
// The folder holds the 4 devices, the scripts they load (by file name: Max finds them next to the .amxd),
// the bridge's production node_modules (ws, @julusian/midi with prebuilt binaries for Windows and macOS),
// README / LICENSE. The version is package.json's, and must match the bridge's VERSION.
import { readFileSync, writeFileSync, rmSync, mkdirSync, cpSync, existsSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const pkg = JSON.parse(readFileSync(join(here, 'package.json'), 'utf8'));
const version = pkg.version;

// The bridge says its version to SY.CORE: the package and the bridge must agree.
const bridgeVersion = /const VERSION = '([^']+)'/.exec(readFileSync(join(here, 'sycore-link.js'), 'utf8'))?.[1];
if (bridgeVersion !== version) {
  console.error(`package.json version ${version} ≠ sycore-link.js VERSION ${bridgeVersion}: set them the same`);
  process.exit(1);
}

const DEVICES = ['sycore-link', 'sycore-link-receive', 'sycore-rig', 'sycore-map'];
const SCRIPTS = ['sycore-link.js', 'link-core.js', 'sycore-map.js', 'sycore-map-view.js', 'sycore-rig-grid.js'];

// The devices must load their scripts by name, not from a path on the computer they were built on.
for (const d of DEVICES) {
  const patch = readFileSync(join(here, `${d}.maxpat`), 'utf8');
  const abs = patch.match(/"(?:text|filename)": "[^"]*(?:[A-Za-z]:\/|\/Users\/|\/home\/)[^"]*"/);
  if (abs) {
    console.error(`${d}.maxpat loads a script by full path (${abs[0]}): rebuild without SYCORE_LINK_DIR`);
    process.exit(1);
  }
}

// Fresh .amxd from the patches.
execFileSync(process.execPath, [join(here, 'make-patch.mjs')], { cwd: here, stdio: 'inherit' });
execFileSync(process.execPath, [join(here, 'make-amxd.mjs')], { cwd: here, stdio: 'inherit' });

const name = `SYCORE-Live-Devices-${version}`;
const distDir = join(here, 'dist');
const out = join(distDir, name);
rmSync(out, { recursive: true, force: true });
mkdirSync(out, { recursive: true });

for (const d of DEVICES) cpSync(join(here, `${d}.amxd`), join(out, `${d}.amxd`));
for (const s of SCRIPTS) cpSync(join(here, s), join(out, s));
for (const f of ['README-USER.md', 'LICENSE']) {
  if (!existsSync(join(here, f))) { console.error(`missing ${f}`); process.exit(1); }
}
cpSync(join(here, 'README-USER.md'), join(out, 'README.md'));
cpSync(join(here, 'LICENSE'), join(out, 'LICENSE'));

// Production dependencies only, exactly as locked; no install scripts (the MIDI binaries are prebuilt).
const { scripts, ...shipPkg } = pkg;
writeFileSync(join(out, 'package.json'), JSON.stringify(shipPkg, null, 2) + '\n');
cpSync(join(here, 'package-lock.json'), join(out, 'package-lock.json'));
execFileSync('npm', ['ci', '--omit=dev', '--ignore-scripts', '--no-audit', '--no-fund'], { cwd: out, stdio: 'inherit' });

// The native MIDI module must carry the binaries for both systems.
const prebuilds = join(out, 'node_modules/@julusian/midi/prebuilds');
for (const p of ['midi-win32-x64', 'midi-darwin-arm64', 'midi-darwin-x64']) {
  if (!existsSync(join(prebuilds, p))) { console.error(`missing MIDI binary ${p}`); process.exit(1); }
}

// Zip (python's zipfile: no zip tool needed).
const zip = join(distDir, `${name}.zip`);
rmSync(zip, { force: true });
execFileSync('python3', ['-m', 'zipfile', '-c', zip, name], { cwd: distDir, stdio: 'inherit' });
console.log(`\n${name}: ${out}\n${zip}`);
