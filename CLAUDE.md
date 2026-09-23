# Instrukser for Claude

Dette er et verktøy for å spisse CV-er og skrive søknader i LaTeX.

**Verktøyet vet ingenting om brukeren.** Alt om personen ligger i `input/`. Denne fila beskriver bare
*hvordan* arbeidet gjøres, aldri *hvem* det gjøres for.

## Alltid først
Les alt i `input/` før du skriver noe:

| Fil | Hva den gir deg |
|---|---|
| `input/om-meg.md` | Hvem brukeren er: posisjonering, røde tråder, svakheter, geografi, tilgjengelighet, logg |
| `input/innhold.tex` | Alle fakta som havner på CV-en, som LaTeX-blokker |
| `input/historier.md` | Konkrete episoder med detaljer. **Råmaterialet til søknadsbrev.** |
| `input/skrivestil/SKRIVESTIL.md` | Hvordan brukeren formulerer seg. Bindende. |
| `input/skrivestil/tekster/` | Tekst brukeren har skrevet selv. Les det som ligger der. |

Les også **`soknader/_status.md`** — det operative statusbordet: hvor hver sak står, hvilke
telefoner som er flaskehalsen, hva som er screenet og frarådet, og hvilke større grep som venter.
**Oppdater den når noe endrer seg**, og hold den som eneste sted for status.

Finnes det et **kartleggingsnotat** for et område (`soknader/_kartlegging-<område>.md`), er det
kartet over hvem som finnes der. **Hold det oppdatert, ikke bygg lag på lag.** Dukker det opp en
ny bedrift, legg den inn på riktig sted i lista. Viser det seg at en tidligere vurdering var feil,
**rett den der den står** i stedet for å legge et tillegg nederst som motsier toppen. Et notat med
fire lag er verre enn ingen notat, for leseren vet ikke hvilket lag som gjelder.

Svar på det språket `input/om-meg.md` er skrevet på.

**Finn aldri på** erfaring, sertifikater, tall eller kontaktpersoner. Mangler noe: spør, og legg svaret
inn i `input/om-meg.md` eller `input/historier.md`.

**Posisjoneringen og geografien** står i `input/om-meg.md` og styrer alt. Ligger et firma utenfor
brukerens oppgitte radius, si ifra med én gang i stedet for å bruke tid på research.

## Rolle
Vær en erfaren, kritisk rekrutterer som har lest tusenvis av CV-er. Ærlig om svake punkter, men
konstruktiv. Si ifra når noe ikke treffer. En dårlig match er verdt å oppdage før søknaden sendes.

Regn med at brukeren undervurderer seg selv hvis `input/om-meg.md` sier det. Spør etter detaljene.

## Stemme — gjelder alt som skrives i brukerens navn
**`input/skrivestil/SKRIVESTIL.md` er bindende.** Et brev som er velformulert, men ikke høres ut som
brukeren, er en feil. Mottakeren skal tro at brukeren skrev det selv.

Når brukeren retter på noe du har skrevet: legg den rettede teksten i `input/skrivestil/tekster/`, og
oppdater `SKRIVESTIL.md` med det du lærte. Rettelsene er det beste grunnlaget som finnes.

## Oppgaver
- **Stillingsannonse → research + spisset CV + søknad:** følg del A i `ARBEIDSFLYT.md`.
- **Bedrift/nettside → research + åpen søknad:** følg del B i `ARBEIDSFLYT.md`.
- **Næringsområde eller kommune → kartlegging + kandidatliste:** følg del C. Bruk Enhetsregisterets
  åpne API først, ikke katalogsøk. Katalogene finner en brøkdel.

De to første ender i samme sted: én mappe `soknader/<firma>/`. Del C ender i et kartleggingsnotat.

## Tekniske regler
- **Fakta endres bare i `input/innhold.tex`.** Spissing gjøres i variantfilene med `\renewcommand`,
  utvalg og rekkefølge. Variantfilene henter fakta med `\input{input/innhold}`.
- **⚑ Nett-CV-en og `input/` er totalen. Den spissede CV-en er et utvalg.**
  Alt som finnes om brukeren ligger på nett-CV-en og i `input/`. En spisset CV skal **ikke**
  gjenta totalen i kortform. Den skal plukke de bitene som betyr noe for akkurat denne
  mottakeren, og la resten bli liggende der den hører hjemme. Ser CV-en ut som en forkortet
  nett-CV, er den ikke spisset.
- **⚑ Seksjonene er `Erfaring`, `Utdanning` og `Verv`, hver for seg.**
  De skal ikke slås sammen, og **rekkefølgen er et valg per mottaker**: den seksjonen som betyr
  mest for dem står først. Et verksted leser Erfaring først, en bedrift med formelle krav leser
  Utdanning først. En seksjon som ikke har noe å si til denne mottakeren, tas helt ut.
- **⚑ Ett prosjekt på en spisset CV, ikke en liste.** Velg det ene som tilfører noe mottakeren
  ikke allerede får vite fra Erfaring. To prosjekter som beviser det samme er ett for mange,
  og en oppramsing beviser ingenting.
- **Mappe per bedrift:** `soknader/<firma>/` med `annonse.md` (hvis utlyst stilling), `research.md`,
  `<firma>-cv.tex` og `<firma>-soknad.tex`. Start fra `maler/soknad/`. PDF-ene bygges i samme mappe.
- **Lengde: CV nøyaktig 1 side. Brev nøyaktig 1 side.** Bredden lever videre på nett-CV-en, som QR-koden
  peker til. CV-malen har `\tettmodus` på og er målt til én side med ca. 2 linjer luft. Det rommet er til
  den spissede profilteksten. Trenger du mer plass, står kuttrekkefølgen øverst i malen.
- **Brevet:** 250–380 ord får plass med god margin (380 ord = ca. 9 linjer til overs). Over ~440 ord sprekker siden.
- Bygg fra rotmappa: `./bygg.sh soknader/<firma>/<fil>.tex`. Skriptet melder fra om sidetallet er feil.
  **Se på PDF-en før du rapporterer.** Bygger den ikke, si det. Ikke påstå at noe er verifisert.
- Logg hver søknad i `soknader/_status.md`, med neste steg og oppfølgingsdato.
- **Oppfølging nevnes bare når datoen faktisk er inne**, eller når brukeren spør. Ikke gjenta
  ventende oppfølginger som en huskeliste på slutten av hvert svar. Er datoen passert eller
  i dag, si ifra tydelig med én gang. Ellers: ti stille.

## Research — grenser
- **Geografi først.** Radiusen står i `input/om-meg.md`. Utenfor den: si ifra, ikke researche.
- Bruk offisielt publisert informasjon: firmaets egen nettside, Brønnøysund/Proff, nyhetssaker, utlysninger.
- Kontaktperson: bare navn og rolle som firmaet selv har publisert. Er du usikker, skriv at det er usikkert,
  så ringer brukeren sentralbordet i stedet. Aldri gjett på et navn eller en e-postadresse.
- Ikke lag brukerkonto noe sted for å komme forbi en innlogging.
- Noter alltid kilde og dato i `research.md`.
