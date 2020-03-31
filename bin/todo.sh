#!/bin/bash
emacsclient -cne -F '((title . "Capturing TODO") (user-position . t) (left . (+ 550)) (top . (+ 400)) (width . 120) (height . 40))' '(progn (org-capture nil "t") (spacemacs/toggle-maximize-buffer) (recenter 0) (raise-frame) (x-focus-frame (selected-frame)))'
