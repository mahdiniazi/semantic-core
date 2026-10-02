#!/bin/bash
# open_continue_config.sh — باز کردن config در editor
if [ -z "$EDITOR" ]; then
  EDITOR="nano"
fi
echo "باز کردن $HOME/.continue/config.json با $EDITOR"
$EDITOR ~/.continue/config.json
