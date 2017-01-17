;;; test.el --- bloom filter test

;; Copyright (C) 2017 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>

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

;;; Code:

(require 'ert)
(require 'bloom-filter)

(ert-deftest bloom-filter ()
  "bloom filter test"
  (let ((bfilter (bloom-filter 100 0.5)))
    (cl-loop for i from 1 to 50
             do
             (bloom-filter-add bfilter i))
    (should (bloom-filter-search bfilter 1))
    (should (bloom-filter-search bfilter 50))
    ;; In most case, search returns nil
    (should (cl-loop for i from 51 to 150
                     thereis (bloom-filter-search bfilter i)))))

;;; test.el ends here
