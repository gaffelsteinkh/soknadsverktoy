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
6. `<firma>-soknad.tex` fra malen — samme regler som i B4.
7. `./bygg.sh soknader/<firma>/*.tex` → **CV 1 side, brev 1 side**. Se på PDF-ene.
8. Logg i `input/om-meg.md` med frist og oppfølgingsdato.

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
7. Logg i `input/om-meg.md` med oppfølgingsdato.
8. **Når brukeren har rettet på teksten:** legg den rettede versjonen i `input/skrivestil/tekster/`
   og oppdater `SKRIVESTIL.md`. Det er slik verktøyet blir bedre for hver søknad.

---

## Sluttrapport til brukeren (begge veier)

Kort, ærlig, og alltid med disse fem punktene:

1. **Hvorfor dette firmaet/stillingen passer** — i én setning.
2. **Sterkeste røde tråd** — og beviset som bærer den.
3. **Risiko** — hva en kritisk leser vil hakke på her, og hvordan søknaden møter det.
4. **Hva brukeren må sjekke selv** før levering: mottakernavn, adresse, frist, om noe i teksten er blitt til underveis.
5. **Oppfølging** — dato for når han bør ta kontakt hvis han ikke hører noe (ca. én uke).
