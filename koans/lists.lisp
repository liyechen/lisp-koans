;;; Copyright 2013 Google Inc.
;;;
;;; Licensed under the Apache License, Version 2.0 (the "License");
;;; you may not use this file except in compliance with the License.
;;; You may obtain a copy of the License at
;;;
;;;     http://www.apache.org/licenses/LICENSE-2.0
;;;
;;; Unless required by applicable law or agreed to in writing, software
;;; distributed under the License is distributed on an "AS IS" BASIS,
;;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;;; See the License for the specific language governing permissions and
;;; limitations under the License.

;;; A singly linked list is the basic build block of Lisp. Each node of such a
;;; list is called a "cons cell" in Lisp. Each cons cell has two slots: a CAR,
;;; often used to hold an element of a list, and a CDR, often used to reference
;;; the next cons cell.

(define-test how-to-make-lists
  (let (;; Literal lists can be passed by quoting them.
        (fruits '(orange pomello clementine))
        ;; Freshly constructed lists can be passed using the LIST function.
        (some-evens (list (* 2 1) (* 2 2) (* 2 3)))
        ;; Lists can also be passed using quotes and dot notation...
        (long-numbers '(16487302 . (3826700034 . (10000000 . '()))))
        ;; ...or by using the function CONS.
        (names (cons "Matthew" (cons "Mark" (cons "Margaret" '())))))
    ;; Try filling in the below blanks in different ways.
    (assert-equal ____ fruits)
    (assert-equal ____ some-evens)
    (assert-equal ____ long-numbers)
    (assert-equal ____ names)))

(define-test cons-tructing-lists
  ;; The function CONS can be used to add new elements at the beginning of
  ;; an existing list.
  (let ((nums '()))
    (setf nums (cons :one nums))
    (assert-equal ____ nums)
    (setf nums (cons :two nums))
    (assert-equal ____ nums)
    ;; Lists can contain anything, even objects of different types.
    (setf nums (cons 333 nums))
    (assert-equal ____ nums)
    ;; Lists can contain other lists, too.
    (setf nums (cons (list "some" "strings") nums))
    (assert-equal ____ nums)))

(define-test car-and-cdr
  ;; We may use functions CAR and CDR (or, alternatively, FIRST and REST) to
  ;; access the two slots of a cons cell.
  (let ((x (cons 1 2)))
    (assert-equal ____ (car x))
    (assert-equal ____ (cdr x)))
  ;; Calls to CAR and CDR are often intertwined to extract data from a nested
  ;; cons structure.
  (let ((structure '((1 2) (("foo" . "bar")))))
    (assert-equal ____ (car x))
    (assert-equal ____ (car (cdr x)))
    (assert-equal ____ (cdr (car (car (cdr x)))))
    ;; Lisp defines shorthand functions for up to four such nested calls.
    (assert-equal ____ (car x))
    (assert-equal ____ (cadr x))
    (assert-equal ____ (cdaadr x))))

(define-test push-pop
  ;; PUSH and POP are macros similar to SETF, as both of them operate on places.
  (let ((place '(10 20 30 40)))
    ;; PUSH sets the value of the place to a new cons cell containing some value
    ;; in its CAR.
    (push 0 place)
    (assert-equal ____ place)
    ;; POP removes a single cons cell from a place, sets the place to its CDR,
    ;; and returns the value from its CAR.
    (let ((value (pop place)))
      (assert-equal ____ value)
      (assert-equal ____ place))
    ;; The return value of POP can be discarded to simply "remove" a single cons
    ;; cell from a place.
    (pop place)
    (let ((value (pop place)))
      (assert-equal ____ value)
      (assert-equal ____ place))))

(define-test append-nconc
  ;; The functions APPEND and NCONC appends one list to the end of another.
  ;; While APPEND creates new lists, NCONC modifies existing ones; therefore
  ;; APPEND can be used on literals, but NCONC needs fresh lists.
  (assert-equal ____ (append '(:a :b) '(:c)))
  (assert-equal ____ (nconc (list :a :b) (list :c)))
  (let ((list-1 (list 1 2 3))
        (list-2 (list 4 5 6)))
    ;; Both APPEND and NCONC return the appended list, but the interesting part
    ;; is what happens when we try to use the original variables passed to them.
    (assert-equal ____ (append list-1 list-2))
    (assert-equal ____ list-1)
    (assert-equal ____ list-2)
    (assert-equal ____ (nconc list-1 list-2))
    (assert-equal ____ list-1)
    (assert-equal ____ list-2)))

(define-test accessing-list-elements
  (let ((noms '("peanut" "butter" "and" "jelly")))
    ;; Common Lisp defines accessor functions for lists: FIRST, SECOND, ...,
    ;; up to TENTH.
    (assert-equal "peanut" (first noms))
    (assert-equal ____ (second noms))
    (assert-equal ____ (fourth noms))
    ;; The function LAST returns the last cons cell of a list.
    (assert-equal ____ (last noms))
    ;; The function NTH returns the n-th element of a list.
    (assert-equal "butter" (nth 1 noms))
    (assert-equal ____ (nth 0 noms))
    (assert-equal ____ (nth 3 noms))))

(define-test cons-tructing-improper-lists
  ;; A proper list is a list whose final CDR ends with NIL.
  ;; An improper list either has a non-NIL value in its final CDR or does not
  ;; have a final CDR due to a cycle in its structure.
  (let (;; We can construct non-cyclic improper lists using LIST*...
        (x (list* 1 2 3 4 5))
        ;; ...or pass them as literals via dot notation.
        (y '(6 7 8 9 . 0)))
    (assert-equal ____ (last x))
    (assert-equal ____ (list y)))
  ;; We can create a cyclic list by changing the last CDR of a list to refer to
  ;; another cons cell
  (let ((list (list 1 2 3 4 5))
        (cyclic-list (list 1 2 3 4 5)))
    (setf (cdr (last cyclic-list)) cyclic-list)
    ;; Function LIST-LENGTH returns NIL if a list is cyclic.
    (assert-equal ____ (list-length list))
    (assert-equal ____ (list-length cyclic-list))
    ;; Many Lisp functions operate only on proper lists.
    ;; The function NTH is not one of them; it can be used to retrieve elements
    ;; of cyclic lists.
    (assert-equal ____ (nth 101 cyclic-list))))

(define-test slicing-lists
  ;; The function SUBSEQ returns a subsequence of a list.
  (let ((noms (list "peanut" "butter" "and" "jelly")))
    (assert-equal ____ (subseq noms 0 1))
    (assert-equal ____ (subseq noms 0 2))
    (assert-equal ____ (subseq noms 2 2))
    (assert-equal ____ (subseq noms 2))))
