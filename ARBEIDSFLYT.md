# Arbeidsflyt

Alt om én bedrift havner i **`soknader/<firma>/`**:

```
soknader/<firma>/
  annonse.md          # bare hvis det finnes en utlyst stilling
  research.md         # alltid
  <firma>-cv.tex      # spisset CV — 1 side
  <firma>-soknad.tex  # søknadsbrev — 1 side
  *.pdf               # bygges her av ./bygg.sh
```

Start alltid fra `maler/soknad/`.

---

## A) Stillingsannonse → spisset CV + søknad

1. Brukeren sender annonsen (lenke eller tekst).
2. Claude leser alt i `input/`, og fyller `annonse.md`:
   krav, ønsker, nøkkelord, tone, frist, kontaktperson. **Lim inn hele annonseteksten** — lenker dør.
3. Kort research på firmaet i `research.md` (se punkt B2) — nok til at brevet kan si noe konkret om *dem*.
4. **Kritisk vurdering, muntlig til brukeren før det skrives noe:** match, hull, hvilke røde tråder som bærer,
   og om stillingen i det hele tatt er verdt å søke på. Er matchen svak, si det.
5. `<firma>-cv.tex` fra `maler/soknad/cv.tex`. Spissingen ligger i profilteksten, utvalget og rekkefølgen.
   **Behandle nett-CV-en og `input/` som totalen, og denne CV-en som et utvalg av den.** Velg
   bitene som treffer annonsen. Seksjonene `Erfaring`, `Utdanning` og `Verv` står hver for seg,
   og den som betyr mest for mottakeren kommer først. Ett prosjekt, ikke en liste.
6. `<firma>-soknad.tex` fra malen — samme regler som i B4.
7. `./bygg.sh soknader/<firma>/*.tex` → **CV 1 side, brev 1 side**. Se på PDF-ene.
8. Logg i `soknader/_status.md` med frist og oppfølgingsdato.

## B) Bedrift/nettside → research + åpen søknad

1. Brukeren sender firmanavn eller nettside.
   **Sjekk geografi først:** radiusen står i `input/om-meg.md`. Utenfor den: si ifra med én gang i stedet for å researche.
2. Claude researcher og fyller `research.md`:
   - firmaets nettside (om oss, tjenester, nyheter, karriere)
   - Proff/Brønnøysund (størrelse, ansatte, økonomi)
   - nyheter og lokalaviser, utlyste stillinger, LinkedIn-omtale
   - **Finnes det en utlyst stilling?** I så fall: gå til del A i stedet, eller spør brukeren hva de vil.
   - riktig mottaker (navn, rolle) — bare hvis firmaet har publisert det. Ellers: marker som usikkert.
   - noter kilder og dato.
3. Claude rapporterer til brukeren **før** brevet skrives: hva de trenger, hvilke røde tråder som treffer,
   hva som er svakt, og hvilken rolle det gir mening å be om.
4. `<firma>-soknad.tex` fra malen. **Les `input/skrivestil/SKRIVESTIL.md` og `input/historier.md` på nytt
   rett før du skriver.** Regler for brevet:
   - **Stemmen er brukerens, ikke din.** Ingen tankestrek (—) i løpende tekst. Ingen floskler.
     Bruk episodene fra `historier.md`, ikke stikkordene fra CV-en.
   - Én side, 250–380 ord, bokmål, direkte og konkret — ingen floskler
     («jeg er en engasjert og løsningsorientert person»).
   - Første avsnitt handler om DEM (noe spesifikt fra researchen), ikke om brukeren.
   - 2–3 røde tråder, hver med ett konkret bevis fra CV-en.
   - Kun fakta som står i `innhold.tex`/`om-meg.md`. Aldri finn på erfaring.
   - Følg posisjoneringen i `input/om-meg.md`. Den bestemmer hvordan brukeren skal selges inn.
   - Konkret forespørsel: en jobb/rolle der bredden er nyttig for akkurat dette firmaet, og et ønske om en prat.
   - Avslutt slik `SKRIVESTIL.md` beskriver at brukeren pleier å avslutte.
5. `<firma>-cv.tex` fra malen — spisset mot firmaet, 1 side.
6. `./bygg.sh soknader/<firma>/*.tex`. Se på PDF-ene.
7. Logg i `soknader/_status.md` med oppfølgingsdato.
8. **Når brukeren har rettet på teksten:** legg den rettede versjonen i `input/skrivestil/tekster/`
   og oppdater `SKRIVESTIL.md`. Det er slik verktøyet blir bedre for hver søknad.

---

## C) Næringsområde → kartlegging → kandidatliste

Når brukeren bor nær et næringsområde, en industripark eller en kommune med mange arbeidsgivere,
er det sløsing å undersøke én bedrift av gangen. Hent hele området først.

**Denne delen kom av en erfaring:** første kartlegging av et område ble gjort med 1881, Gule Sider
og søk, og fant rundt tjue virksomheter. Enhetsregisteret ga over hundre arbeidsgivere med fem eller flere
ansatte i det samme området. **Under en femtedel var funnet.** Konklusjonene som ble trukket fra
den femtedelen var derfor feil.

### 1. Hent hele området fra Enhetsregisteret
Åpent API, ingen innlogging, ingen nøkkel:

```bash
curl 'https://data.brreg.no/enhetsregisteret/api/underenheter?beliggenhetsadresse.postnummer=<PNR>&size=500'
curl 'https://data.brreg.no/enhetsregisteret/api/enheter?forretningsadresse.postnummer=<PNR>&size=500'
```

**Begge trengs.** `underenheter` er de faktiske arbeidsstedene, med ansatte per lokasjon.
`enheter` er selskapene. Store arbeidsgivere ligger ofte bare som underenhet på stedet.

Filtrer på gatenavn i adressen, og dedupliser på organisasjonsnummer.

Andre nyttige kall:
```bash
# alle avdelinger under ett selskap
curl 'https://data.brreg.no/enhetsregisteret/api/underenheter?overordnetEnhet=<ORGNR>&size=100'
# ett oppslag
curl 'https://data.brreg.no/enhetsregisteret/api/enheter/<ORGNR>'
```

### 2. Skill arbeidsgivere fra tomme selskaper
De fleste treffene er holdingselskaper og eiendomsselskaper uten ansatte.
**Filtrer på `antallAnsatte` >= 5.** Da står de reelle arbeidsplassene igjen.

### 3. Grupper på næringskode, ikke på navn
`naeringskode1` avslører hva de faktisk gjør. Et navn gjør det ikke.
Grupper treffene, og se etter klynger som matcher **profilene i `input/om-meg.md`.**

⚠ **Næringskoden er en pekepinn, ikke en konklusjon.** Et firma oppført som «engroshandel» kan vise
seg å ha eget verksted. Screening er ikke research.

### 4. Screen mot brukerens profiler, og skriv en prioritert liste
For hver kandidat: hvorfor er den interessant, og hva stopper den. **«Ikke undersøkt» er ikke en
grunn.** «Avdelingen har to ansatte, ring først» er en grunn.

**Rapporter til brukeren her**, før det gjøres dyp research. Det er hen som vet hva som frister.

### 5. Velg tre til fem, og gjør del B på dem
Screeningen sier ingenting om økonomi, behov eller mottaker. Den sier bare hvem som finnes.

---

### Hva man skal se etter i selve researchen

Dette er lærdommen fra å gjøre det på et helt område. Let etter disse fem tingene, i denne
rekkefølgen, for de avgjør om det er verdt å skrive et brev i det hele tatt.

**1. Den publiserte veien rundt et formelt krav.**
Er bransjen stengt bak fagbrev eller sertifikater, sjekk om noen skriver ut et unntak selv.
Formuleringer som *«start som hjelpearbeider og ta fagbrevet senere»*, «lærlingbedrift siden …»
eller «vi gjennomfører egen opplæring» er gull, og de står som regel på karrieresiden.

**2. Ferske endringssignaler.**
Nyhetsarkivet på firmaets egen side er undervurdert. *Flyttet til større lokaler. Ny avdelingsleder.
Utvidet verksted.* Et firma som nettopp har fått mer kapasitet eller en ny leder over et område,
ansetter oftere enn et som står stille. **Og det gir en åpningssetning som viser at man har lest.**

**3. Utløpte annonser.**
En annonse med gammel frist beviser at rollen finnes hos dem. Det gjør en åpen søknad informert
i stedet for generisk. Bruk deres egne ord fra den annonsen.

**4. Ansattlista.**
Den forteller hva slags sted det er. Fire inneselgere og én lagermedarbeider betyr salg og lager,
ikke verksted, uansett hva bransjekoden sier. Og den gir riktig mottaker med navn og rolle.

**5. Regnskapet, lest som to tall og ikke ett.**
Lønnsomhet og soliditet sier forskjellige ting. Et selskap med overskudd og null egenkapital er
noe annet enn et med underskudd og null egenkapital. Det første tar ut utbytte, det andre blør.
**Si hvilken av delene det er.**

### Faste regler
- **Aldri gjett et navn eller en e-postadresse.** Bruk bare det firmaet selv har publisert.
  Finnes det ikke, skriv at brukeren må ringe sentralbordet.
- **Ikke lag brukerkonto** for å komme forbi en innlogging. Stopp og skriv at resten ikke er lest.
- **Noter kilde og dato** på alt.
- **Ledige stillinger:** `arbeidsplassen.nav.no` har et åpent søke-API som svarer med JSON.
  Sjekk alltid der i tillegg til firmaets egen side. Mange annonser ligger bare ett av stedene.

---

## D) Innkalt til intervju

1. Les annonsen og `research.md` på nytt. Hva er de mest opptatt av?
2. Finn historiene i `input/intervju.md` som svarer på det. Mangler en, skriv den fra
   `historier.md` i brukerens stemme: ett til to minutter, poenget til slutt.
3. Forbered svaret på spørsmålet brukeren helst vil slippe. Ærlig, kort, og det skal ende med
   hva brukeren gjør nå.
4. Skriv om siste setning i «Deg selv, på ett minutt»: hvorfor akkurat dem.
5. Si til brukeren hvilke historier som passer, og be dem øve høyt.

---

## Sluttrapport til brukeren (begge veier)

Kort, ærlig, og alltid med disse fem punktene:

1. **Hvorfor dette firmaet/stillingen passer** — i én setning.
2. **Sterkeste røde tråd** — og beviset som bærer den.
3. **Risiko** — hva en kritisk leser vil hakke på her, og hvordan søknaden møter det.
4. **Hva brukeren må sjekke selv** før levering: mottakernavn, adresse, frist, om noe i teksten er blitt til underveis.
5. **Oppfølging** — dato for når brukeren bør ta kontakt hvis hen ikke hører noe (ca. én uke).
