#!/usr/bin/env bash
# Genera las dos versiones de la presentacion desde defensa.typ.
# Ejecutar desde la raiz del repositorio:  bash presentacion/build.sh
set -e

cd "$(dirname "$0")/.."

# Sin animaciones: una pagina por diapositiva.
# Es la numeracion que usa el guion y la que conviene enviar por correo.
typst compile --root . presentacion/defensa.typ presentacion/defensa.pdf

# Con animaciones: las mismas diapositivas con revelado progresivo.
# Es la que se proyecta el dia de la defensa.
typst compile --root . --input animado=1 \
  presentacion/defensa.typ presentacion/defensa-animada.pdf

echo "Listo:"
echo "  presentacion/defensa.pdf          (sin animaciones)"
echo "  presentacion/defensa-animada.pdf  (con animaciones)"
