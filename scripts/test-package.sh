#!/usr/bin/env bash
# Packs the SDK exactly as `npm publish` would, installs it into a throwaway
# Roku channel with ropm (alias "mparticle", as the README recommends) and
# checks the installed copy is wired up correctly. Usage: npm run test:package
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
version="$(node -p "require('$root/package.json').version")"

fail() { echo "test-package: $*" >&2; exit 1; }

# 1. The SDK reports the same version npm publishes.
grep -q "SDK_VERSION = \"$version\"" "$root/source/mparticle/mParticleCore.brs" \
  || fail "SDK_VERSION in source/mparticle/mParticleCore.brs does not match package.json ($version)"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# 2. ropm copies every top-level folder of a package into the channel, so only source/ and components/ may ship.
(cd "$root" && npm pack --silent --pack-destination "$work" > /dev/null)
tarball="$work/mparticle-roku-sdk-$version.tgz"
folders="$(tar -tzf "$tarball" | awk -F/ 'NF > 2 { print $2 }' | sort -u | tr '\n' ' ')"
[ "$folders" = "components source " ] || fail "package must contain only source/ and components/, found: $folders"

# 3. Install into a throwaway channel the way the README tells customers to.
app="$work/app"
mkdir -p "$app/source" "$app/components"
cat > "$app/package.json" <<EOF
{ "name": "ropm-smoke-test", "version": "1.0.0", "private": true,
  "dependencies": { "mparticle": "file:$tarball" } }
EOF
printf 'title=ropm smoke test\nmajor_version=1\nminor_version=0\nbuild_version=1\n' > "$app/manifest"
cat > "$app/source/main.brs" <<'EOF'
sub main()
    print mparticle_mParticleConstants().SDK_VERSION
end sub
EOF
cat > "$app/components/MainScene.xml" <<'EOF'
<?xml version="1.0" encoding="utf-8" ?>
<component name="MainScene" extends="Scene">
  <script type="text/brightscript" uri="pkg:/source/roku_modules/mparticle/mparticle/mParticleCore.brs"/>
  <script type="text/brightscript" uri="pkg:/components/MainScene.brs"/>
</component>
EOF
cat > "$app/components/MainScene.brs" <<'EOF'
sub init()
    m.mp = mparticle_mParticleSGBridge(CreateObject("roSGNode", "mparticle_mParticleTask"))
end sub
EOF
(cd "$app" && "$root/node_modules/.bin/ropm" install)

lib="$app/source/roku_modules/mparticle/mparticle"
task="$app/components/roku_modules/mparticle"

# 4. SSL pinning loads the certificate from this literal at runtime; it must be rewritten to a file that exists.
grep -q '"pkg:/source/roku_modules/mparticle/mparticle/mParticleBundle.crt"' "$lib/mParticleCore.brs" \
  || fail "certificate path in mParticleCore.brs was not rewritten into roku_modules"
[ -f "$lib/mParticleBundle.crt" ] || fail "mParticleBundle.crt is missing from roku_modules"

# 5. The task is renamed and its run-loop string matches the renamed sub (bsc cannot check strings).
grep -q 'name="mparticle_mParticleTask"' "$task/mParticleTask.xml" || fail "mParticleTask component was not prefixed"
grep -q 'functionName = "mparticle_setupRunLoop"' "$task/mParticleTask.brs" || fail "task functionName was not prefixed"
grep -qi 'sub mparticle_setupRunLoop' "$task/mParticleTask.brs" || fail "setupRunLoop was not prefixed"

# 6. The channel compiles: every prefixed call resolves and every script include points at a real file.
(cd "$app" && "$root/node_modules/.bin/bsc" --createPackage false --stagingDir "$work/staging")

echo "test-package: mparticle-roku-sdk@$version installs and compiles with ropm"
