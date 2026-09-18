#!/usr/bin/env bash
# Bygger CV-er og søknadsbrev til PDF ved siden av kildefila.
#
#   ./bygg.sh                                   alle
#   ./bygg.sh soknader/firma/firma-cv.tex       én
#
# Sjekker sidetall til slutt: CV skal være 1 side, brev 1 side.
set -u
cd "$(dirname "$0")"

if ! command -v xelatex >/dev/null 2>&1; then
  echo "xelatex mangler — ingenting kan bygges."
  echo "  Arch/CachyOS:   sudo pacman -S texlive-xetex texlive-langeuropean texlive-latexextra texlive-fontsrecommended poppler"
  echo "  Debian/Ubuntu:  sudo apt install texlive-xetex texlive-lang-european texlive-latex-extra poppler-utils"
  exit 127
fi
command -v pdfinfo >/dev/null 2>&1 || echo "Merk: pdfinfo mangler — bygger, men kan ikke sjekke sidetall."

filer=("$@")
if [ ${#filer[@]} -eq 0 ]; then
  mapfile -t filer < <(printf '%s\n' cv-generell.tex; find soknader -name '*.tex' | sort)
fi

feil=0
advarsler=()

for f in "${filer[@]}"; do
  [ -f "$f" ] || { echo "MANGLER  $f"; feil=1; continue; }
  ut="$(dirname "$f")"
  if xelatex -interaction=nonstopmode -halt-on-error -output-directory="$ut" "$f" >/dev/null 2>&1; then
    pdf="${f%.tex}.pdf"
    sider=$(pdfinfo "$pdf" 2>/dev/null | awk '/^Pages:/{print $2}')
    sider=${sider:-?}
    case "$(basename "$f")" in
      *-soknad.tex) mal=1; hva="brev"  ;;
      cv-generell.tex) mal=0; hva="CV (grunnversjon)" ;;
      *) mal=1; hva="CV" ;;
    esac
    if [ "$mal" -ne 0 ] && [ "$sider" != "$mal" ]; then
      echo "OK   $pdf  — $sider sider  ⚠ $hva skal være $mal side"
      advarsler+=("$pdf: $sider sider, skal være $mal")
    else
      echo "OK   $pdf  — $sider sider"
    fi
  else
    echo "FEIL $f  (se ${f%.tex}.log)"
    feil=1
  fi
  rm -f "${f%.tex}.aux" "${f%.tex}.out" 2>/dev/null
done

if [ ${#advarsler[@]} -gt 0 ]; then
  echo
  echo "Sidetall å rette opp:"
  printf '  - %s\n' "${advarsler[@]}"
  echo "  CV: kutt en oppføring, bruk Kort-variantene, eller \\tettmodus."
fi

exit $feil
