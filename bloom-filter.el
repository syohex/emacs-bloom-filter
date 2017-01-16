;;; bloom-filter.el --- bloom filter implementation -*- lexical-binding: t; -*-

;; Copyright (C) 2017 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-bloom-filter
;; Version: 0.01
;; Package-Requires: ((emacs "24"))

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

;;; Code:

(require 'cl-lib)
(require 'calc)

(cl-defstruct bloom-filter
  vec hash-funcs length)

(cl-defun bloom-filter--hash-functions (n &optional (type 'sha1))
  (cl-loop for i from 0 to (1- n)
           collect
           (let ((salt i))
             (lambda (obj)
               (secure-hash type (format "%d%s" salt obj))))))

(defun bloom-filter--calculate-parameters (keys error-rate)
  (let* ((bits (ceiling (/ (* -1 keys (log error-rate)) (expt (log 2) 2))))
         (hashes (ceiling (/ (* (log 2) bits) keys))))
    (list bits hashes)))

(defun bloom-filter--apply-hash-funcs (vec obj)
  (cl-loop for func in (bloom-filter-hash-funcs vec)
           for val = (funcall func obj)
           for n = (calc-eval
                    (format "16#%s %% %d" val (bloom-filter-length vec))
                    'rawnum)
           collect n))

(defun bloom-filter--initialize (keys error-rate)
  (cl-destructuring-bind (vec-size hash-num) (bloom-filter--calculate-parameters keys error-rate)
    (let ((funcs (bloom-filter--hash-functions hash-num)))
      (make-bloom-filter
       :vec (make-vector (ceiling (/ vec-size 32.0)) 0)
       :hash-funcs funcs :length vec-size))))

(defun bloom-filter-add (vec key)
  (let ((vals (bloom-filter--apply-hash-funcs vec key)))
    (cl-loop with v = (bloom-filter-vec vec)
             for val in vals
             for idx = (/ val 32)
             for curval = (aref v idx)
             do
             (aset v idx (logior curval (ash 1 (% val 32)))))))

(defun bloom-filter-search (vec key)
  (let ((vals (bloom-filter--apply-hash-funcs vec key)))
    (cl-loop with v = (bloom-filter-vec vec)
             for val in vals
             for idx = (/ val 32)
             for curval = (aref v idx)
             always (not (zerop (logand curval (ash 1 (% val 32))))))))

;;;###autoload
(defun bloom-filter (keys error-rate)
  (bloom-filter--initialize keys error-rate))

(provide 'bloom-filter)

;;; bloom-filter.el ends here
