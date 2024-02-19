;;; org-vlc.el --- a simple package                     -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Jacek Podkanski

;; Author: Jacek Podkanski
;; Keywords: lisp
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Org-vlc provides links for org mode file that allow to use vlc to open video
;; files with the optional start time and stop time.

;;; Code:

;; code goes here
(require 'org)

;;; correct way of adding links
;; https://orgmode.org/manual/Adding-Hyperlink-Types.html


;; https://orgmode.org/manual/Adding-Hyperlink-Types.html
(org-link-set-parameters "vlc"
                         :follow #'org-vlc-open)

(defun org-vlc--my-time-to-seconds (time)
  "Convert TIME in minutes and seconds as 01:20 to seconds as 80."
  (let ((time-parts (mapcar #'string-to-number
                            (split-string time ":"))))
    (if (eq 3 (length time-parts))      ; hrs min sec
        (+ (* 3600 (car time-parts))
           (* 60 (cadr time-parts))
           (caddr time-parts))
      (+ (* 60 (car time-parts))        ; naiive min sec
         (cadr time-parts)))))

(defun org-vlc--time-option (option fn split-timings)
  (let ((time-part (apply fn (list  split-timings))))
    (when time-part
      (format option (org-vlc--my-time-to-seconds time-part)))))

(defun org-vlc-open (link)
  "Where page number is 105, the link should look like:
   [[vlc:/path/to/file.mp4#01:05][My description.]]
   or
   [[vlc:/path/to/file.mp4#01:05-03:25][My description.]]"
  (let* ((path+timing (split-string link "#"))
         (afile (car
                 (split-string
                  (car path+timing)
                  ":")))
         ;; time options
         (timings (cadr path+timing))
         (split-timings (when timings (split-string timings "-")))
         (start-at
          (org-vlc--time-option "--start-time=%s" #'car split-timings))
         (end-at
          (org-vlc--time-option "--stop-time=%s" #'cadr split-timings)))

    ;; (message "vlc opening video %s at  %s %s %s" afile timings start-at end-at )
    (let ((options
           (cond ((and (null start-at) (null end-at))
                  (list  "view-vlc" nil "vlc" afile))
                 ((and start-at (null end-at))
                  (list  "view-vlc" nil "vlc" afile start-at))
                 ((and start-at end-at)
                  (list  "view-vlc" nil "vlc" afile start-at end-at))
                 (t (merssage "error in time arguments")))))
      (message "starting vlc %S" options)
      (apply #'start-process options))))

(provide 'org-vlc)
;;; org-vlc.el ends here
