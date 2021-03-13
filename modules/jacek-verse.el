;;; jacek-verse.el --- Adding bible verse links to org files.
;;
;; Copyright © 2021-2021 Jacek Podkanski
;;
;; Author: TODO
;; URL: TODO

;; This file is not part of GNU Emacs.

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
(require 'cl)
(require 'ido-completing-read+)

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
  (let ((c 0))
    (-map (lambda (x) (incf c) (cons c x)) (verse-books))))

(defun verse-previous-verse-separator ()
  "Find verse separator."
  (interactive)
  (search-backward ":")
  (point))

(defun verse-link ()
  "Find components."
  (interactive)
  ;; enable mode for ido-completing-read+
  (ido-ubiquitous-mode 1)
  (let* ((cpoint (point))
         (cseparator (verse-previous-verse-separator))
         (chapt-ends (1- cseparator))
         (chapt-starts chapt-ends))
    (while (/= 32 (char-after chapt-starts)) (incf chapt-starts -1))
    (let* ((cspace-ends chapt-starts)
           (cspace-starts cspace-ends))
      (while (= 32 (char-after cspace-starts)) (incf cspace-starts -1))
      (let* ((book-ends cspace-starts)
             (book-starts book-ends))
        (while (/= 32 (char-after book-starts)) (incf book-starts -1))
        (let* ((bspace-ends book-starts)
               (bspace-starts bspace-ends))
          (while (= 32 (char-after bspace-starts)) (incf bspace-starts -1))
          (let* ((bnumber-ends  bspace-starts)
                 (bnumber-starts bnumber-ends))
            (while (/= 32 (char-after bnumber-starts)) (incf bnumber-starts -1))

            (let* ((book-number (buffer-substring (1+ bnumber-starts) (1+ bnumber-ends)))
                   (book-name (capitalize (buffer-substring  (1+ book-starts)  (1+ book-ends))))
                   (chapter (buffer-substring  (1+ chapt-starts) (1+ chapt-ends)))
                   (verse (string-trim
                           (buffer-substring (1+ cseparator) cpoint)))
                   (long-books (-map 'car (verse-books)))
                   (link-book (if (member book-name long-books)
                                  book-name
                                (ido-completing-read+ (format "select correction for %S" book-name)
                                                      long-books
                                                      nil
                                                      t
                                                      book-name))))
              (goto-char cpoint)
              ;; print debugging information
              ;; TODO add handling for book with numbers
              (print
               (list 'verse-components
                     'book-number book-number
                     'book book-name
                     'chapter chapter
                     'verse verse))
              (replace-region-contents (1+ book-starts) cpoint
                                       (lambda ()
                                         (verse-page-link link-book chapter verse)))
              (goto-char (1+ cpoint)))))))))

(defun verse-page-link (book-name chapter verse)
  "Take strings BOOK-NAME CHAPTER and VERSE to create a string for org link."
  (let ((book-name-number (caar (-filter (lambda (x)
                                           (equalp book-name (cadr x)))
                                         (verse-books-numbered)))))
    (format "[[https://wol.jw.org/en/wol/b/r1/lp-e/nwtsty/%d/%s#v=%d:%s:%s][%s %s:%s]]"
            book-name-number chapter book-name-number chapter verse
            book-name chapter verse )))

(provide 'jacek-verse)
;;; jacek-verse.el ends here
