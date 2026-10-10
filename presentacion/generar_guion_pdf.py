# -*- coding: utf-8 -*-
"""Convierte guion.md en guion.typ, con la miniatura de cada diapositiva al lado.

Uso (desde la raiz del repositorio):
    python presentacion/generar_guion_pdf.py
    typst compile --root . presentacion/guion.typ

Las miniaturas se generan antes con:
    typst compile --root . --format png --ppi 50 \
        presentacion/defensa.typ "presentacion/miniaturas/d{0p}.png"
"""
import io
import os
import re

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MD = os.path.join(RAIZ, 'presentacion', 'guion.md')
TYP = os.path.join(RAIZ, 'presentacion', 'guion.typ')
MINI = os.path.join(RAIZ, 'presentacion', 'miniaturas')

U_ABRE, U_CIERRA, NEGRITA, CURSIVA = '\x01', '\x02', '\x03', '\x04'


def inline(s):
    """Markdown en linea -> markup de Typst."""
    s = s.replace('<u>', U_ABRE).replace('</u>', U_CIERRA)
    s = s.replace('**', NEGRITA)
    s = s.replace('*', CURSIVA)
    for ch in '\\#$@_<>[]':
        s = s.replace(ch, '\\' + ch)
    s = s.replace(NEGRITA, '*').replace(CURSIVA, '_')
    s = s.replace(U_ABRE, '#underline[').replace(U_CIERRA, ']')
    return s


def main():
    texto = io.open(MD, encoding='utf-8').read()
    partes = re.split(r'^### Diapositiva (\d+) — (.+)$', texto, flags=re.M)
    cabecera = partes[0]

    out = []
    out.append('#set page(paper: "a4", margin: (x: 1.6cm, y: 1.5cm),')
    out.append('  numbering: "1 / 1", number-align: center + bottom)')
    out.append('#set text(lang: "es", font: ("Segoe UI", "Calibri", "Arial"),')
    out.append('  size: 10pt, hyphenate: false)')
    out.append('#set par(justify: false, leading: 0.62em)')
    out.append('#show heading: set text(fill: rgb("#0d2340"))')
    out.append('')
    out.append('#align(center)[')
    out.append('  #text(size: 17pt, weight: "bold", fill: rgb("#0d2340"))'
               '[Guion de defensa]')
    out.append('  #linebreak()')
    out.append('  #text(size: 10pt, fill: rgb("#555"))'
               '[Amaro Zurita Alvarado -- 20 minutos]')
    out.append(']')
    out.append('#v(10pt)')
    out.append('')

    # --- cabecera (tabla de tiempos y regla de rescate) ---
    filas = re.findall(r'^\| ([^|]+) \| ([^|]+) \| ([^|]+) \| ([^|]+) \|$',
                       cabecera, flags=re.M)
    filas = [f for f in filas if '---' not in f[0]]
    if filas:
        out.append('#table(columns: 4, stroke: 0.4pt + rgb("#cdd3da"),'
                   ' inset: 5pt, align: left,')
        for f in filas:
            out.append('  ' + ', '.join('[%s]' % inline(c.strip()) for c in f) + ',')
        out.append(')')
        out.append('#v(6pt)')

    rescate = re.search(r'\*\*Regla de rescate\.\*\*(.+?)\n\n', cabecera, re.S)
    if rescate:
        cuerpo = ' '.join(rescate.group(1).split())
        out.append('#block(fill: rgb("#f6f1e7"), inset: 7pt, radius: 3pt,'
                   ' width: 100%)[')
        out.append('  #text(size: 9pt)[*Regla de rescate.* %s]' % inline(cuerpo))
        out.append(']')
    out.append('#v(10pt)')
    out.append('')

    # --- una entrada por diapositiva ---
    for i in range(1, len(partes), 3):
        num = int(partes[i])
        titulo_completo = partes[i + 1].strip()
        cuerpo = partes[i + 2]

        titulo = titulo_completo
        tiempo = ''
        if ' · ' in titulo_completo:
            titulo, tiempo = titulo_completo.rsplit(' · ', 1)

        # separa acotaciones (cursiva suelta) de lo que se dice (blockquote)
        bloques = []
        buf, modo = [], None
        for linea in cuerpo.split('\n'):
            if linea.startswith('> '):
                nuevo, cont = 'dice', linea[2:]
            elif linea.strip() == '>':
                nuevo, cont = 'dice', ''
            elif linea.strip().startswith('*') and linea.strip() != '':
                nuevo, cont = 'nota', linea.strip()
            elif linea.strip() == '' or linea.strip() == '---':
                if buf:
                    bloques.append((modo, buf))
                    buf, modo = [], None
                continue
            else:
                nuevo, cont = modo or 'nota', linea.strip()
            if modo is not None and nuevo != modo:
                bloques.append((modo, buf))
                buf = []
            modo = nuevo
            buf.append(cont)
        if buf:
            bloques.append((modo, buf))

        derecha = []
        for modo, lineas in bloques:
            parrafos, actual = [], []
            for l in lineas:
                if l.strip() == '':
                    if actual:
                        parrafos.append(' '.join(actual))
                        actual = []
                else:
                    actual.append(l.strip())
            if actual:
                parrafos.append(' '.join(actual))
            for par in parrafos:
                if par.strip() in ('**[clic]**', '*[clic]*'):
                    derecha.append('    #block(inset: (y: 2pt))[')
                    derecha.append('      #text(size: 9pt, weight: "bold",'
                                   ' fill: rgb("#a9741f"))[> clic]')
                    derecha.append('    ]')
                elif modo == 'nota':
                    derecha.append('    #block(inset: (left: 6pt), '
                                   'stroke: (left: 2pt + rgb("#cdd3da")))[')
                    derecha.append('      #text(size: 8.5pt, style: "italic",'
                                   ' fill: rgb("#555"))[%s]' % inline(par.strip('*')))
                    derecha.append('    ]')
                    derecha.append('    #v(3pt)')
                else:
                    derecha.append('    #par[%s]' % inline(par))
                    derecha.append('    #v(3pt)')

        mini = 'miniaturas/d%02d.png' % num
        hay_mini = os.path.exists(os.path.join(MINI, 'd%02d.png' % num))

        out.append('#block(breakable: false, width: 100%)[')
        out.append('  #text(size: 11pt, weight: "bold", fill: rgb("#0d2340"))'
                   '[%d. %s]' % (num, inline(titulo)))
        if tiempo:
            out.append('  #h(6pt)')
            out.append('  #text(size: 9pt, fill: rgb("#777"))[%s]' % inline(tiempo))
            out.append('  #v(4pt)')
        out.append('  #grid(columns: (5.4cm, 1fr), column-gutter: 10pt,'
                   ' align: top,')
        if hay_mini:
            out.append('    image("%s", width: 100%%),' % mini)
        else:
            out.append('    [],')
        out.append('    [')
        out.extend(derecha)
        out.append('    ],')
        out.append('  )')
        out.append(']')
        out.append('#v(9pt)')
        out.append('')

    io.open(TYP, 'w', encoding='utf-8').write('\n'.join(out) + '\n')
    print('escrito', TYP)


if __name__ == '__main__':
    main()
