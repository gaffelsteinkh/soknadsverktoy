#!/usr/bin/env bash
# Lager en ren kopi av verktøyet, uten noe personlig i seg.
#
#   ./nytt-oppsett.sh ~/mitt-jobbsok
#
# Kopierer verktøyfilene og tomme startfiler. Alt om den nåværende
# brukeren (input/, soknader/, cv-generell.tex og PDF-ene) blir IKKE med.
set -eu
cd "$(dirname "$0")"

mal="${1:-}"
if [ -z "$mal" ]; then
  echo "Bruk: ./nytt-oppsett.sh <målmappe>"
  echo "Eksempel: ./nytt-oppsett.sh ~/jobbsok"
  exit 2
fi
if [ -e "$mal" ] && [ -n "$(ls -A "$mal" 2>/dev/null)" ]; then
  echo "FEIL: $mal finnes allerede og er ikke tom."
  exit 1
fi

mkdir -p "$mal"

# --- Verktøyet: virker for hvem som helst ----------------------------
cp    bygg.sh nytt-oppsett.sh cvstil.sty CLAUDE.md ARBEIDSFLYT.md README.md "$mal/"
cp    LICENSE "$mal/" 2>/dev/null || true
# Streng .gitignore: holder brukerens egne data utenfor git som standard.
cp    maler/nytt-oppsett/gitignore "$mal/.gitignore" 
cp -r fonts        "$mal/"
mkdir -p "$mal/maler"
cp -r maler/soknad "$mal/maler/"
cp -r maler/nytt-oppsett "$mal/maler/"

# --- Tomme startfiler på plass ---------------------------------------
cp -r maler/nytt-oppsett/input "$mal/input"
cp    maler/nytt-oppsett/cv-generell.tex "$mal/cv-generell.tex"
mkdir -p "$mal/soknader"
cp    maler/nytt-oppsett/status.md "$mal/soknader/_status.md"
cat > "$mal/soknader/.gitkeep" <<'INNER'
Én mappe per bedrift havner her. Start fra maler/soknad/.
_status.md er statusbordet, og Claude leser det først i hver økt.
Innholdet holdes utenfor git som standard - se .gitignore.
INNER

chmod +x "$mal/bygg.sh" "$mal/nytt-oppsett.sh"

cat <<SLUTT

Ferdig. Rent oppsett i: $mal

Slik kommer du i gang:
  1. cd $mal
  2. Fyll ut input/innhold.tex med dine egne fakta.
  3. Fyll ut input/om-meg.md. Posisjoneringen og geografien der styrer alt.
  4. Skriv løs i input/historier.md. Konkrete episoder, ikke stikkord.
  5. Dump tekst du har skrevet selv i input/skrivestil/tekster/.
     Se LES-MEG.md der for hva som er mest nyttig.
  6. La soknader/_status.md ligge tom til du har en sak. Den fylles ut
     underveis, og er det første Claude leser i en ny økt.
  7. Åpne mappa i Claude Code og si: «Les input/ og fortell hva du mangler.»

  Punkt 3 til 5 er det som skiller et brev som høres ut som deg
  fra et som høres ut som en mal. Ikke hopp over dem.

  input/ og soknader/ er holdt utenfor git som standard. Vil du
  versjonere dine egne data, bruk et separat PRIVAT repo. Git glemmer
  ikke: det du committer her, ligger i historikken for alltid.

Ingenting personlig fra det gamle oppsettet er kopiert.
SLUTT
