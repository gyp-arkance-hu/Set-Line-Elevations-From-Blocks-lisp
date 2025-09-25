# Set Line Elevations From Blocks

Ez a projekt egy AutoLISP segédprogramot tartalmaz, amely automatizálja az AutoCAD vonalobjektumainak Z-koordináta frissítését a vonal végpontjaival megegyező helyen elhelyezett blokkok **ELEV2** attribútuma alapján.

## Felhasználói dokumentáció

### Előkészületek

- AutoCAD (vagy más AutoLISP kompatibilis CAD-szoftver) szükséges.
- A blokkoknak tartalmazniuk kell egy `ELEV2` nevű attribútumot, amely a kívánt magassági értéket (Z-koordinátát) tárolja.
- A frissítendő vonalaknak olyan végpontokra kell csatlakozniuk, ahol a megfelelő blokkok megtalálhatók.

### Betöltés

1. Másold a `SetLineElevationsFromBlocks.lsp` fájlt egy elérhető könyvtárba.
2. AutoCAD-ben futtasd a `APPLOAD` parancsot, és töltsd be a LISP fájlt.
3. Sikeres betöltés után a parancssorban elérhetővé válik a `SetLineElevationsFromBlocks` parancs.

### Használat

1. Indítsd el a `SetLineElevationsFromBlocks` parancsot.
2. A szkript automatikusan végigmegy az aktuális rajz összes `LINE` objektumán.
3. Minden végpontnál ellenőrzi, hogy található-e blokk ugyanazon a koordinátán, amely `ELEV2` attribútummal rendelkezik.
4. Ha a blokk attribútuma megtalálható és számként értelmezhető, a vonal adott végpontjának Z-koordinátája frissül.
5. A parancs a végén üzenetet ír ki: „Vonalak magassága frissítve az ELEV2 attribútum alapján.”

### Beviteli adatok és elvárt formátum

- **Blokk elhelyezése:** a blokk beszúrási pontja legyen pontosan a vonal végpontján.
- **Attribútum név:** a script kizárólag `ELEV2` nevű attribútumot olvas be.
- **Attribútum érték:** decimális szám (pl. `123.45`). Az `atof` függvény próbálja számmá alakítani az értéket.

### Gyakori problémák

| Probléma | Ok | Megoldás |
| --- | --- | --- |
| Nem frissül a vonal magassága | Nincs blokk a vonal végpontján | Ellenőrizd a blokk pozícióját és hogy pontosan a végpontban van-e. |
| Nem frissül a Z-érték | A blokkban nincs `ELEV2` attribútum | Adj hozzá `ELEV2` attribútumot a blokkdefinícióhoz. |
| Hibás magasság | Az attribútum értéke nem számként értelmezhető | Biztosítsd, hogy az attribútum numerikus formátumú legyen. |

## Technikai dokumentáció

### Fő parancs

A `c:SetLineElevationsFromBlocks` egy AutoLISP parancsfüggvény, amely a következő lépéseket hajtja végre:

1. **Attribútum-kinyerés**: A beágyazott `get-elevation-from-block` függvény a megadott ponton lévő blokkot keresi, majd végigiterál a hozzá tartozó attribútumokon. Ha talál `ELEV2` nevű attribútumot, visszaadja annak numerikus értékét.
2. **Vonalgyűjtés**: A `ssget` hívás az egész rajzban összegyűjti a `LINE` típusú objektumokat.
3. **Z-koordináta frissítése**: Minden vonal esetén külön ellenőrzi az első (kód 10) és második (kód 11) végpontot. Ha bármelyikhez tartozik érvényes magassági érték, akkor az `entmod` segítségével módosítja az adott DXF-csoportot.
4. **Rajz frissítése**: Az `entupd` gondoskodik arról, hogy a módosítás azonnal érvényesüljön a rajzban.

### Kód felépítése

- `get-elevation-from-block`: belső függvény a blokk-attribútum kinyerésére.
- `ssget`: teljes rajzra kiterjedő kiválasztás vonalobjektumokra.
- `subst` + `assoc`: DXF-adatszerkezet módosítása a végpontok frissítéséhez.
- `entmod` és `entupd`: objektum módosításának érvényesítése.
- `princ`: parancssori visszajelzés a sikeres futásról.

### Bővíthetőség

- **Attribútum név konfigurálása:** Szükség esetén a `get-elevation-from-block` függvényben a `"ELEV2"` sztring paraméterezhető, így más attribútum név is használható.
- **Egyéb entitások támogatása:** Hasonló logika mentén módosítható, hogy `POLYLINE` vagy más 3D entitások is frissüljenek.
- **Pont tolerancia:** A jelenlegi kód pontos koordináta-egyezést vár el. Amennyiben pontossági toleranciára van szükség, a blokkkeresésnél be lehet vezetni eltérés vizsgálatot.

### Korlátozások

- Csak `LINE` entitásokon működik.
- Csak `ELEV2` attribútumot olvas.
- Feltételezi, hogy a blokk attribútumai sorfolytonosan vannak tárolva, és az `ELEV2` attribútum az `entnext` láncolatban található.
- Nem módosítja a vonalak XY-koordinátáit.

## Változások naplója

- **1.0** – Első kiadás, parancs a vonalak Z-koordinátájának frissítésére blokk attribútum alapján.

## Licenc

A projekt licencét a szerző határozza meg; amennyiben nincs feltüntetve, a felhasználásról egyeztess a készítővel.

