# soknadsverktoy

CV-er og søknader i LaTeX, spisset mot hver enkelt bedrift sammen med Claude.
Ett sted for fakta, ett sted for utseende, én mappe per søknad.

Utskriftsvennlig A4. **CV-en er én side**, med QR-kode til nett-CV-en der hele bredden ligger.
Søknadsbrevet er også én side, med samme topp, så de hører synlig sammen.

---

## Verktøyet og personen er skilt

Dette er det viktigste å forstå i repoet. **Verktøyet vet ingenting om deg.**
Alt om personen ligger i `input/`, og verktøyet leser den mappa.

| Verktøy — virker for hvem som helst | Deg — privat |
|---|---|
| `CLAUDE.md`, `ARBEIDSFLYT.md`, `README.md` | `input/` — alt om deg |
| `cvstil.sty`, `fonts/`, `bygg.sh` | `soknader/` — dine søknader |
| `maler/soknad/` — mal per bedrift | `cv-generell.tex` + PDF-er |
| `maler/nytt-oppsett/` — tomme startfiler | `soknader/_status.md` — statusbordet ditt |
| `nytt-oppsett.sh` | |

Ingen fil i venstre kolonne nevner navnet ditt, hjemstedet ditt, jobbene dine eller hvor langt du
vil pendle. Alt det står i `input/om-meg.md`, og instruksene peker dit i stedet for å gjenta det.

**Vil du gi verktøyet videre:**

```bash
./nytt-oppsett.sh ~/jobbsok-<navn>
```

Det lager en ren kopi med tomme startfiler. Ingenting personlig følger med.
Den nye brukeren fyller ut `input/`, og Claude blir kjent med dem i stedet.

---

## Innhold

| Fil / mappe | Hva |
|---|---|
| `input/` | **Alt om personen.** Claude leser hele mappa før den skriver noe. |
| `input/innhold.tex` | Alle fakta som havner på CV-en, som LaTeX-blokker med `Kort`-varianter for ensideren. |
| `input/om-meg.md` | Posisjonering, røde tråder, svakheter, geografi, tilgjengelighet. Hvem du er, ikke hvor sakene står. |
| `input/historier.md` | Konkrete episoder med detaljer. **Råmaterialet til søknadsbrev.** |
| `input/skrivestil/SKRIVESTIL.md` | Hvordan du skriver. Bindende for alt som skrives i ditt navn. |
| `input/skrivestil/tekster/` | Dump-mappe: tekst du har skrevet selv, så Claude lærer stemmen din. |
| `soknader/<firma>/` | **Én mappe per bedrift:** annonse, research, spisset CV, søknad og PDF-er. |
| `soknader/_status.md` | **Statusbordet.** Hvor hver sak står, hva som er flaskehalsen, hva som er frarådet. Claude leser den først i hver økt. |
| `maler/soknad/` | Malene som kopieres for hver ny bedrift. |
| `maler/nytt-oppsett/` | Tomme startfiler for en ny bruker, inkludert `status.md`. |
| `cvstil.sty` | Utseendet: farger, skrifter, oppføringer, brevoppsett, `\tettmodus`. Rør sjelden. |
| `cv-generell.tex` | Grunnversjonen med hele bredden. Utgangspunkt, ikke noe du sender. |
| `bygg.sh` | Bygger PDF ved siden av kildefila, og sier fra hvis sidetallet er feil. |
| `nytt-oppsett.sh` | Lager en ren kopi av verktøyet til en ny bruker. |
| `ARBEIDSFLYT.md` | Stegene for (A) annonse → CV + søknad og (B) bedrift → research + åpen søknad. |
| `CLAUDE.md` | Instrukser for Claude. Beskriver *hvordan*, aldri *hvem*. |
| `fonts/` | Space Grotesk, JetBrains Mono, CVBody (Source Sans 3). SIL OFL 1.1. |

### Mappe per bedrift

```
soknader/_status.md             # statusbordet — hvor alle saker står
soknader/hansen-maskin/
  annonse.md                    # bare hvis det finnes en utlyst stilling
  research.md                   # firma, behov, røde tråder, mottaker, kilder
  hansen-maskin-cv.tex/.pdf     # spisset CV — 1 side
  hansen-maskin-soknad.tex/.pdf # søknadsbrev — 1 side
```

---

## Kom i gang

Har du klonet dette repoet og mangler `input/`, er den holdt utenfor git med vilje.
Hent startfilene på plass først:

```bash
cp -r maler/nytt-oppsett/input .
cp maler/nytt-oppsett/cv-generell.tex .
mkdir -p soknader && cp maler/nytt-oppsett/status.md soknader/_status.md
```

Så bygger du:

```bash
./bygg.sh                                    # alle
./bygg.sh soknader/hansen-maskin/*.tex       # én bedrift
```

Krever XeLaTeX og `pdfinfo` (poppler) til sidetall-sjekken:

- **Arch / CachyOS:** `sudo pacman -S texlive-xetex texlive-langeuropean texlive-latexextra texlive-fontsrecommended poppler`
- **Debian / Ubuntu:** `sudo apt install texlive-xetex texlive-lang-european texlive-latex-extra poppler-utils`
- **Windows / macOS:** installer TeX Live eller MiKTeX. Bygg alltid fra rotmappa, ellers finnes ikke `fonts/` og `input/`.

## Bruke med Claude

Åpne mappa i Claude Code og si for eksempel:

- *«Her er en stillingsannonse: <lenke>. Spiss CV-en.»*
- *«Lag en åpen søknad til <bedrift / nettside>.»*
- *«Er det verdt å søke her?»* — Claude skal si nei når svaret er nei.

Claude leser `CLAUDE.md`, `ARBEIDSFLYT.md` og hele `input/`, gjør research, skriver filene og bygger PDF.

### To regler som holder verktøyet ærlig

**Fakta endres bare i `input/innhold.tex`.** Spissing skjer i variantfilene, med `\renewcommand`,
utvalg og rekkefølge. Da kan ingen søknad inneholde noe du ikke faktisk har gjort.

**Stemmen er din.** Et velformulert brev som kunne vært skrevet av hvem som helst, blir lest som
autogenerert og lagt bort. Derfor finnes `input/skrivestil/`: du dumper inn tekst du selv har skrevet,
og `SKRIVESTIL.md` destillerer hvordan du faktisk formulerer deg, helt ned til tegnsetting.

Og `input/historier.md` finnes fordi en CV sier «god med kunder», mens det folk husker er
den sinte kunden som gikk fornøyd derfra. Brev blir troverdige av episoder.

**Retter du på et brev Claude har skrevet, legg den rettede versjonen i `input/skrivestil/tekster/`.**
Dine egne rettelser er det beste grunnlaget som finnes, og verktøyet blir bedre for hver søknad.

---

## Gjøre verktøyet offentlig

Verktøyet er skrevet for å kunne deles. Men **et repo som har hatt personlige data i seg, kan ikke
gjøres offentlig.** Git glemmer ikke: en fil du sletter ligger fortsatt i historikken, og hvem som
helst kan hente den ut med én kommando.

Bruk derfor to repoer:

| Repo | Innhold | Synlighet |
|---|---|---|
| Ditt arbeidsrepo | `input/`, `soknader/` og verktøyet | **Privat**, alltid |
| Verktøyrepoet | bare verktøyet, ren historikk | Offentlig, hvis du vil |

Slik lager du det offentlige:

```bash
./nytt-oppsett.sh ~/mitt-verktoy
cd ~/mitt-verktoy
git init -b main && git add -A
```

**Se over hva som faktisk blir med, før du publiserer:**

```bash
git diff --cached --name-only        # dette blir offentlig
git status --porcelain --ignored     # linjer med !! holdes utenfor
```

Første liste skal bare inneholde verktøyfiler. Dukker `input/`, `soknader/` eller din egen
`cv-generell.tex` opp der, stopp og se på `.gitignore` før du går videre.

```bash
git commit -m "Verktøy for spissede CV-er og søknader"
gh repo create <navn> --public --source=. --push
```

Velg et `<navn>` du ikke allerede bruker. Ligger arbeidsrepoet ditt på GitHub under navnet
du hadde tenkt å bruke, må det offentlige hete noe annet.

**Feiler pushen med «Could not read from remote repository»:** `gh` setter remoten til SSH
hvis kontoen din er satt opp for det, og da stopper det om du ikke har SSH-nøkkel. Repoet er
allerede opprettet på det tidspunktet, så du trenger bare bytte til HTTPS og pushe igjen:

```bash
git remote set-url origin https://github.com/<bruker>/<navn>.git
git push -u origin main
```

Kopien har en streng `.gitignore` som holder `input/`, `soknader/` og `cv-generell.tex` utenfor git.
Det beskytter alle som forker repoet mot å publisere sine egne data ved et uhell.

**Se etter deg selv i eksemplene også.** Verktøyfilene skrives mens du bruker dem, og eksempler i
README, maler og arbeidsflyt blir fort hentet fra ditt eget søk: et firmanavn, en historie, et tall
fra en kartlegging. Hver for seg er de ikke personopplysninger, men de kan kjennes igjen. Søk etter
navn, steder og tall fra ditt eget `input/` før du publiserer, og les commit-meldingene dine. Når det
offentlige repoet først er rent, synk endringer inn for hånd i stedet for å lage det på nytt.

**En force-push vasker ikke alt.** Den fjerner gamle commits fra historikken, men GitHub viser dem
fortsatt via en direkte lenke, og SHA-ene ligger i den offentlige hendelsesloggen en stund. Det
eneste som fjerner dem helt, er å slette repoet og lage det på nytt. Gjør det riktig før første push.

## Personvern

`input/` inneholder personopplysninger, og `soknader/` inneholder research på navngitte personer.
**Hold repoet privat.** Husk også at git ikke glemmer: en fil du sletter, ligger fortsatt i historikken.
Skal noe aldri inn, legg det i `.gitignore` før første commit.
