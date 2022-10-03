;;; jacek-verse.el --- Adding bible verse links to org files.
;;
;; Copyright © 2021-2021 Jacek Podkanski
;;
;; Author: TODO
;; URL: TODO

;; This file is not part of GNU Emacs.

;; Package-Requires: ((dash "2.19.1") ido-completing-read+ parsec)

;;; Commentary:

;; Some basic functionality for adding Bible verse links

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:
(require 'cl-lib)
(require 'ido-completing-read+)
(require 'parsec)

; (load "~/.emacs.d/modules/jacek-verse.el")

(defun verse-parse-line (str)
  "Parse STR to get verse components."
  (let ((pre-parsed (parsec-with-input (reverse str)
                      (parsec-collect
                       (parsec-many-s (parsec-str " "))
                       (parsec-many1-s (parsec-digit))
                       (parsec-str ":")
                       (parsec-many1-s (parsec-digit))
                       (parsec-many-s (parsec-str " "))
                       (parsec-many-s (parsec-letter))
                       (parsec-many-s (parsec-str " "))
                       (parsec-optional
                        (parsec-or
                         (parsec-str "1")
                         (parsec-str "2")
                         (parsec-str "3")))
                       (parsec-many-s (parsec-str " "))))))
    ;; (print (format "preparsed %S" pre-parsed))
    (let ((final-spaces   (nth 0 pre-parsed))
          (ver      (reverse (nth 1 pre-parsed)))
          (chap     (reverse (nth 3 pre-parsed)))
          (book     (reverse (nth 5 pre-parsed)))
          (book-num (reverse (nth 7 pre-parsed))))
      (list :initial-spaces (if book-num ; correct for variant w/o book number
                                (nth 8 pre-parsed)
                              (nth 6 pre-parsed))
            :book-num book-num
            :book book
            :chapter chap
            :verse ver
            :final-spaces final-spaces
            :all (reverse (apply 'concat pre-parsed))))))

;; ------------------------------------------------
(defun verse-books ()
  "List of Bible books and abbreviations."
  '(("Genesis" "Ge") ("Exodus" "Ex") ("Leviticus" "Le") ("Numbers" "Nu") ("Deuteronomy" "De")
    ("Joshua" "Jos") ("Judges" "Jg") ("Ruth" "Ru")
    ("1 Samuel" "1Sa") ("2 Samuel" "2Sa") ("1 Kings" "1Ki") ("2 Kings" "2Ki")
    ("1 Chronicles" "1Ch") ("2 Chronicles" "2Ch")
    ("Ezra" "Ezr") ("Nehemiah" "Ne") ("Esther" "Es")
    ("Job" "Job") ("Psalms" "Ps") ("Proverbs" "Pr") ("Ecclesiastes" "Ec") ("Song of Solomon" "Ca")
    ("Isaiah" "Isa") ("Jeremiah" "Jer") ("Lamentations" "La") ("Ezekiel" "Eze") ("Daniel" "Da")
    ("Hosea" "Ho") ("Joel" "Joe") ("Amos" "Am") ("Obadiah" "Ob")
    ("Jonah" "Jon") ("Micah" "Mic") ("Nahum" "Na") ("Habakkuk" "Hab")
    ("Zephaniah" "Zep") ("Haggai" "Hag") ("Zechariah" "Zec") ("Malachi" "Mal")
    ("Matthew" "Mt") ("Mark" "Mr") ("Luke" "Lu") ("John" "Joh") ("Acts" "Ac")
    ("Romans" "Ro") ("1 Corinthians" "1Co") ("2 Corinthians" "2Co")
    ("Galatians" "Ga") ("Ephesians" "Eph") ("Philippians" "Php") ("Colossians" "Col")
    ("1 Thessalonians" "1Th") ("2 Thessalonians" "2Th") ("1 Timothy" "1Ti") ("2 Timothy" "2Ti")
    ("Titus" "Tit") ("Philemon" "Phm") ("Hebrews" "Heb") ("James" "Jas")
    ("1 Peter" "1Pe") ("2 Peter" "2Pe") ("1 John" "1Jo") ("2 John" "2Jo") ("3 John" "3Jo")
    ("Jude" "Jude") ("Revelation" "Re")))

(defun verse-books-numbered ()
  "Bible books with numbers."
  (-zip
   (number-sequence 0 (length (verse-books)))
   (verse-books)))


;; (load "~/.emacs.d/modules/jacek-verse.el")
(defun verse-link ()
  "Find components."
  (interactive)
  ;; enable mode for ido-completing-read+
  (ido-ubiquitous-mode 1)
  (let* ((cpoint (point))
         (bpoint (progn (beginning-of-line) (point)))
         (the-line (buffer-substring-no-properties bpoint cpoint))
         (parsed (verse-parse-line the-line)))
    ;; (print (format ">>> parsed is %S for >%s<" parsed the-line))

    (let* ((book-name (string-trim
                       (concat
                        (plist-get parsed :book-num)
                        " "
                        (capitalize
                         (plist-get parsed :book)))))
           (chapter (plist-get parsed :chapter))
           (verse (plist-get parsed :verse))
           (long-books (-map 'car (verse-books)))
           (link-book (if (member book-name long-books)
                          book-name
                        (ido-completing-read+ (format "select correction for %S" book-name)
                                              long-books
                                              nil
                                              t
                                              book-name))))
      (goto-char cpoint)

      (let ((startpoint (search-backward (plist-get parsed :all)))
            (vpl (verse-page-link link-book chapter verse
                                  (plist-get parsed :initial-spaces)
                                  (plist-get parsed :final-spaces))))
        ;(print (format "going to replace with >%S<" vpl))
        (replace-region-contents (+ 0 startpoint)
                                 (+ 0 cpoint)
                                 (lambda () vpl)))
      (goto-char (1+ cpoint))
      (search-forward "]]")
      (forward-char (length (plist-get parsed :final-spaces))))))

(defun verse-page-link (book-name chapter verse initial-spaces final-spaces)
  "Take strings BOOK-NAME CHAPTER and VERSE to create a string for org link obeying the INITIAL-SPACES and FINAL-SPACES."
  (let ((book-name-number (caar (-filter (lambda (x)
                                           (cl-equalp book-name (cadr x)))
                                         (verse-books-numbered)))))
    (format "%s[[https://wol.jw.org/en/wol/b/r1/lp-e/nwtsty/%d/%s#v=%d:%s:%s][%s %s:%s]]%s"
            initial-spaces
            book-name-number
            chapter
            book-name-number
            chapter
            verse
            book-name
            chapter
            verse
            final-spaces)))

(provide 'jacek-verse)
;;; jacek-verse.el ends here
