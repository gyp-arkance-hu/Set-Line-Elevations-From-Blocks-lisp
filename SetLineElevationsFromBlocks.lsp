(defun c:SetLineElevationsFromBlocks ( / ss i ent pt1 pt2 z1 z2)

  ;; Egy segédfüggvény, ami megkeresi a blokkot az adott ponton és visszaadja az ELEV2 értékét
  (defun get-elevation-from-block (pt)
    (setq blkss (ssget "_X"
      (list
        (cons 0 "INSERT")
        (cons 10 pt)
      )
    ))
    (if (and blkss (> (sslength blkss) 0))
      (progn
        (setq blk (ssname blkss 0))
        (setq att (entnext blk))
        (while (and att (/= (cdr (assoc 0 (entget att))) "SEQEND"))
          (if (= (strcase (cdr (assoc 2 (entget att)))) "ELEV2") ; <-- csak ELEV2 attribútumot keres
            (setq val (cdr (assoc 1 (entget att))))
          )
          (setq att (entnext att))
        )
        (if val
          (atof val)
        )
      )
    )
  )

  ;; Összes LINE feldolgozása
  (setq ss (ssget "_X" '((0 . "LINE"))))
  (if ss
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (entget (ssname ss i)))
        (setq pt1 (cdr (assoc 10 ent)))
        (setq pt2 (cdr (assoc 11 ent)))

        (setq z1 (get-elevation-from-block pt1))
        (setq z2 (get-elevation-from-block pt2))

        ;; Ha legalább az egyik végponthoz van magassági adat, módosítjuk a vonalat
        (if (or z1 z2)
          (progn
            (if z1 (setq pt1 (list (car pt1) (cadr pt1) z1)))
            (if z2 (setq pt2 (list (car pt2) (cadr pt2) z2)))

            (setq newent
              (subst (cons 10 pt1) (assoc 10 ent)
                (subst (cons 11 pt2) (assoc 11 ent) ent)
              )
            )
            (entmod newent)
            (entupd (cdr (assoc -1 ent)))
          )
        )
        (setq i (1+ i))
      )
    )
  )
  (princ "\nVonalak magassága frissítve az ELEV2 attribútum alapján.")
  (princ)
)
