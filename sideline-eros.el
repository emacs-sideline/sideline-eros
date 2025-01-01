;;; sideline-eros.el --- Show EROS result with sideline  -*- lexical-binding: t; -*-

;; Copyright (C) 2024-2025  Shen, Jen-Chieh

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Maintainer: Shen, Jen-Chieh <jcs090218@gmail.com>
;; URL: https://github.com/emacs-sideline/sideline-eros
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1") (sideline "0.1.0") (eros "0.1.0"))
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Show EROS result with sideline.
;;

;;; Code:

(require 'sideline)
(require 'eros)

(defgroup sideline-eros nil
  "Show EROS result with sideline."
  :prefix "sideline-eros-"
  :group 'tool
  :link '(url-link :tag "Repository" "https://github.com/emacs-sideline/sideline-eros"))

(defvar-local sideline-eros--callback nil
  "Callback to display result.")

;;;###autoload
(defun sideline-eros (command)
  "Backend for sideline.

Argument COMMAND is required in sideline backend."
  (cl-case command
    (`candidates (cons :async
                       (lambda (callback &rest _)
                         (setq sideline-eros--callback callback))))
    (`face 'eros-result-overlay-face)))

(defun sideline-eros--result (result &rest _)
  "Display RESULT."
  (when result
    (funcall sideline-eros--callback (list (sideline-2str result)))))

(defun sideline-eros--mode ()
  "Add hook to `sideline-mode-hook'."
  (cond (sideline-mode
         (advice-add #'eros--eval-overlay :override #'sideline-eros--result))
        (t
         (advice-remove #'eros--eval-overlay #'sideline-eros--result))))

;;;###autoload
(defun sideline-eros-setup ()
  "Setup for `eros'."
  (add-hook 'sideline-mode-hook #'sideline-eros--mode)
  (sideline-eros--mode))  ; Run once

(provide 'sideline-eros)
;;; sideline-eros.el ends here
